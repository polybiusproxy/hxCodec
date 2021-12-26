#ifndef VLC_INPUT_ITEM_H
#define VLC_INPUT_ITEM_H 1

#include <vlc_meta.h>
#include <vlc_epg.h>
#include <vlc_events.h>

#include <string.h>

struct info_t
{
    char *psz_name;
    char *psz_value;
};

struct info_category_t
{
    char *psz_name;
    int i_infos;
    struct info_t **pp_infos;
};

struct input_item_t
{
    int i_id;

    char *psz_name;
    char *psz_uri;

    int i_options;
    char **ppsz_options;
    uint8_t *optflagv;
    unsigned optflagc;

    mtime_t i_duration;

    int i_categories;
    info_category_t **pp_categories;

    int i_es;
    es_format_t **es;

    input_stats_t *p_stats;
    int i_nb_played;

    vlc_meta_t *p_meta;

    int i_epg;
    vlc_epg_t **pp_epg;

    vlc_event_manager_t event_manager;

    vlc_mutex_t lock;

    uint8_t i_type;
    bool b_fixed_name;
    bool b_error_when_reading;
};

enum input_item_type_e
{
    ITEM_TYPE_UNKNOWN,
    ITEM_TYPE_FILE,
    ITEM_TYPE_DIRECTORY,
    ITEM_TYPE_DISC,
    ITEM_TYPE_CDDA,
    ITEM_TYPE_CARD,
    ITEM_TYPE_NET,
    ITEM_TYPE_PLAYLIST,
    ITEM_TYPE_NODE,

    ITEM_TYPE_NUMBER
};

struct input_item_node_t
{
    input_item_t *p_item;
    int i_children;
    input_item_node_t **pp_children;
    input_item_node_t *p_parent;
};

VLC_API void input_item_CopyOptions(input_item_t *p_parent, input_item_t *p_child);
VLC_API void input_item_SetName(input_item_t *p_item, const char *psz_name);

VLC_API void input_item_PostSubItem(input_item_t *p_parent, input_item_t *p_child);

VLC_API input_item_node_t *input_item_node_Create(input_item_t *p_input) VLC_USED;

VLC_API input_item_node_t *input_item_node_AppendItem(input_item_node_t *p_node, input_item_t *p_item);

VLC_API void input_item_node_AppendNode(input_item_node_t *p_parent, input_item_node_t *p_child);

VLC_API void input_item_node_Delete(input_item_node_t *p_node);

VLC_API void input_item_node_PostAndDelete(input_item_node_t *p_node);

enum input_item_option_e
{

    VLC_INPUT_OPTION_TRUSTED = 0x2,

    VLC_INPUT_OPTION_UNIQUE = 0x100,
};

VLC_API int input_item_AddOption(input_item_t *, const char *, unsigned i_flags);

VLC_API bool input_item_HasErrorWhenReading(input_item_t *);
VLC_API void input_item_SetMeta(input_item_t *, vlc_meta_type_t meta_type, const char *psz_val);
VLC_API bool input_item_MetaMatch(input_item_t *p_i, vlc_meta_type_t meta_type, const char *psz);
VLC_API char *input_item_GetMeta(input_item_t *p_i, vlc_meta_type_t meta_type) VLC_USED;
VLC_API char *input_item_GetName(input_item_t *p_i) VLC_USED;
VLC_API char *input_item_GetTitleFbName(input_item_t *p_i) VLC_USED;
VLC_API char *input_item_GetURI(input_item_t *p_i) VLC_USED;
VLC_API void input_item_SetURI(input_item_t *p_i, const char *psz_uri);
VLC_API mtime_t input_item_GetDuration(input_item_t *p_i);
VLC_API void input_item_SetDuration(input_item_t *p_i, mtime_t i_duration);
VLC_API bool input_item_IsPreparsed(input_item_t *p_i);
VLC_API bool input_item_IsArtFetched(input_item_t *p_i);

#define INPUT_META(name)                                                            \
    static inline void input_item_Set##name(input_item_t *p_input, const char *val) \
    {                                                                               \
        input_item_SetMeta(p_input, vlc_meta_##name, val);                          \
    }                                                                               \
    static inline char *input_item_Get##name(input_item_t *p_input)                 \
    {                                                                               \
        return input_item_GetMeta(p_input, vlc_meta_##name);                        \
    }

INPUT_META(Title)
INPUT_META(Artist)
INPUT_META(Genre)
INPUT_META(Copyright)
INPUT_META(Album)
INPUT_META(TrackNumber)
INPUT_META(Description)
INPUT_META(Rating)
INPUT_META(Date)
INPUT_META(Setting)
INPUT_META(URL)
INPUT_META(Language)
INPUT_META(NowPlaying)
INPUT_META(Publisher)
INPUT_META(EncodedBy)
INPUT_META(ArtworkURL)
INPUT_META(TrackID)
INPUT_META(TrackTotal)

#define input_item_SetTrackNum input_item_SetTrackNumber
#define input_item_GetTrackNum input_item_GetTrackNumber
#define input_item_SetArtURL input_item_SetArtworkURL
#define input_item_GetArtURL input_item_GetArtworkURL

VLC_API char *input_item_GetInfo(input_item_t *p_i, const char *psz_cat, const char *psz_name) VLC_USED;
VLC_API int input_item_AddInfo(input_item_t *p_i, const char *psz_cat, const char *psz_name, const char *psz_format, ...) VLC_FORMAT(4, 5);
VLC_API int input_item_DelInfo(input_item_t *p_i, const char *psz_cat, const char *psz_name);
VLC_API void input_item_ReplaceInfos(input_item_t *, info_category_t *);
VLC_API void input_item_MergeInfos(input_item_t *, info_category_t *);

VLC_API input_item_t *input_item_NewWithType(const char *psz_uri, const char *psz_name, int i_options, const char *const *ppsz_options, unsigned i_option_flags, mtime_t i_duration, int i_type) VLC_USED;

VLC_API input_item_t *input_item_NewExt(const char *psz_uri, const char *psz_name, int i_options, const char *const *ppsz_options, unsigned i_option_flags, mtime_t i_duration) VLC_USED;

#define input_item_New(a, b) input_item_NewExt(a, b, 0, NULL, 0, -1)

VLC_API input_item_t *input_item_Copy(input_item_t *) VLC_USED;

VLC_API input_item_t *input_item_Hold(input_item_t *);

VLC_API void input_item_Release(input_item_t *);

#define vlc_gc_incref(i) input_item_Hold(i)
#define vlc_gc_decref(i) input_item_Release(i)

struct input_stats_t
{
    vlc_mutex_t lock;

    int64_t i_read_packets;
    int64_t i_read_bytes;
    float f_input_bitrate;
    float f_average_input_bitrate;

    int64_t i_demux_read_packets;
    int64_t i_demux_read_bytes;
    float f_demux_bitrate;
    float f_average_demux_bitrate;
    int64_t i_demux_corrupted;
    int64_t i_demux_discontinuity;

    int64_t i_decoded_audio;
    int64_t i_decoded_video;

    int64_t i_displayed_pictures;
    int64_t i_lost_pictures;

    int64_t i_sent_packets;
    int64_t i_sent_bytes;
    float f_send_bitrate;

    int64_t i_played_abuffers;
    int64_t i_lost_abuffers;
};

#endif
