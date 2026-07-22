using Toybox;
using Toybox.Graphics;
using Toybox.System;
using Toybox.UI;

// Apnea Table View - handles CO2, O2, and Mixed tables execution
class ApneaTableView extends BaseExerciseView {
    var currentTable;
    var currentCycle;
    var totalCycles;
    var currentPhase;
    var maxApneaTime;
    var nextPhaseDuration;
    
    // Phase constants
    var PHASE_PREP = 0;
    var PHASE_APNEA = 1;
    var PHASE_RECOVERY = 2;
    
    /**
     * Initializes the apnea table view
     * @param {ApneaTable} table - The apnea table to perform
     */
    function initialize(table) {
        BaseExerciseView.initialize();
        currentTable = table;
        currentCycle = 0;
        totalCycles = table.defaultCycles;
        currentPhase = PHASE_PREP;
        maxApneaTime = userSettings.maxApneaTime;
        if (maxApneaTime <= 0) {
            maxApneaTime = 120;
        }
    }
    
    function onStart() {
        BaseExerciseView.onStart();
    }
    
    /**
     * Starts the table execution
     */
    function startExercise() {
        currentCycle = 0;
        totalElapsedTime = 0;
        isRunning = true;
        startTime = System.getClockTime().getSecondsSinceEpoch();
        startNextPhase();
    }
    
    /**
     * Starts the next phase of the table
     */
    function startNextPhase() {
        if (currentCycle >= totalCycles) {
            stopExercise();
            return;
        }
        
        currentPhase = PHASE_PREP;
        timeLeft = 5; // Preparation time
        nextPhaseDuration = currentTable.getApneaDurationForCycle(currentCycle, maxApneaTime);
        startTimer(timeLeft);
        updateDisplay();
    }
    
    /**
     * Timer callback
     */
    function onTimerFired() {
        if (!isRunning) {
            return;
        }
        
        timeLeft--;
        updateDisplay();
        
        if (timeLeft <= 0) {
            stopTimer();
            playVibration();
            
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
    
    /**
     * Starts the apnea phase
     */
    function startApneaPhase() {
        currentPhase = PHASE_APNEA;
        timeLeft = currentTable.getApneaDurationForCycle(currentCycle, maxApneaTime);
        nextPhaseDuration = currentTable.getRecoveryDurationForCycle(currentCycle);
        startTimer(timeLeft);
        updateDisplay();
    }
    
    /**
     * Starts the recovery phase
     */
    function startRecoveryPhase() {
        currentPhase = PHASE_RECOVERY;
        timeLeft = currentTable.getRecoveryDurationForCycle(currentCycle);
        nextPhaseDuration = 5; // Next prep time
        startTimer(timeLeft);
        updateDisplay();
    }
    
    /**
     * Pauses the table
     */
    function pauseExercise() {
        BaseExerciseView.pauseExercise();
        var now = System.getClockTime().getSecondsSinceEpoch();
        totalElapsedTime += (now - startTime);
    }
    
    /**
     * Resumes the table
     */
    function resumeExercise() {
        BaseExerciseView.resumeExercise();
        startTime = System.getClockTime().getSecondsSinceEpoch();
        
        // Restart current phase with remaining time
        if (currentPhase == PHASE_PREP) {
            startNextPhase();
        } else if (currentPhase == PHASE_APNEA) {
            startApneaPhase();
        } else if (currentPhase == PHASE_RECOVERY) {
            startRecoveryPhase();
        }
    }
    
    /**
     * Stops the table
     */
    function stopExercise() {
        BaseExerciseView.stopExercise();
    }
    
    /**
     * Saves session to history
     */
    function saveToHistory() {
        var now = System.getClockTime().getSecondsSinceEpoch();
        var sessionDuration = now - startTime;
        HistoryManager.saveApneaTableSession(currentTable.name, currentCycle, sessionDuration);
        System.println("Table completed: " + currentTable.name + " - Cycles: " + currentCycle + "/" + totalCycles);
    }
    
    /**
     * Updates the display
     */
    function updateDisplay() {
        var dc = View.getDC();
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        // Clear screen
        dc.setColor(0, 0, 0);
        dc.fillRectangle(0, 0, width, height);
        
        // Draw header
        dc.setColor(255, 255, 255);
        dc.setFont(Graphics.FONT_SMALL);
        dc.drawText(width / 2, 10, currentTable.name, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, 25, currentTable.getDifficultyName(), Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw cycle counter
        if (userSettings.showCycleCounter) {
            dc.setFont(Graphics.FONT_TINY);
            dc.drawText(10, 40, "Cycle: " + (currentCycle + 1) + "/" + totalCycles, Graphics.TEXT_JUSTIFY_LEFT);
        }
        
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
        
        // Draw timer
        dc.setFont(Graphics.FONT_XLARGE);
        dc.drawText(width / 2, height / 2 + 15, formatTime(timeLeft), Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw progress bar
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
        
        var progress = 1.0 - (timeLeft / (float)phaseDuration);
        
        // Draw background
        dc.setColor(50, 50, 50);
        dc.fillRectangle(20, barY, barWidth, barHeight);
        
        // Draw progress with phase-specific color
        if (currentPhase == PHASE_PREP) {
            drawProgressBar(dc, 20, barY, barWidth, barHeight, progress, 0xFFFF00); // Yellow
        } else if (currentPhase == PHASE_APNEA) {
            drawProgressBar(dc, 20, barY, barWidth, barHeight, progress, 0xFF0000); // Red
        } else {
            drawProgressBar(dc, 20, barY, barWidth, barHeight, progress, 0x00FF00); // Green
        }
        
        // Draw next phase info
        dc.setFont(Graphics.FONT_TINY);
        dc.setColor(200, 200, 200);
        if (currentPhase == PHASE_PREP) {
            dc.drawText(width / 2, height - 20, "Prochaine apnee: " + formatTime(nextPhaseDuration), Graphics.TEXT_JUSTIFY_CENTER);
        } else if (currentPhase == PHASE_APNEA) {
            dc.drawText(width / 2, height - 20, "Recuperation: " + formatTime(nextPhaseDuration), Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            if (currentCycle + 1 < totalCycles) {
                dc.drawText(width / 2, height - 20, "Prochain cycle: " + (currentCycle + 2) + "/" + totalCycles, Graphics.TEXT_JUSTIFY_CENTER);
            } else {
                dc.drawText(width / 2, height - 20, "Fin de la table", Graphics.TEXT_JUSTIFY_CENTER);
            }
        }
        
        // Draw table type
        dc.setFont(Graphics.FONT_TINY);
        dc.setColor(150, 150, 150);
        dc.drawText(10, height - 10, currentTable.getTableTypeName(), Graphics.TEXT_JUSTIFY_LEFT);
        
        // Draw pause indicator
        if (!isRunning) {
            dc.setColor(255, 255, 0);
            dc.setFont(Graphics.FONT_SMALL);
            dc.drawText(width / 2, height - 35, "PAUSE", Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        // Draw instructions
        dc.setFont(Graphics.FONT_TINY);
        dc.setColor(100, 100, 100);
        dc.drawText(width / 2, height - 5, "UP/DOWN: Pause/Reprendre", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    /**
     * Handles key press
     */
    function onKeyPress(key) {
        if (key == Key.BACK) {
            pauseExercise();
            stopExercise();
            return true;
        } else if (key == Key.UP || key == Key.DOWN) {
            if (isRunning) {
                pauseExercise();
            } else {
                resumeExercise();
            }
            return true;
        }
        return false;
    }
}
