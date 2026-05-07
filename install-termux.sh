#!/bin/bash
# LilJR 3.7.3 — ONE COMMAND INSTALL (Termux-compatible)
# Run this in Termux: bash <(curl -s https://raw.githubusercontent.com/signsafepro-create/liljr-v3/master/install-termux.sh)

set -e

REPO="https://github.com/signsafepro-create/liljr-v3"
DIR="$HOME/liljr-v3"

echo "🧠 LILJR 3.7.3 NEURAL LINK INSTALLER"
echo "===================================="

# Step 0: Install dependencies if missing
echo "🔧 Checking dependencies..."
if ! command -v git >/dev/null 2>&1; then
    echo "Installing git..."
    pkg install -y git
fi
if ! command -v node >/dev/null 2>&1; then
    echo "Installing nodejs..."
    pkg install -y nodejs
fi
if ! command -v npm >/dev/null 2>&1; then
    echo "Installing npm..."
    pkg install -y npm
fi

# Step 1: Clone or update
echo "↓ Cloning repo..."
if [ -d "$DIR/.git" ]; then
    echo "↻ Pulling latest..."
    cd "$DIR" && git pull origin master
else
    rm -rf "$DIR"
    git clone "$REPO.git" "$DIR"
fi

cd "$DIR"

# Step 2: Backend setup
echo "⚡ Setting up backend..."
cd backend
npm install 2>/dev/null || true
nohup node -e "require('./src/server.ts')" > backend.log 2>&1 &
echo "✓ Backend starting on http://localhost:3000"
cd ..

# Step 3: Frontend setup
echo "📱 Building app..."
cd frontend
npm install 2>/dev/null || true

echo ""
echo "===================================="
echo "✅ LILJR 3.7.3 INSTALLED"
echo ""
echo "Files at: $DIR"
echo "Backend: cd $DIR/backend && npm run dev"
echo "Frontend: cd $DIR/frontend && npm start"
echo ""
echo "To build APK:"
echo "  cd $DIR/frontend"
echo "  npx expo prebuild --platform android"
echo "  cd android && ./gradlew assembleDebug"
echo ""
echo "Quick start (no build needed):"
echo "  python3 -m http.server 8080 --directory $DIR/frontend"
echo "  Then open http://localhost:8080 in browser"
echo "===================================="
