using Toybox;
using Toybox.FileSystem;

// Manages persistent history of user sessions
class HistoryManager {
    var historyFile = "/history.dat";
    var maxHistoryItems = 50;
    
    /**
     * History item representing a completed session
     */
    class HistoryItem {
        var exerciseName;
        var tableName;
        var date;
        var startTime;
        var duration;
        var totalTime;
        var cyclesCompleted;
        var sessionType; // "EXERCISE" or "APNEA_TABLE"
        
        function initialize(name, table, dateStr, start, dur, total, cycles, type) {
            exerciseName = name;
            tableName = table;
            date = dateStr;
            startTime = start;
            duration = dur;
            totalTime = total;
            cyclesCompleted = cycles;
            sessionType = type;
        }
        
        function getDisplayName() {
            if (sessionType == "APNEA_TABLE" && tableName != null) {
                return tableName;
            }
            return exerciseName;
        }
        
        function getDisplayDuration() {
            return TimeUtils.formatShortTime(duration);
        }
        
        function getDisplayTotalTime() {
            return TimeUtils.formatShortTime(totalTime);
        }
    }
    
    /**
     * Saves a completed exercise session to history
     * @param {String} exerciseName - Name of the exercise
     * @param {int} duration - Duration in seconds
     * @param {int} totalTime - Total session time in seconds
     */
    function static saveExerciseSession(exerciseName, duration, totalTime) {
        var date = TimeUtils.getCurrentDate();
        var startTime = TimeUtils.getCurrentTime();
        saveSession(exerciseName, null, date, startTime, duration, totalTime, 0, "EXERCISE");
    }
    
    /**
     * Saves a completed apnea table session to history
     * @param {String} tableName - Name of the apnea table
     * @param {int} cyclesCompleted - Number of cycles completed
     * @param {int} totalTime - Total session time in seconds
     */
    function static saveApneaTableSession(tableName, cyclesCompleted, totalTime) {
        var date = TimeUtils.getCurrentDate();
        var startTime = TimeUtils.getCurrentTime();
        saveSession(null, tableName, date, startTime, totalTime, totalTime, cyclesCompleted, "APNEA_TABLE");
    }
    
    /**
     * Internal method to save any session type
     */
    function static saveSession(exerciseName, tableName, date, startTime, duration, totalTime, cycles, type) {
        var file = FileSystem.open(historyFile, FileSystem.APPEND);
        if (file != null) {
            try {
                var entry = date + "|" + 
                           startTime + "|" + 
                           (exerciseName != null ? exerciseName : "") + "|" + 
                           (tableName != null ? tableName : "") + "|" + 
                           duration + "|" + 
                           totalTime + "|" + 
                           cycles + "|" + 
                           type + "\n";
                file.writeAll(entry);
            } finally {
                file.close();
            }
        }
    }
    
    /**
     * Loads all history items from file
     * @return {Array} Array of HistoryItem objects
     */
    function static loadHistory() {
        var history = [];
        var file = FileSystem.open(historyFile, FileSystem.READ);
        if (file != null) {
            try {
                var data = file.readAll();
                if (data != null && data.size() > 0) {
                    var lines = Lang.splitString(data, "\n");
                    for (var i = 0; i < lines.size(); i++) {
                        if (lines[i].size() > 0) {
                            var item = parseHistoryLine(lines[i]);
                            if (item != null) {
                                history.push(item);
                            }
                        }
                    }
                }
            } finally {
                file.close();
            }
        }
        // Return most recent items first
        return sortByDate(history);
    }
    
    /**
     * Parses a single line from history file
     * @param {String} line - Line from history file
     * @return {HistoryItem} Parsed history item or null
     */
    function static parseHistoryLine(line) {
        var parts = Lang.splitString(line, "|");
        if (parts.size() >= 8) {
            try {
                var date = parts[0];
                var startTime = parts[1];
                var exerciseName = parts[2].size() > 0 ? parts[2] : null;
                var tableName = parts[3].size() > 0 ? parts[3] : null;
                var duration = Lang.parseInt(parts[4]);
                var totalTime = Lang.parseInt(parts[5]);
                var cycles = Lang.parseInt(parts[6]);
                var type = parts[7];
                
                return new HistoryItem(exerciseName, tableName, date, startTime, 
                                      duration, totalTime, cycles, type);
            } catch (e) {
                System.println("Error parsing history line: " + e);
                return null;
            }
        }
        return null;
    }
    
    /**
     * Sorts history items by date (most recent first)
     * @param {Array} history - Array of HistoryItem objects
     * @return {Array} Sorted array
     */
    function static sortByDate(history) {
        // Simple bubble sort for small arrays
        var sorted = history.copy();
        for (var i = 0; i < sorted.size() - 1; i++) {
            for (var j = 0; j < sorted.size() - i - 1; j++) {
                if (sorted[j].date < sorted[j + 1].date) {
                    var temp = sorted[j];
                    sorted[j] = sorted[j + 1];
                    sorted[j + 1] = temp;
                }
            }
        }
        return sorted;
    }
    
    /**
     * Clears all history
     */
    function static clearHistory() {
        var file = FileSystem.open(historyFile, FileSystem.WRITE);
        if (file != null) {
            try {
                file.writeAll("");
            } finally {
                file.close();
            }
        }
    }
    
    /**
     * Gets statistics for a specific exercise or table
     * @param {String} name - Exercise or table name
     * @param {String} type - "EXERCISE" or "APNEA_TABLE"
     * @return {Object} Statistics object with count, totalTime, avgTime
     */
    function static getStatistics(name, type) {
        var history = loadHistory();
        var count = 0;
        var totalTime = 0;
        var totalSessions = 0;
        
        for (var i = 0; i < history.size(); i++) {
            var item = history[i];
            if (item.sessionType == type) {
                var itemName = type == "EXERCISE" ? item.exerciseName : item.tableName;
                if (itemName == name) {
                    count++;
                    totalTime += item.totalTime;
                    totalSessions += item.cyclesCompleted;
                }
            }
        }
        
        return {
            count: count,
            totalTime: totalTime,
            avgTime: count > 0 ? (int)(totalTime / count) : 0,
            totalSessions: totalSessions
        };
    }
    
    /**
     * Gets total time spent in all sessions
     * @return {int} Total time in seconds
     */
    function static getTotalTime() {
        var history = loadHistory();
        var total = 0;
        for (var i = 0; i < history.size(); i++) {
            total += history[i].totalTime;
        }
        return total;
    }
    
    /**
     * Gets total number of sessions
     * @return {int} Total session count
     */
    function static getTotalSessions() {
        return loadHistory().size();
    }
}
