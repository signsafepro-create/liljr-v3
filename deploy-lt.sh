#!/bin/bash
# LilJR Backend + LocalTunnel — Free, no signup required
# Run: bash <(curl -s https://raw.githubusercontent.com/signsafepro-create/liljr-v3/master/deploy-lt.sh)

set -e
DIR="$HOME/liljr-v3"

echo "🧠 LILJR BACKEND — FREE PUBLIC URL"
echo "==================================="

# Step 1: Install localtunnel
echo "📡 Installing localtunnel..."
npm install -g localtunnel

# Step 2: Start backend
echo "⚡ Starting backend..."
cd "$DIR/backend"
if [ ! -d "node_modules" ]; then
    npm install
fi
nohup npm run dev > backend.log 2>&1 &
echo "✓ Backend on http://localhost:3000"

# Step 3: Expose via localtunnel (FREE, no signup)
echo "🌐 Creating public URL (free)..."
lt --port 3000 &
sleep 5

echo ""
echo "✅ BACKEND IS LIVE"
echo "Check the URL above — it looks like https://something.loca.lt"
echo ""
echo "Copy that URL and tell me. I'll wire your app to it."
