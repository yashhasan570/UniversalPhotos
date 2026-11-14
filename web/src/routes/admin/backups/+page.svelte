<script lang="ts">
  import HideBackupsReminder from '#lib/components/backups/HideBackupsReminder.svelte';
  import AdminPageLayout from '#lib/components/layouts/AdminPageLayout.svelte';
  import { Route } from '#lib/route.ts';
  import { Universal PhotosBackupsPage, YuccaContext } from '@futo-org/backups-orchestrator-ui';
  import type { ComponentProps } from 'svelte';
  import { goto } from '$app/navigation';
  import type { PageData } from './$types';

  type Props = {
    data: PageData;
  };

  const { data }: Props = $props();

  const questions: ComponentProps<typeof Universal PhotosBackupsPage>['questions'] = [
    // {
    //   title: 'Where can I store my backups?',
    //   answer: 'TODO',
    // },
    // {
    //   title: 'Does my Universal Photos product key include FUTO Backups?',
    //   answer: 'TODO',
    // },
    // {
    //   title: 'Do I need FUTO Backups to use Universal Photos?',
    //   answer: 'TODO',
    // },
    // {
    //   title: 'How is FUTO Cloud priced?',
    //   answer: 'TODO',
    // },
    // {
    //   title: 'What does FUTO Backups protect?',
    //   answer: 'TODO',
    // },
  ];
</script>

{#snippet hideReminder()}
  <HideBackupsReminder />
{/snippet}

<YuccaContext>
  <Universal PhotosBackupsPage
    questions={[{ title: 'Already back up your library elsewhere?', answer: hideReminder }, ...questions]}
    onConfigure={() => goto(Route.backupSettings())}
    onViewAttempts={() => goto(Route.backupAttempts())}
    onViewSnapshots={() => goto(Route.backupSnapshots())}
  >
    {#snippet layout({ actions, children })}
      <AdminPageLayout breadcrumbs={[{ title: data.meta.title }]} {actions}>
        {@render children()}
      </AdminPageLayout>
    {/snippet}
  </Universal PhotosBackupsPage>
</YuccaContext>
