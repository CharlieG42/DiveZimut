using Toybox;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.System;
using Toybox.UI;

// Abstract base class for exercise and apnea table views
abstract class BaseExerciseView extends View {
    var timer;
    var isRunning;
    var timeLeft;
    var startTime;
    var totalElapsedTime;
    var userSettings;
    
    // Phase constants
    var PHASE_PREP = 0;
    var PHASE_ACTIVE = 1;
    var PHASE_RECOVERY = 2;
    
    function initialize() {
        View.initialize();
        isRunning = false;
        timeLeft = 0;
        startTime = 0;
        totalElapsedTime = 0;
        userSettings = UserSettings.load();
    }
    
    function onStart() {
        startExercise();
    }
    
    function onStop() {
        stopTimer();
    }
    
    /**
     * Starts the timer with specified duration
     * @param {int} duration - Duration in seconds
     */
    function startTimer(duration) {
        stopTimer();
        timeLeft = duration;
        timer = new Timer();
        timer.start(1000, this, :onTimerFired);
    }
    
    /**
     * Stops the timer
     */
    function stopTimer() {
        if (timer != null) {
            timer.stop();
            timer = null;
        }
    }
    
    /**
     * Timer callback - must be implemented by subclasses
     */
    abstract function onTimerFired();
    
    /**
     * Starts the exercise - must be implemented by subclasses
     */
    abstract function startExercise();
    
    /**
     * Pauses the exercise
     */
    function pauseExercise() {
        isRunning = false;
        stopTimer();
        updateDisplay();
    }
    
    /**
     * Resumes the exercise
     */
    function resumeExercise() {
        isRunning = true;
        // Subclasses should call startTimer with appropriate duration
        updateDisplay();
    }
    
    /**
     * Stops the exercise and returns to main menu
     */
    function stopExercise() {
        isRunning = false;
        stopTimer();
        saveToHistory();
        var mainMenu = new MainMenuView();
        View.setView(mainMenu);
    }
    
    /**
     * Saves session to history - must be implemented by subclasses
     */
    abstract function saveToHistory();
    
    /**
     * Updates the display - must be implemented by subclasses
     */
    abstract function updateDisplay();
    
    /**
     * Formats time in MM:SS format
     * @param {int} seconds - Time in seconds
     * @return {String} Formatted time string
     */
    function formatTime(seconds) {
        return TimeUtils.formatTime(seconds);
    }
    
    /**
     * Draws a progress bar
     * @param {Graphics.DC} dc - Drawing context
     * @param {int} x - X position
     * @param {int} y - Y position
     * @param {int} width - Bar width
     * @param {int} height - Bar height
     * @param {float} progress - Progress value (0.0 to 1.0)
     * @param {int} color - Bar color
     */
    function drawProgressBar(dc, x, y, width, height, progress, color) {
        // Background
        dc.setColor(50, 50, 50);
        dc.fillRectangle(x, y, width, height);
        
        // Progress
        dc.setColor(color);
        var progressWidth = (int)(width * Math.min(1.0, Math.max(0.0, progress)));
        dc.fillRectangle(x, y, progressWidth, height);
    }
    
    /**
     * Draws centered text with background
     * @param {Graphics.DC} dc - Drawing context
     * @param {int} y - Y position
     * @param {String} text - Text to draw
     * @param {int} font - Font type
     * @param {int} color - Text color
     */
    function drawCenteredText(dc, y, text, font, color) {
        dc.setColor(color);
        dc.setFont(font);
        dc.drawText(dc.getWidth() / 2, y, text, Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    /**
     * Handles key press - base implementation
     * @param {int} key - Key code
     * @return {boolean} True if handled
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
    
    /**
     * Plays vibration if enabled in settings
     */
    function playVibration() {
        if (userSettings.enableVibration) {
            System.vibrate(150);
        }
    }
}
