import { test as base, expect, type Page } from '@playwright/test';

/**
 * Navigate to a URL, log diagnostic info, and wait for any Cloudflare
 * challenge to resolve before returning.
 */
export async function gotoAndWait(page: Page, url: string): Promise<void> {
  const response = await page.goto(url, { waitUntil: 'commit' });
  const status = response?.status() ?? 'null';
  const title = await page.title();

  console.log(`[e2e] goto ${url} — HTTP ${status}, title="${title}"`);

  if (title === 'Just a moment...') {
    console.log(`[e2e] Cloudflare challenge detected, waiting for resolution...`);
    try {
      await page.waitForFunction(
        () => document.title !== 'Just a moment...',
        { timeout: 10_000 },
      );
      const newTitle = await page.title();
      console.log(`[e2e] Challenge resolved — title="${newTitle}"`);
    } catch {
      const bodyText = await page.locator('body').innerText().catch(() => '<unreadable>');
      console.log(`[e2e] Challenge did NOT resolve within 10s. Body: ${bodyText.slice(0, 500)}`);
      throw new Error(`Cloudflare challenge did not resolve for ${url} (HTTP ${status})`);
    }
  }

  await page.waitForLoadState('domcontentloaded');
}

export { base as test, expect };
