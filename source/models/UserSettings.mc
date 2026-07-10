using Toybox;
using Toybox.FileSystem;

// User settings model
class UserSettings {
    var defaultDuration;
    var favoriteExercise;
    var enableVibration;
    
    function initialize() {
        defaultDuration = 4;
        favoriteExercise = "Carre";
        enableVibration = true;
    }
    
    // Load settings from file
    function static load() {
        var file = FileSystem.open("/settings.dat", FileSystem.READ);
        if (file != null) {
            var data = file.readAll();
            file.close();
            
            var settings = new UserSettings();
            var parts = Lang.splitString(data, ",");
            if (parts.size() >= 3) {
                settings.defaultDuration = Lang.parseInt(parts[0]);
                settings.favoriteExercise = parts[1];
                settings.enableVibration = Lang.parseBoolean(parts[2]);
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
                      settings.enableVibration;
            file.writeAll(data);
            file.close();
        }
    }
    
    // Update default duration
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
}