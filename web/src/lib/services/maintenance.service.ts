import { executeMutation } from '#lib/queries/client.ts';
import { setMaintenanceModeMutation } from '#lib/queries/maintenance.query.ts';
import { MaintenanceAction } from '@universal_photos/sdk';
import type { ActionItem } from '@universal_photos/ui';
import { mdiProgressWrench } from '@mdi/js';
import type { MessageFormatter } from 'svelte-i18n';

export const getMaintenanceAdminActions = ($t: MessageFormatter) => {
  const StartMaintenance: ActionItem = {
    title: $t('admin.maintenance_start'),
    onAction: () =>
      executeMutation(setMaintenanceModeMutation, [{ setMaintenanceModeDto: { action: MaintenanceAction.Start } }]),
    icon: mdiProgressWrench,
  };

  return { StartMaintenance };
};
