package hxcodec.base;

/**
 * A system for handling multiple callbacks for a single event.
 * Uses FlxSignal if available, otherwise uses a basic reimplementation.
 * 
 * - Callback functions take a single argument of type `T`, and return `Void`.
 * - Use `callback.add(cb)` to add a callback function.
 * - Use `callback.addOnce(cb)` to add a callback function that will be removed after the first call.
 * - Use `callback.remove(cb)` to remove a callback function.
 * - Use `callback.dispatch(arg)` from the caller to dispatch an event to all callbacks.
 */
#if flixel
import flixel.util.FlxSignal;
import flixel.util.FlxSignal.FlxTypedSignal;


@:forward(add, addOnce, remove, has, removeAll)
abstract Callback<T>(FlxTypedSignal<T->Void>) {
  public function new() {
    this = new FlxTypedSignal<T->Void>();
  }

  public function dispatch(value:T) {
    this.dispatch(value);
  }

  /**
   * Add this function to the callback when attempting to do `callback = function()`
   */
  @:deprecated("Please use callback.add(func) instead.")
  @:op(A = B)
  public function addCallback(cb:T->Void):T->Void {
    this.add(cb);
    return cb;
  }
}

@:forward(add, addOnce, remove, has, removeAll)
abstract CallbackVoid(FlxSignal) {
  public function new() {
    this = new FlxSignal();
  }

  public function dispatch() {
    this.dispatch();
  }

  /**
   * Add this function to the callback when attempting to do `callback = function()`
   */
  @:deprecated("Please use callback.add(func) instead.")
  @:op(A = B)
  public function addCallback(cb:Void->Void):Void->Void {
    this.add(cb);
    return cb;
  }
}
#else
class Callback<T>
{
  /**
   * The list of current callback handlers.
   */
  var handlers:Array<CallbackHandler<T>> = [];

  /**
   * Whether the handler array is currently being iterated over,
   * and therefore cannot be modified.
   */
  var cleanupPending:Bool = false;

  public function new() {}

  /**
   * Add a new callback function to the list.
   * @param cb The callback function.
   */
  public function add(cb:T->Void):Void
  {
    if (cb == null) return;
    registerCallback(cb, false);
  }

  @:deprecated("Please use callback.add(func) instead.")
  @:op(A = B)
  public function addViaAssignment(cb:T->Void):T->Void {
    add(cb);
    return cb;
  }

  /**
   * Add a new callback function to the list. It will be removed after the first call.
   * @param cb The callback function.
   */
  public function addOnce(cb:T->Void):Void
  {
    if (cb == null) return;
    registerCallback(cb, true);
  }

  /**
   * Remove a callback function from the list.
   * @param cb The callback function.
   */
  public function remove(cb:T->Void):Void
  {
    if (cb == null) return;
    removeHandler(getHandler(cb));
  }

  /**
   * @param cb The callback function.
   * @return Whether the callback function is in the list.
   */
  public function has(cb:T->Void):Bool
  {
    if (cb == null) return false;
    return getHandler(cb) != null;
  }

  /**
   * Clears the list of callback functions.
   */
  public function removeAll():Void
  {
    if (cleanupPending)
    {
      // Prevent bugs/crashes if removeAll is called during a dispatch.
      for (handler in handlers)
      {
        handler.pendingCleanup = true;
      }
    }
    else
    {
      // No reason to do anything fancy lol.
      handlers = [];
    }
  }

  /**
   * Dispatch an event, sending the given value to all callback functions.
   * @param arg The value to send to all callback functions.
   */
  public function dispatch(arg:T):Void
  {
    cleanupPending = true;
    for (handler in handlers)
    {
      if (handler == null || handler.pendingCleanup) continue;
      handler.dispatch(arg);
      if (handler.once) handler.pendingCleanup = true;
    }
    cleanupPending = false;

    cleanup();
  }

  function registerCallback(dispatch:T->Void, ?once:Bool = false):Void
  {
    var handler:CallbackHandler<T> =
      {
        dispatch: dispatch,
        once: once,
        pendingCleanup: false
      };
    handlers.push(handler);
  }

  function getHandler(dispatch:T->Void):CallbackHandler<T>
  {
    for (handler in handlers)
    {
      if (handler.dispatch == dispatch) return handler;
    }
    return null;
  }

  function removeHandler(handler:CallbackHandler<T>, ?force:Bool = false)
  {
    // Mark the handler for cleanup.
    // It will be removed from the array after the next dispatch is complete.
    handler.pendingCleanup = true;
    if (force) cleanup();
  }

  /**
   * Remove any callback handlers that have been marked for cleanup.
   */
  function cleanup():Void
  {
    if (cleanupPending) return;

    for (handler in handlers)
    {
      if (handler.pendingCleanup) handlers.remove(handler);
    }
  }
}

typedef CallbackHandler<T> =
{
  /**
   * The function to call.
   */
  var dispatch:T->Void;

  /**
   * Whether to mark this handler for removal after the first call.
   */
  var once:Bool;

  /**
   * Whether this handler is awaiting removal.
   */
  var pendingCleanup:Bool;
}

/**
 * A callback with no argument.
 */
 @:forward
 abstract CallbackVoid(Callback<NoUse>)
 {
   public function new():Void
   {
     this = new Callback<NoUse>();
   }
 
   public function dispatch():Void
   {
     this.dispatch(NoUse);
   }
 
   public function add(cb:Void->Void):Void
   {
     @:privateAccess
     this.handlers.push(
       {
         dispatch: function(_:NoUse):Void cb(),
         once: false,
         pendingCleanup: false
       });
   }

   // @:deprecated("Please use callback.add(func) instead.")
   // @:op(A = B)
   // public function addViaAssignment(cb:Void->Void):Void->Void {
   //   add(cb);
   //   return cb;
   // }
 }
#end

/**
 * A "meaningless" type.
 */
enum abstract NoUse(Int)
{
  var NoUse = 0;

  @:from
  static function fromDynamic(_:Dynamic):NoUse
  {
    return NoUse;
  }
}
