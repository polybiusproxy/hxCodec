package hxcodec._internal;

#if (!(desktop || android))
#error 'LibVLC only supports the Windows, Mac, Linux, and Android target platforms.'
#end

/**
 * @see https://videolan.videolan.me/vlc/group__libvlc__error.html
 */
@:buildXml("<include name='${haxelib:hxcodec}/project/Build.xml' />") // Link static/dynamic libraries for VLC
@:include('vlc/vlc.h') // Include VLC functions and types
@:keep // Fix issues with DCE
@:unreflective // TODO: Write down why this is needed
extern class LibVLCError
{
  /**
   * A human-readable error message for the last LibVLC error in the calling
   * thread. The resulting string is valid until another error occurs (at least
   * until the next LibVLC call).
   *
   * @warning
   * This will be NULL if there was no error.
   * @note In hxCodec, this returns a ConstPointer<Char> instead of a String.
   *       Use LibVLCError.getErrorMessage() to get a String;
   *       this properly handles the edge case where errmsg() returns null.
   */
  @:native('libvlc_errmsg')
  static function errmsg():String;

  /**
   * Clears the LibVLC error status for the current thread. This is optional.
   * By default, the error status is automatically overridden when a new error
   * occurs, and destroyed when the thread exits.
   */
  @:native('libvlc_clearerr')
  static function clearerr():Void;

  /**
   * Sets the LibVLC error status and message for the current thread.
   * Any previous error is overridden.
   * @param fmt the format string
   * @param ...  the arguments for the format string
   * @return a nul terminated string in any case
   */
  @:native('libvlc_printerr')
  static function printerr(fmt:String):String;
}

/**
 * Helper functions for LibVLCError.
 */
class LibVLCErrorHelper
{
  /**
   * `printf` the current LibVLC error message.
   */
  @:functionCode('
    printf("[libvlc] %s\\n", libvlc_errmsg());
    return;
  ')
  public static function printErrorMessage():Void
  {
    throw 'functionCode';
  }

  /**
   * hey remember that one meme where the youtube channel is like "the devs hid this secret tomato outside the map"
   * and the devs are like "if we remove the tomato, the game crashes"
   * 
   * this function just exists here, it doesn't do anything but if you remove it the app won't build.
   */
  static function getErrorMessage():String
  {
    var msg:String = LibVLCError.errmsg();
    if (msg == null) return '';
    return msg;
  }
}
