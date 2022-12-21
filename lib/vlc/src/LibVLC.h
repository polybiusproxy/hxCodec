#include "vlc/vlc.h"
#include "stdint.h"

typedef struct ctx
{
	unsigned char *pixeldata;
} t_ctx;

class LibVLC
{
	public:
		LibVLC();
		~LibVLC();
		static LibVLC* create();
		void play();
		void play(const char *path, bool loop, bool haccelerated);
		void stop();
		void pause();
		void resume();
		void togglePause();
		float getLength();
		float getDuration();
		float getFPS();
		int getWidth();
		int getHeight();
		bool isMediaPlayerAlive();
		bool isMediaItemAlive();
		bool isPlaying();
		bool isSeekable();
		const char *getLastError();
		void setVolume(float volume);
		float getVolume();
		void setTime(int time);
		int getTime();
		void setPosition(float pos);
		float getPosition();
		uint8_t* getPixelData();
		void setupEvents();
		void cleanupEvents();
		int flags[11] = { -1 };
	private:
		t_ctx ctx;
		libvlc_instance_t *libVlcInstance = nullptr;
		libvlc_media_t *libVlcMediaItem = nullptr;
		libvlc_media_player_t *libVlcMediaPlayer = nullptr;
		libvlc_event_manager_t *libVlcEventManager = nullptr;
		static void callbacks(const libvlc_event_t *event, void *self);
};
