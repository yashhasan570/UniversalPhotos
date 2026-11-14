import { defineEnvVars } from '@sveltejs/kit/env';

export const variables = defineEnvVars({
  PUBLIC_UNIVERSALPHOTOS_BUY_HOST: { public: true, static: true },
  PUBLIC_UNIVERSALPHOTOS_PAY_HOST: { public: true, static: true },
});
