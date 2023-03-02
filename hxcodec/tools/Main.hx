package hxcodec.tools;

import hxcodec.tools.commands.Help;
import hxcodec.tools.commands.Setup;

using StringTools;

class Main {
  static var quiet:Bool = false;

  public static function main() {
    parseArgs(Sys.args());
  }

  static function parseArgs(args:Array<String>):Void {
    var _exePath:String = args.shift();

    var command:String = null;
    var unknownArgs:Array<String> = [];
    var commandArgs:Array<String> = [];

    // Flags
    var help:Bool = false;
    var verbose:Bool = false;

    while (args.length > 0) {
      var arg:String = args.shift();

      if (arg.startsWith('-')) {
        switch (arg) {
          // Flags
          case '-v':
          case '--version':
            Help.printVersion();
            return;
          case '-h':
          case '--help':
            help = true;
          case '--verbose':
            verbose = true;
          case '--quiet':
            quiet = true;
          default:
            unknownArgs.push(arg);
        }
      } else if (command == null) {
        switch (arg) {
          // Commands
          case 'init':
            command = 'init';
          case 'help':
            help = true;
          default:
            unknownArgs.push(arg);
        }
      } else {
        commandArgs.push(arg);
      }
    }

    if (command == null) {
      if (unknownArgs.length > 0) {
        Help.printUnknownArgs(unknownArgs);
      }

      Help.printHelp();
      return;
    } else {
      if (unknownArgs.length > 0) {
        Help.printUnknownArgs(unknownArgs);
      } else {
        if (help) {
          Help.printCommandHelp(command);
        } else {
          performCommand(command, commandArgs, verbose);
        }
      }
    }
  }

  public static function performCommand(command:String, args:Array<String>, verbose:Bool):Void {
    switch (command) {
      case 'init':
        new Setup(verbose).perform(args);
    }
  }

  public static inline function print(value:String) {
    if (quiet)
      return;
    #if sys
    Sys.println(value);
    #end
  }
}
