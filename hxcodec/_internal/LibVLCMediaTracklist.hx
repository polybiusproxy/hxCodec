package hxcodecpro._internal;

import cpp.Int64;

#if (!(desktop || android) && macro)
#error "LibVLC only supports the Windows, Mac, Linux, and Android target platforms."
#end

/**
 * @see https://videolan.videolan.me/vlc/group__libvlc__media__track.html
 */
@:buildXml("<include name='${haxelib:hxcodecpro}/project/Build.xml' />") // Link static/dynamic libraries for VLC
@:include("vlc/vlc.h") // Include VLC functions and types
@:keep // Fix issues with DCE
@:unreflective // TODO: Write down why this is needed
extern class LibVLCMediaTrack
{
  /**
   * Release a tracklist
   *
   * @version LibVLC 4.0.0 and later.
   *
   * @see libvlc_media_get_tracklist
   * @see libvlc_media_player_get_tracklist
   *
   * @param list valid tracklist
   */
  @:native("libvlc_media_tracklist_delete")
  static function delete(list:LibVLC_MediaTracklist):Void;
}
