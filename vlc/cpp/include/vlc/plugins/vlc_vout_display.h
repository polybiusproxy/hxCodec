#ifndef VLC_VOUT_DISPLAY_H
#define VLC_VOUT_DISPLAY_H 1

#include <vlc_es.h>
#include <vlc_picture.h>
#include <vlc_picture_pool.h>
#include <vlc_subpicture.h>
#include <vlc_keys.h>
#include <vlc_mouse.h>
#include <vlc_vout_window.h>

typedef struct vout_display_t vout_display_t;
typedef struct vout_display_sys_t vout_display_sys_t;
typedef struct vout_display_owner_t vout_display_owner_t;
typedef struct vout_display_owner_sys_t vout_display_owner_sys_t;

typedef enum
{
    VOUT_DISPLAY_ALIGN_CENTER,

    VOUT_DISPLAY_ALIGN_LEFT,
    VOUT_DISPLAY_ALIGN_RIGHT,

    VOUT_DISPLAY_ALIGN_TOP,
    VOUT_DISPLAY_ALIGN_BOTTOM,
} vout_display_align_t;

enum
{
    VOUT_WINDOW_STATE_NORMAL = 0,
    VOUT_WINDOW_STATE_ABOVE = 1,
    VOUT_WINDOW_STATE_BELOW = 2,
    VOUT_WINDOW_STACK_MASK = 3,
};

typedef struct
{
    bool is_fullscreen;

    struct
    {

        const char *title;

        unsigned width;
        unsigned height;

        struct
        {
            unsigned num;
            unsigned den;
        } sar;
    } display;

    struct
    {
        int horizontal;
        int vertical;
    } align;

    bool is_display_filled;

    struct
    {
        int num;
        int den;
    } zoom;

} vout_display_cfg_t;

typedef struct
{
    bool is_slow;
    bool has_double_click;
    bool has_hide_mouse;
    bool has_pictures_invalid;
    bool has_event_thread;
    const vlc_fourcc_t *subpicture_chromas;
} vout_display_info_t;

enum
{

    VOUT_DISPLAY_HIDE_MOUSE,

    VOUT_DISPLAY_RESET_PICTURES,

    VOUT_DISPLAY_CHANGE_FULLSCREEN,

    VOUT_DISPLAY_CHANGE_WINDOW_STATE,

    VOUT_DISPLAY_CHANGE_DISPLAY_SIZE,

    VOUT_DISPLAY_CHANGE_DISPLAY_FILLED,

    VOUT_DISPLAY_CHANGE_ZOOM,

    VOUT_DISPLAY_CHANGE_SOURCE_ASPECT,

    VOUT_DISPLAY_CHANGE_SOURCE_CROP,

    VOUT_DISPLAY_GET_OPENGL,
};

enum
{

    VOUT_DISPLAY_EVENT_PICTURES_INVALID,

    VOUT_DISPLAY_EVENT_FULLSCREEN,
    VOUT_DISPLAY_EVENT_WINDOW_STATE,

    VOUT_DISPLAY_EVENT_DISPLAY_SIZE,

    VOUT_DISPLAY_EVENT_CLOSE,
    VOUT_DISPLAY_EVENT_KEY,

    VOUT_DISPLAY_EVENT_MOUSE_STATE,

    VOUT_DISPLAY_EVENT_MOUSE_MOVED,
    VOUT_DISPLAY_EVENT_MOUSE_PRESSED,
    VOUT_DISPLAY_EVENT_MOUSE_RELEASED,
    VOUT_DISPLAY_EVENT_MOUSE_DOUBLE_CLICK,
};

struct vout_display_owner_t
{

    vout_display_owner_sys_t *sys;

    void (*event)(vout_display_t *, int, va_list);

    vout_window_t *(*window_new)(vout_display_t *, const vout_window_cfg_t *);
    void (*window_del)(vout_display_t *, vout_window_t *);
};

struct vout_display_t
{
    VLC_COMMON_MEMBERS

