import { asMutation } from '#lib/queries/client.ts';
import { unlinkAllOAuthAccountsAdmin } from '@universal_photos/sdk';

export const unlinkAllOAuthAccountsAdminMutation = () =>
  asMutation(unlinkAllOAuthAccountsAdmin, { meta: { success: { toast: true } } });
