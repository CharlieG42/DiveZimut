using Toybox;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.System;
using Toybox.UI;

// Exercise view - handles the breathing exercise execution
class ExerciseView extends View {
    var currentExercise;
    var currentPhaseIndex;
    var timeLeft;
    var timer;
    var userSettings;
    var isRunning;
    
    function initialize(exercise) {
        View.initialize();
        currentExercise = exercise;
        currentPhaseIndex = 0;
        timeLeft = currentExercise.defaultDuration;
        userSettings = UserSettings.load();
        isRunning = false;
    }
    
    function onStart() {
        startExercise();
    }
    
    function startExercise() {
        currentPhaseIndex = 0;
        timeLeft = getPhaseDuration(currentPhaseIndex);
        isRunning = true;
        startTimer();
        updateDisplay();
    }
    
    function getPhaseDuration(phaseIndex) {
        if (currentExercise.name == "4-7-8") {
            if (phaseIndex == 0) {
                return 4;
            } else if (phaseIndex == 1) {
                return 7;
            } else {
                return 8;
            }
        }
        return currentExercise.defaultDuration;
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
            
            nextPhase();
        }
    }
    
    function nextPhase() {
        currentPhaseIndex = (currentPhaseIndex + 1) % currentExercise.phases.size();
        timeLeft = getPhaseDuration(currentPhaseIndex);
        updateDisplay();
        startTimer();
    }
    
    function pauseExercise() {
        isRunning = false;
        if (timer != null) {
            timer.stop();
        }
        updateDisplay();
    }
    
    function resumeExercise() {
        isRunning = true;
        startTimer();
        updateDisplay();
    }
    
    function stopExercise() {
        isRunning = false;
        if (timer != null) {
            timer.stop();
        }
        saveToHistory();
        var mainMenu = new MainMenuView();
        View.setView(mainMenu);
    }
    
    function saveToHistory() {
        System.println("Exercise completed: " + currentExercise.name);
    }
    
    function updateDisplay() {
        var dc = View.getDC();
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        dc.setColor(0, 0, 0);
        dc.fillRectangle(0, 0, width, height);
        
        dc.setColor(255, 255, 255);
        dc.setFont(Graphics.FONT_MEDIUM);
        dc.drawText(width / 2, 20, currentExercise.name, Graphics.TEXT_JUSTIFY_CENTER);
        
        var phase = currentExercise.phases[currentPhaseIndex];
        dc.setFont(Graphics.FONT_LARGE);
        dc.drawText(width / 2, height / 2 - 20, phase, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setFont(Graphics.FONT_XLARGE);
        dc.drawText(width / 2, height / 2 + 20, formatTime(timeLeft), Graphics.TEXT_JUSTIFY_CENTER);
        
        var barWidth = width - 40;
        var barHeight = 10;
        var barY = height - 50;
        var progress = 1.0 - (timeLeft / (float)getPhaseDuration(currentPhaseIndex));
        
        dc.setColor(50, 50, 50);
        dc.fillRectangle(20, barY, barWidth, barHeight);
        
        dc.setColor(0, 200, 255);
        dc.fillRectangle(20, barY, (int)(barWidth * progress), barHeight);
        
        if (!isRunning) {
            dc.setColor(255, 255, 0);
            dc.setFont(Graphics.FONT_SMALL);
            dc.drawText(width / 2, height - 20, "PAUSE", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
    
    function formatTime(seconds) {
        if (seconds < 10) {
            return "00:0" + seconds;
        } else if (seconds < 60) {
            return "00:" + seconds;
        } else {
            var minutes = (int)(seconds / 60);
            var secs = seconds % 60;
            return minutes + ":" + (secs < 10 ? "0" + secs : secs);
        }
    }
    
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