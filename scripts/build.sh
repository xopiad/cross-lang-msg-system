#!/bin/bash

# Create an RPM that installs a script to run all the apps

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$ROOT_DIR/build"
BIN_DIR="$BUILD_DIR/bin"  # Variable for binary output directory

set -e  # Exit on error

# Remove old build directory if it exists
if [ -d "$BUILD_DIR" ]; then
    echo "Removing existing build directory..."
    rm -rf "$BUILD_DIR"
fi
mkdir -p "$BUILD_DIR"

# Create the bin directory where binaries will be outputted
mkdir -p "$BIN_DIR"

# Setup RPM build environment
for dir in BUILD RPMS SOURCES SPECS SRPMS; do
    mkdir -p "$BUILD_DIR/rpmbuild/$dir"
done

PROJECT_NAME="cross_lang_msg_system"
SOURCE_DIR="$BUILD_DIR/rpmbuild/SOURCES/$PROJECT_NAME"

mkdir -p "$SOURCE_DIR"

# --- Compile C++ App ---
echo "Compiling C++ app..."
cd "$ROOT_DIR/src/cpp"
g++ -o "$BIN_DIR/app_cpp" app.cpp  # Output the binary to BIN_DIR

# --- Compile Flutter App ---
echo "Compiling Flutter app..."
cd "$ROOT_DIR/src/flutter"
dart compile exe app.dart -o "$BIN_DIR/app_flutter"  # Output the binary to BIN_DIR

# --- Compile Python App ---
echo "Running tests for Python app..."
cd "$ROOT_DIR/src/python"
# pytest  # Run tests using pytest

# Copy Python app (no compilation, just copy)
install -m 755 "$ROOT_DIR/src/python/app.py" "$BIN_DIR/"

# --- Compile Go App ---
echo "Compiling Go app..."
cd "$ROOT_DIR/src/go"
go build -o "$BIN_DIR/app_go" app.go

# --- Compile Lua App ---
echo "Running tests for Lua app..."
cd "$ROOT_DIR/src/lua"
# luarocks install --only-deps  # Install any dependencies if needed
# lua test.lua  # Assuming you have a test script for Lua

# Copy Lua app (no compilation, just copy)
install -m 755 "$ROOT_DIR/src/lua/app.lua" "$BIN_DIR/"

# --- Copy the existing start_apps.sh script to the bin directory with 755 permissions ---
echo "Copying existing start_apps.sh script..."
install -m 755 "$ROOT_DIR/scripts/start_apps.sh" "$BIN_DIR/"

# Copy RPM spec
cp "$ROOT_DIR/etc/cross_lang_msg_system.spec" "$BUILD_DIR/rpmbuild/SPECS/"

# Package the source and configuration files into the tarball, and create the proper directory structure
mkdir -p "$BUILD_DIR/rpmbuild/SOURCES/cross_lang_msg_system-1.0"
cp -r "$BIN_DIR" "$BUILD_DIR/rpmbuild/SOURCES/cross_lang_msg_system-1.0/bin"

# Create tarball
tar -czf "$BUILD_DIR/rpmbuild/SOURCES/$PROJECT_NAME.tar.gz" -C "$BUILD_DIR/rpmbuild/SOURCES" cross_lang_msg_system-1.0

# Build the RPM package using the defined topdir
rpmbuild --define "_topdir $BUILD_DIR/rpmbuild" -v -ba "$BUILD_DIR/rpmbuild/SPECS/$PROJECT_NAME.spec"
