using Toybox;
using Toybox.FileSystem;

// User settings model - extended for apnea training
class UserSettings {
    // Settings version for migration support
    var settingsVersion = 2;
    
    // Breathing exercise settings
    var defaultDuration;
    var favoriteExercise;
    var enableVibration;
    var enableSound;
    
    // Apnea training settings
    var maxApneaTime;
    var co2ToleranceLevel;
    var o2EfficiencyLevel;
    var favoriteApneaTable;
    
    // Display settings
    var showPhaseTimer;
    var showCycleCounter;
    
    // Default values
    var DEFAULT_DURATION = 4;
    var DEFAULT_MAX_APNEA_TIME = 120;
    var DEFAULT_CO2_TOLERANCE = 1;
    var DEFAULT_O2_EFFICIENCY = 1;
    var DEFAULT_FAVORITE_EXERCISE = "Carre";
    var DEFAULT_FAVORITE_TABLE = "CO2 Debutant";
    
    /**
     * Initializes user settings with default values
     */
    function initialize() {
        defaultDuration = DEFAULT_DURATION;
        favoriteExercise = DEFAULT_FAVORITE_EXERCISE;
        enableVibration = true;
        enableSound = false;
        maxApneaTime = DEFAULT_MAX_APNEA_TIME;
        co2ToleranceLevel = DEFAULT_CO2_TOLERANCE;
        o2EfficiencyLevel = DEFAULT_O2_EFFICIENCY;
        favoriteApneaTable = DEFAULT_FAVORITE_TABLE;
        showPhaseTimer = true;
        showCycleCounter = true;
    }
    
    /**
     * Loads settings from file
     * @return {UserSettings} UserSettings object with loaded values
     */
    function static load() {
        var file = FileSystem.open("/settings.dat", FileSystem.READ);
        if (file != null) {
            try {
                var data = file.readAll();
                file.close();
                
                if (data != null && data.size() > 0) {
                    return parseSettings(data);
                }
            } catch (e) {
                System.println("Error loading settings: " + e);
            }
        }
        return new UserSettings();
    }
    
    /**
     * Parses settings data from string
     * @param {String} data - Settings data string
     * @return {UserSettings} Parsed UserSettings object
     */
    function static parseSettings(data) {
        var settings = new UserSettings();
        var parts = Lang.splitString(data, "|");
        
        try {
            if (parts.size() >= 2) {
                var version = Lang.parseInt(parts[0]);
                
                if (version >= 2) {
                    // Version 2 format
                    if (parts.size() >= 11) {
                        settings.defaultDuration = Lang.parseInt(parts[1]);
                        settings.favoriteExercise = parts[2];
                        settings.enableVibration = Lang.parseBoolean(parts[3]);
                        settings.enableSound = Lang.parseBoolean(parts[4]);
                        settings.maxApneaTime = Lang.parseInt(parts[5]);
                        settings.co2ToleranceLevel = Lang.parseInt(parts[6]);
                        settings.o2EfficiencyLevel = Lang.parseInt(parts[7]);
                        settings.favoriteApneaTable = parts[8];
                        settings.showPhaseTimer = Lang.parseBoolean(parts[9]);
                        settings.showCycleCounter = Lang.parseBoolean(parts[10]);
                    }
                } else {
                    // Version 1 format (CSV)
                    if (parts.size() >= 9) {
                        settings.defaultDuration = Lang.parseInt(parts[0]);
                        settings.favoriteExercise = parts[1];
                        settings.enableVibration = Lang.parseBoolean(parts[2]);
                        settings.enableSound = Lang.parseBoolean(parts[3]);
                        settings.maxApneaTime = Lang.parseInt(parts[4]);
                        settings.co2ToleranceLevel = Lang.parseInt(parts[5]);
                        settings.o2EfficiencyLevel = Lang.parseInt(parts[6]);
                        settings.favoriteApneaTable = parts[7];
                        // Default values for new fields
                        settings.showPhaseTimer = true;
                        settings.showCycleCounter = true;
                    } else if (parts.size() >= 4) {
                        // Very old format
                        settings.defaultDuration = Lang.parseInt(parts[0]);
                        settings.favoriteExercise = parts[1];
                        settings.enableVibration = Lang.parseBoolean(parts[2]);
                        settings.enableSound = Lang.parseBoolean(parts[3]);
                        // Set defaults for new fields
                        settings.maxApneaTime = DEFAULT_MAX_APNEA_TIME;
                        settings.co2ToleranceLevel = DEFAULT_CO2_TOLERANCE;
                        settings.o2EfficiencyLevel = DEFAULT_O2_EFFICIENCY;
                        settings.favoriteApneaTable = DEFAULT_FAVORITE_TABLE;
                        settings.showPhaseTimer = true;
                        settings.showCycleCounter = true;
                    }
                }
            }
        } catch (e) {
            System.println("Error parsing settings: " + e);
            // Return default settings on parse error
            return new UserSettings();
        }
        
        // Validate loaded values
        settings.validate();
        return settings;
    }
    
