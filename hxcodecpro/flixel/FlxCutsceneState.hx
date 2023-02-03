package hxcodecpro.flixel;

#if flixel
import flixel.FlxState;

/**
 * A standard cutscene playback state, with basic playback controls.
 */
class FlxCutsceneState extends FlxState {
    public function new() {
        super();
    }

    public override function create():Void {
        super.create();
    }
}
#else
/**
 * Stub class used to prevent compilation errors when flixel is not installed.
 */
class FlxCutsceneState {
    public function new() {
        throw "flixel is not installed";
    }
}
#end