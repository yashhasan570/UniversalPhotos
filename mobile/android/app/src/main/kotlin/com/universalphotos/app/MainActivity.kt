package com.universalphotos.app

import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.ext.SdkExtensions
import com.universalphotos.app.background.BackgroundEngineLock
import com.universalphotos.app.background.BackgroundWorkerApiImpl
import com.universalphotos.app.background.BackgroundWorkerFgHostApi
import com.universalphotos.app.background.BackgroundWorkerLockApi
import com.universalphotos.app.connectivity.ConnectivityApi
import com.universalphotos.app.connectivity.ConnectivityApiImpl
import com.universalphotos.app.core.HttpClientManager
import com.universalphotos.app.core.UniversalPhotosPlugin
import com.universalphotos.app.core.NetworkApiPlugin
import me.albemala.native_video_player.NativeVideoPlayerPlugin
import com.universalphotos.app.images.LocalImageApi
import com.universalphotos.app.images.LocalImagesImpl
import com.universalphotos.app.images.RemoteImageApi
import com.universalphotos.app.images.RemoteImagesImpl
import com.universalphotos.app.passkey.PasskeyPlugin
import com.universalphotos.app.permission.PermissionApi
import com.universalphotos.app.permission.PermissionApiImpl
import com.universalphotos.app.sync.NativeSyncApi
import com.universalphotos.app.sync.NativeSyncApiImpl26
import com.universalphotos.app.sync.NativeSyncApiImpl30
import com.universalphotos.app.viewintent.ViewIntentPlugin
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
