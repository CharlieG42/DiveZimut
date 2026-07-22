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
    var scrollPosition;
    var maxVisibleItems;
    
    // Setting item indices
    var ITEM_DEFAULT_DURATION = 0;
    var ITEM_FAVORITE_EXERCISE = 1;
    var ITEM_VIBRATION = 2;
    var ITEM_SOUND = 3;
    var ITEM_MAX_APNEA_TIME = 4;
    var ITEM_CO2_TOLERANCE = 5;
    var ITEM_O2_EFFICIENCY = 6;
    var ITEM_FAVORITE_TABLE = 7;
    var ITEM_SHOW_PHASE_TIMER = 8;
    var ITEM_SHOW_CYCLE_COUNTER = 9;
    var ITEM_RESET_SETTINGS = 10;
    var ITEM_SAVE_AND_EXIT = 11;
    
    function initialize() {
        View.initialize();
        userSettings = UserSettings.load();
        exercises = Exercise.getAllExercises();
        apneaTables = ApneaTable.getAllApneaTables();
        selectedItem = 0;
        numItems = 12;
        scrollPosition = 0;
        maxVisibleItems = 7;
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
        var lineHeight = 22;
        
        // Draw visible items
        for (var i = scrollPosition; i < Math.min(scrollPosition + maxVisibleItems, numItems); i++) {
            drawSettingItem(dc, y, i, selectedItem == i);
            y += lineHeight;
        }
        
        // Draw scroll indicator if needed
        if (numItems > maxVisibleItems) {
            dc.setFont(Graphics.FONT_TINY);
            dc.setColor(100, 100, 100);
            var scrollText = (scrollPosition + 1) + "/" + (numItems - maxVisibleItems + 1);
            dc.drawText(width - 30, height - 10, scrollText, Graphics.TEXT_JUSTIFY_RIGHT);
        }
        
        // Draw user level
        dc.setFont(Graphics.FONT_TINY);
        dc.setColor(200, 200, 0);
        dc.drawText(10, height - 10, "Niveau: " + userSettings.getUserLevelName(), Graphics.TEXT_JUSTIFY_LEFT);
        
        // Instructions
        dc.setFont(Graphics.FONT_TINY);
        dc.setColor(150, 150, 150);
        dc.drawText(width / 2, height - 30, "UP/DOWN: Naviguer", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, height - 20, "ENTER: Modifier", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, height - 10, "BACK: Retour", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    /**
     * Draws a single setting item
     * @param {Graphics.DC} dc - Drawing context
     * @param {int} y - Y position
     * @param {int} itemIndex - Index of the setting item
     * @param {boolean} isSelected - Whether the item is selected
     */
    function drawSettingItem(dc, y, itemIndex, isSelected) {
        var width = dc.getWidth();
        var label = "";
        var value = "";
        
        // Set label and value based on item index
        switch (itemIndex) {
            case ITEM_DEFAULT_DURATION:
                label = "Duree defaut resp.";
                value = userSettings.defaultDuration + "s";
                break;
            case ITEM_FAVORITE_EXERCISE:
                label = "Exercice favori";
                value = userSettings.favoriteExercise;
                break;
            case ITEM_VIBRATION:
                label = "Vibrations";
                value = userSettings.enableVibration ? "ON" : "OFF";
                break;
            case ITEM_SOUND:
                label = "Son";
                value = userSettings.enableSound ? "ON" : "OFF";
                break;
            case ITEM_MAX_APNEA_TIME:
                label = "Temps max apnee";
                value = userSettings.getMaxApneaTimeFormatted();
                break;
            case ITEM_CO2_TOLERANCE:
                label = "Tolerance CO2";
                value = userSettings.getCO2ToleranceName();
                break;
            case ITEM_O2_EFFICIENCY:
                label = "Efficacite O2";
                value = userSettings.getO2EfficiencyName();
                break;
            case ITEM_FAVORITE_TABLE:
                label = "Table favori";
                value = userSettings.favoriteApneaTable;
                break;
            case ITEM_SHOW_PHASE_TIMER:
                label = "Afficher timer";
                value = userSettings.showPhaseTimer ? "ON" : "OFF";
                break;
            case ITEM_SHOW_CYCLE_COUNTER:
                label = "Afficher compteur";
                value = userSettings.showCycleCounter ? "ON" : "OFF";
                break;
            case ITEM_RESET_SETTINGS:
                label = "Reinitialiser";
                value = "";
                break;
            case ITEM_SAVE_AND_EXIT:
                label = "Sauvegarder";
                value = "";
                break;
        }
        
        // Draw background if selected
        if (isSelected) {
            dc.setColor(100, 100, 255);
            dc.fillRectangle(0, y - 2, width, 20);
        }
        
        // Draw label
        dc.setColor(255, 255, 255);
        dc.setFont(Graphics.FONT_SMALL);
        dc.drawText(10, y, label, Graphics.TEXT_JUSTIFY_LEFT);
        
        // Draw value
        if (value.size() > 0) {
            dc.drawText(width - 10, y, value, Graphics.TEXT_JUSTIFY_RIGHT);
        }
    }
    
    function onKeyPress(key) {
        if (key == Key.BACK) {
            // Save settings before exiting
            UserSettings.save(userSettings);
            var mainMenu = new MainMenuView();
            View.setView(mainMenu);
            return true;
        } else if (key == Key.UP) {
            selectedItem = (selectedItem - 1 + numItems) % numItems;
            // Adjust scroll position
            if (selectedItem < scrollPosition) {
                scrollPosition = selectedItem;
            } else if (selectedItem >= scrollPosition + maxVisibleItems) {
                scrollPosition = selectedItem - maxVisibleItems + 1;
            }
            updateDisplay();
            return true;
        } else if (key == Key.DOWN) {
            selectedItem = (selectedItem + 1) % numItems;
            // Adjust scroll position
            if (selectedItem >= scrollPosition + maxVisibleItems) {
                scrollPosition = selectedItem - maxVisibleItems + 1;
            } else if (selectedItem < scrollPosition) {
                scrollPosition = selectedItem;
            }
            updateDisplay();
            return true;
        } else if (key == Key.ENTER) {
            modifySelectedSetting();
            return true;
        }
        return false;
    }
    
    function modifySelectedSetting() {
        switch (selectedItem) {
            case ITEM_DEFAULT_DURATION:
                userSettings.updateDefaultDuration((userSettings.defaultDuration % 20) + 1);
                break;
            case ITEM_FAVORITE_EXERCISE:
                var currentIndex = 0;
                for (var i = 0; i < exercises.size(); i++) {
                    if (exercises[i].name == userSettings.favoriteExercise) {
                        currentIndex = i;
                        break;
                    }
                }
                currentIndex = (currentIndex + 1) % exercises.size();
                userSettings.updateFavoriteExercise(exercises[currentIndex].name);
                break;
            case ITEM_VIBRATION:
                userSettings.updateVibration(!userSettings.enableVibration);
                break;
            case ITEM_SOUND:
                userSettings.updateSound(!userSettings.enableSound);
                break;
            case ITEM_MAX_APNEA_TIME:
                var newTime = userSettings.maxApneaTime + 30;
                if (newTime > 600) {
                    newTime = 30;
                }
                userSettings.updateMaxApneaTime(newTime);
                break;
            case ITEM_CO2_TOLERANCE:
                userSettings.updateCO2Tolerance((userSettings.co2ToleranceLevel % 5) + 1);
                break;
            case ITEM_O2_EFFICIENCY:
                userSettings.updateO2Efficiency((userSettings.o2EfficiencyLevel % 5) + 1);
                break;
            case ITEM_FAVORITE_TABLE:
                var currentIndex = 0;
                for (var i = 0; i < apneaTables.size(); i++) {
                    if (apneaTables[i].name == userSettings.favoriteApneaTable) {
                        currentIndex = i;
                        break;
                    }
                }
                currentIndex = (currentIndex + 1) % apneaTables.size();
                userSettings.updateFavoriteApneaTable(apneaTables[currentIndex].name);
                break;
            case ITEM_SHOW_PHASE_TIMER:
                userSettings.updateShowPhaseTimer(!userSettings.showPhaseTimer);
                break;
            case ITEM_SHOW_CYCLE_COUNTER:
                userSettings.updateShowCycleCounter(!userSettings.showCycleCounter);
                break;
            case ITEM_RESET_SETTINGS:
                // Confirm reset
                userSettings.resetToDefaults();
                break;
            case ITEM_SAVE_AND_EXIT:
                UserSettings.save(userSettings);
                var mainMenu = new MainMenuView();
                View.setView(mainMenu);
                break;
        }
        updateDisplay();
    }
}
