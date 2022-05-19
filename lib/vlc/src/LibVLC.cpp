#include <mutex>
#include <iostream>
#include <string>
#include <stdint.h>
#include <sstream>

using std::string;
using namespace std;

//////////////////////////////////////////////////////////////////////////////////////

#ifdef ANDROID
namespace patch {
	template < typename T > std::string to_string(const T& n) {
		std::ostringstream stm;
		stm << n;
		return stm.str();
	}
}
#endif

//////////////////////////////////////////////////////////////////////////////////////

LibVLC::LibVLC(void)
{
	libVlcInstance = libvlc_new(0, NULL);
}

LibVLC* LibVLC::create()
{
    return new LibVLC;
}

//////////////////////////////////////////////////////////////////////////////////////

static void *lock(void *data, void **p_pixels)
{
	t_ctx *ctx = (t_ctx*)data;
	ctx->imagemutex.lock();
	*p_pixels = ctx->pixeldata;
	return NULL;
}

static void unlock(void *data, void *id, void *const *p_pixels)
{
	t_ctx *ctx = (t_ctx *)data;
	ctx->imagemutex.unlock();
}

//////////////////////////////////////////////////////////////////////////////////////

static void display(void *opaque, void *picture) {}

static unsigned format_setup(void** opaque, char* chroma, unsigned* width, unsigned* height, unsigned* pitches, unsigned* lines)
{
	struct ctx *callback = reinterpret_cast<struct ctx *>(*opaque);	
	
	unsigned _w = (*width);
	unsigned _h = (*height);
	unsigned _pitch = _w*4;
	unsigned _frame = (_w*_h)*4;

	(*pitches) = _pitch;
	(*lines) = _h;
	memcpy(chroma, "RV32", 4);
	
	if (callback->pixeldata != 0)
		delete callback->pixeldata;
		
	callback->pixeldata = new unsigned char[_frame];
	return 1;
}

static void format_cleanup(void *opaque) {}

//////////////////////////////////////////////////////////////////////////////////////

void LibVLC::play()
{
	libvlc_media_player_play(libVlcMediaPlayer);
}

void LibVLC::play(const char* path) {
	std::cout << "video file location: " << path << std::endl;

	libVlcMediaItem = libvlc_media_new_location(libVlcInstance, path);
	libVlcMediaPlayer = libvlc_media_player_new_from_media(libVlcMediaItem);
	libvlc_media_parse(libVlcMediaItem);

	libvlc_media_add_option(libVlcMediaItem, ":hwdec=vaapi");
	libvlc_media_add_option(libVlcMediaItem, ":ffmpeg-hw");
	libvlc_media_add_option(libVlcMediaItem, ":avcodec-hw=dxva2.lo");
	libvlc_media_add_option(libVlcMediaItem, ":avcodec-hw=any");
	libvlc_media_add_option(libVlcMediaItem, ":avcodec-hw=dxva2");
	libvlc_media_add_option(libVlcMediaItem, "--avcodec-hw=dxva2");
	libvlc_media_add_option(libVlcMediaItem, ":avcodec-hw=vaapi");

	if (libVlcMediaItem != nullptr) {
		std::string sa = "input-repeat=";
		#ifdef ANDROID
		sa += patch::to_string(repeat);
		#else
		sa += std::to_string(repeat);
		#endif
		libvlc_media_add_option(libVlcMediaItem, sa.c_str());
	}

	ctx.pixeldata = 0;

	libvlc_video_set_format_callbacks(libVlcMediaPlayer, format_setup, format_cleanup);
	libvlc_video_set_callbacks(libVlcMediaPlayer, lock, unlock, display, &ctx);
	eventManager = libvlc_media_player_event_manager(libVlcMediaPlayer);

	libvlc_event_attach(eventManager, libvlc_MediaPlayerPlaying,			callbacks, this);
	libvlc_event_attach(eventManager, libvlc_MediaPlayerStopped,			callbacks, this);
	libvlc_event_attach(eventManager, libvlc_MediaPlayerEndReached,			callbacks, this);
	libvlc_event_attach(eventManager, libvlc_MediaPlayerTimeChanged,		callbacks, this);
	libvlc_event_attach(eventManager, libvlc_MediaPlayerPositionChanged,	callbacks, this);
	libvlc_event_attach(eventManager, libvlc_MediaPlayerSeekableChanged,	callbacks, this);
	libvlc_event_attach(eventManager, libvlc_MediaPlayerPlaying,			callbacks, this);
	libvlc_event_attach(eventManager, libvlc_MediaPlayerEncounteredError,	callbacks, this);
	libvlc_event_attach(eventManager, libvlc_MediaPlayerOpening,			callbacks, this);
	libvlc_event_attach(eventManager, libvlc_MediaPlayerBuffering,			callbacks, this);
	libvlc_event_attach(eventManager, libvlc_MediaPlayerForward,			callbacks, this);
	libvlc_event_attach(eventManager, libvlc_MediaPlayerBackward,			callbacks, this);

	libvlc_media_player_play(libVlcMediaPlayer);
	libvlc_audio_set_volume(libVlcMediaPlayer, 0);
}

