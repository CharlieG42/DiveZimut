using Toybox;
using Toybox.Graphics;
using Toybox.System;
using Toybox.UI;

// Apnea Table View - handles CO2, O2, and Mixed tables execution
class ApneaTableView extends View {
    var currentTable;
    var currentCycle;
    var totalCycles;
    var currentPhase;
    var timeLeft;
    var timer;
    var userSettings;
    var maxApneaTime;
    var isRunning;
    
    // Phase constants
    var PHASE_PREP = 0;
    var PHASE_APNEA = 1;
    var PHASE_RECOVERY = 2;
    
    function initialize(table) {
        View.initialize();
        currentTable = table;
        currentCycle = 0;
        totalCycles = table.defaultCycles;
        currentPhase = PHASE_PREP;
        userSettings = UserSettings.load();
        maxApneaTime = userSettings.maxApneaTime;
        if (maxApneaTime <= 0) {
            maxApneaTime = 120;  // Default 2:00 if not set
        }
        isRunning = false;
    }
    
    function onStart() {
        startTable();
    }
    
    function startTable() {
        currentCycle = 0;
        isRunning = true;
        startNextPhase();
    }
    
    function startNextPhase() {
        if (currentCycle >= totalCycles) {
            stopTable();
            return;
        }
        
        currentPhase = PHASE_PREP;
        timeLeft = 5;  // 5s preparation
        startTimer();
        updateDisplay();
    }
    
    function startTimer() {
        if (timer != null) {
            timer.stop();
        }
        timer = new Timer();
        timer.start(1000, this, :onTimerFired);
    }
    
    function onTimerFired() {
        if (!isRunning) {
            return;
        }
        
        timeLeft--;
        updateDisplay();
        
        if (timeLeft <= 0) {
            timer.stop();
            
            if (userSettings.enableVibration) {
                System.vibrate(150);
            }
            
            // Move to next phase
            if (currentPhase == PHASE_PREP) {
                startApneaPhase();
            } else if (currentPhase == PHASE_APNEA) {
                startRecoveryPhase();
            } else if (currentPhase == PHASE_RECOVERY) {
                currentCycle++;
                startNextPhase();
            }
        }
    }
    
    function startApneaPhase() {
        currentPhase = PHASE_APNEA;
        var apneaDuration = currentTable.getApneaDurationForCycle(currentCycle, maxApneaTime);
        timeLeft = apneaDuration;
        startTimer();
        updateDisplay();
    }
    
    function startRecoveryPhase() {
        currentPhase = PHASE_RECOVERY;
        var recoveryDuration = currentTable.getRecoveryDurationForCycle(currentCycle);
        timeLeft = recoveryDuration;
        startTimer();
        updateDisplay();
    }
    
    function pauseTable() {
        isRunning = false;
        if (timer != null) {
            timer.stop();
        }
        updateDisplay();
    }
    
    function resumeTable() {
        isRunning = true;
        startTimer();
        updateDisplay();
    }
    
    function stopTable() {
        isRunning = false;
        if (timer != null) {
            timer.stop();
        }
        saveToHistory();
        var mainMenu = new MainMenuView();
        View.setView(mainMenu);
    }
    
    function saveToHistory() {
        System.println("Table completed: " + currentTable.name + " - Cycles: " + currentCycle + "/" + totalCycles);
    }
    
    function updateDisplay() {
        var dc = View.getDC();
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        // Clear screen
        dc.setColor(0, 0, 0);
        dc.fillRectangle(0, 0, width, height);
        
        // Draw table name and type
        dc.setColor(255, 255, 255);
        dc.setFont(Graphics.FONT_SMALL);
        dc.drawText(width / 2, 10, currentTable.name, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, 25, currentTable.getDifficultyName(), Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw cycle info
        dc.setFont(Graphics.FONT_TINY);
        dc.drawText(10, 40, "Cycle: " + (currentCycle + 1) + "/" + totalCycles, Graphics.TEXT_JUSTIFY_LEFT);
        
        // Draw current phase
        dc.setFont(Graphics.FONT_LARGE);
        var phaseText = "";
        if (currentPhase == PHASE_PREP) {
            phaseText = "Prepare";
        } else if (currentPhase == PHASE_APNEA) {
            phaseText = "Apnee";
        } else if (currentPhase == PHASE_RECOVERY) {
            phaseText = "Recupere";
        }
        dc.drawText(width / 2, height / 2 - 15, phaseText, Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw time left
        dc.setFont(Graphics.FONT_XLARGE);
        dc.drawText(width / 2, height / 2 + 15, formatTime(timeLeft), Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw progress bar for current phase
        var barWidth = width - 40;
        var barHeight = 8;
        var barY = height - 40;
        var phaseDuration = 0;
        if (currentPhase == PHASE_PREP) {
            phaseDuration = 5;
        } else if (currentPhase == PHASE_APNEA) {
            phaseDuration = currentTable.getApneaDurationForCycle(currentCycle, maxApneaTime);
        } else if (currentPhase == PHASE_RECOVERY) {
            phaseDuration = currentTable.getRecoveryDurationForCycle(currentCycle);
        }
        
        var originalDuration = phaseDuration;
        var progress = 1.0 - (timeLeft / (float)originalDuration);
        
        // Background bar
        dc.setColor(50, 50, 50);
        dc.fillRectangle(20, barY, barWidth, barHeight);
        
        // Progress bar - different colors for each phase
        if (currentPhase == PHASE_PREP) {
            dc.setColor(255, 255, 0);  // Yellow for prep
        } else if (currentPhase == PHASE_APNEA) {
            dc.setColor(255, 0, 0);    // Red for apnea
        } else {
            dc.setColor(0, 255, 0);    // Green for recovery
        }
        dc.fillRectangle(20, barY, (int)(barWidth * progress), barHeight);
        
        // Draw next phase info
        dc.setFont(Graphics.FONT_TINY);
        if (currentPhase == PHASE_PREP) {
            var nextDuration = currentTable.getApneaDurationForCycle(currentCycle, maxApneaTime);
            dc.drawText(width / 2, height - 20, "Prochaine apnee: " + formatTime(nextDuration), Graphics.TEXT_JUSTIFY_CENTER);
        } else if (currentPhase == PHASE_APNEA) {
            var nextDuration = currentTable.getRecoveryDurationForCycle(currentCycle);
            dc.drawText(width / 2, height - 20, "Recuperation: " + formatTime(nextDuration), Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(width / 2, height - 20, "Prochain cycle: " + (currentCycle + 2) + "/" + totalCycles, Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        // Draw pause indicator if paused
        if (!isRunning) {
            dc.setColor(255, 255, 0);
            dc.setFont(Graphics.FONT_SMALL);
            dc.drawText(width / 2, height - 10, "PAUSE", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
    
    function formatTime(seconds) {
        if (seconds < 0) {
            return "00:00";
        }
        var mins = (int)(seconds / 60);
        var secs = seconds % 60;
        if (mins > 0) {
            return mins + ":" + (secs < 10 ? "0" + secs : secs);
        } else {
            return "00:" + (secs < 10 ? "0" + secs : secs);
        }
    }
    
    function onKeyPress(key) {
        if (key == Key.BACK) {
            pauseTable();
            stopTable();
            return true;
        } else if (key == Key.UP || key == Key.DOWN) {
            if (isRunning) {
                pauseTable();
            } else {
                resumeTable();
            }
            return true;
        }
        return false;
    }
}