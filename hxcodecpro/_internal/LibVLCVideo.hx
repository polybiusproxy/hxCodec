package hxcodecpro._internal;

import cpp.Int64;

#if (!(desktop || android) && macro)
#error "LibVLC only supports the Windows, Mac, Linux, and Android target platforms."
#end

/**
 * @see https://videolan.videolan.me/vlc/group__libvlc__video.html
 */
@:buildXml("<include name='${haxelib:hxcodecpro}/project/Build.xml' />") // Link static/dynamic libraries for VLC
@:include("vlc/vlc.h") // Include VLC functions and types
@:keep // Fix issues with DCE
@:unreflective // TODO: Write down why this is needed
extern class LibVLCVideo
{
  /**
   * Set callbacks and private data to render decoded video to a custom area
   * in memory.
   * Use libvlc_video_set_format() or libvlc_video_set_format_callbacks()
   * to configure the decoded format.
   *
   * @warning Rendering video into custom memory buffers is considerably less
   * efficient than rendering in a custom window as normal.
   *
   * For optimal perfomances, VLC media player renders into a custom window, and
   * does not use this function and associated callbacks. It is <b>highly
   * recommended</b> that other LibVLC-based application do likewise.
   * To embed video in a window, use libvlc_media_player_set_xwindow() or
   * equivalent depending on the operating system.
   *
   * If window embedding does not fit the application use case, then a custom
   * LibVLC video output display plugin is required to maintain optimal video
   * rendering performances.
   *
   * The following limitations affect performance:
   * - Hardware video decoding acceleration will either be disabled completely,
   *   or require (relatively slow) copy from video/DSP memory to main memory.
   * - Sub-pictures (subtitles, on-screen display, etc.) must be blent into the
   *   main picture by the CPU instead of the GPU.
   * - Depending on the video format, pixel format conversion, picture scaling,
   *   cropping and/or picture re-orientation, must be performed by the CPU
   *   instead of the GPU.
   * - Memory copying is required between LibVLC reference picture buffers and
   *   application buffers (between lock and unlock callbacks).
   *
   * @param mp the media player
   * @param lock callback to lock video memory (must not be NULL)
   * @param unlock callback to unlock video memory (or NULL if not needed)
   * @param display callback to display video (or NULL if not needed)
   * @param opaque private pointer for the three callbacks (as first parameter)
   * @version LibVLC 1.1.1 or later
   */
  @:native("libvlc_video_set_callbacks")
  static function set_callbacks(mp:LibVLC_MediaPlayer, lock:LibVLC_Video_Lock_Callback, unlock:LibVLC_Video_Unlock_Callback,
    display:LibVLC_Video_Display_Callback, opaque:VoidStar):Void;

  /**
   * Set decoded video chroma and dimensions. This only works in combination with
   * `LibVLCVideo.set_callbacks()`.
   *
   * @param mp the media player
   * @param setup callback to select the video format (cannot be NULL)
   * @param cleanup callback to release any allocated resources (or NULL)
   * @version LibVLC 2.0.0 or later
   */
  @:native("libvlc_video_set_format_callbacks")
  static function set_format_callbacks(mp:LibVLC_MediaPlayer, setup:LibVLC_Video_Setup_Callback, cleanup:LibVLC_Video_Cleanup_Callback):Void;
}
