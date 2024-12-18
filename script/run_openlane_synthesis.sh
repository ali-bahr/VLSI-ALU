#!/bin/bash
# Variables
DESIGN_NAME="tree_multiplier"  # Update this if your design name changes
DESIGN_DIR="$HOME/openlane2/openlane/designs/$DESIGN_NAME"
CONFIG_FILE="$DESIGN_DIR/config.json"

# Check if design directory exists
if [ ! -d "$DESIGN_DIR" ]; then
    echo "Error: Design directory '$DESIGN_DIR' does not exist!"
    exit 1
fi

# Check if config.json exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file '$CONFIG_FILE' does not exist in the design directory!"
    exit 1
fi

# Print the config file for verification
echo "Using the following configuration file:"
cat "$CONFIG_FILE"


# Run synthesis
echo "Running synthesis for design: $DESIGN_NAME"
openlane --design-dir "$DESIGN_DIR" "$CONFIG_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Synthesis step failed!"
    exit 1
fi

# Synthesis completed
echo "Synthesis completed successfully!"
echo "Check the runs/ directory for outputs."

