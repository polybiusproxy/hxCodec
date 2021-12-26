#define OBJECT_FLAGS_QUIET 0x0002
#define OBJECT_FLAGS_NOINTERACT 0x0004

struct vlc_object_t
{
    VLC_COMMON_MEMBERS
};

VLC_API void *vlc_object_create(vlc_object_t *, size_t) VLC_MALLOC VLC_USED;
VLC_API vlc_object_t *vlc_object_find_name(vlc_object_t *, const char *) VLC_USED VLC_DEPRECATED;
VLC_API void *vlc_object_hold(vlc_object_t *);
VLC_API void vlc_object_release(vlc_object_t *);
VLC_API vlc_list_t *vlc_list_children(vlc_object_t *) VLC_USED;
VLC_API void vlc_list_release(vlc_list_t *);
VLC_API char *vlc_object_get_name(const vlc_object_t *) VLC_USED;
#define vlc_object_get_name(o) vlc_object_get_name(VLC_OBJECT(o))

#define vlc_object_create(a, b) vlc_object_create(VLC_OBJECT(a), b)

#define vlc_object_find_name(a, b) \
    vlc_object_find_name(VLC_OBJECT(a), b)

#define vlc_object_hold(a) \
    vlc_object_hold(VLC_OBJECT(a))

#define vlc_object_release(a) \
    vlc_object_release(VLC_OBJECT(a))

#define vlc_list_children(a) \
    vlc_list_children(VLC_OBJECT(a))

VLC_API VLC_USED VLC_DEPRECATED bool vlc_object_alive(vlc_object_t *);
#define vlc_object_alive(a) vlc_object_alive(VLC_OBJECT(a))
