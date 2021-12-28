#ifndef VLC_PLAYLIST_H_
#define VLC_PLAYLIST_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <vlc_input.h>
#include <vlc_events.h>

    TYPEDEF_ARRAY(playlist_item_t *, playlist_item_array_t)

    typedef struct playlist_export_t
    {
        VLC_COMMON_MEMBERS
        const char *psz_filename;
        FILE *p_file;
        playlist_item_t *p_root;
    } playlist_export_t;

    struct playlist_item_t
    {
        input_item_t *p_input;

        playlist_item_t **pp_children;
        playlist_item_t *p_parent;
        int i_children;

        int i_id;
        uint8_t i_flags;

        playlist_t *p_playlist;
    };

    typedef enum
    {
        PLAYLIST_SAVE_FLAG = 0x0001,
        PLAYLIST_SKIP_FLAG = 0x0002,
        PLAYLIST_DBL_FLAG = 0x0004,
        PLAYLIST_RO_FLAG = 0x0008,
        PLAYLIST_REMOVE_FLAG = 0x0010,
        PLAYLIST_EXPANDED_FLAG = 0x0020,
        PLAYLIST_SUBITEM_STOP_FLAG = 0x0040,
    } playlist_item_flags_e;

    typedef enum
    {
        PLAYLIST_STOPPED,
        PLAYLIST_RUNNING,
        PLAYLIST_PAUSED
    } playlist_status_t;

    struct playlist_t
    {
        VLC_COMMON_MEMBERS

        playlist_item_array_t items;
        playlist_item_array_t all_items;

        playlist_item_array_t current;
        int i_current_index;

        playlist_item_t *p_root;
        playlist_item_t *p_playing;
        playlist_item_t *p_media_library;

        playlist_item_t *p_root_category;
        playlist_item_t *p_root_onelevel;
        playlist_item_t *p_local_category;
        playlist_item_t *p_ml_category;
        playlist_item_t *p_local_onelevel;
        playlist_item_t *p_ml_onelevel;
    };

    struct playlist_add_t
    {
        int i_node;
        int i_item;
    };

#define VLC_DEFINE_SORT_FUNCTIONS \
    DEF(SORT_ID)                  \
    DEF(SORT_TITLE)               \
    DEF(SORT_TITLE_NODES_FIRST)   \
    DEF(SORT_ARTIST)              \
    DEF(SORT_GENRE)               \
    DEF(SORT_DURATION)            \
    DEF(SORT_TITLE_NUMERIC)       \
    DEF(SORT_ALBUM)               \
    DEF(SORT_TRACK_NUMBER)        \
    DEF(SORT_DESCRIPTION)         \
    DEF(SORT_RATING)              \
    DEF(SORT_URI)

#define DEF(s) s,
    enum
    {
        VLC_DEFINE_SORT_FUNCTIONS
            SORT_RANDOM,
        NUM_SORT_FNS = SORT_RANDOM
    };
#undef DEF
#ifndef VLC_INTERNAL_PLAYLIST_SORT_FUNCTIONS
#undef VLC_DEFINE_SORT_FUNCTIONS
#endif

    enum
    {
        ORDER_NORMAL = 0,
        ORDER_REVERSE = 1,
    };

#define PLAYLIST_INSERT 0x0001
#define PLAYLIST_APPEND 0x0002
#define PLAYLIST_GO 0x0004
#define PLAYLIST_PREPARSE 0x0008
#define PLAYLIST_SPREPARSE 0x0010
#define PLAYLIST_NO_REBUILD 0x0020

#define PLAYLIST_END -666

    enum pl_locked_state
    {
        pl_Locked = true,
        pl_Unlocked = false
    };

#define PL_LOCK playlist_Lock(p_playlist)
#define PL_UNLOCK playlist_Unlock(p_playlist)
#define PL_ASSERT_LOCKED playlist_AssertLocked(p_playlist)

    VLC_API playlist_t *pl_Get(vlc_object_t *);
#define pl_Get(a) pl_Get(VLC_OBJECT(a))

