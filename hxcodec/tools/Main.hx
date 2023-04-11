package hxcodec.tools;

import haxe.Rest;
import hxcodec.tools.commands.Help;
import hxcodec.tools.commands.Setup;
import tink.Cli;

using StringTools;

class HxCodecCli
{
  public function new() {}

  // @:command
  // public var setup:Setup;
  @:command
  public var help:Help;

  public var version:Bool = false;

  public var quiet:Bool = false;

  @:defaultCommand
  public function run(rest:Rest<String>)
  {
    if (version) Help.printVersion();

    // Help.printHelp();
    // trace("WAHOO! " + setup);
  }

  public function print(value:String)
  {
    if (quiet) return;
    #if sys Sys.println(value); #end
  }
}

class Main
{
  static var cli:HxCodecCli;

  public static function main()
  {
    cli = new HxCodecCli();
    Cli.process(Sys.args(), cli).handle(Cli.exit);

    // parseArgs(Sys.args());
  }

  static function parseArgs(args:Array<String>):Void
  {
    var _exePath:String = args.shift();

    var command:String = null;
    var unknownArgs:Array<String> = [];
    var commandArgs:Array<String> = [];

    // Flags
    var verbose:Bool = false;

    while (args.length > 0)
    {
      var arg:String = args.shift();

      trace(arg);

      if (arg.startsWith('-'))
      {
        switch (arg)
        {
          case '--verbose':
            verbose = true;
          default:
            unknownArgs.push(arg);
        }
      }
      else if (command == null)
      {
        switch (arg)
        {
          // Commands
          case 'setup':
            command = 'init';
          case 'init':
            command = 'init';
          default:
            unknownArgs.push(arg);
        }
      }
      else
      {
        commandArgs.push(arg);
      }
    }

    if (command == null)
    {
      if (unknownArgs.length > 0)
      {
        Help.printUnknownArgs(unknownArgs);
      }

      Help.printHelp();
      return;
    }
    else
    {
      if (unknownArgs.length > 0)
      {
        Help.printUnknownArgs(unknownArgs);
      }
      else
      {
        performCommand(command, commandArgs, verbose);
      }
    }
  }

  public static function performCommand(command:String, args:Array<String>, verbose:Bool):Void
  {
    switch (command)
    {
      case 'init':
        // new Setup(verbose).perform(args);
    }
  }

  public static inline function print(value:String)
  {
    cli.print(value);
  }
}
