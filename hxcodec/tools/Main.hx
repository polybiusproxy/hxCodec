package hxcodec.tools;

import haxe.Rest;
import hxcodec.tools.commands.Help;
import hxcodec.tools.commands.Setup;
import tink.Cli;

using StringTools;

class HxCodecCli
{
  public function new() {}

  @:command
  public var setup:Setup;
  @:command
  public var help:Help;

  public var version:Bool = false;

  public var quiet:Bool = false;

  @:defaultCommand
  public function run(rest:Rest<String>)
  {
    if (version) Help.printVersion();
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
  }

  public static inline function print(value:String)
  {
    cli.print(value);
  }
}
