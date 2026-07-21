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
    
    function initialize(tableName, type, desc, cycles, minPerc, maxPerc, initRecovery, decr, level) {
        name = tableName;
        tableType = type;
        description = desc;
        defaultCycles = cycles;
        minApneaPercentage = minPerc;
        maxApneaPercentage = maxPerc;
        initialRecoveryTime = initRecovery;
        recoveryDecrement = decr;
        difficultyLevel = level;
    }
    
    // Factory methods for CO2 Tables
    function static getCO2BeginnerTable() {
        return new ApneaTable(
            "CO2 Debutant",
            "CO2",
            "Table CO2 pour debutants",
            8,
            50,
            50,
            120,
            10,
            1
        );
    }
    
    function static getCO2IntermediateTable() {
        return new ApneaTable(
            "CO2 Intermediaire",
            "CO2",
            "Table CO2 intermediaire",
            10,
            60,
            60,
            110,
            10,
            2
        );
    }
    
    function static getCO2AdvancedTable() {
        return new ApneaTable(
            "CO2 Avance",
            "CO2",
            "Table CO2 avancee",
            12,
            70,
            70,
            90,
            5,
            3
        );
    }
    
    function static getCO2PyramidTable() {
        return new ApneaTable(
            "CO2 Pyramide",
            "CO2",
            "Table CO2 en pyramide",
            7,
            50,
            80,
            120,
            0,
            2
        );
    }
    
    // Factory methods for O2 Tables
    function static getO2BeginnerTable() {
        return new ApneaTable(
            "O2 Debutant",
            "O2",
            "Table O2 pour debutants",
            5,
            70,
            70,
            180,
            0,
            1
        );
    }
    
    function static getO2IntermediateTable() {
        return new ApneaTable(
            "O2 Intermediaire",
            "O2",
            "Table O2 intermediaire",
            6,
            80,
            80,
            180,
            0,
            2
        );
    }
    
    function static getO2AdvancedTable() {
        return new ApneaTable(
            "O2 Avance",
            "O2",
            "Table O2 avancee",
            8,
            85,
            85,
            150,
            0,
            3
        );
    }
    
    function static getO2ProgressiveTable() {
        return new ApneaTable(
            "O2 Progressive",
            "O2",
            "Table O2 progressive",
            6,
            70,
            90,
            180,
            0,
            2
        );
    }
    
    // Factory methods for Mixed Tables
    function static getMixedBalancedTable() {
        return new ApneaTable(
            "Mixte Equilibree",
            "MIXED",
            "Table mixte equilibree",
            8,
            60,
            80,
            120,
            0,
            2
        );
    }
    
    function static getMixedAdvancedTable() {
        return new ApneaTable(
            "Mixte Avancee",
            "MIXED",
            "Table mixte avancee",
            10,
            70,
            85,
            120,
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
            var midCycle = (int)(defaultCycles / 2);
            if (cycle <= midCycle) {
                var percentage = minApneaPercentage + (cycle * ((maxApneaPercentage - minApneaPercentage) / midCycle));
                return (int)((maxApneaTime * percentage) / 100);
            } else {
                var percentage = maxApneaPercentage - ((cycle - midCycle) * ((maxApneaPercentage - minApneaPercentage) / midCycle));
                return (int)((maxApneaTime * percentage) / 100);
            }
        } else if (tableType == "O2" && name == "O2 Progressive") {
            var percentage = minApneaPercentage + (cycle * ((maxApneaPercentage - minApneaPercentage) / (defaultCycles - 1)));
            return (int)((maxApneaTime * percentage) / 100);
        } else {
            return (int)((maxApneaTime * minApneaPercentage) / 100);
        }
    }
    
    // Calculate recovery duration for a given cycle
    function getRecoveryDurationForCycle(cycle) {
        if (tableType == "CO2") {
            return Math.max(60, initialRecoveryTime - (cycle * recoveryDecrement));
        } else {
            return initialRecoveryTime;
        }
    }
    
    // Get difficulty level name
    function getDifficultyName() {
        if (difficultyLevel == 1) {
            return "Debutant";
        } else if (difficultyLevel == 2) {
            return "Intermediaire";
        } else if (difficultyLevel == 3) {
            return "Avance";
        }
        return "Inconnu";
    }
}