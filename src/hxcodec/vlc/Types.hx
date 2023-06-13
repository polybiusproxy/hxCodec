package hxcodec.vlc;

#if (!cpp && macro)
#error "LibVLC supports only C++ target platforms."
#end
class Types {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:native("libvlc_instance_t")
extern class LibVLC_Instance_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:native("libvlc_media_t")
extern class LibVLC_Media_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:native("libvlc_media_player_t")
extern class LibVLC_MediaPlayer_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:native("libvlc_event_manager_t")
extern class LibVLC_EventManager_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:native("libvlc_event_t")
extern class LibVLC_Event_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:native("libvlc_log_t")
extern class LibVLC_Log_T {}

/**
 * Event types.
 */
enum abstract LibVLC_Event_Type(Int) from Int to Int
{
	final LibVLC_MediaMetaChanged = 0;
	final LibVLC_MediaSubItemAdded = 1;
	final LibVLC_MediaDurationChanged = 2;
	final LibVLC_MediaParsedChanged = 3;
	final LibVLC_MediaFreed = 4;
	final LibVLC_MediaStateChanged = 5;
	final LibVLC_MediaSubItemTreeAdded = 6;
	final LibVLC_MediaPlayerMediaChanged = 256;
	final LibVLC_MediaPlayerNothingSpecial = 257;
	final LibVLC_MediaPlayerOpening = 258;
	final LibVLC_MediaPlayerBuffering = 259;
	final LibVLC_MediaPlayerPlaying = 260;
	final LibVLC_MediaPlayerPaused = 261;
	final LibVLC_MediaPlayerStopped = 262;
	final LibVLC_MediaPlayerForward = 263;
	final LibVLC_MediaPlayerBackward = 264;
	final LibVLC_MediaPlayerEndReached = 265;
	final LibVLC_MediaPlayerEncounteredError = 266;
	final LibVLC_MediaPlayerTimeChanged = 267;
	final LibVLC_MediaPlayerPositionChanged = 268;
	final LibVLC_MediaPlayerSeekableChanged = 269;
	final LibVLC_MediaPlayerPausableChanged = 270;
	final LibVLC_MediaPlayerTitleChanged = 271;
	final LibVLC_MediaPlayerSnapshotTaken = 272;
	final LibVLC_MediaPlayerLengthChanged = 273;
	final LibVLC_MediaPlayerVout = 274;
	final LibVLC_MediaPlayerScrambledChanged = 275;
	final LibVLC_MediaPlayerESAdded = 276;
	final LibVLC_MediaPlayerESDeleted = 277;
	final LibVLC_MediaPlayerESSelected = 278;
	final LibVLC_MediaPlayerCorked = 279;
	final LibVLC_MediaPlayerUncorked = 280;
	final LibVLC_MediaPlayerMuted = 281;
	final LibVLC_MediaPlayerUnmuted = 282;
	final LibVLC_MediaPlayerAudioVolume = 283;
	final LibVLC_MediaPlayerAudioDevice = 284;
	final LibVLC_MediaPlayerChapterChanged = 285;
	final LibVLC_MediaListItemAdded = 512;
	final LibVLC_MediaListWillAddItem = 513;
	final LibVLC_MediaListItemDeleted = 514;
	final LibVLC_MediaListWillDeleteItem = 515;
	final LibVLC_MediaListEndReached = 516;
	final LibVLC_MediaListViewItemAdded = 768;
	final LibVLC_MediaListViewWillAddItem = 769;
	final LibVLC_MediaListViewItemDeleted = 770;
	final LibVLC_MediaListViewWillDeleteItem = 771;
	final LibVLC_MediaListPlayerPlayed = 1024;
	final LibVLC_MediaListPlayerNextItemSet = 1025;
	final LibVLC_MediaListPlayerStopped = 1026;
	final LibVLC_MediaDiscovererStarted = 1280; /* @deprecated Useless event, it will be triggered only when calling libvlc_media_discoverer_start(). */
	final LibVLC_MediaDiscovererEnded = 1281; /* @deprecated Useless event, it will be triggered only when calling libvlc_media_discoverer_stop(). */
	final LibVLC_RendererDiscovererItemAdded = 1282;
	final LibVLC_RendererDiscovererItemDeleted = 1283;
	final LibVLC_VlmMediaAdded = 1536;
	final LibVLC_VlmMediaRemoved = 1537;
	final LibVLC_VlmMediaChanged = 1538;
	final LibVLC_VlmMediaInstanceStarted = 1539;
	final LibVLC_VlmMediaInstanceStopped = 1540;
	final LibVLC_VlmMediaInstanceStatusInit = 1541;
	final LibVLC_VlmMediaInstanceStatusOpening = 1542;
	final LibVLC_VlmMediaInstanceStatusPlaying = 1543;
	final LibVLC_VlmMediaInstanceStatusPause = 1544;
	final LibVLC_VlmMediaInstanceStatusEnd = 1545;
	final LibVLC_VlmMediaInstanceStatusError = 1546;
}

/**
 * Audio channels.
 */
enum abstract LibVLC_Audio_Output_Channel(Int) from Int to Int
{
	final LibVLC_AudioChannel_Error = -1;
	final LibVLC_AudioChannel_Stereo = 1;
	final LibVLC_AudioChannel_RStereo = 2;
	final LibVLC_AudioChannel_Left = 3;
	final LibVLC_AudioChannel_Right = 4;
	final LibVLC_AudioChannel_Dolbys = 5;
}

typedef LibVLC_Callback_T = cpp.Callable<(p_event:cpp.RawConstPointer<LibVLC_Event_T>, p_data:cpp.RawPointer<cpp.Void>) -> Void>;

typedef LibVLC_Log_CB = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, level:Int, ctx:cpp.RawConstPointer<LibVLC_Log_T>, fmt:cpp.ConstCharStar,
		args:cpp.VarList) -> Void>;

typedef LibVLC_Video_Format_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.RawPointer<cpp.Void>>, chroma:cpp.CharStar, width:cpp.RawPointer<cpp.UInt32>,
		height:cpp.RawPointer<cpp.UInt32>, pitches:cpp.RawPointer<cpp.UInt32>, lines:cpp.RawPointer<cpp.UInt32>) -> cpp.UInt32>;

typedef LibVLC_Video_Cleanup_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>) -> Void>;
typedef LibVLC_Video_Lock_CB = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, p_pixels:cpp.RawPointer<cpp.RawPointer<cpp.Void>>) -> cpp.RawPointer<cpp.Void>>;
typedef LibVLC_Video_Unlock_CB = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, id:cpp.RawPointer<cpp.Void>, p_pixels:cpp.VoidStarConstStar) -> Void>;
typedef LibVLC_Video_Display_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>, picture:cpp.RawPointer<cpp.Void>) -> Void>;
