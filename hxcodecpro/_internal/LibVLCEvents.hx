package hxcodecpro._internal;

import cpp.Int64;

#if (!(desktop || android) && macro)
#error "LibVLC only supports the Windows, Mac, Linux, and Android target platforms."
#end

/**
 * @see https://videolan.videolan.me/vlc/group__libvlc__event.html
 */
@:buildXml("<include name='${haxelib:hxcodecpro}/project/Build.xml' />") // Link static/dynamic libraries for VLC
@:include("vlc/vlc.h") // Include VLC functions and types
@:keep // Fix issues with DCE
@:unreflective // TODO: Write down why this is needed
extern class LibVLCEvents
{
  /**
   * Register for an event notification.
   *
   * @param p_event_manager the event manager to which you want to attach to.
   *        Generally it is obtained by vlc_my_object_event_manager() where
   *        my_object is the object you want to listen to.
   * @param i_event_type the desired event to which we want to listen
   * @param f_callback the function to call when i_event_type occurs
   * @param user_data user provided data to carry with the event
   * @return 0 on success, ENOMEM on error
   */
  @:native("libvlc_event_attach")
  static function attach(p_event_manager:LibVLCTypes.LibVLC_EventManager, i_event_type:LibVLC_EventType, f_callback:LibVLC_Event_Callback,
    user_data:VoidStar):Int;

  /**
   * Unregister an event notification.
   *
   * @param p_event_manager the event manager
   * @param i_event_type the desired event to which we want to unregister
   * @param f_callback the function to call when i_event_type occurs
   * @param p_user_data user provided data to carry with the event
   */
  @:native("libvlc_event_detach")
  static function detach(p_event_manager:LibVLCTypes.LibVLC_EventManager, i_event_type:LibVLC_EventType, f_callback:LibVLC_Event_Callback,
    p_user_data:VoidStar):Void;
}
