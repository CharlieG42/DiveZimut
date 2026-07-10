using Toybox;
using Toybox.Graphics;
using Toybox.UI;

// About view
class AboutView extends View {
    function initialize() {
        View.initialize();
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
        dc.drawText(width / 2, 20, "A PROPOS", Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw content
        dc.setFont(Graphics.FONT_SMALL);
        var y = 50;
        var lineHeight = 20;
        
        dc.drawText(width / 2, y, "DiveZimut v1.0.0", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        dc.drawText(width / 2, y, "Exercices de respiration", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        dc.drawText(width / 2, y, "pour Garmin Instinct 2X", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight * 2;
        
        dc.drawText(width / 2, y, "Developpe par:", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        dc.drawText(width / 2, y, "WildZimut", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight * 2;
        
        dc.setFont(Graphics.FONT_TINY);
        dc.drawText(width / 2, height - 10, "BACK: Retour", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function onKeyPress(key) {
        if (key == Key.BACK) {
            var mainMenu = new MainMenuView();
            View.setView(mainMenu);
            return true;
        }
        return false;
    }
}