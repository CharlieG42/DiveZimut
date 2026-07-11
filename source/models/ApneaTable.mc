using Toybox;

// Apnea Table model for CO2, O2, and Mixed training
class ApneaTable {
    var name;
    var tableType;  // "CO2", "O2", or "MIXED"
    var description;
    var defaultCycles;
    var minApneaPercentage;  // % of max apnea time
    var maxApneaPercentage;
    var initialRecoveryTime;  // in seconds
    var recoveryDecrement;   // seconds to decrease per cycle (for CO2 tables)
    var recoveryIncrement;   // seconds to increase per cycle (for O2 tables)
    var difficultyLevel;    // 1=Beginner, 2=Intermediate, 3=Advanced
    
    function initialize(tableName, type, desc, cycles, minPerc, maxPerc, initRecovery, decr, incr, level) {
        name = tableName;
        tableType = type;
        description = desc;
        defaultCycles = cycles;
        minApneaPercentage = minPerc;
        maxApneaPercentage = maxPerc;
        initialRecoveryTime = initRecovery;
        recoveryDecrement = decr;
        recoveryIncrement = incr;
        difficultyLevel = level;
    }
    
    // Factory methods for CO2 Tables
    function static getCO2BeginnerTable() {
        return new ApneaTable(
            "CO2 Débutant",
            "CO2",
            "Table CO2 pour débutants : 8 cycles à 50% du max, récupération décroissante",
            8,
            50,  // 50% of max apnea
            50,
            120, // 2:00 initial recovery
            10,  // decrease by 10s per cycle
            0,
            1    // Beginner
        );
    }
    
    function static getCO2IntermediateTable() {
        return new ApneaTable(
            "CO2 Intermédiaire",
            "CO2",
            "Table CO2 intermédiaire : 10 cycles à 60% du max, récupération décroissante",
            10,
            60,
            60,
            110, // 1:50 initial recovery
            10,
            0,
            2
        );
    }
    
    function static getCO2AdvancedTable() {
        return new ApneaTable(
            "CO2 Avancé",
            "CO2",
            "Table CO2 avancée : 12 cycles à 70% du max, récupération décroissante",
            12,
            70,
            70,
            90,  // 1:30 initial recovery
            5,   // decrease by 5s per cycle
            0,
            3
        );
    }
    
    function static getCO2PyramidTable() {
        return new ApneaTable(
            "CO2 Pyramide",
            "CO2",
            "Table CO2 en pyramide : durée croissante puis décroissante",
            7,
            50,
            80,
            120,
            0,
            0,
            2
        );
    }
    
    // Factory methods for O2 Tables
    function static getO2BeginnerTable() {
        return new ApneaTable(
            "O2 Débutant",
            "O2",
            "Table O2 pour débutants : 5 cycles à 70% du max, récupération fixe",
            5,
            70,
            70,
            180, // 3:00 recovery
            0,
            0,
            1
        );
    }
    
    function static getO2IntermediateTable() {
        return new ApneaTable(
            "O2 Intermédiaire",
            "O2",
            "Table O2 intermédiaire : 6 cycles à 80% du max, récupération fixe",
            6,
            80,
            80,
            180, // 3:00 recovery
            0,
            0,
            2
        );
    }
    
    function static getO2AdvancedTable() {
        return new ApneaTable(
            "O2 Avancé",
            "O2",
            "Table O2 avancée : 8 cycles à 85% du max, récupération fixe",
            8,
            85,
            85,
            150, // 2:30 recovery
            0,
            0,
            3
        );
    }
    
    function static getO2ProgressiveTable() {
        return new ApneaTable(
            "O2 Progressive",
            "O2",
            "Table O2 progressive : durée d'apnée croissante, récupération fixe",
            6,
            70,
            90,
            180,
            0,
            0,
            2
        );
    }
    
    // Factory methods for Mixed Tables
    function static getMixedBalancedTable() {
        return new ApneaTable(
            "Mixte Équilibrée",
            "MIXED",
            "Table mixte : alternance CO2 et O2 pour un entraînement complet",
            8,
            60,
            80,
            120,
            0,
            0,
            2
        );
    }
    
    function static getMixedAdvancedTable() {
        return new ApneaTable(
            "Mixte Avancée",
            "MIXED",
            "Table mixte avancée : alternance CO2 et O2 avec durées variables",
            10,
            70,
            85,
            120,
            0,
            0,
            3
        );
    }
    
    // Get all available apnea tables
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
    
    // Get table by name
    function static getTableByName(tableName) {
        var tables = getAllApneaTables();
        for (var i = 0; i < tables.size(); i++) {
            if (tables[i].name == tableName) {
                return tables[i];
            }
        }
        return null;
    }
    
    // Calculate apnea duration for a given cycle
    function getApneaDurationForCycle(cycle, maxApneaTime) {
        if (tableType == "CO2" && name == "CO2 Pyramide") {
            // Pyramid logic: increase then decrease
            var midCycle = (int)(defaultCycles / 2);
            if (cycle <= midCycle) {
                // Increasing phase
                var percentage = minApneaPercentage + (cycle * ((maxApneaPercentage - minApneaPercentage) / midCycle));
                return (int)((maxApneaTime * percentage) / 100);
            } else {
                // Decreasing phase
                var percentage = maxApneaPercentage - ((cycle - midCycle) * ((maxApneaPercentage - minApneaPercentage) / midCycle));
                return (int)((maxApneaTime * percentage) / 100);
            }
        } else if (tableType == "O2" && name == "O2 Progressive") {
            // Progressive increase
            var percentage = minApneaPercentage + (cycle * ((maxApneaPercentage - minApneaPercentage) / (defaultCycles - 1)));
            return (int)((maxApneaTime * percentage) / 100);
        } else {
            // Fixed percentage
            return (int)((maxApneaTime * minApneaPercentage) / 100);
        }
    }
    
    // Calculate recovery duration for a given cycle
    function getRecoveryDurationForCycle(cycle) {
        if (tableType == "CO2") {
            // For CO2 tables, recovery decreases with each cycle
            return Math.max(60, initialRecoveryTime - (cycle * recoveryDecrement));
        } else {
            // For O2 and MIXED tables, recovery is fixed or increases
            return initialRecoveryTime;
        }
    }
    
    // Get difficulty level name
    function getDifficultyName() {
        if (difficultyLevel == 1) return "Débutant";
        else if (difficultyLevel == 2) return "Intermédiaire";
        else if (difficultyLevel == 3) return "Avancé";
        return "Inconnu";
    }
}