    module_t *module;

    const vout_display_cfg_t *cfg;

    video_format_t source;

    video_format_t fmt;

    vout_display_info_t info;

    picture_pool_t *(*pool)(vout_display_t *, unsigned count);

    void (*prepare)(vout_display_t *, picture_t *, subpicture_t *);

    void (*display)(vout_display_t *, picture_t *, subpicture_t *);

    int (*control)(vout_display_t *, int, va_list);

    void (*manage)(vout_display_t *);

    vout_display_sys_t *sys;

    vout_display_owner_t owner;
};

static inline void vout_display_SendEvent(vout_display_t *vd, int query, ...)
{
    va_list args;
    va_start(args, query);
    vd->owner.event(vd, query, args);
    va_end(args);
}

static inline void vout_display_SendEventDisplaySize(vout_display_t *vd, int width, int height, bool is_fullscreen)
{
    vout_display_SendEvent(vd, VOUT_DISPLAY_EVENT_DISPLAY_SIZE, width, height, is_fullscreen);
}
static inline void vout_display_SendEventPicturesInvalid(vout_display_t *vd)
{
    vout_display_SendEvent(vd, VOUT_DISPLAY_EVENT_PICTURES_INVALID);
}
static inline void vout_display_SendEventClose(vout_display_t *vd)
{
    vout_display_SendEvent(vd, VOUT_DISPLAY_EVENT_CLOSE);
}
static inline void vout_display_SendEventKey(vout_display_t *vd, int key)
{
    vout_display_SendEvent(vd, VOUT_DISPLAY_EVENT_KEY, key);
}
static inline void vout_display_SendEventFullscreen(vout_display_t *vd, bool is_fullscreen)
{
    vout_display_SendEvent(vd, VOUT_DISPLAY_EVENT_FULLSCREEN, is_fullscreen);
}
static inline void vout_display_SendWindowState(vout_display_t *vd, unsigned state)
{
    vout_display_SendEvent(vd, VOUT_DISPLAY_EVENT_WINDOW_STATE, state);
}

static inline void vout_display_SendEventMouseState(vout_display_t *vd, int x, int y, int button_mask)
{
    vout_display_SendEvent(vd, VOUT_DISPLAY_EVENT_MOUSE_STATE, x, y, button_mask);
}
static inline void vout_display_SendEventMouseMoved(vout_display_t *vd, int x, int y)
{
    vout_display_SendEvent(vd, VOUT_DISPLAY_EVENT_MOUSE_MOVED, x, y);
}
static inline void vout_display_SendEventMousePressed(vout_display_t *vd, int button)
{
    vout_display_SendEvent(vd, VOUT_DISPLAY_EVENT_MOUSE_PRESSED, button);
}
static inline void vout_display_SendEventMouseReleased(vout_display_t *vd, int button)
{
    vout_display_SendEvent(vd, VOUT_DISPLAY_EVENT_MOUSE_RELEASED, button);
}
static inline void vout_display_SendEventMouseDoubleClick(vout_display_t *vd)
{
    vout_display_SendEvent(vd, VOUT_DISPLAY_EVENT_MOUSE_DOUBLE_CLICK);
}

static inline vout_window_t *vout_display_NewWindow(vout_display_t *vd, const vout_window_cfg_t *cfg)
{
    return vd->owner.window_new(vd, cfg);
}

static inline void vout_display_DeleteWindow(vout_display_t *vd,
                                             vout_window_t *window)
{
    vd->owner.window_del(vd, window);
}

VLC_API void vout_display_GetDefaultDisplaySize(unsigned *width, unsigned *height, const video_format_t *source, const vout_display_cfg_t *);

typedef struct
{
    int x;
    int y;
    unsigned width;
    unsigned height;
} vout_display_place_t;

VLC_API void vout_display_PlacePicture(vout_display_place_t *place, const video_format_t *source, const vout_display_cfg_t *cfg, bool do_clipping);

#endif
