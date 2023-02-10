# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2023-02-10
This version is a full rewrite by EliteMasterEric, based on the old codebase, with new features and improvements.
## Added
- Added premade classes for video playback on HaxeFlixel.
    - Added `FlxVideoState` which plays videos.
    - Added `FlxVideoSubState` which plays videos.
    - Added `FlxCutsceneState` which plays a specific video (with the option to skip) before switching to the next state.
- All video player classes now have new video controls and metadata available.
    - Play a video (or switch what video is playing) with `video.playVideo`
    - Pause the video with `video.pause`
    - Resume the video with `video.resume`
    - Toggle played/paused with `video.togglePaused`
    - Stop the video with `video.stop`
    - Seek in the video by timestamp with `video.time`
    - Seek in the video by percent complete with `video.position`
    - Set volume with `video.volume`
    - Mute audio with `video.muteAudio`
    - Set playback rate with `video.playbackRate`
    - Fetch the video duration with `video.duration`
    - Check if video is playing with `video.isPlaying`
- All video player classes now utilize a new standardized callback/listener system.
    - This is based on FlxSignal if it is available, and its own implementation if FlxSignal is not available.
    - Available callbacks include `onOpening`, `onPlaying`, `onPaused`, `onStopped`, `onEndReached`, `onEncounteredError`, `onForward`, `onBackward`.
    - Use `onEndReached.add(funcToCall)` to add a callback to be executed each time the video ends.
    - Use `onEndReached.addOnce(funcToCall)` to add a callback to be executed only once.
    - Use `onEndReached.remove(funcToCall)` to remove an existing callback.
- Added new sample projects to demonstrate the use of the library.
    - These sample projects do not include video files to minimize repo size. Please make sure to download the videos for the sample projects before testing.
## Changed
- Reworked classes for video playback for HaxeFlixel and OpenFL.
    - `FlxVideoSprite` for HaxeFlixel can be added to a scene to play a video.
    - `VideoSprite` for OpenFL can be added as a sprite to play a video.
- All video players now use an `IVideoPlayer` interface, which ensures all video player classes support the same controls.
- Reworked internal library code to use LibVLC 4.0.
    - This lays the groundwork for future features and performance improvements.
- Refactored codebase for improved readability and maintainability.
- Added new documentation for most functions.
- Added Haxe Checkstyle to maintain consistent code style and formatting in Haxe code.
