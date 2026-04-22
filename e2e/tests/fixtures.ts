import { test as base, expect, type Page } from '@playwright/test';

/**
 * Wait for a Cloudflare challenge page ("Just a moment...") to resolve.
 * If the page is not a challenge, this returns immediately.
 */
async function waitForCloudflare(page: Page, timeout = 15_000): Promise<void> {
  const title = await page.title();
  if (title === 'Just a moment...') {
    await page.waitForFunction(
      () => document.title !== 'Just a moment...',
      { timeout },
    );
    // Allow the real page to fully render after challenge clears
    await page.waitForLoadState('domcontentloaded');
  }
}

/**
 * Navigate to a URL and wait for any Cloudflare challenge to resolve
 * before returning. Throws if the challenge never clears.
 */
export async function gotoAndWait(page: Page, url: string): Promise<void> {
  await page.goto(url, { waitUntil: 'commit' });
  await waitForCloudflare(page);
  await page.waitForLoadState('domcontentloaded');
}

export { base as test, expect };
