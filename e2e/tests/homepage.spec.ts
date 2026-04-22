import { test, expect } from '@playwright/test';

test.describe('homepage', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('page title contains site name', async ({ page }) => {
    await expect(page).toHaveTitle(/samcaldwell/i);
  });

  test('welcome heading is visible', async ({ page }) => {
    await expect(page.locator('h2', { hasText: 'Welcome' })).toBeVisible();
  });

  test('LinkedIn link is present', async ({ page }) => {
    await expect(page.locator('a[href*="linkedin.com/in/samcaldwell"]')).toBeVisible();
  });

  test('GitHub link is present', async ({ page }) => {
    await expect(page.locator('a[href*="github.com/sam-caldwell"]')).toBeVisible();
  });

  test('home nav link is active', async ({ page }) => {
    const homeLink = page.locator('.nav-link', { hasText: 'home' });
    await expect(homeLink).toHaveClass(/active/);
  });
});
