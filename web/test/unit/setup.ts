import { MemoryStorage } from '#test/unit/mocks/storage.ts';
import { init } from 'svelte-i18n';

for (const name of ['localStorage', 'sessionStorage']) {
  Object.defineProperty(globalThis, name, { value: new MemoryStorage(), configurable: true });
}

beforeAll(async () => {
  await init({ fallbackLocale: 'dev' });
});

vi.mock('$app/env', () => ({ browser: true, dev: true, building: false, version: 'test' }));
vi.mock('$app/navigation', () => import('#test/unit/mocks/app-navigation.ts'));
vi.mock('$app/state', () => import('#test/unit/mocks/app-state.svelte.ts'));

vi.mock('$app/env/public', () => ({
  PUBLIC_UNIVERSALPHOTOS_BUY_HOST: 'https://buy.',
  PUBLIC_UNIVERSALPHOTOS_PAY_HOST: 'https://pay.futo.org',
}));

vi.mock('$env/dynamic/public', () => ({
  env: {
    PUBLIC_UNIVERSALPHOTOS_HOSTNAME: '',
  },
}));
