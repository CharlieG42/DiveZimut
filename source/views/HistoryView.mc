using Toybox;
using Toybox.Graphics;
using Toybox.UI;

// History view - shows past sessions
class HistoryView extends View {
    var historyItems;
    var selectedItem;
    var scrollPosition;
    var maxVisibleItems;
    var showStatistics;
    
    function initialize() {
        View.initialize();
        historyItems = [];
        selectedItem = 0;
        scrollPosition = 0;
        maxVisibleItems = 5;
        showStatistics = false;
    }
    
    function onStart() {
        loadHistory();
        updateDisplay();
    }
    
    /**
     * Loads history from persistent storage
     */
    function loadHistory() {
        historyItems = HistoryManager.loadHistory();
        if (historyItems.size() == 0) {
            // Add dummy data for testing if no history exists
            // historyItems.push(new HistoryManager.HistoryItem("Carre", null, "2026-07-10", "10:00:00", 300, 300, 5, "EXERCISE"));
            // historyItems.push(new HistoryManager.HistoryItem(null, "CO2 Debutant", "2026-07-09", "09:00:00", 900, 900, 8, "APNEA_TABLE"));
        }
    }
    
    /**
     * Refreshes the history display
     */
    function refresh() {
        loadHistory();
        selectedItem = 0;
        scrollPosition = 0;
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
        dc.drawText(width / 2, 10, "HISTORIQUE", Graphics.TEXT_JUSTIFY_CENTER);
        
        if (showStatistics) {
            drawStatistics(dc, width, height);
        } else {
            drawHistoryList(dc, width, height);
        }
        
        // Instructions
        dc.setFont(Graphics.FONT_TINY);
        dc.setColor(150, 150, 150);
        if (showStatistics) {
            dc.drawText(width / 2, height - 10, "BACK: Retour", Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(width / 2, height - 30, "UP/DOWN: Selectionner", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, height - 20, "ENTER: Details", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, height - 10, "BACK: Retour", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
    
    /**
     * Draws the history list
     * @param {Graphics.DC} dc - Drawing context
     * @param {int} width - Screen width
     * @param {int} height - Screen height
     */
    function drawHistoryList(dc, width, height) {
        var y = 35;
        var lineHeight = 35;
        
        if (historyItems.size() == 0) {
            dc.setColor(150, 150, 150);
            dc.setFont(Graphics.FONT_SMALL);
            dc.drawText(width / 2, height / 2, "Aucune session", Graphics.TEXT_JUSTIFY_CENTER);
            return;
        }
        
        // Draw headers
        dc.setColor(200, 200, 200);
        dc.setFont(Graphics.FONT_TINY);
        dc.drawText(10, y, "Date", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(width / 2, y, "Session", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width - 60, y, "Duree", Graphics.TEXT_JUSTIFY_RIGHT);
        y += lineHeight;
        
        // Draw separator
        dc.setColor(80, 80, 80);
        dc.drawLine(0, y - 5, width, y - 5);
        
        // Draw visible items
        for (var i = scrollPosition; i < Math.min(scrollPosition + maxVisibleItems, historyItems.size()); i++) {
            var item = historyItems[i];
            
            if (i == selectedItem) {
                dc.setColor(50, 50, 100);
                dc.fillRectangle(0, y - 2, width, lineHeight);
            }
            
            dc.setColor(255, 255, 255);
            dc.setFont(Graphics.FONT_SMALL);
            
            // Draw date
            dc.drawText(10, y, item.date, Graphics.TEXT_JUSTIFY_LEFT);
            
            // Draw session name
            var sessionName = item.getDisplayName();
            dc.drawText(width / 2, y, sessionName, Graphics.TEXT_JUSTIFY_CENTER);
            
            // Draw duration
            dc.drawText(width - 60, y, item.getDisplayDuration(), Graphics.TEXT_JUSTIFY_RIGHT);
            
            // Draw session type indicator
            dc.setFont(Graphics.FONT_TINY);
            dc.setColor(150, 150, 255);
            if (item.sessionType == "EXERCISE") {
                dc.drawText(width - 55, y + 15, "R", Graphics.TEXT_JUSTIFY_RIGHT);
            } else if (item.sessionType == "APNEA_TABLE") {
                dc.drawText(width - 55, y + 15, "A", Graphics.TEXT_JUSTIFY_RIGHT);
            }
            
            y += lineHeight;
        }
        
        // Draw scroll indicator if needed
        if (historyItems.size() > maxVisibleItems) {
            dc.setFont(Graphics.FONT_TINY);
            dc.setColor(100, 100, 100);
            var scrollText = (scrollPosition + 1) + "/" + (historyItems.size() - maxVisibleItems + 1);
            dc.drawText(width - 30, height - 40, scrollText, Graphics.TEXT_JUSTIFY_RIGHT);
        }
        
        // Draw total sessions
        dc.setFont(Graphics.FONT_TINY);
        dc.setColor(200, 200, 200);
        dc.drawText(10, height - 40, "Total: " + historyItems.size() + " sessions", Graphics.TEXT_JUSTIFY_LEFT);
    }
    
    /**
     * Draws statistics view
     * @param {Graphics.DC} dc - Drawing context
     * @param {int} width - Screen width
     * @param {int} height - Screen height
     */
    function drawStatistics(dc, width, height) {
        var y = 35;
        var lineHeight = 25;
        
        dc.setColor(255, 255, 255);
        dc.setFont(Graphics.FONT_MEDIUM);
        dc.drawText(width / 2, y, "STATISTIQUES", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        // Calculate statistics
        var totalSessions = HistoryManager.getTotalSessions();
        var totalTime = HistoryManager.getTotalTime();
        
        dc.setFont(Graphics.FONT_SMALL);
        
        // Total sessions
        dc.setColor(200, 200, 200);
        dc.drawText(10, y, "Sessions totales:", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(width - 10, y, totalSessions, Graphics.TEXT_JUSTIFY_RIGHT);
        y += lineHeight;
        
        // Total time
        dc.drawText(10, y, "Temps total:", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(width - 10, y, TimeUtils.formatLongTime(totalTime), Graphics.TEXT_JUSTIFY_RIGHT);
        y += lineHeight;
        
        // Average session time
        if (totalSessions > 0) {
            var avgTime = (int)(totalTime / totalSessions);
            dc.drawText(10, y, "Moyenne/session:", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(width - 10, y, TimeUtils.formatShortTime(avgTime), Graphics.TEXT_JUSTIFY_RIGHT);
            y += lineHeight;
        }
        
        y += lineHeight;
        
        // Per type statistics
        dc.setColor(200, 200, 0);
        dc.drawText(width / 2, y, "Par type", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        var exerciseStats = HistoryManager.getStatistics(null, "EXERCISE");
        var tableStats = HistoryManager.getStatistics(null, "APNEA_TABLE");
        
        dc.setColor(200, 200, 200);
        dc.setFont(Graphics.FONT_TINY);
        
        dc.drawText(10, y, "Respiration:", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(width / 2, y, exerciseStats.count + " sessions", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width - 10, y, TimeUtils.formatShortTime(exerciseStats.totalTime), Graphics.TEXT_JUSTIFY_RIGHT);
        y += lineHeight - 5;
        
        dc.drawText(10, y, "Apnee:", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(width / 2, y, tableStats.count + " sessions", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width - 10, y, TimeUtils.formatShortTime(tableStats.totalTime), Graphics.TEXT_JUSTIFY_RIGHT);
    }
    
    function onKeyPress(key) {
        if (key == Key.BACK) {
            if (showStatistics) {
                showStatistics = false;
                updateDisplay();
            } else {
                var mainMenu = new MainMenuView();
                View.setView(mainMenu);
            }
            return true;
        } else if (key == Key.UP) {
            if (showStatistics) {
                return false;
            }
            selectedItem = (selectedItem - 1 + historyItems.size()) % historyItems.size();
            // Adjust scroll position
            if (selectedItem < scrollPosition) {
                scrollPosition = selectedItem;
            } else if (selectedItem >= scrollPosition + maxVisibleItems) {
                scrollPosition = selectedItem - maxVisibleItems + 1;
            }
            updateDisplay();
            return true;
        } else if (key == Key.DOWN) {
            if (showStatistics) {
                return false;
            }
            selectedItem = (selectedItem + 1) % historyItems.size();
            // Adjust scroll position
            if (selectedItem >= scrollPosition + maxVisibleItems) {
                scrollPosition = selectedItem - maxVisibleItems + 1;
            } else if (selectedItem < scrollPosition) {
                scrollPosition = selectedItem;
            }
            updateDisplay();
            return true;
        } else if (key == Key.ENTER) {
            if (showStatistics) {
                showStatistics = false;
                updateDisplay();
            } else if (historyItems.size() > 0) {
                showStatistics = true;
                updateDisplay();
            }
            return true;
        }
        return false;
    }
}
