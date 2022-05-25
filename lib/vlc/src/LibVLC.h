#ifndef LIBVLC_H
#define LIBVLC_H

#include "vlc/vlc.h"
#include <mutex>

struct libvlc_instance_t;
struct libvlc_media_t;
struct libvlc_media_player_t;

typedef struct ctx
{
	unsigned char *pixeldata;
	std::mutex imagemutex;
} t_ctx;

class LibVLC
{
	//////////////////////////////////////////////////////////////////////////////////////

	public:
		LibVLC();
		static LibVLC* create();
		void play();
		void play(const char * path);
		void stop();
		void togglePause();
		void release();
		float getLength();
		float getDuration();
		int getWidth();
		int getHeight();
		int isPlaying();
		uint8_t* getPixelData();
		void setVolume(float volume);
		float getVolume();
		int getTime();
		void setTime(int time);
		float getPosition();
		void setPosition(float pos);
		bool isSeekable();
		void setRepeat(int numRepeats);
		int getRepeat();
		const char* getLastError();
		void openMedia(const char* mediaPathName);
		int flags[11]={-1};
		t_ctx ctx;
	private:
		libvlc_instance_t* libVlcInstance;
		libvlc_media_t* libVlcMediaItem;
		libvlc_media_player_t* libVlcMediaPlayer;
		libvlc_event_manager_t* eventManager;
        static void callbacks(const libvlc_event_t* event, void* self);
		int repeat;

	//////////////////////////////////////////////////////////////////////////////////////
};
#endif