typedef int (*vlc_activate_t)(void *func, va_list args);
typedef void (*vlc_deactivate_t)(void *func, va_list args);

VLC_API module_t *vlc_module_load(vlc_object_t *obj, const char *cap, const char *name, bool strict, vlc_activate_t probe, ...) VLC_USED;
#define vlc_module_load(o, c, n, s, ...) \
    vlc_module_load(VLC_OBJECT(o), c, n, s, __VA_ARGS__)
VLC_API void vlc_module_unload(module_t *, vlc_deactivate_t deinit, ...);

VLC_API module_t *module_need(vlc_object_t *, const char *, const char *, bool) VLC_USED;
#define module_need(a, b, c, d) module_need(VLC_OBJECT(a), b, c, d)
VLC_API void module_unneed(vlc_object_t *, module_t *);
#define module_unneed(a, b) module_unneed(VLC_OBJECT(a), b)
VLC_API bool module_exists(const char *) VLC_USED;
VLC_API module_t *module_find(const char *) VLC_USED;

int module_start(vlc_object_t *, const module_t *);
#define module_start(o, m) module_start(VLC_OBJECT(o), m)
void module_stop(vlc_object_t *, const module_t *);
#define module_stop(o, m) module_stop(VLC_OBJECT(o), m)

VLC_API module_config_t *module_config_get(const module_t *, unsigned *) VLC_USED;
VLC_API void module_config_free(module_config_t *);

VLC_API void module_list_free(module_t **);
VLC_API module_t **module_list_get(size_t *n) VLC_USED;

VLC_API bool module_provides(const module_t *m, const char *cap);
VLC_API const char *module_get_object(const module_t *m) VLC_USED;
VLC_API const char *module_get_name(const module_t *m, bool long_name) VLC_USED;
#define module_GetLongName(m) module_get_name(m, true)
VLC_API const char *module_get_help(const module_t *m) VLC_USED;
VLC_API const char *module_get_capability(const module_t *m) VLC_USED;
VLC_API int module_get_score(const module_t *m) VLC_USED;
VLC_API const char *module_gettext(const module_t *, const char *) VLC_USED;

VLC_USED static inline module_t *module_get_main(void)
{
    return module_find("main");
}
#define module_get_main(a) module_get_main()

VLC_USED static inline bool module_is_main(const module_t *p_module)
{
    return !strcmp(module_get_object(p_module), "main");
}
