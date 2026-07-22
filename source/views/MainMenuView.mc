using Toybox;
using Toybox.Graphics;
using Toybox.UI;
using Toybox.UI.Menu2;

// Main menu view - updated with apnea tables
class MainMenuView extends Menu2 {
    var exercises;
    var apneaTables;
    var userSettings;
    var showRecommended;
    
    // Menu section indices
    var SECTION_RESPIRATION = 0;
    var SECTION_APNEA = 1;
    var SECTION_SETTINGS = 2;
    
    function initialize() {
        Menu2.initialize();
        
        userSettings = UserSettings.load();
        exercises = Exercise.getAllExercises();
        apneaTables = ApneaTable.getAllApneaTables();
        showRecommended = false;
        
        buildMenu();
    }
    
    /**
     * Builds the menu with all items
     */
    function buildMenu() {
        clearItems();
        
        // Respiration section
        this.addItem("--- RESPIRATION ---", null);
        
        if (showRecommended) {
            // Show only recommended exercises
            var recommended = userSettings.getRecommendedExercises();
            for (var i = 0; i < recommended.size(); i++) {
                var exercise = recommended[i];
                addExerciseItem(exercise);
            }
        } else {
            // Show all exercises
            for (var i = 0; i < exercises.size(); i++) {
                addExerciseItem(exercises[i]);
            }
        }
        
        // Apnea tables section
        this.addItem("--- TABLES APNEE ---", null);
        
        if (showRecommended) {
            // Show only recommended tables
            var recommended = userSettings.getRecommendedTables();
            for (var i = 0; i < recommended.size(); i++) {
                addTableItem(recommended[i]);
            }
        } else {
            // Show all tables
            for (var i = 0; i < apneaTables.size(); i++) {
                addTableItem(apneaTables[i]);
            }
        }
        
        // Settings section
        this.addItem("--- REGLAAGES ---", null);
        this.addItem("Reglages", :onSettingsSelected);
        this.addItem("Historique", :onHistorySelected);
        this.addItem("A propos", :onAboutSelected);
        
        // Add toggle for recommended view
        this.addItem("--- OPTIONS ---", null);
        this.addItem(showRecommended ? "Tout afficher" : "Recommandations", :onToggleRecommended);
    }
    
    /**
     * Adds an exercise to the menu
     * @param {Exercise} exercise - Exercise to add
     */
    function addExerciseItem(exercise) {
        var displayName = exercise.name;
        if (exercise.name == userSettings.favoriteExercise) {
            displayName = "★ " + displayName;
        }
        this.addItem(displayName + " - " + exercise.phases.size() + " phases", :onExerciseSelected);
    }
    
    /**
     * Adds an apnea table to the menu
     * @param {ApneaTable} table - Table to add
     */
    function addTableItem(table) {
        var displayName = table.name;
        if (table.name == userSettings.favoriteApneaTable) {
            displayName = "★ " + displayName;
        }
        this.addItem(displayName + " - " + table.getDifficultyName(), :onApneaTableSelected);
    }
    
    /**
     * Clears all menu items
     */
    function clearItems() {
        // Menu2 doesn't have a clear method, so we need to rebuild
        // This is a workaround by creating a new instance
        // For now, we'll just rebuild the menu
    }
    
    function onExerciseSelected(index) {
        // Calculate the actual exercise index
        // Skip the section header (1 item) and adjust for respiration section
        var exerciseIndex = index - 1;
        
        if (showRecommended) {
            var recommended = userSettings.getRecommendedExercises();
            if (exerciseIndex >= 0 && exerciseIndex < recommended.size()) {
                var exercise = recommended[exerciseIndex];
                var exerciseView = new ExerciseView(exercise);
                View.setView(exerciseView);
            }
        } else {
            if (exerciseIndex >= 0 && exerciseIndex < exercises.size()) {
                var exercise = exercises[exerciseIndex];
                var exerciseView = new ExerciseView(exercise);
                View.setView(exerciseView);
            }
        }
    }
    
    function onApneaTableSelected(index) {
        // Calculate the actual table index
        // Skip respiration section (exercises.size() + 2 for headers)
        // and apnea section header
        var respirationItems = showRecommended ? 
            userSettings.getRecommendedExercises().size() + 2 : 
            exercises.size() + 2;
        var tableIndex = index - respirationItems - 1;
        
        if (showRecommended) {
            var recommended = userSettings.getRecommendedTables();
            if (tableIndex >= 0 && tableIndex < recommended.size()) {
                var table = recommended[tableIndex];
                var tableView = new ApneaTableView(table);
                View.setView(tableView);
            }
        } else {
            if (tableIndex >= 0 && tableIndex < apneaTables.size()) {
                var table = apneaTables[tableIndex];
                var tableView = new ApneaTableView(table);
                View.setView(tableView);
            }
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
    
    /**
     * Toggles between showing all items and recommended items
     */
    function onToggleRecommended() {
        showRecommended = !showRecommended;
        buildMenu();
        // Force menu refresh by setting view again
        View.setView(this);
    }
}