    /**
     * Validates and corrects settings values
     */
    function validate() {
        // Validate defaultDuration
        if (defaultDuration < 1 || defaultDuration > 20) {
            defaultDuration = DEFAULT_DURATION;
        }
        
        // Validate maxApneaTime
        if (maxApneaTime < 30 || maxApneaTime > 600) {
            maxApneaTime = DEFAULT_MAX_APNEA_TIME;
        }
        
        // Validate tolerance levels
        if (co2ToleranceLevel < 1 || co2ToleranceLevel > 5) {
            co2ToleranceLevel = DEFAULT_CO2_TOLERANCE;
        }
        
        if (o2EfficiencyLevel < 1 || o2EfficiencyLevel > 5) {
            o2EfficiencyLevel = DEFAULT_O2_EFFICIENCY;
        }
        
        // Validate favorite exercise
        var validExercises = Exercise.getAllExercises();
        var found = false;
        for (var i = 0; i < validExercises.size(); i++) {
            if (validExercises[i].name == favoriteExercise) {
                found = true;
                break;
            }
        }
        if (!found) {
            favoriteExercise = DEFAULT_FAVORITE_EXERCISE;
        }
        
        // Validate favorite table
        var validTables = ApneaTable.getAllApneaTables();
        found = false;
        for (var i = 0; i < validTables.size(); i++) {
            if (validTables[i].name == favoriteApneaTable) {
                found = true;
                break;
            }
        }
        if (!found) {
            favoriteApneaTable = DEFAULT_FAVORITE_TABLE;
        }
    }
    
    /**
     * Saves settings to file
     * @param {UserSettings} settings - Settings to save
     */
    function static save(settings) {
        // Validate before saving
        settings.validate();
        
        var file = FileSystem.open("/settings.dat", FileSystem.WRITE);
        if (file != null) {
            try {
                var data = buildSettingsString(settings);
                file.writeAll(data);
            } finally {
                file.close();
            }
        }
    }
    
    /**
     * Builds settings string for saving
     * @param {UserSettings} settings - Settings to serialize
     * @return {String} Settings data string
     */
    function static buildSettingsString(settings) {
        return settingsVersion + "|" +
               settings.defaultDuration + "|" +
               settings.favoriteExercise + "|" +
               (settings.enableVibration ? "true" : "false") + "|" +
               (settings.enableSound ? "true" : "false") + "|" +
               settings.maxApneaTime + "|" +
               settings.co2ToleranceLevel + "|" +
               settings.o2EfficiencyLevel + "|" +
               settings.favoriteApneaTable + "|" +
               (settings.showPhaseTimer ? "true" : "false") + "|" +
               (settings.showCycleCounter ? "true" : "false");
    }
    
    // Update methods with validation
    
    /**
     * Updates default duration
     * @param {int} duration - New duration in seconds
     */
    function updateDefaultDuration(duration) {
        if (duration >= 1 && duration <= 20) {
            defaultDuration = duration;
        }
    }
    
    /**
     * Updates favorite exercise
     * @param {String} exerciseName - Name of the favorite exercise
     */
    function updateFavoriteExercise(exerciseName) {
        // Validate that the exercise exists
        var exercise = Exercise.getExerciseByName(exerciseName);
        if (exercise != null) {
            favoriteExercise = exerciseName;
        }
    }
    
    /**
     * Updates vibration setting
     * @param {boolean} enabled - Whether vibrations are enabled
     */
    function updateVibration(enabled) {
        enableVibration = enabled;
    }
    
    /**
     * Updates sound setting
     * @param {boolean} enabled - Whether sound is enabled
     */
    function updateSound(enabled) {
        enableSound = enabled;
    }
    
    /**
     * Updates max apnea time
     * @param {int} time - Max apnea time in seconds
     */
    function updateMaxApneaTime(time) {
        if (time >= 30 && time <= 600) {
            maxApneaTime = time;
        }
    }
    
    /**
     * Updates CO2 tolerance level
     * @param {int} level - Tolerance level (1-5)
     */
    function updateCO2Tolerance(level) {
        if (level >= 1 && level <= 5) {
            co2ToleranceLevel = level;
        }
    }
    
