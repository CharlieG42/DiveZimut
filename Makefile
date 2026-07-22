# Makefile for DiveZimut Connect IQ Application
# 
# Usage:
#   make            - Build the application
#   make clean      - Clean build artifacts
#   make package    - Package the application
#   make all        - Clean, build, and package
#   make install    - Install to connected device (if available)

# Connect IQ SDK path (adjust as needed)
# SDK_PATH ?= /opt/garmin/ConnectIQ
MONKEYC ?= monkeyc
MONKEYBARREL ?= monkeybarrel
MONKEYDO ?= monkeydo

# Project directories
SRC_DIR = source
BIN_DIR = bin
RES_DIR = resources

# Source files
MONKEYC_SOURCES = \
    $(SRC_DIR)/DiveZimutApp.mc \
    $(SRC_DIR)/models/Exercise.mc \
    $(SRC_DIR)/models/ApneaTable.mc \
    $(SRC_DIR)/models/UserSettings.mc \
    $(SRC_DIR)/utils/TimeUtils.mc \
    $(SRC_DIR)/utils/HistoryManager.mc \
    $(SRC_DIR)/views/BaseExerciseView.mc \
    $(SRC_DIR)/views/MainMenuView.mc \
    $(SRC_DIR)/views/ExerciseView.mc \
    $(SRC_DIR)/views/ApneaTableView.mc \
    $(SRC_DIR)/views/SettingsView.mc \
    $(SRC_DIR)/views/HistoryView.mc \
    $(SRC_DIR)/views/AboutView.mc

# Output files
MANIFEST = manifest.xml
OUTPUT_PRG = DiveZimut.prg
OUTPUT_IQ = DiveZimut.iq

# Compiler flags
MONKEYC_FLAGS = -o $(BIN_DIR)/ -f $(MANIFEST)

all: clean build package

build: $(BIN_DIR) $(MONKEYC_SOURCES)
	@echo "Building DiveZimut..."
	@mkdir -p $(BIN_DIR)/mir
	@mkdir -p $(BIN_DIR)/gen
	$(MONKEYC) $(MONKEYC_FLAGS) $(MONKEYC_SOURCES)
	@echo "Build complete!"

package: build
	@echo "Packaging application..."
	$(MONKEYBARREL) -o $(OUTPUT_PRG) -f $(MANIFEST) $(BIN_DIR)/
	@echo "Package created: $(OUTPUT_PRG)"

clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(BIN_DIR)/*
	rm -f $(OUTPUT_PRG)
	rm -f $(OUTPUT_IQ)
	@echo "Clean complete!"

install: package
	@echo "Installing to device..."
	$(MONKEYDO) $(OUTPUT_PRG)
	@echo "Installation complete!"

# Phony targets
.PHONY: all build clean package install

# Directory targets
$(BIN_DIR):
	mkdir -p $(BIN_DIR)
