using Toybox;
using Toybox.Graphics;
using Toybox.UI;

// Settings view
class SettingsView extends View {
    var userSettings;
    var exercises;
    var selectedItem;
    
    function initialize() {
        View.initialize();
        userSettings = UserSettings.load();
        exercises = Exercise.getAllExercises();
        selectedItem = 0;
    }
    
    function onStart() {
        updateDisplay();
    }
    
    function updateDisplay() {
        var dc = View.getDC();
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        // Clear screen
        dc.setColor(0, 0, 0);
        dc.fillRectangle(0, 0, width, height);
        
        // Draw title
        dc.setColor(255, 255, 255);
        dc.setFont(Graphics.FONT_MEDIUM);
        dc.drawText(width / 2, 20, "REGLAAGES", Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw settings items
        var y = 50;
        var lineHeight = 30;
        
        // Default duration
        dc.setFont(Graphics.FONT_SMALL);
        dc.drawText(10, y, "Duree defaut:", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(width - 50, y, userSettings.defaultDuration + "s", Graphics.TEXT_JUSTIFY_RIGHT);
        y += lineHeight;
        
        // Favorite exercise
        dc.drawText(10, y, "Exercice favori:", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(width - 50, y, userSettings.favoriteExercise, Graphics.TEXT_JUSTIFY_RIGHT);
        y += lineHeight;
        
        // Vibration
        dc.drawText(10, y, "Vibrations:", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(width - 50, y, userSettings.enableVibration ? "ON" : "OFF", Graphics.TEXT_JUSTIFY_RIGHT);
        y += lineHeight;
        
        // Highlight selected item
        if (selectedItem >= 0 && selectedItem < 3) {
            var highlightY = 50 + selectedItem * lineHeight;
            dc.setColor(100, 100, 255);
            dc.fillRectangle(0, highlightY - 2, width, lineHeight);
            dc.setColor(255, 255, 255);
        }
        
        // Instructions
        dc.setFont(Graphics.FONT_TINY);
        dc.drawText(width / 2, height - 10, "BACK: Retour", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function onKeyPress(key) {
        if (key == Key.BACK) {
            UserSettings.save(userSettings);
            var mainMenu = new MainMenuView();
            View.setView(mainMenu);
            return true;
        } else if (key == Key.UP) {
            selectedItem = (selectedItem - 1 + 3) % 3;
            updateDisplay();
            return true;
        } else if (key == Key.DOWN) {
            selectedItem = (selectedItem + 1) % 3;
            updateDisplay();
            return true;
        } else if (key == Key.ENTER) {
            modifySelectedSetting();
            return true;
        }
        return false;
    }
    
    function modifySelectedSetting() {
        if (selectedItem == 0) {
            userSettings.defaultDuration = (userSettings.defaultDuration % 20) + 1;
        } else if (selectedItem == 1) {
            var currentIndex = 0;
            for (var i = 0; i < exercises.size(); i++) {
                if (exercises[i].name == userSettings.favoriteExercise) {
                    currentIndex = i;
                    break;
                }
            }
            currentIndex = (currentIndex + 1) % exercises.size();
            userSettings.favoriteExercise = exercises[currentIndex].name;
        } else if (selectedItem == 2) {
            userSettings.enableVibration = !userSettings.enableVibration;
        }
        updateDisplay();
    }
}