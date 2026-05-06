#!/bin/bash
# LilJR 3.7.3 — ONE COMMAND INSTALL
# Run this in Termux: bash <(curl -s https://raw.githubusercontent.com/signsafepro-create/liljr-v3/master/install.sh)

set -e

REPO="https://github.com/signsafepro-create/liljr-v3"
DIR="$HOME/liljr-v3"

echo "🧠 LILJR 3.7.3 NEURAL LINK INSTALLER"
echo "===================================="

# Step 1: Clone or update
if [ -d "$DIR/.git" ]; then
    echo "↻ Pulling latest..."
    cd "$DIR" && git pull origin master
else
    echo "↓ Cloning repo..."
    rm -rf "$DIR"
    git clone "$REPO.git" "$DIR"
fi

cd "$DIR"

# Step 2: Backend setup
echo "⚡ Setting up backend..."
cd backend
npm install 2>/dev/null || yarn install
nohup npm run dev > backend.log 2>&1 &
echo "✓ Backend running on http://localhost:3000"
cd ..

# Step 3: Frontend setup
echo "📱 Building app..."
cd frontend
npm install 2>/dev/null || yarn install

# Build the APK via EAS or local
if command -v eas &> /dev/null; then
    echo "🔨 Building with EAS..."
    eas build --platform android --profile production --non-interactive
else
    echo "🔨 Building locally..."
    npx expo prebuild --platform android
    cd android
    ./gradlew assembleRelease 2>/dev/null || ./gradlew assembleDebug
    APK="app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$APK" ]; then
        cp "$APK" "$HOME/liljr-v3.apk"
        echo "✓ APK built: $HOME/liljr-v3.apk"
        echo "📲 Install with: pm install -r $HOME/liljr-v3.apk"
    fi
    cd ..
fi

echo ""
echo "===================================="
echo "✅ LILJR 3.7.3 INSTALLED"
echo "Backend: http://localhost:3000"
echo "Frontend: cd ~/liljr-v3/frontend && npx expo start --android"
echo "APK: ~/liljr-v3.apk"
echo "===================================="
