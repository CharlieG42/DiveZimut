using Toybox;
using Toybox.Graphics;
using Toybox.UI;
using Toybox.UI.Menu2;

// Main menu view
class MainMenuView extends Menu2 {
    var exercises;
    var userSettings;
    
    function initialize() {
        Menu2.initialize();
        
        // Load user settings
        userSettings = UserSettings.load();
        
        // Load all exercises
        exercises = Exercise.getAllExercises();
        
        // Add exercises to menu
        for (var i = 0; i < exercises.size(); i++) {
            var exercise = exercises[i];
            var displayName = exercise.name;
            if (exercise.name == userSettings.favoriteExercise) {
                displayName = displayName + " *";
            }
            this.addItem(displayName, :onExerciseSelected);
        }
        
        // Add settings and history options
        this.addItem("---", null);
        this.addItem("Reglages", :onSettingsSelected);
        this.addItem("Historique", :onHistorySelected);
        this.addItem("A propos", :onAboutSelected);
    }
    
    function onExerciseSelected(index) {
        if (index < exercises.size()) {
            var exercise = exercises[index];
            var exerciseView = new ExerciseView(exercise);
            View.setView(exerciseView);
        }
    }
    
    function onSettingsSelected() {
        var settingsView = new SettingsView();
        View.setView(settingsView);
    }
    
    function onHistorySelected() {
        var historyView = new HistoryView();
        View.setView(historyView);
    }
    
    function onAboutSelected() {
        var aboutView = new AboutView();
        View.setView(aboutView);
    }
}