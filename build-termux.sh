#!/bin/bash
# ONE COMMAND — Build LilJR APK in Termux
# Run: bash <(curl -s https://raw.githubusercontent.com/signsafepro-create/liljr-v3/master/build-termux.sh)

set -e
DIR="$HOME/liljr-v3"
FRONTEND="$DIR/frontend"

echo "🧠 LILJR BUILDER"

# Find the real Expo project
if [ -f "$HOME/liljr-complete/frontend/package.json" ]; then
    FRONTEND="$HOME/liljr-complete/frontend"
    echo "✓ Found original project at $FRONTEND"
elif [ -f "$HOME/liljr-v995/frontend/package.json" ]; then
    FRONTEND="$HOME/liljr-v995/frontend"
    echo "✓ Found project at $FRONTEND"
elif [ -f "$FRONTEND/package.json" ]; then
    echo "✓ Using $FRONTEND"
else
    echo "❌ No Expo project found. Searching..."
    for d in "$HOME"/*/frontend/package.json "$HOME"/*/*/frontend/package.json; do
        if [ -f "$d" ]; then
            FRONTEND="$(dirname "$d")"
            echo "✓ Found: $FRONTEND"
            break
        fi
    done
fi

if [ ! -f "$FRONTEND/package.json" ]; then
    echo "❌ Cannot find your Expo project."
    echo "It should have: package.json, node_modules/, src/screens/"
    echo ""
    echo "If you deleted it, re-clone with:"
    echo "  cd \$HOME && git clone https://github.com/signsafepro-create/liljr-complete.git"
    exit 1
fi

cd "$FRONTEND"

# Copy fixed files from liljr-v3 (if they exist)
if [ -d "$HOME/liljr-v3/frontend/src" ]; then
    echo "↻ Copying fixes..."
    cp -f "$HOME/liljr-v3/frontend/src/screens/HomeScreen.js" src/screens/ 2>/dev/null || true
    cp -f "$HOME/liljr-v3/frontend/src/navigation/AppNavigator.js" src/navigation/ 2>/dev/null || true
    cp -f "$HOME/liljr-v3/frontend/App.js" ./ 2>/dev/null || true
    cp -f "$HOME/liljr-v3/frontend/src/screens/SplashScreen.js" src/screens/ 2>/dev/null || true
    cp -f "$HOME/liljr-v3/frontend/src/api/trpc.ts" src/api/ 2>/dev/null || true
fi

# Install deps if missing
echo "📦 Checking dependencies..."
if [ ! -d "node_modules" ]; then
    echo "Installing node_modules..."
    npm install
fi

# Build APK
echo "🔨 Building APK..."
npx expo prebuild --platform android

cd android
./gradlew assembleDebug

APK="app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK" ]; then
    echo "✅ APK BUILT"
    echo "Location: $FRONTEND/android/$APK"
    echo ""
    echo "Install now:"
    echo "  pm install -r $FRONTEND/android/$APK"
else
    echo "❌ Build failed. Check $FRONTEND/android/ for errors."
    exit 1
fi
