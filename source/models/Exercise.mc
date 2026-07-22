using Toybox;

// Exercise model class - represents a breathing exercise
class Exercise {
    var name;
    var phases;
    var defaultDuration;
    var iconPath;
    var description;
    var difficultyLevel;
    
    // Difficulty levels
    var DIFFICULTY_BEGINNER = 1;
    var DIFFICULTY_INTERMEDIATE = 2;
    var DIFFICULTY_ADVANCED = 3;
    
    /**
     * Initializes an exercise
     * @param {String} exerciseName - Name of the exercise
     * @param {Array} exercisePhases - Array of phase names
     * @param {int} defaultDur - Default duration per phase in seconds
     * @param {String} icon - Path to icon resource
     * @param {String} desc - Exercise description
     * @param {int} level - Difficulty level (1-3)
     */
    function initialize(exerciseName, exercisePhases, defaultDur, icon, desc, level) {
        name = exerciseName;
        phases = exercisePhases;
        defaultDuration = defaultDur;
        iconPath = icon;
        description = desc;
        difficultyLevel = level;
    }
    
    /**
     * Factory method for Square Breathing (Box Breathing)
     * 4 equal phases: Inhale, Hold (full), Exhale, Hold (empty)
     */
    function static getSquareBreathing() {
        return new Exercise(
            "Carre",
            ["Inspire", "Retien (plein)", "Expire", "Retien (vide)"],
            4,
            null,
            "4 phases egales. Reduction du stress, amelioration de la concentration",
            DIFFICULTY_BEGINNER
        );
    }
    
    /**
     * Factory method for Triangle Breathing
     * 3 phases: Inhale, Exhale, Hold (empty)
     */
    function static getTriangleBreathing() {
        return new Exercise(
            "Triangle",
            ["Inspire", "Expire", "Retien (vide)"],
            3,
            null,
            "3 phases. Apaisement rapide, recentrage",
            DIFFICULTY_BEGINNER
        );
    }
    
    /**
     * Factory method for 4-7-8 Breathing
     * Inhale 4s, Hold 7s, Exhale 8s
     */
    function static get478Breathing() {
        return new Exercise(
            "4-7-8",
            ["Inspire (4s)", "Retien (7s)", "Expire (8s)"],
            4,
            null,
            "Endormissement rapide, reduction de l'anxiete, relaxation profonde",
            DIFFICULTY_INTERMEDIATE
        );
    }
    
    /**
     * Factory method for Coherence Cardiaque
     * Inhale 5s, Exhale 5s (no retention)
     */
    function static getCoherenceBreathing() {
        return new Exercise(
            "Coherence",
            ["Inspire", "Expire"],
            5,
            null,
            "Equilibre du systeme nerveux, reduction du cortisol",
            DIFFICULTY_INTERMEDIATE
        );
    }
    
    /**
     * Gets the duration for a specific phase
     * @param {int} phaseIndex - Index of the phase
     * @param {int} customDuration - Optional custom duration override
     * @return {int} Duration in seconds
     */
    function getPhaseDuration(phaseIndex, customDuration) {
        // Special handling for 4-7-8 exercise
        if (name == "4-7-8") {
            if (phaseIndex == 0) {
                return 4; // Inhale
            } else if (phaseIndex == 1) {
                return 7; // Hold
            } else {
                return 8; // Exhale
            }
        }
        
        // Use custom duration if provided, otherwise use default
        var duration = customDuration != null ? customDuration : defaultDuration;
        return duration;
    }
    
    /**
     * Gets the total duration of one complete cycle
     * @param {int} customDuration - Optional custom duration override
     * @return {int} Total cycle duration in seconds
     */
    function getCycleDuration(customDuration) {
        var total = 0;
        for (var i = 0; i < phases.size(); i++) {
            total += getPhaseDuration(i, customDuration);
        }
        return total;
    }
    
    /**
     * Gets all available exercises
     * @return {Array} Array of Exercise objects
     */
    function static getAllExercises() {
        return [
            getSquareBreathing(),
            getTriangleBreathing(),
            get478Breathing(),
            getCoherenceBreathing()
        ];
    }
    
    /**
     * Gets exercise by name
     * @param {String} exerciseName - Name of the exercise to find
     * @return {Exercise} Exercise object or null if not found
     */
    function static getExerciseByName(exerciseName) {
        var exercises = getAllExercises();
        for (var i = 0; i < exercises.size(); i++) {
            if (exercises[i].name == exerciseName) {
                return exercises[i];
            }
        }
        return null;
    }
    
    /**
     * Gets difficulty level name
     * @return {String} Difficulty level name
     */
    function getDifficultyName() {
        if (difficultyLevel == DIFFICULTY_BEGINNER) {
            return "Debutant";
        } else if (difficultyLevel == DIFFICULTY_INTERMEDIATE) {
            return "Intermediaire";
        } else if (difficultyLevel == DIFFICULTY_ADVANCED) {
            return "Avance";
        }
        return "Inconnu";
    }
    
    /**
     * Gets the recommended number of cycles for this exercise
     * @return {int} Recommended number of cycles
     */
    function getRecommendedCycles() {
        if (name == "4-7-8") {
            return 4; // Typically 4 cycles for 4-7-8
        } else if (name == "Coherence") {
            return 10; // 5 minutes (10 cycles of 30s each)
        }
        return 5; // Default for other exercises
    }
    
    /**
     * Gets the recommended daily frequency
     * @return {int} Recommended times per day
     */
    function getRecommendedFrequency() {
        if (name == "Coherence") {
            return 3; // 3 times per day
        }
        return 1;
    }
}
