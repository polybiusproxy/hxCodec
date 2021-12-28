#ifndef VLC_VOUT_WINDOW_H
#define VLC_VOUT_WINDOW_H 1

#include <vlc_common.h>

typedef struct vout_window_t vout_window_t;
typedef struct vout_window_sys_t vout_window_sys_t;

enum
{
    VOUT_WINDOW_TYPE_INVALID = 0,
    VOUT_WINDOW_TYPE_XID,
    VOUT_WINDOW_TYPE_HWND,
    VOUT_WINDOW_TYPE_NSOBJECT,
};

enum
{
    VOUT_WINDOW_SET_STATE,
    VOUT_WINDOW_SET_SIZE,
    VOUT_WINDOW_SET_FULLSCREEN,
};

typedef struct
{

    bool is_standalone;

    unsigned type;

    int x;
    int y;

    unsigned width;
    unsigned height;

} vout_window_cfg_t;

struct vout_window_t
{
    VLC_COMMON_MEMBERS

    union
    {
        void *hwnd;
        uint32_t xid;
        void *nsobject;
    } handle;

    union
    {
        char *x11;
    } display;

    int (*control)(vout_window_t *, int query, va_list);

    vout_window_sys_t *sys;
};

VLC_API vout_window_t *vout_window_New(vlc_object_t *, const char *module, const vout_window_cfg_t *);

VLC_API void vout_window_Delete(vout_window_t *);

VLC_API int vout_window_Control(vout_window_t *, int query, ...);

static inline int vout_window_SetState(vout_window_t *window, unsigned state)
{
    return vout_window_Control(window, VOUT_WINDOW_SET_STATE, state);
}

static inline int vout_window_SetSize(vout_window_t *window,
                                      unsigned width, unsigned height)
{
    return vout_window_Control(window, VOUT_WINDOW_SET_SIZE, width, height);
}

static inline int vout_window_SetFullScreen(vout_window_t *window, bool full)
{
    return vout_window_Control(window, VOUT_WINDOW_SET_FULLSCREEN, full);
}

#endif