#define playlist_Play(p) playlist_Control(p, PLAYLIST_PLAY, pl_Unlocked)
#define playlist_Pause(p) playlist_Control(p, PLAYLIST_PAUSE, pl_Unlocked)
#define playlist_Stop(p) playlist_Control(p, PLAYLIST_STOP, pl_Unlocked)
#define playlist_Next(p) playlist_Control(p, PLAYLIST_SKIP, pl_Unlocked, 1)
#define playlist_Prev(p) playlist_Control(p, PLAYLIST_SKIP, pl_Unlocked, -1)
#define playlist_Skip(p, i) playlist_Control(p, PLAYLIST_SKIP, pl_Unlocked, (i))

    VLC_API void playlist_Lock(playlist_t *);
    VLC_API void playlist_Unlock(playlist_t *);
    VLC_API void playlist_AssertLocked(playlist_t *);
    VLC_API void playlist_Deactivate(playlist_t *);

    VLC_API int playlist_Control(playlist_t *p_playlist, int i_query, bool b_locked, ...);

    VLC_API input_thread_t *playlist_CurrentInput(playlist_t *p_playlist) VLC_USED;

    VLC_API mtime_t playlist_GetNodeDuration(playlist_item_t *);

    VLC_API void playlist_Clear(playlist_t *, bool);

    VLC_API int playlist_PreparseEnqueue(playlist_t *, input_item_t *);

    VLC_API int playlist_AskForArtEnqueue(playlist_t *, input_item_t *);

    VLC_API int playlist_TreeMove(playlist_t *, playlist_item_t *, playlist_item_t *, int);
    VLC_API int playlist_TreeMoveMany(playlist_t *, int, playlist_item_t **, playlist_item_t *, int);
    VLC_API int playlist_RecursiveNodeSort(playlist_t *, playlist_item_t *, int, int);

    VLC_API playlist_item_t *playlist_CurrentPlayingItem(playlist_t *) VLC_USED;
    VLC_API int playlist_Status(playlist_t *);

    VLC_API int playlist_Export(playlist_t *p_playlist, const char *psz_name, playlist_item_t *p_export_root, const char *psz_type);

    VLC_API int playlist_Import(playlist_t *p_playlist, const char *psz_file);

    VLC_API int playlist_ServicesDiscoveryAdd(playlist_t *, const char *);

    VLC_API int playlist_ServicesDiscoveryRemove(playlist_t *, const char *);

    VLC_API bool playlist_IsServicesDiscoveryLoaded(playlist_t *, const char *) VLC_DEPRECATED;

    VLC_API int playlist_ServicesDiscoveryControl(playlist_t *, const char *, int, ...);

    VLC_API int playlist_DeleteFromInput(playlist_t *, input_item_t *, bool);

    VLC_API int playlist_Add(playlist_t *, const char *, const char *, int, int, bool, bool);
    VLC_API int playlist_AddExt(playlist_t *, const char *, const char *, int, int, mtime_t, int, const char *const *, unsigned, bool, bool);
    VLC_API int playlist_AddInput(playlist_t *, input_item_t *, int, int, bool, bool);
    VLC_API playlist_item_t *playlist_NodeAddInput(playlist_t *, input_item_t *, playlist_item_t *, int, int, bool);
    VLC_API int playlist_NodeAddCopy(playlist_t *, playlist_item_t *, playlist_item_t *, int);

    VLC_API playlist_item_t *playlist_ItemGetById(playlist_t *, int) VLC_USED;
    VLC_API playlist_item_t *playlist_ItemGetByInput(playlist_t *, input_item_t *) VLC_USED;

    VLC_API int playlist_LiveSearchUpdate(playlist_t *, playlist_item_t *, const char *, bool);

    VLC_API playlist_item_t *playlist_NodeCreate(playlist_t *, const char *, playlist_item_t *p_parent, int i_pos, int i_flags, input_item_t *);
    VLC_API int playlist_NodeAppend(playlist_t *, playlist_item_t *, playlist_item_t *);
    VLC_API int playlist_NodeInsert(playlist_t *, playlist_item_t *, playlist_item_t *, int);
    VLC_API int playlist_NodeRemoveItem(playlist_t *, playlist_item_t *, playlist_item_t *);
    VLC_API playlist_item_t *playlist_ChildSearchName(playlist_item_t *, const char *) VLC_USED;
    VLC_API int playlist_NodeDelete(playlist_t *, playlist_item_t *, bool, bool);

    VLC_API playlist_item_t *playlist_GetNextLeaf(playlist_t *p_playlist, playlist_item_t *p_root, playlist_item_t *p_item, bool b_ena, bool b_unplayed) VLC_USED;
    VLC_API playlist_item_t *playlist_GetPrevLeaf(playlist_t *p_playlist, playlist_item_t *p_root, playlist_item_t *p_item, bool b_ena, bool b_unplayed) VLC_USED;

    VLC_API audio_output_t *playlist_GetAout(playlist_t *);

#define AOUT_VOLUME_DEFAULT 256
#define AOUT_VOLUME_MAX 512

    VLC_API float playlist_VolumeGet(playlist_t *);
    VLC_API int playlist_VolumeSet(playlist_t *, float);
    VLC_API int playlist_VolumeUp(playlist_t *, int, float *);
#define playlist_VolumeDown(a, b, c) playlist_VolumeUp(a, -(b), c)
    VLC_API int playlist_MuteSet(playlist_t *, bool);
    VLC_API int playlist_MuteGet(playlist_t *);

    static inline int playlist_MuteToggle(playlist_t *pl)
    {
        int val = playlist_MuteGet(pl);
        if (val >= 0)
            val = playlist_MuteSet(pl, !val);
        return val;
    }

    VLC_API void playlist_EnableAudioFilter(playlist_t *, const char *, bool);

#define pl_CurrentInput(a) __pl_CurrentInput(VLC_OBJECT(a))
    static inline input_thread_t *__pl_CurrentInput(vlc_object_t *p_this)
    {
        return playlist_CurrentInput(pl_Get(p_this));
    }

    static inline bool playlist_IsEmpty(playlist_t *p_playlist)
    {
        PL_ASSERT_LOCKED;
        return p_playlist->items.i_size == 0;
    }

    static inline int playlist_CurrentSize(playlist_t *p_playlist)
    {
        PL_ASSERT_LOCKED;
        return p_playlist->current.i_size;
    }

#ifdef __cplusplus
}
#endif

#endif
