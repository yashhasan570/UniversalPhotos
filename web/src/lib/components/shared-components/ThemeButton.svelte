<script lang="ts">
  import { ThemePreference, ThemeSwitcher, themeManager } from '@Universal Photos/ui';
</script>

{#if themeManager.preference !== ThemePreference.System}
  <ThemeSwitcher size="medium" color="secondary" />
{/if}
