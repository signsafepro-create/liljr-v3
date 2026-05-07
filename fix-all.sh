#!/bin/bash
# FIX EVERYTHING — Gradle Java + Backend + Build
# Run in Termux: bash <(curl -s https://raw.githubusercontent.com/signsafepro-create/liljr-v3/master/fix-all.sh)

set -e

echo "🔧 LILJR FIX-ALL SCRIPT"
echo "======================="

# ========== FIX 1: GRADLE JAVA ==========
echo ""
echo "☕ FIXING GRADLE JAVA DETECTION..."

# Find Java
JAVA_DIR=""
for d in "$PREFIX/lib/jvm"/*; do
    if [ -f "$d/bin/javac" ]; then
        JAVA_DIR="$d"
        break
    fi
done

if [ -z "$JAVA_DIR" ]; then
    echo "❌ No Java found. Install it first:"
    echo "   pkg install -y openjdk-21"
    exit 1
fi

echo "✓ Java found at: $JAVA_DIR"

# Set JAVA_HOME
export JAVA_HOME="$JAVA_DIR"
export PATH="$JAVA_HOME/bin:$PATH"

# Fix Gradle properties
GRADLE_PROPS="$HOME/liljr-complete/frontend/android/gradle.properties"
if [ -f "$GRADLE_PROPS" ]; then
    # Remove old java.home if exists
    grep -v "org.gradle.java.home" "$GRADLE_PROPS" > /tmp/gradle.props.tmp || true
    mv /tmp/gradle.props.tmp "$GRADLE_PROPS"
fi

# Add Java home for Gradle
echo "" >> "$GRADLE_PROPS"
echo "org.gradle.java.home=$JAVA_DIR" >> "$GRADLE_PROPS"
echo "✓ Gradle configured to use: $JAVA_DIR"

# ========== FIX 2: BACKEND ==========
echo ""
echo "⚡ FIXING BACKEND..."

cd "$HOME/liljr-v3/backend"

# Install dependencies
npm install

# Compile TypeScript instead of using tsx
npx tsc

# Start compiled backend
nohup node dist/server.js > backend.log 2>&1 &
echo "✓ Backend running on http://localhost:3000"

# ========== FIX 3: FRONTEND API URL ==========
echo ""
echo "🔗 FIXING FRONTEND API URL..."

cd "$HOME/liljr-complete/frontend"

# Fix the trpc.ts file
sed -i "s|const BACKEND_URL = .*|const BACKEND_URL = 'http://localhost:3000';|" src/api/trpc.ts

# Or create a simple local backend client
mkdir -p src/api
cat > src/api/trpc.ts << 'EOF'
// Local backend client — points to Termux localhost
const BACKEND_URL = 'http://localhost:3000';

// Simple fetch wrapper for tRPC
export const trpc = {
  device: {
    getStatus: () => fetch(`${BACKEND_URL}/api/trpc/device.getStatus`).then(r => r.json()),
    telemetry: () => fetch(`${BACKEND_URL}/api/trpc/device.telemetry`).then(r => r.json()),
  },
  neural: {
    getMessages: () => fetch(`${BACKEND_URL}/api/trpc/neural.getMessages`).then(r => r.json()),
    sendMessage: (content: string) => fetch(`${BACKEND_URL}/api/trpc/neural.sendMessage`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ content })
    }).then(r => r.json()),
    getBrainwaves: () => fetch(`${BACKEND_URL}/api/trpc/neural.getBrainwaves`).then(r => r.json()),
  },
  trading: {
    getPortfolio: () => fetch(`${BACKEND_URL}/api/trpc/trading.getPortfolio`).then(r => r.json()),
    marketData: () => fetch(`${BACKEND_URL}/api/trpc/trading.marketData`).then(r => r.json()),
  },
  security: {
    status: () => fetch(`${BACKEND_URL}/api/trpc/security.status`).then(r => r.json()),
  },
  ai: {
    brainStatus: () => fetch(`${BACKEND_URL}/api/trpc/ai.brainStatus`).then(r => r.json()),
  },
};
EOF

echo "✓ Frontend API points to localhost:3000"

# ========== FIX 4: BUILD APK ==========
echo ""
echo "🔨 BUILDING APK..."

cd "$HOME/liljr-complete/frontend"

# Ensure node_modules
if [ ! -d "node_modules" ]; then
    npm install
fi

# Prebuild
npx expo prebuild --platform android

# Build with fixed Java
cd android
export JAVA_HOME
export PATH
./gradlew assembleDebug

# Deliver
APK="$HOME/liljr-complete/frontend/android/app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK" ]; then
    cp "$APK" "$HOME/downloads/liljr-fixed.apk"
    echo ""
    echo "✅ SUCCESS! APK built."
    echo "📲 Location: ~/downloads/liljr-fixed.apk"
    echo ""
    echo "Install:"
    echo "   termux-open ~/downloads/liljr-fixed.apk"
    echo ""
    echo "Or copy to internal storage and tap:"
    echo "   cp ~/downloads/liljr-fixed.apk /sdcard/Download/"
else
    echo "❌ Build failed"
    exit 1
fi
