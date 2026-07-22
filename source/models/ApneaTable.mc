using Toybox;

// Apnea Table model for CO2, O2, and Mixed training
class ApneaTable {
    var name;
    var tableType;
    var description;
    var defaultCycles;
    var minApneaPercentage;
    var maxApneaPercentage;
    var initialRecoveryTime;
    var recoveryDecrement;
    var difficultyLevel;
    var recommendedFrequency;
    var estimatedDuration;
    
    // Table types
    var TYPE_CO2 = "CO2";
    var TYPE_O2 = "O2";
    var TYPE_MIXED = "MIXED";
    
    // Difficulty levels
    var DIFFICULTY_BEGINNER = 1;
    var DIFFICULTY_INTERMEDIATE = 2;
    var DIFFICULTY_ADVANCED = 3;
    
    /**
     * Initializes an apnea table
     * @param {String} tableName - Name of the table
     * @param {String} type - Table type (CO2, O2, MIXED)
     * @param {String} desc - Table description
     * @param {int} cycles - Number of cycles
     * @param {int} minPerc - Minimum apnea percentage
     * @param {int} maxPerc - Maximum apnea percentage
     * @param {int} initRecovery - Initial recovery time in seconds
     * @param {int} decr - Recovery time decrement per cycle in seconds
     * @param {int} level - Difficulty level (1-3)
     * @param {int} freq - Recommended frequency per week
     */
    function initialize(tableName, type, desc, cycles, minPerc, maxPerc, initRecovery, decr, level, freq) {
        name = tableName;
        tableType = type;
        description = desc;
        defaultCycles = cycles;
        minApneaPercentage = minPerc;
        maxApneaPercentage = maxPerc;
        initialRecoveryTime = initRecovery;
        recoveryDecrement = decr;
        difficultyLevel = level;
        recommendedFrequency = freq;
        estimatedDuration = calculateEstimatedDuration();
    }
    
    /**
     * Calculates estimated duration for this table
     * @return {int} Estimated duration in seconds
     */
    function calculateEstimatedDuration() {
        // Base estimation: assume 120s max apnea time
        var baseMaxTime = 120;
        var total = 0;
        
        for (var i = 0; i < defaultCycles; i++) {
            var apneaDur = getApneaDurationForCycle(i, baseMaxTime);
            var recoveryDur = getRecoveryDurationForCycle(i);
            // Add preparation time (5s)
            total += 5 + apneaDur + recoveryDur;
        }
        
        return total;
    }
    
    /**
     * Gets estimated duration formatted as string
     * @return {String} Formatted duration
     */
    function getEstimatedDurationFormatted() {
        return TimeUtils.formatShortTime(estimatedDuration);
    }
    
    // Factory methods for CO2 Tables
    
    /**
     * CO2 Beginner Table
     * 8 cycles at 50% of max, recovery from 2:00 to 1:30
     */
    function static getCO2BeginnerTable() {
        return new ApneaTable(
            "CO2 Debutant",
            TYPE_CO2,
            "Table CO2 pour debutants. Augmente la tolerance au CO2.",
            8,
            50,
            50,
            120,
            10,
            DIFFICULTY_BEGINNER,
            3
        );
    }
    
    /**
     * CO2 Intermediate Table
     * 10 cycles at 60% of max, recovery from 1:50 to 1:00
     */
    function static getCO2IntermediateTable() {
        return new ApneaTable(
            "CO2 Intermediaire",
            TYPE_CO2,
            "Table CO2 intermediaire. Pour ceux qui maîtrisent les bases.",
            10,
            60,
            60,
            110,
            10,
            DIFFICULTY_INTERMEDIATE,
            4
        );
    }
    
    /**
     * CO2 Advanced Table
     * 12 cycles at 70% of max, recovery from 1:30 to 0:45
     */
    function static getCO2AdvancedTable() {
        return new ApneaTable(
            "CO2 Avance",
            TYPE_CO2,
            "Table CO2 avancee. Pour les pratiquants experimentes.",
            12,
            70,
            70,
            90,
            5,
            DIFFICULTY_ADVANCED,
            5
        );
    }
    
    /**
     * CO2 Pyramid Table
     * 7 cycles with progressive then regressive duration
     */
    function static getCO2PyramidTable() {
        return new ApneaTable(
            "CO2 Pyramide",
            TYPE_CO2,
            "Table CO2 en pyramide. Travaille la progression et la decroissance.",
            7,
            50,
            80,
            120,
            0,
            DIFFICULTY_INTERMEDIATE,
            3
        );
    }
    
