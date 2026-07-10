using Toybox;

// Exercise model class
class Exercise {
    var name;
    var phases;
    var defaultDuration;
    var iconPath;
    
    function initialize(exerciseName, exercisePhases, defaultDur, icon) {
        name = exerciseName;
        phases = exercisePhases;
        defaultDuration = defaultDur;
        iconPath = icon;
    }
    
    // Factory method for Square Breathing
    function static getSquareBreathing() {
        return new Exercise(
            "Carre",
            ["Inspire", "Retien (plein)", "Expire", "Retien (vide)"],
            4,
            null
        );
    }
    
    // Factory method for Triangle Breathing
    function static getTriangleBreathing() {
        return new Exercise(
            "Triangle",
            ["Inspire", "Expire", "Retien (vide)"],
            3,
            null
        );
    }
    
    // Factory method for 4-7-8 Breathing
    function static get478Breathing() {
        return new Exercise(
            "4-7-8",
            ["Inspire (4s)", "Retien (7s)", "Expire (8s)"],
            4,
            null
        );
    }
    
    // Factory method for Coherence Cardiaque
    function static getCoherenceBreathing() {
        return new Exercise(
            "Coherence",
            ["Inspire", "Expire"],
            5,
            null
        );
    }
    
    // Get all available exercises
    function static getAllExercises() {
        return [
            getSquareBreathing(),
            getTriangleBreathing(),
            get478Breathing(),
            getCoherenceBreathing()
        ];
    }
    
    // Get exercise by name
    function static getExerciseByName(exerciseName) {
        var exercises = getAllExercises();
        for (var i = 0; i < exercises.size(); i++) {
            if (exercises[i].name == exerciseName) {
                return exercises[i];
            }
        }
        return null;
    }
}