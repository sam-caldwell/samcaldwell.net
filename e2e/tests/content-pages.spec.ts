import { test, expect, gotoAndWait } from './fixtures';

test.describe('blog', () => {
  test('lists at least 23 posts', async ({ page }) => {
    await gotoAndWait(page, '/blog/');
    const items = page.locator('.list-group-item');
    expect(await items.count()).toBeGreaterThanOrEqual(23);
  });

  test('each post links to a valid page', async ({ page }) => {
    await gotoAndWait(page, '/blog/');
    const firstLink = page.locator('.list-group-item a').first();
    await expect(firstLink).toHaveAttribute('href', /\//);
  });
});

test.describe('books', () => {
  test('lists at least 11 books', async ({ page }) => {
    await gotoAndWait(page, '/books/');
    const items = page.locator('.list-group-item');
    expect(await items.count()).toBeGreaterThanOrEqual(11);
  });
});

test.describe('jokes', () => {
  test('lists at least 16 jokes', async ({ page }) => {
    await gotoAndWait(page, '/jokes/');
    const items = page.locator('.list-group-item');
    expect(await items.count()).toBeGreaterThanOrEqual(16);
  });
});

test.describe('epitaphs', () => {
  test('lists at least 5 epitaphs', async ({ page }) => {
    await gotoAndWait(page, '/epitaphs/');
    const items = page.locator('.list-group-item');
    expect(await items.count()).toBeGreaterThanOrEqual(5);
  });
});

test.describe('dashboards', () => {
  test('lists at least 2 dashboards', async ({ page }) => {
    await gotoAndWait(page, '/dashboards/');
    const items = page.locator('.list-group-item');
    expect(await items.count()).toBeGreaterThanOrEqual(2);
  });
});

test.describe('projects', () => {
  test('lists claude-shell project with GitHub link', async ({ page }) => {
    await gotoAndWait(page, '/projects/');
    await expect(
      page.locator('a[href*="github.com/sam-caldwell/claude-shell"]')
    ).toBeVisible();
  });

  test('lists CRSCE project with GitHub link', async ({ page }) => {
    await gotoAndWait(page, '/projects/');
    await expect(
      page.locator('a[href*="github.com/sam-caldwell/CRSCE"]')
    ).toBeVisible();
  });

  test('lists Asymmetric Effort GreyNet project', async ({ page }) => {
    await gotoAndWait(page, '/projects/');
    await expect(
      page.locator('strong', { hasText: 'Asymmetric Effort GreyNet' })
    ).toBeVisible();
  });
});
