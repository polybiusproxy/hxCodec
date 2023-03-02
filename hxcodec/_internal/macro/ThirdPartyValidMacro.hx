package hxcodec._internal.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Position;
import haxe.io.Path;

/**
 * This macro validates that the `thirdparty/` directory is present and
 * able to be added to the build by Lime. If it is not, it will throw a compile-time error.
 */
class ThirdPartyValidMacro {
  static final LIBRARY_NAME = 'hxcodec';

  public static function thirdPartyExistsWindows():Void {
    #if (macro && !display)
    var process = new sys.io.Process('haxelib', ['path', LIBRARY_NAME]);
    if (process.exitCode() != 0) {
      var message = process.stderr.readAll().toString();
      Context.error('Cannot execute `haxelib path $LIBRARY_NAME`. ${message}', mockPosition());
    }
    
    // read the output of the process
    var libraryPath:String = process.stdout.readLine()
    libraryPath = libraryPath.split(' ')[1];
    libraryPath = Path.join([Path.normalize(libraryPath), 'thirdparty']);

    Context.error('hxcodec library path: $libraryPath', mockPosition());
    
    return;
    #else 
    // `#if display` is used for code completion. In this case returning an
    // empty string is good enough; We don't want to call a process on every hint.
    var commitHash:String = "";
    return;
    #end
  }

  static inline function mockPosition():Position {
    #if (macro && !display)
    return Context.currentPos();
    #else
    return {
      file: 'hxcodec',
      min: 0,
      max: 0
    };
    #end
  }
}