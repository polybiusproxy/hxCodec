#include <stdint.h>

LibVLC::LibVLC(void)
{
	libVlcInstance = libvlc_new(0, NULL);
}

LibVLC::~LibVLC(void)
{
	cleanupEvents();

	libvlc_media_player_release(libVlcMediaPlayer);
	libvlc_release(libVlcInstance);
}

LibVLC *LibVLC::create()
{
	return new LibVLC;
}

static void *lock(void *data, void **p_pixels)
{
	t_ctx *ctx = (t_ctx*) data;
	*p_pixels = ctx->pixeldata;
	return NULL;
}

static void unlock(void *data, void *id, void *const *p_pixels)
{
	t_ctx *ctx = (t_ctx*) data;
}

static void display(void *data, void *id)
{
	t_ctx *ctx = (t_ctx*) data;
}

static unsigned format_setup(void **opaque, char *chroma, unsigned *width, unsigned *height, unsigned *pitches, unsigned *lines)
{
	struct ctx *callback = reinterpret_cast< struct ctx*> (*opaque);

	unsigned _w = (*width);
	unsigned _h = (*height);
	unsigned _pitch = _w * 4;
	unsigned _frame = _w *_h * 4;

	(*pitches) = _pitch;
	(*lines) = _h;

	memcpy(chroma, "RV32", 4);

	if (callback->pixeldata != 0)
		delete callback->pixeldata;

	callback->pixeldata = new unsigned char[_frame];
	return 1;
}

static void format_cleanup(void *opaque)
{
	struct ctx *callback = reinterpret_cast< struct ctx*> (opaque);
}

void LibVLC::play()
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		libvlc_media_player_play(libVlcMediaPlayer);
}

void LibVLC::play(const char *path, bool loop, bool haccelerated)
{
	libVlcMediaItem = libvlc_media_new_path(libVlcInstance, path);
	libVlcMediaPlayer = libvlc_media_player_new_from_media(libVlcMediaItem);

	libvlc_media_parse(libVlcMediaItem);

	if (loop)
	{
		#ifdef ANDROID
		libvlc_media_add_option(libVlcMediaItem, "input-repeat=65535");
		#else
		libvlc_media_add_option(libVlcMediaItem, "input-repeat=-1");
		#endif
	}
	else
		libvlc_media_add_option(libVlcMediaItem, "input-repeat=0");

	if (haccelerated)
	{
		libvlc_media_add_option(libVlcMediaItem, ":hwdec=vaapi");
		libvlc_media_add_option(libVlcMediaItem, ":ffmpeg-hw");
		libvlc_media_add_option(libVlcMediaItem, ":avcodec-hw=dxva2.lo");
		libvlc_media_add_option(libVlcMediaItem, ":avcodec-hw=any");
		libvlc_media_add_option(libVlcMediaItem, ":avcodec-hw=dxva2");
		libvlc_media_add_option(libVlcMediaItem, "--avcodec-hw=dxva2");
		libvlc_media_add_option(libVlcMediaItem, ":avcodec-hw=vaapi");
	}

	libvlc_media_release(libVlcMediaItem);

	if (ctx.pixeldata != 0)
		ctx.pixeldata = 0;

	libvlc_video_set_format_callbacks(libVlcMediaPlayer, format_setup, format_cleanup);
	libvlc_video_set_callbacks(libVlcMediaPlayer, lock, unlock, display, &ctx);

	setupEvents();

	libvlc_media_player_play(libVlcMediaPlayer);
}

void LibVLC::stop()
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		libvlc_media_player_stop(libVlcMediaPlayer);
}

void LibVLC::pause()
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		libvlc_media_player_set_pause(libVlcMediaPlayer, 1);
}

void LibVLC::resume()
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		libvlc_media_player_set_pause(libVlcMediaPlayer, 0);
}

void LibVLC::togglePause()
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		libvlc_media_player_pause(libVlcMediaPlayer);
}

float LibVLC::getLength()
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		return libvlc_media_player_get_length(libVlcMediaPlayer);
	else
		return 0;
}

float LibVLC::getDuration()
{
	if (libVlcMediaItem != NULL && libVlcMediaItem != nullptr)
		return libvlc_media_get_duration(libVlcMediaItem);
	else
		return 0;
}

float LibVLC::getFPS()
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		return libvlc_media_player_get_fps(libVlcMediaPlayer);
	else
		return 0;
}

int LibVLC::getWidth()
{
	unsigned int width;
	unsigned int height;

	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
	{
		libvlc_video_get_size(libVlcMediaPlayer, 0, &width, &height);
		return width;
	}
	else
		return 0;
}

int LibVLC::getHeight()
{
	unsigned int width;
	unsigned int height;

	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
	{
		libvlc_video_get_size(libVlcMediaPlayer, 0, &width, &height);
		return height;
	}
	else
		return 0;
}

bool LibVLC::isMediaPlayerAlive()
{
	return libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr;
}

bool LibVLC::isMediaItemAlive()
{
	return libVlcMediaItem != NULL && libVlcMediaItem != nullptr;
}

bool LibVLC::isPlaying()
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		return libvlc_media_player_is_playing(libVlcMediaPlayer);
	else
		return false;
}

bool LibVLC::isSeekable()
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		return libvlc_media_player_is_seekable(libVlcMediaPlayer);
	else
		return false;
}

const char *LibVLC::getLastError()
{
	if (libvlc_errmsg())
		return libvlc_errmsg();
	else
		return "Error not specified :(";
}

