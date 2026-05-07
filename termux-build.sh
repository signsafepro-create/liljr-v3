#!/bin/bash
# LilJR Builder — Fixed Java detection for Termux
# Run: bash <(curl -s https://raw.githubusercontent.com/signsafepro-create/liljr-v3/master/termux-build.sh)

set -e
DIR="$HOME/liljr-complete/frontend"

echo "🧠 LILJR TERMUX BUILDER"
echo "======================"

# Step 1: Find or install Java
echo "☕ Checking Java..."
if command -v javac > /dev/null 2>&1; then
    echo "✓ Java found: $(javac -version 2>&1)"
elif [ -d "$PREFIX/lib/jvm" ]; then
    # Find any Java installation
    for jvm in "$PREFIX/lib/jvm"/*; do
        if [ -f "$jvm/bin/javac" ]; then
            export JAVA_HOME="$jvm"
            export PATH="$JAVA_HOME/bin:$PATH"
            echo "✓ Java found at $jvm"
            break
        fi
    done
else
    echo "Installing Java 21..."
    pkg update -y
    pkg install -y openjdk-21
fi

# CRITICAL: Set JAVA_HOME properly for Gradle
if [ -z "$JAVA_HOME" ]; then
    if [ -d "$PREFIX/lib/jvm/java-21-openjdk" ]; then
        export JAVA_HOME="$PREFIX/lib/jvm/java-21-openjdk"
    elif [ -d "$PREFIX/lib/jvm/java-25-openjdk" ]; then
        export JAVA_HOME="$PREFIX/lib/jvm/java-25-openjdk"
    else
        # Auto-detect
        for d in "$PREFIX/lib/jvm"/*openjdk*; do
            if [ -d "$d" ]; then
                export JAVA_HOME="$d"
                break
            fi
        done
    fi
fi

export PATH="$JAVA_HOME/bin:$PATH"

# Verify
if [ ! -f "$JAVA_HOME/bin/javac" ]; then
    echo "❌ Java not found. Check: ls $PREFIX/lib/jvm/"
    exit 1
fi

echo "✓ JAVA_HOME: $JAVA_HOME"
echo "✓ Java: $(javac -version 2>&1)"

# Step 2: Get project
echo "📁 Checking project..."
if [ ! -f "$DIR/package.json" ]; then
    echo "↓ Cloning..."
    rm -rf "$HOME/liljr-complete"
    cd "$HOME" && git clone https://github.com/signsafepro-create/liljr-complete.git
fi

cd "$DIR"

# Step 3: Install deps
echo "📦 npm install..."
if [ ! -d "node_modules" ]; then
    npm install
fi

# Step 4: Prebuild
echo "🔨 Prebuilding..."
npx expo prebuild --platform android

# Step 5: Build
echo "⚡ Building APK..."
cd android

# Export JAVA_HOME for Gradle
export JAVA_HOME
export PATH

./gradlew assembleDebug

# Step 6: Deliver
APK="$DIR/android/app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK" ]; then
    cp "$APK" "$HOME/downloads/liljr.apk"
    echo ""
    echo "✅ BUILT: ~/downloads/liljr.apk"
    echo "📲 Opening file manager... TAP TO INSTALL"
    termux-open "$HOME/downloads/liljr.apk"
else
    echo "❌ Build failed"
    exit 1
fi
