package hxcodecpro._internal;

import cpp.RawPointer;
import cpp.RawConstPointer;
import cpp.Int64;
import cpp.UInt32;

#if (!(desktop || android) && macro)
#error "LibVLC only supports the Windows, Mac, Linux, and Android target platforms."
#end

/**
 * TODO: These functions and documentation were copied from the VLC headers manually. It would be nice to automate this process.
 * @see https://videolan.videolan.me/vlc/group__libvlc__core.html
 */
@:buildXml("<include name='${haxelib:hxcodecpro}/project/Build.xml' />") // Link static/dynamic libraries for VLC
@:include("vlc/vlc.h") // Include VLC functions and types
@:keep // Fix issues with DCE
@:unreflective // TODO: Write down why this is needed
extern class LibVLCCore
{
  /**
    * Create and initialize a libvlc instance.
    * This functions accept a list of "command line" arguments similar to the
    * main(). These arguments affect the LibVLC instance default configuration.
    *
    * @note
    * LibVLC may create threads. Therefore, any thread-unsafe process
    * initialization must be performed before calling init(). In particular
    * and where applicable:
    * - setlocale() and textdomain(),
    * - setenv(), unsetenv() and putenv(),
    * - with the X11 display system, XInitThreads()
    *   (see also LibVLCMediaPlayer.set_xwindow()) and
    * - on Microsoft Windows, SetErrorMode().
    * - sigprocmask() shall never be invoked; pthread_sigmask() can be used.
    *
    * On POSIX systems, the SIGCHLD signal <b>must not</b> be ignored, i.e. the
    * signal handler must set to SIG_DFL or a function pointer, not SIG_IGN.
    * Also while LibVLC is active, the wait() function shall not be called, and
    * any call to waitpid() shall use a strictly positive value for the first
    * parameter (i.e. the PID). Failure to follow those rules may lead to a
    * deadlock or a busy loop.
    * Also on POSIX systems, it is recommended that the SIGPIPE signal be blocked,
    * even if it is not, in principles, necessary, e.g.:
    * @code
      sigset_t set;

      signal(SIGCHLD, SIG_DFL);
      sigemptyset(&set);
      sigaddset(&set, SIGPIPE);
      pthread_sigmask(SIG_BLOCK, &set, NULL);
    * @endcode
    *
    * On Microsoft Windows, setting the default DLL directories to SYSTEM32
    * exclusively is strongly recommended for security reasons:
    * @code
      SetDefaultDllDirectories(LOAD_LIBRARY_SEARCH_SYSTEM32);
    * @endcode
    *
    * @version
    * Arguments are meant to be passed from the command line to LibVLC, just like
    * VLC media player does. The list of valid arguments depends on the LibVLC
    * version, the operating system and platform, and set of available LibVLC
    * plugins. Invalid or unsupported arguments will cause the function to fail
    * (i.e. return NULL). Also, some arguments may alter the behaviour or
    * otherwise interfere with other LibVLC functions.
    *
    * @warning
    * There is absolutely no warranty or promise of forward, backward and
    * cross-platform compatibility with regards to init() arguments.
    * We recommend that you do not use them, other than when debugging.
    *
    * @note hxCodecPro renames this to `init` since `new` is a reserved word in Haxe.
    * @param argc the number of arguments (should be 0)
    * @param argv list of arguments (should be NULL)
    * @return the libvlc instance or NULL in case of error
   */
  @:native("libvlc_new")
  static function init(argc:Int, argv:RawConstPointer<String>):LibVLCTypes.LibVLC_Instance;

  /**
   * Decrement the reference count of a libvlc instance, and destroy it
   * if it reaches zero.
   *
   * @param p_instance the instance to destroy
   */
  @:native("libvlc_release")
  static function release(p_instance:LibVLCTypes.LibVLC_Instance):Void;

  /**
   * Increments the reference count of a libvlc instance.
   * The initial reference count is 1 after init() returns.
   *
   * @param p_instance the instance to reference
   */
  @:native("libvlc_retain")
  static function retain(p_instance:LibVLCTypes.LibVLC_Instance):Void;

  /**
   * Get the ABI version of the libvlc library.
   *
   * This is different than the VLC version, which is the version of the whole
   * VLC package. The value is the same as LIBVLC_ABI_VERSION_INT used when
   * compiling.
   *
   * @return a value with the following mask in hexadecimal
   *  0xFF000000: major VLC version, similar to VLC major version,
   *  0x00FF0000: major ABI version, incremented incompatible changes are added,
   *  0x0000FF00: minor ABI version, incremented when new functions are added
   *  0x000000FF: micro ABI version, incremented with new release/builds
   *
   * @note This the same value as the .so version but cross platform.
   */
  @:native("libvlc_abi_version")
  static function abi_version():Int;

  /**
   * Try to start a user interface for the libvlc instance.
   *
   * @param p_instance the instance
   * @param name interface name, or NULL for default
   * @return 0 on success, -1 on error.
   */
  @:native("libvlc_add_intf")
  static function add_intf(p_instance:LibVLCTypes.LibVLC_Instance, name:String):Int;

  /**
   * Registers a callback for the LibVLC exit event. This is mostly useful if
   * the VLC playlist and/or at least one interface are started with
   * libvlc_playlist_play() or libvlc_add_intf() respectively.
   * Typically, this function will wake up your application main loop (from
   * another thread).
   *
   * @note This function should be called before the playlist or interface are
   * started. Otherwise, there is a small race condition: the exit event could
   * be raised before the handler is registered.
   *
   * @param p_instance LibVLC instance
   * @param cb callback to invoke when LibVLC wants to exit,
   *           or NULL to disable the exit handler (as by default)
   * @param opaque data pointer for the callback
   */
  @:native("libvlc_set_exit_handler")
  static function set_exit_handler(p_instance:LibVLCTypes.LibVLC_Instance, cb:LibVLCTypes.LibVLC_Exit_Callback, opaque:LibVLCTypes.VoidStar):Void;

  /**
   * Sets the application name. LibVLC passes this as the user agent string
   * when a protocol requires it.
   *
   * @param p_instance LibVLC instance
   * @param name human-readable application name, e.g. `FooBar player 1.2.3`
   * @param http HTTP User Agent, e.g. `FooBar/1.2.3 Python/2.6.0`
   * @version LibVLC 1.1.1 or later
   */
  @:native("libvlc_set_user_agent")
  static function set_user_agent(p_instance:LibVLCTypes.LibVLC_Instance, name:String, http:String):Void;

  /**
   * Sets some meta-information about the application.
   * See also set_user_agent().
   *
   * @param p_instance LibVLC instance
   * @param id Java-style application identifier, e.g. `com.acme.foobar`
   * @param version application version numbers, e.g. `1.2.3`
   * @param icon application icon name, e.g. `foobar`
   * @version LibVLC 2.1.0 or later.
   */
  @:native("libvlc_set_app_id")
  static function set_app_id(p_instance:LibVLCTypes.LibVLC_Instance, id:String, version:String, icon:String):Void;

  /**
   * Retrieve libvlc version.
   *
   * Example: `1.1.0-git The Luggage`
   *
   * @return a string containing the libvlc version
   */
  @:native("libvlc_get_version")
  static function get_version():String;

  /**
   * Retrieve libvlc compiler version.
   *
   * Example: `gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu6)`
   *
   * @return a string containing the libvlc compiler version
   */
  @:native("libvlc_get_compiler")
  static function get_compiler():String;

  /**
   * Retrieve libvlc changeset.
   *
   * Example: `aa9bce0bc4`
   *
   * @return a string containing the libvlc changeset
   */
  @:native("libvlc_get_changeset")
  static function get_changeset():String;

  /**
   * Frees an heap allocation returned by a LibVLC function.
   * If you know you're using the same underlying C run-time as the LibVLC
   * implementation, then you can call ANSI C free() directly instead.
   *
   * @param ptr the pointer
   */
  @:native("libvlc_free")
  static function free(ptr:LibVLCTypes.VoidStar):Void;

  /**
   * Release a list of module descriptions.
   *
   * @param p_list the list to be released
   */
  @:native("libvlc_free")
  static function libvlc_module_description_list_release(p_list:LibVLCTypes.LibVLC_ModuleDescription):Void;

  /**
   * Returns a list of audio filters that are available.
   *
   * @param p_instance libvlc instance
   *
   * @return a list of module descriptions. It should be freed with libvlc_module_description_list_release().
   *         In case of an error, NULL is returned.
   *
   * @see libvlc_module_description_t
   * @see libvlc_module_description_list_release
   */
  @:native("libvlc_audio_filter_list_get")
  static function libvlc_audio_filter_list_get(p_instance:LibVLCTypes.LibVLC_Instance):LibVLCTypes.LibVLC_ModuleDescription;

  /**
   * Returns a list of video filters that are available.
   *
   * @param p_instance libvlc instance
   *
   * @return a list of module descriptions. It should be freed with libvlc_module_description_list_release().
   *         In case of an error, NULL is returned.
   *
   * @see libvlc_module_description_t
   * @see libvlc_module_description_list_release
   */
  @:native("libvlc_video_filter_list_get")
  static function libvlc_video_filter_list_get(p_instance:LibVLCTypes.LibVLC_Instance):LibVLCTypes.LibVLC_ModuleDescription;
}
