using Toybox;
using Toybox.Graphics;
using Toybox.UI;

// History view - shows past sessions
class HistoryView extends View {
    var historyItems;
    var selectedItem;
    
    function initialize() {
        View.initialize();
        historyItems = [];
        selectedItem = 0;
        
        // Add dummy data for testing
        historyItems.push(new HistoryItem("Carre", "2026-07-10", 5, 20));
        historyItems.push(new HistoryItem("Triangle", "2026-07-09", 3, 15));
        historyItems.push(new HistoryItem("4-7-8", "2026-07-08", 4, 10));
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
        dc.drawText(width / 2, 20, "HISTORIQUE", Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw history items
        var y = 50;
        var lineHeight = 40;
        
        if (historyItems.size() == 0) {
            dc.setFont(Graphics.FONT_SMALL);
            dc.drawText(width / 2, height / 2, "Aucune session", Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            for (var i = 0; i < historyItems.size(); i++) {
                var item = historyItems[i];
                
                if (i == selectedItem) {
                    dc.setColor(50, 50, 100);
                    dc.fillRectangle(0, y - 2, width, lineHeight);
                }
                
                dc.setColor(255, 255, 255);
                dc.setFont(Graphics.FONT_SMALL);
                
                dc.drawText(10, y, item.date, Graphics.TEXT_JUSTIFY_LEFT);
                dc.drawText(width / 2, y, item.exerciseName, Graphics.TEXT_JUSTIFY_CENTER);
                dc.drawText(width - 60, y, item.duration + "min", Graphics.TEXT_JUSTIFY_RIGHT);
                
                y += lineHeight;
            }
        }
        
        // Instructions
        dc.setFont(Graphics.FONT_TINY);
        dc.drawText(width / 2, height - 10, "BACK: Retour", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function onKeyPress(key) {
        if (key == Key.BACK) {
            var mainMenu = new MainMenuView();
            View.setView(mainMenu);
            return true;
        } else if (key == Key.UP) {
            selectedItem = (selectedItem - 1 + historyItems.size()) % historyItems.size();
            updateDisplay();
            return true;
        } else if (key == Key.DOWN) {
            selectedItem = (selectedItem + 1) % historyItems.size();
            updateDisplay();
            return true;
        }
        return false;
    }
}

// History item class
class HistoryItem {
    var exerciseName;
    var date;
    var duration;
    var totalTime;
    
    function initialize(name, dateStr, dur, total) {
        exerciseName = name;
        date = dateStr;
        duration = dur;
        totalTime = total;
    }
}