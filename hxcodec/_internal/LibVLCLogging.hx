package hxcodec._internal;

import cpp.NativeString;
import cpp.ConstCharStar;
import cpp.StdStringRef;

#if (!(desktop || android) && macro)
#error 'LibVLC only supports the Windows, Mac, Linux, and Android target platforms.'
#end

/**
 * @see https://videolan.videolan.me/vlc/group__libvlc__log.html
 */
@:buildXml("<include name='${haxelib:hxcodec}/project/Build.xml' />") // Link static/dynamic libraries for VLC
@:include('vlc/vlc.h') // Include VLC functions and types
@:keep // Fix issues with DCE
@:unreflective // TODO: Write down why this is needed
extern class LibVLCLogging
{
  /**
   * Gets log message debug infos.
   *
   * This function retrieves self-debug information about a log message:
   * - the name of the VLC module emitting the message,
   * - the name of the source code module (i.e. file) and
   * - the line number within the source code module.
   *
   * The returned module name and file name will be NULL if unknown.
   * The returned line number will similarly be zero if unknown.
   *
   * @param ctx message context (as passed to the @ref libvlc_log_cb callback)
   * @param module module name storage (or NULL) [OUT]
   * @param file source code file name storage (or NULL) [OUT]
   * @param line source code file line number storage (or NULL) [OUT]
   * @warning The returned module name and source code file name, if non-NULL,
   * are only valid until the logging callback returns.
   *
   * @version LibVLC 2.1.0 or later
   */
  @:native('libvlc_log_get_context')
  static function get_context(ctx:LibVLC_Log, module:ConstCharStarStar, file:ConstCharStarStar, line:UnsignedStar):Void;

  /**
   * Gets log message info.
   *
   * This function retrieves meta-information about a log message:
   * - the type name of the VLC object emitting the message,
   * - the object header if any, and
   * - a temporaly-unique object identifier.
   *
   * This information is mainly meant for <b>manual</b> troubleshooting.
   *
   * The returned type name may be 'generic' if unknown, but it cannot be NULL.
   * The returned header will be NULL if unset; in current versions, the header
   * is used to distinguish for VLM inputs.
   * The returned object ID will be zero if the message is not associated with
   * any VLC object.
   *
   * @param ctx message context (as passed to the @ref libvlc_log_cb callback)
   * @param name object name storage (or NULL) [OUT]
   * @param header object header (or NULL) [OUT]
   * @param id temporarily-unique object identifier (or 0) [OUT]
   * @warning The returned module name and source code file name, if non-NULL,
   * are only valid until the logging callback returns.
   *
   * @version LibVLC 2.1.0 or later
   */
  @:native('libvlc_log_get_object')
  static function get_object(ctx:LibVLC_Log, name:ConstCharStarStar, header:ConstCharStarStar, id:UInt64Star):Void;

  /**
   * Unsets the logging callback.
   *
   * This function deregisters the logging callback for a LibVLC instance.
   * This is rarely needed as the callback is implicitly unset when the instance
   * is destroyed.
   *
   * @note This function will wait for any pending callbacks invocation to
   * complete (causing a deadlock if called from within the callback).
   *
   * @param p_instance libvlc instance
   * @version LibVLC 2.1.0 or later
   */
  @:native('libvlc_log_unset')
  static function unset(p_instance:LibVLC_Instance):Void;

  /**
   * Sets the logging callback for a LibVLC instance.
   *
   * This function is thread-safe: it will wait for any pending callbacks
   * invocation to complete.
   *
   * @param cb callback function pointer
   * @param data opaque data pointer for the callback function
   *
   * @note Some log messages (especially debug) are emitted by LibVLC while
   * is being initialized. These messages cannot be captured with this interface.
   *
   * @warning A deadlock may occur if this function is called from the callback.
   *
   * @param p_instance libvlc instance
   * @version LibVLC 2.1.0 or later
   */
  @:native('libvlc_log_set')
  static function set(p_instance:LibVLC_Instance, cb:LibVLC_Log_Callback, data:VoidStar):Void;

  /**
   * Sets up logging to a file.
   * @param p_instance libvlc instance
   * @param stream FILE pointer opened for writing
   *         (the FILE pointer must remain valid until libvlc_log_unset())
   * @version LibVLC 2.1.0 or later
   */
  @:native('libvlc_log_set_file')
  static function set_file(p_instance:LibVLC_Instance, stream:cpp.FILE):Void;
}

@:cppInclude('string')
@:cppNamespaceCode('
#include <stdlib.h>
#include <stdarg.h>
// thanks StackOverflow
int vasprintf(char **strp, const char *fmt, va_list ap) {
    // _vscprintf tells you how big the buffer needs to be
    int len = _vscprintf(fmt, ap);
    if (len == -1) {
        return -1;
    }
    size_t size = (size_t)len + 1;
    char *str = (char*) malloc(size);
    if (!str) {
        return -1;
    }
    // _vsprintf_s is the "secure" version of vsprintf
    int r = vsprintf_s(str, len + 1, fmt, ap);
    if (r == -1) {
        free(str);
        return -1;
    }
    *strp = str;
    return r;
}

static void logCallback(void *data, int level, const libvlc_log_t *ctx, const char *fmt, va_list args)
{
  LibVLCLoggingHelper_obj* self = static_cast<LibVLCLoggingHelper_obj*>(data);

  char* msg = NULL; // set it to null otherwise it will be some random ass bytes, it is not null by default.
  if (vasprintf(&msg,fmt,args) < 0) {
    msg = "Failed to format log message.";
  }

  self->messages.push_back(msg);

  return;
}')
class LibVLCLoggingHelper
{
  @:functionCode('
    printf("Test");
    return fopen(file, mode);
  ')
  static function openFile(file:String, mode:String):cpp.FILE
  {
    throw 'functionCode';
  }

  /**
   * Begin logging LibVLC messages to a file.
   * @param p_instance libvlc instance
   * @param file The file to log to.
   */
  public static function logToFile(p_instance:LibVLC_Instance, file:String):Void
  {
    trace('Logging LibVLC to file: ' + file);

    var stream = openFile(file, 'w');

    LibVLCLogging.set_file(p_instance, stream);

    trace('Initialized LibVLC logging.');
  }

  public static function logToCallback(p_instance:LibVLC_Instance, callback:String->Void):LibVLCLoggingHelper
  {
    var helper = new LibVLCLoggingHelper();
    helper.setup(p_instance, callback);
    return helper;
  }

  var p_instance:LibVLC_Instance;
  var callback:String->Void;

  public function new()
  {
    messages = StdVectorChar.create();
  }

  public function setup(p_instance:LibVLC_Instance, callback:String->Void):Void
  {
    this.p_instance = p_instance;
    this.callback = callback;

    trace('Logging LibVLC to callback.');
    setCallback();
    trace('Initialized LibVLC logging.');
  }

  @:functionCode('
    libvlc_log_set(p_instance, logCallback, this);
    return;
  ')
  function setCallback():Void
  {
    throw 'functionCode';
  }

  var messages:StdVectorChar;

  public function update()
  {
    var messagesOut:Array<String> = [];

    while (messages.size() > 0)
    {
      // Pop the last message in the vector.
      var msg:CharStar = messages.back();
      var msgStr:String = NativeString.fromPointer(msg);

      messagesOut.insert(0, msgStr);

      // Free the message.

      messages.pop_back();
    }

    for (msg in messagesOut)
    {
      callback(msg);
    }
  }
}