    // Factory methods for O2 Tables
    
    /**
     * O2 Beginner Table
     * 5 cycles at 70% of max, fixed 3:00 recovery
     */
    function static getO2BeginnerTable() {
        return new ApneaTable(
            "O2 Debutant",
            TYPE_O2,
            "Table O2 pour debutants. Ameliore l'efficacite de l'O2.",
            5,
            70,
            70,
            180,
            0,
            DIFFICULTY_BEGINNER,
            2
        );
    }
    
    /**
     * O2 Intermediate Table
     * 6 cycles at 80% of max, fixed 3:00 recovery
     */
    function static getO2IntermediateTable() {
        return new ApneaTable(
            "O2 Intermediaire",
            TYPE_O2,
            "Table O2 intermediaire. Pour ameliorer l'utilisation de l'O2.",
            6,
            80,
            80,
            180,
            0,
            DIFFICULTY_INTERMEDIATE,
            3
        );
    }
    
    /**
     * O2 Advanced Table
     * 8 cycles at 85% of max, fixed 2:30 recovery
     */
    function static getO2AdvancedTable() {
        return new ApneaTable(
            "O2 Avance",
            TYPE_O2,
            "Table O2 avancee. Pour les apneistes experimentes.",
            8,
            85,
            85,
            150,
            0,
            DIFFICULTY_ADVANCED,
            3
        );
    }
    
    /**
     * O2 Progressive Table
     * 6 cycles with increasing duration
     */
    function static getO2ProgressiveTable() {
        return new ApneaTable(
            "O2 Progressive",
            TYPE_O2,
            "Table O2 progressive. Travaille l'augmentation progressive.",
            6,
            70,
            90,
            180,
            0,
            DIFFICULTY_INTERMEDIATE,
            3
        );
    }
    
    // Factory methods for Mixed Tables
    
    /**
     * Mixed Balanced Table
     * 8 cycles (4 CO2 + 4 O2 alternating)
     */
    function static getMixedBalancedTable() {
        return new ApneaTable(
            "Mixte Equilibree",
            TYPE_MIXED,
            "Table mixte equilibree. Combine CO2 et O2.",
            8,
            60,
            80,
            120,
            0,
            DIFFICULTY_INTERMEDIATE,
            3
        );
    }
    
    /**
     * Mixed Advanced Table
     * 10 cycles (5 CO2 + 5 O2 alternating)
     */
    function static getMixedAdvancedTable() {
        return new ApneaTable(
            "Mixte Avancee",
            TYPE_MIXED,
            "Table mixte avancee. Pour un entrainement complet.",
            10,
            70,
            85,
            120,
            0,
            DIFFICULTY_ADVANCED,
            4
        );
    }
    
    /**
     * Gets all available apnea tables
     * @return {Array} Array of ApneaTable objects
     */
    function static getAllApneaTables() {
        return [
            getCO2BeginnerTable(),
            getCO2IntermediateTable(),
            getCO2AdvancedTable(),
            getCO2PyramidTable(),
            getO2BeginnerTable(),
            getO2IntermediateTable(),
            getO2AdvancedTable(),
            getO2ProgressiveTable(),
            getMixedBalancedTable(),
            getMixedAdvancedTable()
        ];
    }
    
    /**
     * Gets CO2 tables only
     * @return {Array} Array of CO2 ApneaTable objects
     */
    function static getCO2Tables() {
        return [
            getCO2BeginnerTable(),
            getCO2IntermediateTable(),
            getCO2AdvancedTable(),
            getCO2PyramidTable()
        ];
    }
    
    /**
     * Gets O2 tables only
     * @return {Array} Array of O2 ApneaTable objects
     */
    function static getO2Tables() {
        return [
            getO2BeginnerTable(),
            getO2IntermediateTable(),
            getO2AdvancedTable(),
            getO2ProgressiveTable()
        ];
    }
    
    /**
     * Gets Mixed tables only
     * @return {Array} Array of Mixed ApneaTable objects
     */
    function static getMixedTables() {
        return [
            getMixedBalancedTable(),
            getMixedAdvancedTable()
        ];
    }
    
    /**
     * Gets table by name
     * @param {String} tableName - Name of the table to find
     * @return {ApneaTable} ApneaTable object or null if not found
     */
    function static getTableByName(tableName) {
        var tables = getAllApneaTables();
        for (var i = 0; i < tables.size(); i++) {
            if (tables[i].name == tableName) {
                return tables[i];
            }
        }
        return null;
    }
    
