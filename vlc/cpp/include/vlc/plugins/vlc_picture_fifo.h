#ifndef VLC_PICTURE_FIFO_H
#define VLC_PICTURE_FIFO_H 1

#include <vlc_picture.h>

typedef struct picture_fifo_t picture_fifo_t;

VLC_API picture_fifo_t *picture_fifo_New(void) VLC_USED;

VLC_API void picture_fifo_Delete(picture_fifo_t *);

VLC_API picture_t *picture_fifo_Pop(picture_fifo_t *) VLC_USED;

VLC_API picture_t *picture_fifo_Peek(picture_fifo_t *) VLC_USED;

VLC_API void picture_fifo_Push(picture_fifo_t *, picture_t *);

VLC_API void picture_fifo_Flush(picture_fifo_t *, mtime_t date, bool flush_before);

VLC_API void picture_fifo_OffsetDate(picture_fifo_t *, mtime_t delta);

#endif
