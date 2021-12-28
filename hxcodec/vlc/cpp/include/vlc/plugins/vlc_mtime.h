#ifndef __VLC_MTIME_H
#define __VLC_MTIME_H 1

#define LAST_MDATE ((mtime_t)((uint64_t)(-1) / 2))

#define MSTRTIME_MAX_SIZE 22

VLC_API char *mstrtime(char *psz_buffer, mtime_t date);
VLC_API char *secstotimestr(char *psz_buffer, int32_t secs);

struct date_t
{
    mtime_t date;
    uint32_t i_divider_num;
    uint32_t i_divider_den;
    uint32_t i_remainder;
};

VLC_API void date_Init(date_t *, uint32_t, uint32_t);
VLC_API void date_Change(date_t *, uint32_t, uint32_t);
VLC_API void date_Set(date_t *, mtime_t);
VLC_API mtime_t date_Get(const date_t *);
VLC_API void date_Move(date_t *, mtime_t);
VLC_API mtime_t date_Increment(date_t *, uint32_t);
VLC_API mtime_t date_Decrement(date_t *, uint32_t);
VLC_API uint64_t NTPtime64(void);
#endif
