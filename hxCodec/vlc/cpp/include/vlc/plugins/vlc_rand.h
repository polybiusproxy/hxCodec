#ifndef VLC_RAND_H
#define VLC_RAND_H

VLC_API void vlc_rand_bytes(void *buf, size_t len);

VLC_API double vlc_drand48(void) VLC_USED;
VLC_API long vlc_lrand48(void) VLC_USED;
VLC_API long vlc_mrand48(void) VLC_USED;

#endif
