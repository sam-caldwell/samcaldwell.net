import { test, expect } from '@playwright/test';

const NAV_ITEMS = [
  { title: 'home', url: '/' },
  { title: 'about', url: '/about/' },
  { title: 'GPG Keys', url: '/gpg-keys/' },
  { title: 'blog', url: '/blog/' },
  { title: 'books', url: '/books/' },
  { title: 'epitaphs', url: '/epitaphs/' },
  { title: 'jokes', url: '/jokes/' },
  { title: 'projects', url: '/projects/' },
  { title: 'dashboards', url: '/dashboards/' },
];

for (const item of NAV_ITEMS) {
  test(`nav "${item.title}" loads successfully at ${item.url}`, async ({ page }) => {
    const response = await page.goto(item.url);
    expect(response?.status()).toBe(200);

    // Every page except homepage should have a .page-title
    if (item.url !== '/') {
      await expect(page.locator('.page-title')).toBeVisible();
    }

    // The corresponding nav link should be active
    const navLink = page.locator('.nav-link', { hasText: item.title });
    await expect(navLink).toHaveClass(/active/);
  });
}
