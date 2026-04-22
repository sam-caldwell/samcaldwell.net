import { test as base, expect, type Page } from '@playwright/test';

/**
 * Navigate to a URL and wait for the page to be ready.
 */
export async function gotoAndWait(page: Page, url: string): Promise<void> {
  await page.goto(url);
  await page.waitForLoadState('domcontentloaded');
}

export { base as test, expect };
