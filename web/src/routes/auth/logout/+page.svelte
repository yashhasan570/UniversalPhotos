<script lang="ts">
  import { authManager } from '#lib/managers/auth-manager.svelte.ts';
  import { LoadingSpinner } from '@Universal Photos/ui';

  void authManager.logout();
</script>

<div class="h-screen w-screen overflow-hidden">
  <div class="m-auto">
    <LoadingSpinner />
  </div>
</div>
