import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 20_000,
  expect: { timeout: 10_000 },
  retries: 0,
  reporter: [['html', { open: 'never' }], ['list']],
  use: {
    baseURL: 'https://samcaldwell.net',
    screenshot: 'only-on-failure',
    trace: 'retain-on-failure',
    extraHTTPHeaders: {
      ...(process.env.CF_BYPASS_TOKEN
        ? { 'X-CF-E2E-Bypass': process.env.CF_BYPASS_TOKEN }
        : {}),
    },
  },
  projects: [
    { name: 'chromium', use: { browserName: 'chromium' } },
  ],
});
