package com.universalphotos.app.images

object ThumbHash {
  init {
    System.loadLibrary("native_core_ffi")
  }

  @JvmStatic
  external fun decode(hash: ByteArray, info: IntArray): Long
}
