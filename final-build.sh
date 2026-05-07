#!/bin/bash
# ONE COMMAND — Install Java, build APK, open for install
# Run in Termux: bash <(curl -s https://raw.githubusercontent.com/signsafepro-create/liljr-v3/master/final-build.sh)

set -e
DIR="$HOME/liljr-complete/frontend"

echo "🧠 LILJR FINAL BUILDER"
echo "======================="

# Step 1: Install Java
echo "☕ Checking Java..."
if ! command -v javac >/dev/null 2>&1; then
    echo "Installing OpenJDK... (this takes a few minutes)"
    pkg update -y
    pkg install -y openjdk-17
fi
export JAVA_HOME="$PREFIX/lib/jvm/java-17-openjdk"
export PATH="$JAVA_HOME/bin:$PATH"
echo "✓ Java ready"

# Step 2: Verify project exists
if [ ! -f "$DIR/package.json" ]; then
    echo "↓ Re-cloning project..."
    rm -rf "$HOME/liljr-complete"
    cd "$HOME" && git clone https://github.com/signsafepro-create/liljr-complete.git
fi

cd "$DIR"

# Step 3: Install deps
echo "📦 Installing packages..."
if [ ! -d "node_modules" ]; then
    npm install
fi

# Step 4: Prebuild
echo "🔨 Prebuilding Android project..."
npx expo prebuild --platform android

# Step 5: Build APK
echo "⚡ Building APK..."
cd android
./gradlew assembleDebug

# Step 6: Deliver APK
APK="$DIR/android/app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK" ]; then
    echo ""
    echo "✅ APK BUILT SUCCESSFULLY"
    echo ""
    
    # Copy to downloads for easy access
    cp "$APK" "$HOME/downloads/liljr-v3.apk"
    echo "📲 APK copied to: ~/downloads/liljr-v3.apk"
    echo ""
    echo "Opening file manager... TAP THE APK TO INSTALL"
    termux-open "$HOME/downloads/liljr-v3.apk"
    
    echo ""
    echo "If that didn't open, manually go to:"
    echo "  /sdcard/Download/ or ~/downloads/"
    echo "  and tap liljr-v3.apk"
else
    echo "❌ Build failed"
    exit 1
fi
