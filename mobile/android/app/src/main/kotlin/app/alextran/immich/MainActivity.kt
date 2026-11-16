package app.alextran.universal_photos

import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.ext.SdkExtensions
import app.alextran.universal_photos.background.BackgroundEngineLock
import app.alextran.universal_photos.background.BackgroundWorkerApiImpl
import app.alextran.universal_photos.background.BackgroundWorkerFgHostApi
import app.alextran.universal_photos.background.BackgroundWorkerLockApi
import app.alextran.universal_photos.connectivity.ConnectivityApi
import app.alextran.universal_photos.connectivity.ConnectivityApiImpl
import app.alextran.universal_photos.core.HttpClientManager
import app.alextran.universal_photos.core.UniversalPhotosPlugin
import app.alextran.universal_photos.core.NetworkApiPlugin
import me.albemala.native_video_player.NativeVideoPlayerPlugin
import app.alextran.universal_photos.images.LocalImageApi
import app.alextran.universal_photos.images.LocalImagesImpl
import app.alextran.universal_photos.images.RemoteImageApi
import app.alextran.universal_photos.images.RemoteImagesImpl
import app.alextran.universal_photos.passkey.PasskeyPlugin
import app.alextran.universal_photos.permission.PermissionApi
import app.alextran.universal_photos.permission.PermissionApiImpl
import app.alextran.universal_photos.sync.NativeSyncApi
import app.alextran.universal_photos.sync.NativeSyncApiImpl26
import app.alextran.universal_photos.sync.NativeSyncApiImpl30
import app.alextran.universal_photos.viewintent.ViewIntentPlugin
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterFragmentActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    registerPlugins(this, flutterEngine)
    flutterEngine.plugins.add(PasskeyPlugin())
  }

  override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
    setIntent(intent)
  }

  companion object {
    fun registerPlugins(ctx: Context, flutterEngine: FlutterEngine) {
      HttpClientManager.initialize(ctx)
      NativeVideoPlayerPlugin.dataSourceFactory = HttpClientManager::createDataSourceFactory
      flutterEngine.plugins.add(NetworkApiPlugin())

      val messenger = flutterEngine.dartExecutor.binaryMessenger
      val backgroundEngineLockImpl = BackgroundEngineLock(ctx)
      BackgroundWorkerLockApi.setUp(messenger, backgroundEngineLockImpl)
      val nativeSyncApiImpl =
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R || SdkExtensions.getExtensionVersion(Build.VERSION_CODES.R) < 1) {
          NativeSyncApiImpl26(ctx)
        } else {
          NativeSyncApiImpl30(ctx)
        }
      val permissionApiImpl = PermissionApiImpl(ctx)
      NativeSyncApi.setUp(messenger, nativeSyncApiImpl)
      PermissionApi.setUp(messenger, permissionApiImpl)
      LocalImageApi.setUp(messenger, LocalImagesImpl(ctx))
      RemoteImageApi.setUp(messenger, RemoteImagesImpl(ctx))

      BackgroundWorkerFgHostApi.setUp(messenger, BackgroundWorkerApiImpl(ctx))
      ConnectivityApi.setUp(messenger, ConnectivityApiImpl(ctx))

      flutterEngine.plugins.add(ViewIntentPlugin())
      flutterEngine.plugins.add(backgroundEngineLockImpl)
      flutterEngine.plugins.add(nativeSyncApiImpl)
      flutterEngine.plugins.add(permissionApiImpl)
    }

    fun cancelPlugins(flutterEngine: FlutterEngine) {
      val nativeApi =
        flutterEngine.plugins.get(NativeSyncApiImpl26::class.java) as UniversalPhotosPlugin?
          ?: flutterEngine.plugins.get(NativeSyncApiImpl30::class.java) as UniversalPhotosPlugin?
      nativeApi?.detachFromEngine()
      val permissionApi = flutterEngine.plugins.get(PermissionApiImpl::class.java) as UniversalPhotosPlugin?
      permissionApi?.detachFromEngine()
    }
  }
}
