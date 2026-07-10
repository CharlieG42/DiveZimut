using Toybox;

// Main application class
class DiveZimutAppView extends Application.AppBase {
    
    function initialize() {
        AppBase.initialize();
    }
    
    function onStart() {
        // Initialize and show main menu
        var mainMenu = new MainMenuView();
        View.setView(mainMenu);
    }
    
    function onStop() {
        // Clean up resources
    }
}