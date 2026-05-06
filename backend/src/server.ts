import { initTRPC } from '@trpc/server';
import { z } from 'zod';
import cors from 'cors';
import express from 'express';
import * as trpcExpress from '@trpc/server/adapters/express';

// ─── DB (in-memory for now — swap for real DB later) ───
const db = {
  messages: [] as any[],
  deviceStatus: {
    deviceName: 'LilJR-NeuralLink',
    connected: true,
    batteryLevel: 87,
    signalStrength: 92,
    syncRate: 144,
    latency: 12,
    packetsPerSecond: 2400,
    cpuUsage: 23,
    ramUsage: 45,
    packets: 48291,
    uptime: 3600 * 72,
    impedance: 4.2,
    sampleRate: 256
  },
  brainwaves: {
    gamma: 42,
    beta: 38,
    alpha: 55,
    theta: 28,
    linkStrength: 94,
    meditationMode: false
  },
  memory: {
    files: [
      { id: '1', filename: 'neural-cortex-v2.bin', fileType: 'binary', sizeBytes: 4194304, createdAt: new Date().toISOString() },
      { id: '2', filename: 'training-log.json', fileType: 'json', sizeBytes: 204800, createdAt: new Date().toISOString() },
      { id: '3', filename: 'voice-samples.wav', fileType: 'audio', sizeBytes: 10485760, createdAt: new Date().toISOString() },
      { id: '4', filename: 'trade-history.csv', fileType: 'csv', sizeBytes: 51200, createdAt: new Date().toISOString() }
    ]
  },
  portfolio: {
    totalValue: 2847.32,
    cashBalance: 512.50,
    dayPnl: +127.45,
    totalPnl: +892.11,
    riskLevel: 'moderate'
  },
  marketData: {
    stocks: [
      { symbol: 'AAPL', price: 187.45, change: +1.23, changePercent: +0.66 },
      { symbol: 'NVDA', price: 892.10, change: +12.40, changePercent: +1.41 },
      { symbol: 'TSLA', price: 175.30, change: -2.10, changePercent: -1.18 },
      { symbol: 'MSFT', price: 412.35, change: +3.50, changePercent: +0.86 }
    ],
    crypto: [
      { symbol: 'BTC', price: 67432.10, change: +1200.50, changePercent: +1.81 },
      { symbol: 'ETH', price: 3421.55, change: +45.30, changePercent: +1.34 },
      { symbol: 'SOL', price: 142.80, change: -1.20, changePercent: -0.83 }
    ],
    forex: [
      { symbol: 'EUR/USD', price: 1.0845, change: +0.0012, changePercent: +0.11 },
      { symbol: 'GBP/USD', price: 1.2670, change: -0.0008, changePercent: -0.06 }
    ]
  },
  social: {
    platforms: 5,
    connected: true,
    totalFollowers: 12473,
    postsToday: 12,
    engagement: 4.7,
    scheduled: 3,
    platformsList: ['Twitter/X', 'Instagram', 'TikTok', 'YouTube', 'LinkedIn']
  },
  intel: [
    { title: 'AI Market Cap Hits $4T', source: 'Bloomberg', time: '2h ago', category: 'tech', confidence: 92 },
    { title: 'Fed Signals Rate Cut Incoming', source: 'Reuters', time: '4h ago', category: 'macro', confidence: 78 },
    { title: 'Neural Interface Breakthrough', source: 'TechCrunch', time: '6h ago', category: 'tech', confidence: 85 }
  ],
  legal: {
    active: 2,
    pending: 1,
    closed: 5,
    upcomingDeadlines: 1,
    totalDocuments: 23
  },
  security: {
    overall: 'secure',
    score: 94,
    vpn: true,
    biometric: true,
    lastBreach: null,
    activeThreats: 0,
    firewall: true,
    encryption: true
  },
  securityEvents: [
    { id: '1', eventType: 'scan_complete', severity: 'info', message: 'Deep scan completed — no threats found', createdAt: new Date().toISOString() }
  ],
  automation: {
    total: 12,
    running: 3,
    scheduled: 5,
    completed: 142,
    failed: 1,
    workflows: ['market_monitor', 'social_sync', 'backup_cleanup', 'security_scan']
  },
  ai: {
    status: 'online',
    model: 'LilJR-Neural-v3',
    cortexLoad: 34,
    memoryUsed: 2.1,
    totalMemory: 16,
    synapses: 142857,
    lastSelfHeal: 'Never needed',
    uptime: '72h 14m',
    capabilities: ['chat', 'voice', 'vision', 'trading', 'intel', 'security', 'automation']
  },
  settings: {
    hudOpacity: 0.85,
    animationSpeed: 1.0,
    soundEffects: true,
    meditationMode: false,
    neuralBridge: true,
    autoSync: true,
    encryption: true,
    theme: 'void'
  }
};

// ─── tRPC SETUP ───
const t = initTRPC.create();
const router = t.router;
const publicProcedure = t.procedure;

