using Toybox;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.System;
using Toybox.UI;

// Exercise view - handles the breathing exercise execution
class ExerciseView extends BaseExerciseView {
    var currentExercise;
    var currentPhaseIndex;
    var cyclesCompleted;
    var totalCycles;
    var phaseStartTime;
    
    /**
     * Initializes the exercise view
     * @param {Exercise} exercise - The exercise to perform
     */
    function initialize(exercise) {
        BaseExerciseView.initialize();
        currentExercise = exercise;
        currentPhaseIndex = 0;
        cyclesCompleted = 0;
        totalCycles = currentExercise.getRecommendedCycles();
    }
    
    function onStart() {
        BaseExerciseView.onStart();
    }
    
    /**
     * Starts the exercise
     */
    function startExercise() {
        currentPhaseIndex = 0;
        cyclesCompleted = 0;
        totalElapsedTime = 0;
        isRunning = true;
        startTime = System.getClockTime().getSecondsSinceEpoch();
        startNextPhase();
    }
    
    /**
     * Starts the next phase of the exercise
     */
    function startNextPhase() {
        var phaseDuration = currentExercise.getPhaseDuration(currentPhaseIndex, userSettings.defaultDuration);
        phaseStartTime = System.getClockTime().getSecondsSinceEpoch();
        startTimer(phaseDuration);
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
            nextPhase();
        }
    }
    
    /**
     * Moves to the next phase
     */
    function nextPhase() {
        currentPhaseIndex = (currentPhaseIndex + 1) % currentExercise.phases.size();
        
        // Check if we completed a full cycle
        if (currentPhaseIndex == 0) {
            cyclesCompleted++;
        }
        
        // Check if we should stop
        if (cyclesCompleted >= totalCycles && currentPhaseIndex == 0) {
            stopExercise();
            return;
        }
        
        startNextPhase();
    }
    
    /**
     * Pauses the exercise
     */
    function pauseExercise() {
        BaseExerciseView.pauseExercise();
        // Update elapsed time
        var now = System.getClockTime().getSecondsSinceEpoch();
        totalElapsedTime += (now - phaseStartTime);
    }
    
    /**
     * Resumes the exercise
     */
    function resumeExercise() {
        BaseExerciseView.resumeExercise();
        phaseStartTime = System.getClockTime().getSecondsSinceEpoch();
        startNextPhase();
    }
    
    /**
     * Stops the exercise
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
        HistoryManager.saveExerciseSession(currentExercise.name, sessionDuration, totalElapsedTime);
        System.println("Exercise completed: " + currentExercise.name + " - Duration: " + sessionDuration + "s");
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
        dc.setFont(Graphics.FONT_MEDIUM);
        dc.drawText(width / 2, 15, currentExercise.name, Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw difficulty level
        dc.setFont(Graphics.FONT_TINY);
        dc.drawText(width / 2, 30, currentExercise.getDifficultyName(), Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw current phase
        var phase = currentExercise.phases[currentPhaseIndex];
        dc.setFont(Graphics.FONT_LARGE);
        dc.drawText(width / 2, height / 2 - 30, phase, Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw timer
        dc.setFont(Graphics.FONT_XLARGE);
        dc.drawText(width / 2, height / 2 + 10, formatTime(timeLeft), Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw progress bar
        var barWidth = width - 40;
        var barHeight = 10;
        var barY = height - 60;
        var phaseDuration = currentExercise.getPhaseDuration(currentPhaseIndex, userSettings.defaultDuration);
        var progress = 1.0 - (timeLeft / (float)phaseDuration);
        
        drawProgressBar(dc, 20, barY, barWidth, barHeight, progress, 0x00C8FF);
        
        // Draw cycle counter
        if (userSettings.showCycleCounter) {
            dc.setFont(Graphics.FONT_SMALL);
            dc.setColor(200, 200, 200);
            dc.drawText(width / 2, height - 45, "Cycle: " + (cyclesCompleted + 1) + "/" + totalCycles, Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        // Draw phase indicator
        dc.setFont(Graphics.FONT_TINY);
        dc.setColor(150, 150, 150);
        var phaseText = "Phase: " + (currentPhaseIndex + 1) + "/" + currentExercise.phases.size();
        dc.drawText(width / 2, height - 30, phaseText, Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw pause indicator
        if (!isRunning) {
            dc.setColor(255, 255, 0);
            dc.setFont(Graphics.FONT_SMALL);
            dc.drawText(width / 2, height - 15, "PAUSE", Graphics.TEXT_JUSTIFY_CENTER);
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
