import { test, expect, gotoAndWait } from './fixtures';

const NAV_TITLES = [
  'home', 'about', 'GPG Keys', 'blog', 'books',
  'epitaphs', 'jokes', 'projects', 'dashboards',
];

test.describe('site layout', () => {
  test.beforeEach(async ({ page }) => {
    await gotoAndWait(page, '/');
  });

  test('header renders with profile photo', async ({ page }) => {
    const header = page.locator('header');
    await expect(header).toBeVisible();
    await expect(header.locator('img.img-thumbnail')).toBeVisible();
  });

  test('navigation bar contains all expected links', async ({ page }) => {
    const nav = page.locator('nav.site-nav');
    await expect(nav).toBeVisible();

    const links = nav.locator('.nav-link');
    await expect(links).toHaveCount(NAV_TITLES.length);

    for (const title of NAV_TITLES) {
      await expect(nav.locator('.nav-link', { hasText: title })).toBeVisible();
    }
  });

  test('footer renders with copyright text', async ({ page }) => {
    const footer = page.locator('footer');
    await expect(footer).toBeVisible();
    await expect(footer).toContainText('Sam Caldwell');
    await expect(footer).toContainText('All Rights Reserved');
  });

  test('content wrapper exists', async ({ page }) => {
    await expect(page.locator('#content')).toBeVisible();
  });
});