// ─── ROUTERS ───
const deviceRouter = router({
  getStatus: publicProcedure.query(() => ({
    deviceName: db.deviceStatus.deviceName,
    connected: db.deviceStatus.connected,
    batteryLevel: db.deviceStatus.batteryLevel,
    signalStrength: db.deviceStatus.signalStrength,
    syncRate: db.deviceStatus.syncRate,
    latency: db.deviceStatus.latency,
    packetsPerSecond: db.deviceStatus.packetsPerSecond,
    cpuUsage: db.deviceStatus.cpuUsage,
    ramUsage: db.deviceStatus.ramUsage
  })),
  telemetry: publicProcedure.query(() => ({
    packets: db.deviceStatus.packets,
    latency: db.deviceStatus.latency,
    uptime: db.deviceStatus.uptime,
    cpu: db.deviceStatus.cpuUsage,
    ram: db.deviceStatus.ramUsage,
    battery: db.deviceStatus.batteryLevel,
    impedance: db.deviceStatus.impedance,
    sampleRate: db.deviceStatus.sampleRate
  }))
});

const neuralRouter = router({
  getMessages: publicProcedure.query(() => db.messages),
  sendMessage: publicProcedure
    .input(z.object({ content: z.string() }))
    .mutation(({ input }) => {
      const msg = {
        id: crypto.randomUUID(),
        userId: 'user',
        role: 'user',
        content: input.content,
        createdAt: new Date().toISOString()
      };
      db.messages.push(msg);
      // Auto-reply
      const reply = {
        id: crypto.randomUUID(),
        userId: 'liljr',
        role: 'assistant',
        content: generateReply(input.content),
        createdAt: new Date().toISOString()
      };
      db.messages.push(reply);
      return { reply: reply.content };
    }),
  getBrainwaves: publicProcedure.query(() => db.brainwaves)
});

function generateReply(userMsg: string): string {
  const lower = userMsg.toLowerCase();
  if (lower.includes('price') || lower.includes('stock') || lower.includes('trade'))
    return 'Markets are active. AAPL +0.66%, NVDA +1.41%. Your portfolio is up $127 today. Want me to execute a trade?';
  if (lower.includes('hello') || lower.includes('hi'))
    return 'Neural link established. I\'m online and listening. What do you need?';
  if (lower.includes('scan') || lower.includes('security'))
    return 'Security scan complete. Score: 94/100. No active threats. VPN and biometric auth are active.';
  return 'Acknowledged. Processing through neural cortex. I\'ll handle that for you.';
}

const memoryRouter = router({
  list: publicProcedure.query(() => db.memory.files),
  search: publicProcedure
    .input(z.object({ query: z.string() }))
    .query(({ input }) => ({
      results: db.memory.files.filter(f =>
        f.filename.toLowerCase().includes(input.query.toLowerCase())
      )
    })),
  stats: publicProcedure.query(() => {
    const totalSize = db.memory.files.reduce((sum, f) => sum + f.sizeBytes, 0);
    return {
      totalFiles: db.memory.files.length,
      totalSizeBytes: totalSize,
      totalSizeGb: Number((totalSize / 1073741824).toFixed(2)),
      byType: db.memory.files.reduce((acc: any, f) => {
        acc[f.fileType] = (acc[f.fileType] || 0) + 1;
        return acc;
      }, {})
    };
  })
});

const tradingRouter = router({
  getPortfolio: publicProcedure.query(() => db.portfolio),
  marketData: publicProcedure.query(() => db.marketData)
});

const socialRouter = router({
  stats: publicProcedure.query(() => db.social)
});

const intelRouter = router({
  news: publicProcedure.query(() => db.intel)
});

const legalRouter = router({
  stats: publicProcedure.query(() => db.legal)
});

const securityRouter = router({
  status: publicProcedure.query(() => db.security),
  getEvents: publicProcedure.query(() => db.securityEvents)
});

const automationRouter = router({
  stats: publicProcedure.query(() => db.automation)
});

const aiRouter = router({
  brainStatus: publicProcedure.query(() => db.ai),
  selfHeal: publicProcedure.query(() => ({
    ok: true,
    actions: ['cortex_optimized', 'memory_defragged', 'synapses_pruned']
  }))
});

const settingsRouter = router({
  get: publicProcedure.query(() => db.settings),
  update: publicProcedure
    .input(z.object({
      hudOpacity: z.number().optional(),
      animationSpeed: z.number().optional(),
      soundEffects: z.boolean().optional(),
      meditationMode: z.boolean().optional(),
      neuralBridge: z.boolean().optional(),
      autoSync: z.boolean().optional(),
      encryption: z.boolean().optional(),
      theme: z.string().optional()
    }))
    .mutation(({ input }) => {
      Object.assign(db.settings, input);
      return { ok: true };
    })
});

// ─── APP ROUTER ───
const appRouter = router({
  device: deviceRouter,
  neural: neuralRouter,
  memory: memoryRouter,
  trading: tradingRouter,
  social: socialRouter,
  intel: intelRouter,
  legal: legalRouter,
  security: securityRouter,
  automation: automationRouter,
  ai: aiRouter,
  settings: settingsRouter
});

export type AppRouter = typeof appRouter;

// ─── EXPRESS SERVER ───
const app = express();
app.use(cors({ origin: '*' }));
app.use(express.json());

// Health check
app.get('/', (_req, res) => {
  res.json({ status: 'online', version: '3.7.3', name: 'LilJR Neural Link' });
});

// tRPC endpoint
app.use('/api/trpc', trpcExpress.createExpressMiddleware({
  router: appRouter,
  createContext: () => ({})
}));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🧠 LilJR Backend v3.7.3 running on port ${PORT}`);
  console.log(`📡 tRPC endpoint: http://localhost:${PORT}/api/trpc`);
});

export { appRouter };
