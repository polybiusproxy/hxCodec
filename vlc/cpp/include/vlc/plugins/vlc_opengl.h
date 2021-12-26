#ifndef VLC_GL_H
#define VLC_GL_H 1

struct vout_window_t;

typedef struct vlc_gl_t vlc_gl_t;

struct vlc_gl_t
{
    VLC_COMMON_MEMBERS

    struct vout_window_t *surface;
    module_t *module;
    void *sys;

    int (*makeCurrent)(vlc_gl_t *);
    void (*releaseCurrent)(vlc_gl_t *);
    void (*swap)(vlc_gl_t *);
    int (*lock)(vlc_gl_t *);
    void (*unlock)(vlc_gl_t *);
    void *(*getProcAddress)(vlc_gl_t *, const char *);
};

enum
{
    VLC_OPENGL,
    VLC_OPENGL_ES,
    VLC_OPENGL_ES2,
};

VLC_API vlc_gl_t *vlc_gl_Create(struct vout_window_t *, unsigned, const char *) VLC_USED;
VLC_API void vlc_gl_Destroy(vlc_gl_t *);

static inline int vlc_gl_MakeCurrent(vlc_gl_t *gl)
{
    return gl->makeCurrent(gl);
}

static inline void vlc_gl_ReleaseCurrent(vlc_gl_t *gl)
{
    gl->releaseCurrent(gl);
}

static inline int vlc_gl_Lock(vlc_gl_t *gl)
{
    return (gl->lock != NULL) ? gl->lock(gl) : VLC_SUCCESS;
}

static inline void vlc_gl_Unlock(vlc_gl_t *gl)
{
    if (gl->unlock != NULL)
        gl->unlock(gl);
}

static inline void vlc_gl_Swap(vlc_gl_t *gl)
{
    gl->swap(gl);
}

static inline void *vlc_gl_GetProcAddress(vlc_gl_t *gl, const char *name)
{
    return (gl->getProcAddress != NULL) ? gl->getProcAddress(gl, name) : NULL;
}

#endif
