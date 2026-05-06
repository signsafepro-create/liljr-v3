import { createTRPCProxyClient, httpBatchLink } from '@trpc/client';
import type { AppRouter } from '../../backend/src/server';

const BACKEND_URL = 'https://liljr-backend-production.up.railway.app';

export const trpc = createTRPCProxyClient<AppRouter>({
  links: [
    httpBatchLink({
      url: `${BACKEND_URL}/api/trpc`,
      headers() {
        return {
          'Content-Type': 'application/json',
        };
      },
    }),
  ],
});

export const getDeviceStatus = async () => trpc.device.getStatus.query();
export const getMessages = async () => trpc.neural.getMessages.query();
export const sendMessage = async (content: string) => trpc.neural.sendMessage.mutate({ content });
export const getBrainwaves = async () => trpc.neural.getBrainwaves.query();
export const getPortfolio = async () => trpc.trading.getPortfolio.query();
export const getMarketData = async () => trpc.trading.marketData.query();
export const getSocialStats = async () => trpc.social.stats.query();
export const getSecurityStatus = async () => trpc.security.status.query();
export const getAIStatus = async () => trpc.ai.brainStatus.query();
export const getSettings = async () => trpc.settings.get.query();
export const updateSettings = async (data: any) => trpc.settings.update.mutate(data);
