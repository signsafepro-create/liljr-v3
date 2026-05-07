#!/bin/bash
# LilJR — Java installer + APK builder for Termux
# Run: bash <(curl -s https://raw.githubusercontent.com/signsafepro-create/liljr-v3/master/setup-java-build.sh)

set -e
DIR="$HOME/liljr-complete/frontend"

echo "🧠 LILJR JAVA + BUILD SETUP"
echo "============================"

# Step 1: Install Java if missing
if ! command -v javac >/dev/null 2>&1; then
    echo "☕ Installing OpenJDK..."
    pkg update -y
    pkg install -y openjdk-17
fi

# Step 2: Set JAVA_HOME
export JAVA_HOME="$PREFIX/lib/jvm/java-17-openjdk"
export PATH="$JAVA_HOME/bin:$PATH"
echo "✓ Java: $(java -version 2>&1 | head -1)"

# Step 3: Make sure project exists
if [ ! -d "$DIR" ]; then
    echo "↓ Cloning project..."
    cd $HOME && git clone https://github.com/signsafepro-create/liljr-complete.git
fi

cd "$DIR"

# Step 4: Install deps
if [ ! -d "node_modules" ]; then
    echo "📦 Installing npm packages..."
    npm install
fi

# Step 5: Build APK
echo "🔨 Building APK..."
npx expo prebuild --platform android

cd android
./gradlew assembleDebug

APK="app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK" ]; then
    echo ""
    echo "✅ APK BUILT SUCCESSFULLY"
    echo "Location: $DIR/android/$APK"
    echo ""
    echo "📲 INSTALL OPTIONS:"
    echo "1) Via file manager:"
    echo "   termux-open $DIR/android/$APK"
    echo ""
    echo "2) Copy to downloads and tap:"
    echo "   cp $DIR/android/$APK ~/downloads/liljr.apk"
    echo "   termux-open ~/downloads/liljr.apk"
    echo ""
    echo "3) If you have root:"
    echo "   su -c 'pm install -r $DIR/android/$APK'"
else
    echo "❌ Build failed"
    exit 1
fi
