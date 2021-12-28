#ifndef VLC_EPG_H
#define VLC_EPG_H 1

typedef struct
{
    int64_t i_start;
    int i_duration;

    char *psz_name;
    char *psz_short_description;
    char *psz_description;

    uint8_t i_rating;
} vlc_epg_event_t;

typedef struct
{
    char *psz_name;
    vlc_epg_event_t *p_current;

    int i_event;
    vlc_epg_event_t **pp_event;
} vlc_epg_t;

VLC_API void vlc_epg_Init(vlc_epg_t *p_epg, const char *psz_name);

VLC_API void vlc_epg_Clean(vlc_epg_t *p_epg);

VLC_API void vlc_epg_AddEvent(vlc_epg_t *p_epg, int64_t i_start, int i_duration, const char *psz_name, const char *psz_short_description, const char *psz_description, uint8_t i_rating);

VLC_API vlc_epg_t *vlc_epg_New(const char *psz_name) VLC_USED;

VLC_API void vlc_epg_Delete(vlc_epg_t *p_epg);

VLC_API void vlc_epg_SetCurrent(vlc_epg_t *p_epg, int64_t i_start);

VLC_API void vlc_epg_Merge(vlc_epg_t *p_dst, const vlc_epg_t *p_src);

#endif
