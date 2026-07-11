using Toybox;
using Toybox.Graphics;
using Toybox.UI;
using Toybox.UI.Menu2;

// Main menu view - updated with apnea tables
class MainMenuView extends Menu2 {
    var exercises;
    var apneaTables;
    var userSettings;
    
    function initialize() {
        Menu2.initialize();
        
        // Load user settings
        userSettings = UserSettings.load();
        
        // Load all exercises
        exercises = Exercise.getAllExercises();
        
        // Load all apnea tables
        apneaTables = ApneaTable.getAllApneaTables();
        
        // Add breathing exercises to menu
        this.addItem("--- RESPIRATION ---", null);
        for (var i = 0; i < exercises.size(); i++) {
            var exercise = exercises[i];
            var displayName = exercise.name;
            if (exercise.name == userSettings.favoriteExercise) {
                displayName = displayName + " *";
            }
            this.addItem(displayName, :onExerciseSelected);
        }
        
        // Add apnea tables to menu
        this.addItem("--- TABLES APNÉE ---", null);
        for (var j = 0; j < apneaTables.size(); j++) {
            var table = apneaTables[j];
            var tableDisplayName = table.name;
            if (table.name == userSettings.favoriteApneaTable) {
                tableDisplayName = tableDisplayName + " *";
            }
            this.addItem(tableDisplayName, :onApneaTableSelected);
        }
        
        // Add settings and other options
        this.addItem("--- RÉGLAAGES ---", null);
        this.addItem("Réglages", :onSettingsSelected);
        this.addItem("Historique", :onHistorySelected);
        this.addItem("À propos", :onAboutSelected);
    }
    
    function onExerciseSelected(index) {
        // Adjust index for the separator items
        var exerciseIndex = index - 1;  // Skip the first separator
        if (exerciseIndex >= 0 && exerciseIndex < exercises.size()) {
            var exercise = exercises[exerciseIndex];
            var exerciseView = new ExerciseView(exercise);
            View.setView(exerciseView);
        }
    }
    
    function onApneaTableSelected(index) {
        // Calculate table index: skip breathing exercises + 2 separators
        var tableIndex = index - exercises.size() - 2;
        if (tableIndex >= 0 && tableIndex < apneaTables.size()) {
            var table = apneaTables[tableIndex];
            var tableView = new ApneaTableView(table);
            View.setView(tableView);
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