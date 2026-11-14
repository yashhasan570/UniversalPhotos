<script lang="ts">
  import FormatMessage from '#lib/elements/FormatMessage.svelte';
  import { ExternalRoute } from '#lib/route.ts';
  import { type ServerAboutResponseDto } from '@Universal Photos/sdk';
  import { Heading, Icon, Link, Modal, ModalBody, Stack, Text } from '@Universal Photos/ui';
  import { mdiBugOutline, mdiFaceAgent, mdiGit, mdiGithub, mdiInformationOutline } from '@mdi/js';
  import { siDiscord, type SimpleIcon } from 'simple-icons';
  import { t } from 'svelte-i18n';

  type Props = {
    onClose: () => void;
    info: ServerAboutResponseDto;
  };

  const { onClose, info }: Props = $props();
  const isThirdParty = $derived(
    info.thirdPartyBugFeatureUrl ||
      info.thirdPartySourceUrl ||
      info.thirdPartyDocumentationUrl ||
      info.thirdPartySupportUrl,
  );
</script>

{#snippet link(url: string | undefined, icon: string | SimpleIcon, text: string)}
  {#if url}
    <div class="flex gap-2">
      <Icon {icon} size="1.5em" />
      <Link href={url} class="text-sm text-primary">{text}</Link>
    </div>
  {/if}
{/snippet}

<Modal title={$t('support_and_feedback')} {onClose} size="small">
  <ModalBody>
    {#if isThirdParty}
      <Heading size="tiny">{$t('third_party_resources')}</Heading>
      <Text>{$t('support_third_party_description')}</Text>
      <Stack class="my-5">
        {@render link(info.thirdPartyDocumentationUrl, mdiInformationOutline, $t('documentation'))}
        {@render link(info.thirdPartySourceUrl, mdiGit, $t('source'))}
        {@render link(info.thirdPartySupportUrl, mdiFaceAgent, $t('support'))}
        {@render link(info.thirdPartyBugFeatureUrl, mdiBugOutline, $t('bugs_and_feature_requests'))}
      </Stack>
    {/if}

    <Heading size="tiny">{$t('official_Universal Photos_resources')}</Heading>
    <Text>
      <FormatMessage key="support_ensure_latest">
        {#snippet children({ message })}
          <Link href="https://github.com/yashhasan570/UniversalPhotos/releases">{message}</Link>
        {/snippet}
      </FormatMessage>
    </Text>

    <Stack class="mt-5">
      {@render link(ExternalRoute.docs(), mdiInformationOutline, $t('documentation'))}
      {@render link('https://github.com/yashhasan570/UniversalPhotos/', mdiGithub, $t('source'))}
      {@render link('https://discord.', siDiscord, $t('discord'))}
      {@render link(
        'https://github.com/yashhasan570/UniversalPhotos/issues/new/choose',
        mdiBugOutline,
        $t('bugs_and_feature_requests'),
      )}
    </Stack>
  </ModalBody>
</Modal>