    /**
     * Calculates apnea duration for a given cycle
     * @param {int} cycle - Cycle number (0-indexed)
     * @param {int} maxApneaTime - User's maximum apnea time in seconds
     * @return {int} Apnea duration in seconds
     */
    function getApneaDurationForCycle(cycle, maxApneaTime) {
        // Ensure valid inputs
        if (maxApneaTime <= 0) {
            maxApneaTime = 120; // Default to 2 minutes
        }
        
        if (name == "CO2 Pyramide") {
            return calculatePyramidDuration(cycle, maxApneaTime);
        } else if (name == "O2 Progressive") {
            return calculateProgressiveDuration(cycle, maxApneaTime);
        } else {
            // Standard calculation for most tables
            return (int)((maxApneaTime * minApneaPercentage) / 100);
        }
    }
    
    /**
     * Calculates pyramid duration for CO2 Pyramid table
     * @param {int} cycle - Cycle number
     * @param {int} maxApneaTime - Max apnea time
     * @return {int} Duration in seconds
     */
    function calculatePyramidDuration(cycle, maxApneaTime) {
        var midCycle = (int)(defaultCycles / 2);
        var range = maxApneaPercentage - minApneaPercentage;
        
        if (cycle <= midCycle) {
            // Ascending phase
            var percentage = minApneaPercentage + (cycle * (range / midCycle));
            return (int)((maxApneaTime * percentage) / 100);
        } else {
            // Descending phase
            var percentage = maxApneaPercentage - ((cycle - midCycle) * (range / midCycle));
            return (int)((maxApneaTime * percentage) / 100);
        }
    }
    
    /**
     * Calculates progressive duration for O2 Progressive table
     * @param {int} cycle - Cycle number
     * @param {int} maxApneaTime - Max apnea time
     * @return {int} Duration in seconds
     */
    function calculateProgressiveDuration(cycle, maxApneaTime) {
        var range = maxApneaPercentage - minApneaPercentage;
        var percentage = minApneaPercentage + (cycle * (range / (defaultCycles - 1)));
        return (int)((maxApneaTime * percentage) / 100);
    }
    
    /**
     * Calculates recovery duration for a given cycle
     * @param {int} cycle - Cycle number (0-indexed)
     * @return {int} Recovery duration in seconds
     */
    function getRecoveryDurationForCycle(cycle) {
        if (tableType == TYPE_CO2 && recoveryDecrement > 0) {
            // Decreasing recovery for CO2 tables
            return Math.max(60, initialRecoveryTime - (cycle * recoveryDecrement));
        } else {
            // Fixed recovery for O2 and Mixed tables
            return initialRecoveryTime;
        }
    }
    
    /**
     * Gets difficulty level name
     * @return {String} Difficulty level name
     */
    function getDifficultyName() {
        if (difficultyLevel == DIFFICULTY_BEGINNER) {
            return "Debutant";
        } else if (difficultyLevel == DIFFICULTY_INTERMEDIATE) {
            return "Intermediaire";
        } else if (difficultyLevel == DIFFICULTY_ADVANCED) {
            return "Avance";
        }
        return "Inconnu";
    }
    
    /**
     * Gets table type name
     * @return {String} Table type name
     */
    function getTableTypeName() {
        if (tableType == TYPE_CO2) {
            return "CO2";
        } else if (tableType == TYPE_O2) {
            return "O2";
        } else if (tableType == TYPE_MIXED) {
            return "Mixte";
        }
        return "Inconnu";
    }
    
    /**
     * Gets recommended max apnea time for this table
     * @return {int} Recommended max apnea time in seconds
     */
    function getRecommendedMaxApneaTime() {
        if (difficultyLevel == DIFFICULTY_BEGINNER) {
            return 60; // 1 minute
        } else if (difficultyLevel == DIFFICULTY_INTERMEDIATE) {
            return 120; // 2 minutes
        } else {
            return 180; // 3 minutes
        }
    }
    
    /**
     * Checks if this table is suitable for a given max apnea time
     * @param {int} maxTime - User's max apnea time in seconds
     * @return {boolean} True if suitable
     */
    function isSuitableFor(maxTime) {
        var recommended = getRecommendedMaxApneaTime();
        // Table is suitable if user's max time is at least 80% of recommended
        return maxTime >= (int)(recommended * 0.8);
    }
}
