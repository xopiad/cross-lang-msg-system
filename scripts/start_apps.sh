#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Run all applications
echo "Starting C++ app..."
"$SCRIPT_DIR/app_cpp" &

echo "Starting Flutter app..."
"$SCRIPT_DIR/app_flutter" &

echo "Starting Python app..."
python3 "$SCRIPT_DIR/app.py" &

echo "Starting Go app..."
"$SCRIPT_DIR/app_go" &

echo "Starting Lua app..."
lua "$SCRIPT_DIR/app.lua" &

# Wait for all processes to finish
wait
