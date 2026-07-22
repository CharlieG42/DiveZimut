using Toybox;

// Utility class for time formatting and calculations
class TimeUtils {
    
    /**
     * Formats seconds into MM:SS format
     * @param {int} seconds - Time in seconds
     * @return {String} Formatted time string
     */
    function static formatTime(seconds) {
        if (seconds < 10) {
            return "00:0" + seconds;
        } else if (seconds < 60) {
            return "00:" + seconds;
        } else {
            var minutes = (int)(seconds / 60);
            var secs = seconds % 60;
            return minutes + ":" + (secs < 10 ? "0" + secs : secs);
        }
    }
    
    /**
     * Formats seconds into short format (e.g., "1m 30s" or "90s")
     * @param {int} seconds - Time in seconds
     * @return {String} Short formatted time string
     */
    function static formatShortTime(seconds) {
        if (seconds < 60) {
            return seconds + "s";
        } else {
            var minutes = (int)(seconds / 60);
            var secs = seconds % 60;
            if (secs == 0) {
                return minutes + "min";
            } else {
                return minutes + "min " + secs + "s";
            }
        }
    }
    
    /**
     * Formats seconds into HH:MM:SS format for longer durations
     * @param {int} seconds - Time in seconds
     * @return {String} Formatted time string
     */
    function static formatLongTime(seconds) {
        var hours = (int)(seconds / 3600);
        var minutes = (int)((seconds % 3600) / 60);
        var secs = seconds % 60;
        
        if (hours > 0) {
            return (hours < 10 ? "0" + hours : hours) + ":" + 
                   (minutes < 10 ? "0" + minutes : minutes) + ":" + 
                   (secs < 10 ? "0" + secs : secs);
        } else {
            return formatTime(seconds);
        }
    }
    
    /**
     * Converts MM:SS string to seconds
     * @param {String} timeStr - Time string in MM:SS format
     * @return {int} Time in seconds
     */
    function static parseTime(timeStr) {
        var parts = Lang.splitString(timeStr, ":");
        if (parts.size() == 2) {
            var minutes = Lang.parseInt(parts[0]);
            var seconds = Lang.parseInt(parts[1]);
            return minutes * 60 + seconds;
        } else if (parts.size() == 1) {
            return Lang.parseInt(parts[0]);
        }
        return 0;
    }
    
    /**
     * Gets current timestamp as formatted date string
     * @return {String} Formatted date string (YYYY-MM-DD)
     */
    function static getCurrentDate() {
        var now = System.getClockTime();
        var year = now.getYear();
        var month = now.getMonth() + 1;
        var day = now.getDay();
        return year + "-" + (month < 10 ? "0" + month : month) + "-" + (day < 10 ? "0" + day : day);
    }
    
    /**
     * Gets current timestamp as formatted time string
     * @return {String} Formatted time string (HH:MM:SS)
     */
    function static getCurrentTime() {
        var now = System.getClockTime();
        var hours = now.getHours();
        var minutes = now.getMinutes();
        var seconds = now.getSeconds();
        return (hours < 10 ? "0" + hours : hours) + ":" + 
               (minutes < 10 ? "0" + minutes : minutes) + ":" + 
               (seconds < 10 ? "0" + seconds : seconds);
    }
    
    /**
     * Gets current timestamp as ISO format string
     * @return {String} ISO formatted datetime string
     */
    function static getCurrentDateTime() {
        return getCurrentDate() + " " + getCurrentTime();
    }
}