void LibVLC::setVolume(float volume)
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		libvlc_audio_set_volume(libVlcMediaPlayer, volume);
}

float LibVLC::getVolume()
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		return libvlc_audio_get_volume(libVlcMediaPlayer);
	else
		return 0;
}

void LibVLC::setTime(int time)
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		libvlc_media_player_set_time(libVlcMediaPlayer, time);
}

int LibVLC::getTime()
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		return libvlc_media_player_get_time(libVlcMediaPlayer);
	else
		return 0;
}

void LibVLC::setPosition(float pos)
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		libvlc_media_player_set_position(libVlcMediaPlayer, pos);
}

float LibVLC::getPosition()
{
	if (libVlcMediaPlayer != NULL && libVlcMediaPlayer != nullptr)
		return libvlc_media_player_get_position(libVlcMediaPlayer);
	else
		return 0;
}

uint8_t *LibVLC::getPixelData()
{
	return ctx.pixeldata;
}

void LibVLC::callbacks(const libvlc_event_t *event, void *ptr)
{
	LibVLC *self = reinterpret_cast<LibVLC*> (ptr);

	switch (event->type)
	{
		case libvlc_MediaPlayerPlaying:
			self->flags[0] = 1;
			break;
		case libvlc_MediaPlayerStopped:
			self->flags[1] = 1;
			break;
		case libvlc_MediaPlayerEndReached:
			self->flags[2] = 1;
			break;
		case libvlc_MediaPlayerTimeChanged:
			self->flags[3] = event->u.media_player_time_changed.new_time;
			break;
		case libvlc_MediaPlayerPositionChanged:
			self->flags[4] = event->u.media_player_position_changed.new_position;
			break;
		case libvlc_MediaPlayerSeekableChanged:
			self->flags[5] = event->u.media_player_seekable_changed.new_seekable;
			break;
		case libvlc_MediaPlayerEncounteredError:
			self->flags[6] = 1;
			break;
		case libvlc_MediaPlayerOpening:
			self->flags[7] = 1;
			break;
		case libvlc_MediaPlayerBuffering:
			self->flags[8] = 1;
			break;
		case libvlc_MediaPlayerForward:
			self->flags[9] = 1;
			break;
		case libvlc_MediaPlayerBackward:
			self->flags[10] = 1;
			break;
		default:
			break;
	}
}

void LibVLC::setupEvents()
{
	if (libVlcEventManager == NULL && libVlcEventManager == nullptr)
		libVlcEventManager = libvlc_media_player_event_manager(libVlcMediaPlayer);

	libvlc_event_attach(libVlcEventManager, libvlc_MediaPlayerPlaying, callbacks, this);
	libvlc_event_attach(libVlcEventManager, libvlc_MediaPlayerStopped, callbacks, this);
	libvlc_event_attach(libVlcEventManager, libvlc_MediaPlayerEndReached, callbacks, this);
	libvlc_event_attach(libVlcEventManager, libvlc_MediaPlayerTimeChanged, callbacks, this);
	libvlc_event_attach(libVlcEventManager, libvlc_MediaPlayerPositionChanged, callbacks, this);
	libvlc_event_attach(libVlcEventManager, libvlc_MediaPlayerSeekableChanged, callbacks, this);
	libvlc_event_attach(libVlcEventManager, libvlc_MediaPlayerPlaying, callbacks, this);
	libvlc_event_attach(libVlcEventManager, libvlc_MediaPlayerEncounteredError, callbacks, this);
	libvlc_event_attach(libVlcEventManager, libvlc_MediaPlayerOpening, callbacks, this);
	libvlc_event_attach(libVlcEventManager, libvlc_MediaPlayerBuffering, callbacks, this);
	libvlc_event_attach(libVlcEventManager, libvlc_MediaPlayerForward, callbacks, this);
	libvlc_event_attach(libVlcEventManager, libvlc_MediaPlayerBackward, callbacks, this);
}

void LibVLC::cleanupEvents()
{
	if (libVlcEventManager == NULL && libVlcEventManager == nullptr)
		return;

	libvlc_event_detach(libVlcEventManager, libvlc_MediaPlayerPlaying, callbacks, this);
	libvlc_event_detach(libVlcEventManager, libvlc_MediaPlayerStopped, callbacks, this);
	libvlc_event_detach(libVlcEventManager, libvlc_MediaPlayerEndReached, callbacks, this);
	libvlc_event_detach(libVlcEventManager, libvlc_MediaPlayerTimeChanged, callbacks, this);
	libvlc_event_detach(libVlcEventManager, libvlc_MediaPlayerPositionChanged, callbacks, this);
	libvlc_event_detach(libVlcEventManager, libvlc_MediaPlayerSeekableChanged, callbacks, this);
	libvlc_event_detach(libVlcEventManager, libvlc_MediaPlayerPlaying, callbacks, this);
	libvlc_event_detach(libVlcEventManager, libvlc_MediaPlayerEncounteredError, callbacks, this);
	libvlc_event_detach(libVlcEventManager, libvlc_MediaPlayerOpening, callbacks, this);
	libvlc_event_detach(libVlcEventManager, libvlc_MediaPlayerBuffering, callbacks, this);
	libvlc_event_detach(libVlcEventManager, libvlc_MediaPlayerForward, callbacks, this);
	libvlc_event_detach(libVlcEventManager, libvlc_MediaPlayerBackward, callbacks, this);
}
