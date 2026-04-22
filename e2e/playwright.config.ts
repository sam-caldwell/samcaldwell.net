import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 45_000,
  expect: { timeout: 15_000 },
  retries: 2,
  reporter: [['html', { open: 'never' }]],
  use: {
    baseURL: 'https://samcaldwell.net',
    screenshot: 'only-on-failure',
    trace: 'retain-on-failure',
    // Bypass header — requires a matching Cloudflare WAF rule to skip
    // the managed challenge when this header is present.
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
