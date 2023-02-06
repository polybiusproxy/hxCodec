package hxcodecpro.openfl;

import openfl.events.Event;
import hxcodecpro._internal.VideoBitmapInternal;

class VideoBitmap extends VideoBitmapInternal
{
  public function new():Void
  {
    super();

    if (stage != null)
    {
      // We were already added to the stage, so setup immediately.
      onAddedToStage();
    }
    else
    {
      // Postpone setup until we are added to the stage.
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }
  }

  // Internal Methods
  function onAddedToStage(?e:Event):Void
  {
    if (hasEventListener(Event.ADDED_TO_STAGE)) removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

    stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
  }
}
