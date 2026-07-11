using Toybox;
using Toybox.FileSystem;

// User settings model - extended for apnea training
class UserSettings {
    var defaultDuration;
    var favoriteExercise;
    var enableVibration;
    var enableSound;
    var maxApneaTime;        // User's maximum apnea time in seconds
    var co2ToleranceLevel;   // 1-5 scale for CO2 tolerance
    var o2EfficiencyLevel;    // 1-5 scale for O2 efficiency
    var favoriteApneaTable;  // Favorite apnea table name
    
    function initialize() {
        defaultDuration = 4;
        favoriteExercise = "Carre";
        enableVibration = true;
        enableSound = false;
        maxApneaTime = 120;    // Default 2:00
        co2ToleranceLevel = 1;
        o2EfficiencyLevel = 1;
        favoriteApneaTable = "CO2 Débutant";
    }
    
    // Load settings from file
    function static load() {
        var file = FileSystem.open("/settings.dat", FileSystem.READ);
        if (file != null) {
            var data = file.readAll();
            file.close();
            
            var settings = new UserSettings();
            var parts = Lang.splitString(data, ",");
            if (parts.size() >= 9) {
                settings.defaultDuration = Lang.parseInt(parts[0]);
                settings.favoriteExercise = parts[1];
                settings.enableVibration = Lang.parseBoolean(parts[2]);
                settings.enableSound = Lang.parseBoolean(parts[3]);
                settings.maxApneaTime = Lang.parseInt(parts[4]);
                settings.co2ToleranceLevel = Lang.parseInt(parts[5]);
                settings.o2EfficiencyLevel = Lang.parseInt(parts[6]);
                settings.favoriteApneaTable = parts[7];
            } else if (parts.size() >= 4) {
                // Legacy format - upgrade
                settings.defaultDuration = Lang.parseInt(parts[0]);
                settings.favoriteExercise = parts[1];
                settings.enableVibration = Lang.parseBoolean(parts[2]);
                settings.enableSound = Lang.parseBoolean(parts[3]);
                // Set defaults for new fields
                settings.maxApneaTime = 120;
                settings.co2ToleranceLevel = 1;
                settings.o2EfficiencyLevel = 1;
                settings.favoriteApneaTable = "CO2 Débutant";
            }
            return settings;
        }
        return new UserSettings();
    }
    
    // Save settings to file
    function static save(settings) {
        var file = FileSystem.open("/settings.dat", FileSystem.WRITE);
        if (file != null) {
            var data = settings.defaultDuration + "," + 
                      settings.favoriteExercise + "," + 
                      settings.enableVibration + "," + 
                      settings.enableSound + "," +
                      settings.maxApneaTime + "," +
                      settings.co2ToleranceLevel + "," +
                      settings.o2EfficiencyLevel + "," +
                      settings.favoriteApneaTable;
            file.writeAll(data);
            file.close();
        }
    }
    
    // Update settings
    function updateDefaultDuration(duration) {
        if (duration >= 1 && duration <= 20) {
            defaultDuration = duration;
        }
    }
    
    function updateFavoriteExercise(exerciseName) {
        favoriteExercise = exerciseName;
    }
    
    function updateVibration(enabled) {
        enableVibration = enabled;
    }
    
    function updateMaxApneaTime(time) {
        if (time >= 30 && time <= 600) {  // 30s to 10:00
            maxApneaTime = time;
        }
    }
    
    function updateCO2Tolerance(level) {
        if (level >= 1 && level <= 5) {
            co2ToleranceLevel = level;
        }
    }
    
    function updateO2Efficiency(level) {
        if (level >= 1 && level <= 5) {
            o2EfficiencyLevel = level;
        }
    }
    
    function updateFavoriteApneaTable(tableName) {
        favoriteApneaTable = tableName;
    }
    
    // Get CO2 tolerance level name
    function getCO2ToleranceName() {
        if (co2ToleranceLevel == 1) return "Débutant";
        else if (co2ToleranceLevel == 2) return "Intermédiaire-";
        else if (co2ToleranceLevel == 3) return "Intermédiaire";
        else if (co2ToleranceLevel == 4) return "Intermédiaire+";
        else if (co2ToleranceLevel == 5) return "Avancé";
        return "Inconnu";
    }
    
    // Get O2 efficiency level name
    function getO2EfficiencyName() {
        if (o2EfficiencyLevel == 1) return "Débutant";
        else if (o2EfficiencyLevel == 2) return "Intermédiaire-";
        else if (o2EfficiencyLevel == 3) return "Intermédiaire";
        else if (o2EfficiencyLevel == 4) return "Intermédiaire+";
        else if (o2EfficiencyLevel == 5) return "Avancé";
        return "Inconnu";
    }
    
    // Get max apnea time formatted
    function getMaxApneaTimeFormatted() {
        var mins = (int)(maxApneaTime / 60);
        var secs = maxApneaTime % 60;
        if (mins > 0) {
            return mins + ":" + (secs < 10 ? "0" + secs : secs);
        } else {
            return "00:" + (secs < 10 ? "0" + secs : secs);
        }
    }
}