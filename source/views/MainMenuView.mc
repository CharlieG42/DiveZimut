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
        
        userSettings = UserSettings.load();
        exercises = Exercise.getAllExercises();
        apneaTables = ApneaTable.getAllApneaTables();
        
        this.addItem("--- RESPIRATION ---", null);
        for (var i = 0; i < exercises.size(); i++) {
            var exercise = exercises[i];
            var displayName = exercise.name;
            if (exercise.name == userSettings.favoriteExercise) {
                displayName = displayName + " *";
            }
            this.addItem(displayName, :onExerciseSelected);
        }
        
        this.addItem("--- TABLES APNEE ---", null);
        for (var j = 0; j < apneaTables.size(); j++) {
            var table = apneaTables[j];
            var tableDisplayName = table.name;
            if (table.name == userSettings.favoriteApneaTable) {
                tableDisplayName = tableDisplayName + " *";
            }
            this.addItem(tableDisplayName, :onApneaTableSelected);
        }
        
        this.addItem("--- REGLAAGES ---", null);
        this.addItem("Reglages", :onSettingsSelected);
        this.addItem("Historique", :onHistorySelected);
        this.addItem("A propos", :onAboutSelected);
    }
    
    function onExerciseSelected(index) {
        var exerciseIndex = index - 1;
        if (exerciseIndex >= 0 && exerciseIndex < exercises.size()) {
            var exercise = exercises[exerciseIndex];
            var exerciseView = new ExerciseView(exercise);
            View.setView(exerciseView);
        }
    }
    
    function onApneaTableSelected(index) {
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