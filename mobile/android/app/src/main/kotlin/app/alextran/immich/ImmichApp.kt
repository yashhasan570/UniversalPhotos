package app.alextran.universal_photos

import android.app.Application
import android.os.Handler
import android.os.Looper
import app.alextran.universal_photos.background.BackgroundEngineLock
import app.alextran.universal_photos.background.BackgroundWorkerApiImpl

class UniversalPhotosApp : Application() {
  override fun onCreate() {
    super.onCreate()
    // After the process is killed (by user or system), the first trigger (taking a new picture) is lost.
    // Thus, the BackupWorker is not started. If the system kills the process after each initialization
    // (because of low memory etc.), the backup is never performed.
    // As a workaround, we also run a backup check when initializing the application
    Handler(Looper.getMainLooper()).postDelayed({
      // We can only check the engine count and not the status of the lock here,
      // as the previous start might have been killed without unlocking.
      if (BackgroundEngineLock.connectEngines > 0) return@postDelayed
      BackgroundWorkerApiImpl.enqueueBackgroundWorker(this)
    }, 15000)
  }
}
