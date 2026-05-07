#!/bin/bash
# LilJR Builder — Works with ANY Java available in Termux
# Run: bash <(curl -s https://raw.githubusercontent.com/signsafepro-create/liljr-v3/master/termux-build.sh)

set -e
DIR="$HOME/liljr-complete/frontend"

echo "🧠 LILJR TERMUX BUILDER"
echo "======================"

# Step 1: Find or install Java
echo "☕ Finding Java..."
if command -v javac >/dev/null 2>&1; then
    echo "✓ Java found: $(javac -version 2>&1)"
elif [ -d "$PREFIX/lib/jvm" ]; then
    for jvm in "$PREFIX/lib/jvm"/*; do
        if [ -f "$jvm/bin/javac" ]; then
            export JAVA_HOME="$jvm"
            export PATH="$JAVA_HOME/bin:$PATH"
            echo "✓ Java found at $jvm"
            break
        fi
    done
else
    echo "Installing Java..."
    pkg update -y
    # Try multiple package names
    pkg install -y openjdk-21 2>/dev/null || \
    pkg install -y openjdk-17 2>/dev/null || \
    pkg install -y openjdk-11 2>/dev/null || \
    pkg install -y default-jdk 2>/dev/null || \
    (echo "❌ Cannot install Java automatically. Try:"; echo "   pkg search openjdk"; echo "   pkg install <whatever-is-available>"; exit 1)
fi

# Verify Java
if ! command -v javac >/dev/null 2>&1; then
    echo "❌ Java installation failed. Check: pkg list-all | grep openjdk"
    exit 1
fi

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
