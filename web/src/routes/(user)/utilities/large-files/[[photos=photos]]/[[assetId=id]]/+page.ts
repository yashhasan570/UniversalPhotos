import { authenticate } from '#lib/utils/auth.ts';
import { getFormatter } from '#lib/utils/i18n.ts';
import { searchLargeAssets } from '@universalphotos/sdk';
import type { PageLoad } from './$types';

export const load = (async ({ url }) => {
  await authenticate(url);
  const assets = await searchLargeAssets({ minFileSize: 0 });
  const $t = await getFormatter();

  return {
    assets,
    meta: {
      title: $t('large_files'),
    },
  };
}) satisfies PageLoad;
