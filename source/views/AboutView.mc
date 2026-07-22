using Toybox;
using Toybox.Graphics;
using Toybox.UI;

// About view - displays application information
class AboutView extends View {
    var scrollPosition;
    var maxScroll;
    
    function initialize() {
        View.initialize();
        scrollPosition = 0;
        maxScroll = 0;
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
        
        dc.drawText(width / 2, y, "DiveZimut v2.0.0", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        y += lineHeight / 2;
        
        dc.drawText(width / 2, y, "Exercices de respiration", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        dc.drawText(width / 2, y, "et tables d'apnee", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        y += lineHeight / 2;
        
        dc.drawText(width / 2, y, "Pour montres Garmin", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        dc.drawText(width / 2, y, "Instinct 2/2S/2X", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        y += lineHeight / 2;
        
        dc.drawText(width / 2, y, "Developpe par:", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        dc.drawText(width / 2, y, "WildZimut", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        y += lineHeight / 2;
        
        dc.setFont(Graphics.FONT_TINY);
        dc.setColor(200, 200, 200);
        
        dc.drawText(width / 2, y, "Contact:", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        dc.drawText(width / 2, y, "charlie@wildzimut.com", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        dc.drawText(width / 2, y, "github.com/CharlieG42/DiveZimut", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        y += lineHeight / 2;
        
        dc.setColor(150, 150, 150);
        dc.drawText(width / 2, y, "Licence: MIT", Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        
        dc.drawText(width / 2, y, "Respirez mieux, plongez plus loin", Graphics.TEXT_JUSTIFY_CENTER);
        
        // Instructions
        dc.setFont(Graphics.FONT_TINY);
        dc.setColor(100, 100, 100);
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