    /**
     * Updates O2 efficiency level
     * @param {int} level - Efficiency level (1-5)
     */
    function updateO2Efficiency(level) {
        if (level >= 1 && level <= 5) {
            o2EfficiencyLevel = level;
        }
    }
    
    /**
     * Updates favorite apnea table
     * @param {String} tableName - Name of the favorite table
     */
    function updateFavoriteApneaTable(tableName) {
        // Validate that the table exists
        var table = ApneaTable.getTableByName(tableName);
        if (table != null) {
            favoriteApneaTable = tableName;
        }
    }
    
    /**
     * Updates phase timer display setting
     * @param {boolean} enabled - Whether to show phase timer
     */
    function updateShowPhaseTimer(enabled) {
        showPhaseTimer = enabled;
    }
    
    /**
     * Updates cycle counter display setting
     * @param {boolean} enabled - Whether to show cycle counter
     */
    function updateShowCycleCounter(enabled) {
        showCycleCounter = enabled;
    }
    
    // Getter methods
    
    /**
     * Gets CO2 tolerance level name
     * @return {String} Tolerance level name
     */
    function getCO2ToleranceName() {
        if (co2ToleranceLevel == 1) {
            return "Debutant";
        } else if (co2ToleranceLevel == 2) {
            return "Intermediaire-";
        } else if (co2ToleranceLevel == 3) {
            return "Intermediaire";
        } else if (co2ToleranceLevel == 4) {
            return "Intermediaire+";
        } else if (co2ToleranceLevel == 5) {
            return "Avance";
        }
        return "Inconnu";
    }
    
    /**
     * Gets O2 efficiency level name
     * @return {String} Efficiency level name
     */
    function getO2EfficiencyName() {
        if (o2EfficiencyLevel == 1) {
            return "Debutant";
        } else if (o2EfficiencyLevel == 2) {
            return "Intermediaire-";
        } else if (o2EfficiencyLevel == 3) {
            return "Intermediaire";
        } else if (o2EfficiencyLevel == 4) {
            return "Intermediaire+";
        } else if (o2EfficiencyLevel == 5) {
            return "Avance";
        }
        return "Inconnu";
    }
    
    /**
     * Gets max apnea time formatted as MM:SS
     * @return {String} Formatted time string
     */
    function getMaxApneaTimeFormatted() {
        return TimeUtils.formatTime(maxApneaTime);
    }
    
    /**
     * Gets max apnea time formatted as short string
     * @return {String} Short formatted time string
     */
    function getMaxApneaTimeShortFormatted() {
        return TimeUtils.formatShortTime(maxApneaTime);
    }
    
    /**
     * Gets recommended tables based on user's max apnea time
     * @return {Array} Array of recommended ApneaTable objects
     */
    function getRecommendedTables() {
        var recommendations = [];
        var allTables = ApneaTable.getAllApneaTables();
        
        for (var i = 0; i < allTables.size(); i++) {
            var table = allTables[i];
            if (table.isSuitableFor(maxApneaTime)) {
                recommendations.push(table);
            }
        }
        
        return recommendations;
    }
    
    /**
     * Gets recommended exercises based on user's level
     * @return {Array} Array of recommended Exercise objects
     */
    function getRecommendedExercises() {
        var allExercises = Exercise.getAllExercises();
        var level = getUserLevel();
        
        // For now, return all exercises
        // Could be enhanced to filter based on level
        return allExercises;
    }
    
    /**
     * Estimates user level based on max apnea time
     * @return {int} Level (1-3)
     */
    function getUserLevel() {
        if (maxApneaTime < 60) {
            return 1; // Beginner
        } else if (maxApneaTime < 120) {
            return 2; // Intermediate
        } else {
            return 3; // Advanced
        }
    }
    
    /**
     * Gets user level name
     * @return {String} Level name
     */
    function getUserLevelName() {
        var level = getUserLevel();
        if (level == 1) {
            return "Debutant";
        } else if (level == 2) {
            return "Intermediaire";
        } else {
            return "Avance";
        }
    }
    
    /**
     * Resets settings to default values
     */
    function resetToDefaults() {
        defaultDuration = DEFAULT_DURATION;
        favoriteExercise = DEFAULT_FAVORITE_EXERCISE;
        enableVibration = true;
        enableSound = false;
        maxApneaTime = DEFAULT_MAX_APNEA_TIME;
        co2ToleranceLevel = DEFAULT_CO2_TOLERANCE;
        o2EfficiencyLevel = DEFAULT_O2_EFFICIENCY;
        favoriteApneaTable = DEFAULT_FAVORITE_TABLE;
        showPhaseTimer = true;
        showCycleCounter = true;
    }
}
