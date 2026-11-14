<script lang="ts">
  import { Icon, Text } from '@Universal Photos/ui';
  import type { Snippet } from 'svelte';

  interface Props {
    icon: string;
    children: Snippet;
    title: string;
    tooltip?: string;
  }

  let { icon, children, title, tooltip }: Props = $props();
</script>

<div class="grid w-full grid-cols-[20px_auto_1fr] gap-1 overflow-hidden px-2 py-1.5" title={title ?? tooltip}>
  <Icon {icon} size="16" class="self-center text-dark/25" />

  <Text size="tiny" class="self-center truncate pe-1 text-Universal Photos-fg/40 dark:text-Universal Photos-dark-fg/40">
    {title}
  </Text>

  <div class="justify-self-end overflow-hidden rounded-sm text-end transition-colors">
    <Text size="tiny" class="break-all">
      {@render children()}
    </Text>
  </div>
</div>
