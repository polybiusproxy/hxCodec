package hxcodecpro._internal;

import cpp.Int64;

#if (!(desktop || android) && macro)
#error "LibVLC only supports the Windows, Mac, Linux, and Android target platforms."
#end

/**
 * @see https://videolan.videolan.me/vlc/group__libvlc__clock.html
 */
@:buildXml("<include name='${haxelib:hxcodecpro}/project/Build.xml' />") // Link static/dynamic libraries for VLC
@:include("vlc/vlc.h") // Include VLC functions and types
@:keep // Fix issues with DCE
@:unreflective // TODO: Write down why this is needed
extern class LibVLCTime
{
  /**
   * Return the current time as defined by LibVLC. The unit is the microsecond.
   * Time increases monotonically (regardless of time zone changes and RTC
   * adjustments).
   * The origin is arbitrary but consistent across the whole system
   * (e.g. the system uptime, the time since the system was booted).
   * @note On systems that support it, the POSIX monotonic clock is used.
   */
  @:native("libvlc_clock")
  static function clock():Int64;

  /**
   * Return the delay (in microseconds) until a certain timestamp.
   * @param pts timestamp
   * @return negative if timestamp is in the past,
   * positive if it is in the future
   */
  @:native("libvlc_clock")
  static function delay(pts:Int):Int64;
}
