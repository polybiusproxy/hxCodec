#ifndef VLC_DIALOG_H_
#define VLC_DIALOG_H_
#include <stdarg.h>

typedef struct dialog_fatal_t
{
        const char *title;
        const char *message;
} dialog_fatal_t;

VLC_API void dialog_VFatal(vlc_object_t *, bool, const char *, const char *, va_list);

static inline VLC_FORMAT(3, 4) void dialog_Fatal(vlc_object_t *obj, const char *title, const char *fmt, ...)
{
        va_list ap;

        va_start(ap, fmt);
        dialog_VFatal(obj, false, title, fmt, ap);
        va_end(ap);
}
#define dialog_Fatal(o, t, ...) \
        dialog_Fatal(VLC_OBJECT(o), t, __VA_ARGS__)

static inline VLC_FORMAT(3, 4) void dialog_FatalWait(vlc_object_t *obj, const char *title,
                                                     const char *fmt, ...)
{
        va_list ap;

        va_start(ap, fmt);
        dialog_VFatal(obj, true, title, fmt, ap);
        va_end(ap);
}
#define dialog_FatalWait(o, t, ...) \
        dialog_FatalWait(VLC_OBJECT(o), t, __VA_ARGS__)

typedef struct dialog_login_t
{
        const char *title;
        const char *message;
        char **username;
        char **password;
} dialog_login_t;

VLC_API void dialog_Login(vlc_object_t *, char **, char **, const char *, const char *, ...) VLC_FORMAT(5, 6);
#define dialog_Login(o, u, p, t, ...) \
        dialog_Login(VLC_OBJECT(o), u, p, t, __VA_ARGS__)

typedef struct dialog_question_t
{
        const char *title;
        const char *message;
        const char *yes;
        const char *no;
        const char *cancel;
        int answer;
} dialog_question_t;

VLC_API int dialog_Question(vlc_object_t *, const char *, const char *,
                            const char *, const char *, const char *, ...)
    VLC_FORMAT(3, 7);
#define dialog_Question(o, t, m, y, n, ...) \
        dialog_Question(VLC_OBJECT(o), t, m, y, n, __VA_ARGS__)

typedef struct dialog_progress_bar_t
{
        const char *title;
        const char *message;
        const char *cancel;

        void (*pf_update)(void *, const char *, float);
        bool (*pf_check)(void *);
        void (*pf_destroy)(void *);
        void *p_sys;
} dialog_progress_bar_t;

VLC_API dialog_progress_bar_t *dialog_ProgressCreate(vlc_object_t *, const char *, const char *, const char *) VLC_USED;
#define dialog_ProgressCreate(o, t, m, c) \
        dialog_ProgressCreate(VLC_OBJECT(o), t, m, c)
VLC_API void dialog_ProgressDestroy(dialog_progress_bar_t *);
VLC_API void dialog_ProgressSet(dialog_progress_bar_t *, const char *, float);
VLC_API bool dialog_ProgressCancelled(dialog_progress_bar_t *);

VLC_API int dialog_Register(vlc_object_t *);
VLC_API int dialog_Unregister(vlc_object_t *);
#define dialog_Register(o) dialog_Register(VLC_OBJECT(o))
#define dialog_Unregister(o) dialog_Unregister(VLC_OBJECT(o))

#endif
