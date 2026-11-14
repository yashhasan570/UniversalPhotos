<script lang="ts">
  import { IconButton, type ActionItem, type Size } from '@Universal Photos/ui';

  type Props = {
    action: ActionItem;
    size?: Size;
  };

  const { action, size }: Props = $props();
  const { title, icon, onAction } = $derived(action);
</script>

{#if icon && (action.$if?.() ?? true)}
  <IconButton
    {size}
    shape="round"
    color="primary"
    {icon}
    aria-label={title}
    onclick={(event: MouseEvent) => onAction({ event, action })}
  />
{/if}
