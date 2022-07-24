#include "vlc/vlc.h"
#include "stdint.h"

struct libvlc_instance_t;
struct libvlc_media_t;
struct libvlc_media_player_t;

typedef struct ctx
{
	unsigned char *pixeldata;
}

t_ctx;

class LibVLC
{
	public:
		LibVLC();
		~LibVLC();
		static LibVLC* create();
		void playFile(const char *path, bool loop, bool haccelerated);
		void play();
		void stop();
		void pause();
		void resume();
		void togglePause();
		float getLength();
		float getDuration();
		float getFPS();
		int getWidth();
		int getHeight();
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
		int flags[12] = { -1 };
		t_ctx ctx;
	private:
		libvlc_instance_t *libVlcInstance = nullptr;
		libvlc_media_t *libVlcMediaItem = nullptr;
		libvlc_media_player_t *libVlcMediaPlayer = nullptr;
		libvlc_event_manager_t *eventManager = nullptr;
		static void callbacks(const libvlc_event_t *event, void *self);
};
