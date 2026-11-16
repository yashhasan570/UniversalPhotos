import { getPublicConfig } from '@universal_photos/sdk';
import { queryOptions } from '@tanstack/svelte-query';

export const getPublicConfigQuery = () =>
  queryOptions({
    queryKey: ['config', 'public'],
    queryFn: ({ signal }) => getPublicConfig({ signal }),
    gcTime: Infinity,
  });