void LibVLC::stop()
{
	libvlc_media_player_stop(libVlcMediaPlayer);
}

void LibVLC::togglePause()
{
	libvlc_media_player_pause(libVlcMediaPlayer);
}

void LibVLC::release()
{
	libvlc_media_player_release(libVlcMediaPlayer);
	libvlc_release(libVlcInstance);
}

float LibVLC::getLength()
{
	return libvlc_media_player_get_length(libVlcMediaPlayer);
}

float LibVLC::getDuration()
{
	return libvlc_media_get_duration(libVlcMediaItem);
}

int LibVLC::getWidth()
{
	return libvlc_video_get_width(libVlcMediaPlayer);
}

int LibVLC::getHeight()
{
	return libvlc_video_get_height(libVlcMediaPlayer);
}

int LibVLC::isPlaying()
{
	return libvlc_media_player_is_playing(libVlcMediaPlayer);
}

uint8_t* LibVLC::getPixelData()
{
	return ctx.pixeldata;
}

void LibVLC::setRepeat(int numRepeats)
{
	repeat = numRepeats;
}

int LibVLC::getRepeat()
{
	return repeat;
}

const char* LibVLC::getLastError()
{
	return libvlc_errmsg();	
}

void LibVLC::setVolume(float volume)
{
	if (volume > 100)
		volume = 100.0;

	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
	{
		libvlc_audio_set_volume(libVlcMediaPlayer, volume);
	}
}

float LibVLC::getVolume()
{
    float volume = libvlc_audio_get_volume(libVlcMediaPlayer);
    return volume;
}

int LibVLC::getTime()
{
	if (libVlcMediaPlayer!=NULL && libVlcMediaPlayer!=nullptr)
	{
		int t = libvlc_media_player_get_time(libVlcMediaPlayer);
		return t;
	}
	else
		return 0;
}

void LibVLC::setTime(int time)
{
	libvlc_media_player_set_time(libVlcMediaPlayer, time);
}

float LibVLC::getPosition()
{
    return libvlc_media_player_get_position(libVlcMediaPlayer);
}

void LibVLC::setPosition(float pos)
{
	libvlc_media_player_set_position(libVlcMediaPlayer, pos);
}

bool LibVLC::isSeekable()
{
    return libvlc_media_player_is_seekable(libVlcMediaPlayer) == 1;
}

void LibVLC::openMedia(const char* mediaPathName)
{
	libVlcMediaItem = libvlc_media_new_location(libVlcInstance, mediaPathName);
    libvlc_media_player_set_media(libVlcMediaPlayer, libVlcMediaItem);    
}

//////////////////////////////////////////////////////////////////////////////////////

void LibVLC::callbacks(const libvlc_event_t* event, void* ptr) {
	LibVLC* self = reinterpret_cast<LibVLC*>(ptr);

	switch (event -> type) {
		case libvlc_MediaPlayerPlaying:
			self -> flags[1] = 1;
			break;
		case libvlc_MediaPlayerStopped:
			self -> flags[2] = 1;
			break;
		case libvlc_MediaPlayerEndReached:
			self -> flags[3] = 1;
			break;
		case libvlc_MediaPlayerTimeChanged:
			self -> flags[4] = event -> u.media_player_time_changed.new_time;
			break;
		case libvlc_MediaPlayerPositionChanged:
			self -> flags[5] = event -> u.media_player_position_changed.new_position;
			break;
		case libvlc_MediaPlayerSeekableChanged:
			self -> flags[6] = event -> u.media_player_seekable_changed.new_seekable;
			break;
		case libvlc_MediaPlayerEncounteredError:
			self -> flags[7] = 1;
			break;
		case libvlc_MediaPlayerOpening:
			self -> flags[8] = 1;
			break;
		case libvlc_MediaPlayerBuffering:
			self -> flags[9] = 1;
			break;
		case libvlc_MediaPlayerForward:
			self -> flags[10] = 1;
			break;
		case libvlc_MediaPlayerBackward:
			self -> flags[11] = 1;
			break;
		default:
			break;
	}
}

//////////////////////////////////////////////////////////////////////////////////////