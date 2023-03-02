package hxcodec.tools.commands;

class Help {
  static final LIBRARY_NAME:String = "hxcodec";
  static final VERSION = haxe.macro.Compiler.getDefine("hxcodec");

  public static function printVersion():Void {
    var versionStr:String = '${LIBRARY_NAME} Command Line Tools (v${VERSION})';

    Main.print(versionStr);
    Main.print('');
  }

  public static function printHelp():Void {
    printVersion();

    Main.print('Usage: haxelib run ${LIBRARY_NAME} <command> [options]');
    Main.print('');
    Main.print('Commands:');
    Main.print('  setup     Setup third party libraries');
    // Main.print('  deploy    Deploy your serverless project');
    // Main.print('  invoke    Invoke a serverless function');
    // Main.print('  logs      View logs for a serverless function');
    // Main.print('  remove    Remove a serverless function');
    // Main.print('  config    Configure your serverless project');
    Main.print('  help      Display help for a command');
    Main.print('');
    Main.print('Options:');
    Main.print('  -v, --version    Output the version number');
    Main.print('  -h, --help       Output usage information or display help for a command');
    Main.print('  --verbose        Enable verbose output');
    Main.print('  --quiet          Disable all output');
    Main.print('');
  }

  public static function printUnknownArgs(unknownArgs:Array<String>):Void {
    for (i in 0...unknownArgs.length) {
      Main.print('Unknown argument: ${unknownArgs[i]}');
    }
  }

  public static function printCommandHelp(command:String):Void {
    printVersion();

    switch (command) {
      case 'setup':
        printCommandHelp_setup();
    }
  }

  public static function printCommandHelp_setup():Void {
    Main.print('Usage: haxelib run ${LIBRARY_NAME} setup [options]');
    Main.print('');
    Main.print('Options:');
    Main.print('  -h, --help       Output usage information');
    Main.print('');
  }
}
