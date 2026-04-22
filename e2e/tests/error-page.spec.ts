import { test, expect } from '@playwright/test';

test.describe('404 page', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/404.html');
  });

  test('displays 404 title', async ({ page }) => {
    await expect(page.locator('.page-title')).toContainText('404');
  });

  test('shows helpful message', async ({ page }) => {
    await expect(page.locator('#content')).toContainText('Page not found');
  });

  test('navigation is still rendered', async ({ page }) => {
    await expect(page.locator('nav.site-nav')).toBeVisible();
  });
});
