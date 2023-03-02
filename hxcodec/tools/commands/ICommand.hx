package hxcodec.tools.commands;

interface ICommand {
    public function perform(args:Array<String>):Void;
}