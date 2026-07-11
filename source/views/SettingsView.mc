using Toybox;
using Toybox.Graphics;
using Toybox.UI;

// Settings view - updated with apnea-specific settings
class SettingsView extends View {
    var userSettings;
    var exercises;
    var apneaTables;
    var selectedItem;
    var numItems;
    
    function initialize() {
        View.initialize();
        userSettings = UserSettings.load();
        exercises = Exercise.getAllExercises();
        apneaTables = ApneaTable.getAllApneaTables();
        selectedItem = 0;
        numItems = 7;  // Total number of settings items
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
        dc.drawText(width / 2, 10, "REGLAAGES", Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw settings items
        var y = 35;
        var lineHeight = 25;
        
        // 1. Default duration for breathing exercises
        drawSettingItem(dc, y, "Durée défaut resp.", userSettings.defaultDuration + "s", selectedItem == 0);
        y += lineHeight;
        
        // 2. Favorite breathing exercise
        drawSettingItem(dc, y, "Exercice favori resp.", userSettings.favoriteExercise, selectedItem == 1);
        y += lineHeight;
        
        // 3. Vibration
        drawSettingItem(dc, y, "Vibrations", userSettings.enableVibration ? "ON" : "OFF", selectedItem == 2);
        y += lineHeight;
        
        // 4. Max apnea time
        drawSettingItem(dc, y, "Temps max apnée", userSettings.getMaxApneaTimeFormatted(), selectedItem == 3);
        y += lineHeight;
        
        // 5. CO2 tolerance level
        drawSettingItem(dc, y, "Tolérance CO2", userSettings.getCO2ToleranceName(), selectedItem == 4);
        y += lineHeight;
        
        // 6. O2 efficiency level
        drawSettingItem(dc, y, "Efficacité O2", userSettings.getO2EfficiencyName(), selectedItem == 5);
        y += lineHeight;
        
        // 7. Favorite apnea table
        drawSettingItem(dc, y, "Table apnée favori", userSettings.favoriteApneaTable, selectedItem == 6);
        
        // Instructions
        dc.setFont(Graphics.FONT_TINY);
        dc.setColor(150, 150, 150);
        dc.drawText(width / 2, height - 30, "UP/DOWN: Sélectionner", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, height - 20, "ENTER: Modifier", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, height - 10, "BACK: Retour", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function drawSettingItem(dc, y, label, value, isSelected) {
        var width = dc.getWidth();
        
        if (isSelected) {
            dc.setColor(100, 100, 255);
            dc.fillRectangle(0, y - 2, width, 22);
        }
        
        dc.setColor(255, 255, 255);
        dc.setFont(Graphics.FONT_SMALL);
        dc.drawText(10, y, label, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(width - 10, y, value, Graphics.TEXT_JUSTIFY_RIGHT);
    }
    
    function onKeyPress(key) {
        if (key == Key.BACK) {
            UserSettings.save(userSettings);
            var mainMenu = new MainMenuView();
            View.setView(mainMenu);
            return true;
        } else if (key == Key.UP) {
            selectedItem = (selectedItem - 1 + numItems) % numItems;
            updateDisplay();
            return true;
        } else if (key == Key.DOWN) {
            selectedItem = (selectedItem + 1) % numItems;
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
            // Default duration
            userSettings.defaultDuration = (userSettings.defaultDuration % 20) + 1;
        } else if (selectedItem == 1) {
            // Favorite breathing exercise
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
            // Vibration toggle
            userSettings.enableVibration = !userSettings.enableVibration;
        } else if (selectedItem == 3) {
            // Max apnea time
            userSettings.maxApneaTime = userSettings.maxApneaTime + 30;
            if (userSettings.maxApneaTime > 600) {
                userSettings.maxApneaTime = 30;
            }
        } else if (selectedItem == 4) {
            // CO2 tolerance level
            userSettings.co2ToleranceLevel = (userSettings.co2ToleranceLevel % 5) + 1;
        } else if (selectedItem == 5) {
            // O2 efficiency level
            userSettings.o2EfficiencyLevel = (userSettings.o2EfficiencyLevel % 5) + 1;
        } else if (selectedItem == 6) {
            // Favorite apnea table
            var currentIndex = 0;
            for (var i = 0; i < apneaTables.size(); i++) {
                if (apneaTables[i].name == userSettings.favoriteApneaTable) {
                    currentIndex = i;
                    break;
                }
            }
            currentIndex = (currentIndex + 1) % apneaTables.size();
            userSettings.favoriteApneaTable = apneaTables[currentIndex].name;
        }
        updateDisplay();
    }
}