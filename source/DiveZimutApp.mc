using Toybox;

// Main application class for DiveZimut
class DiveZimutAppView extends Application.AppBase {
    var viewCache;
    
    function initialize() {
        AppBase.initialize();
        viewCache = {};
    }
    
    function onStart() {
        // Initialize settings if needed
        var settings = UserSettings.load();
        UserSettings.save(settings);
        
        // Create and show main menu
        var mainMenu = getOrCreateView("MainMenuView", null);
        View.setView(mainMenu);
    }
    
    function onStop() {
        // Clean up resources
        viewCache = {};
    }
    
    /**
     * Gets a view from cache or creates a new one
     * @param {String} viewName - Name of the view class
     * @param {Object} params - Parameters for view initialization
     * @return {View} The view instance
     */
    function getOrCreateView(viewName, params) {
        if (viewCache[viewName] == null) {
            if (viewName == "MainMenuView") {
                viewCache[viewName] = new MainMenuView();
            } else if (viewName == "SettingsView") {
                viewCache[viewName] = new SettingsView();
            } else if (viewName == "HistoryView") {
                viewCache[viewName] = new HistoryView();
            } else if (viewName == "AboutView") {
                viewCache[viewName] = new AboutView();
            }
            // Note: ExerciseView and ApneaTableView are not cached
            // as they require specific parameters
        }
        return viewCache[viewName];
    }
    
    /**
     * Clears a view from cache
     * @param {String} viewName - Name of the view to clear
     */
    function clearViewCache(viewName) {
        if (viewCache[viewName] != null) {
            viewCache[viewName] = null;
        }
    }
    
    /**
     * Clears all cached views
     */
    function clearAllCache() {
        viewCache = {};
    }
}
