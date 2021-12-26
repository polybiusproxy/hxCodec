#ifndef VLC_CONFIGURATION_H
#define VLC_CONFIGURATION_H 1

#include <sys/types.h>

#ifdef __cplusplus
extern "C"
{
#endif

    struct config_category_t
    {
        int i_id;
        const char *psz_name;
        const char *psz_help;
    };

    typedef union
    {
        char *psz;
        int64_t i;
        float f;
    } module_value_t;

    typedef int (*vlc_string_list_cb)(vlc_object_t *, const char *,
                                      char ***, char ***);
    typedef int (*vlc_integer_list_cb)(vlc_object_t *, const char *,
                                       int64_t **, char ***);

    struct module_config_t
    {
        uint8_t i_type;
        char i_short;
        unsigned b_advanced : 1;
        unsigned b_internal : 1;
        unsigned b_unsaveable : 1;
        unsigned b_safe : 1;
        unsigned b_removed : 1;

        char *psz_type;
        char *psz_name;
        char *psz_text;
        char *psz_longtext;

        module_value_t value;
        module_value_t orig;
        module_value_t min;
        module_value_t max;

        uint16_t list_count;
        union
        {
            char **psz;
            int *i;
            vlc_string_list_cb psz_cb;
            vlc_integer_list_cb i_cb;
        } list;
        char **list_text;
    };

    VLC_API int config_GetType(vlc_object_t *, const char *) VLC_USED;
    VLC_API int64_t config_GetInt(vlc_object_t *, const char *) VLC_USED;
    VLC_API void config_PutInt(vlc_object_t *, const char *, int64_t);
    VLC_API float config_GetFloat(vlc_object_t *, const char *) VLC_USED;
    VLC_API void config_PutFloat(vlc_object_t *, const char *, float);
    VLC_API char *config_GetPsz(vlc_object_t *, const char *) VLC_USED VLC_MALLOC;
    VLC_API void config_PutPsz(vlc_object_t *, const char *, const char *);
    VLC_API ssize_t config_GetIntChoices(vlc_object_t *, const char *,
                                         int64_t **, char ***) VLC_USED;
    VLC_API ssize_t config_GetPszChoices(vlc_object_t *, const char *,
                                         char ***, char ***) VLC_USED;

    VLC_API int config_SaveConfigFile(vlc_object_t *);
#define config_SaveConfigFile(a) config_SaveConfigFile(VLC_OBJECT(a))

    VLC_API void config_ResetAll(vlc_object_t *);
#define config_ResetAll(a) config_ResetAll(VLC_OBJECT(a))

    VLC_API module_config_t *config_FindConfig(vlc_object_t *, const char *) VLC_USED;
    VLC_API char *config_GetDataDir(void) VLC_USED VLC_MALLOC;
    VLC_API char *config_GetLibDir(void) VLC_USED;

    typedef enum vlc_userdir
    {
        VLC_HOME_DIR,
        VLC_CONFIG_DIR,
        VLC_DATA_DIR,
        VLC_CACHE_DIR,

        VLC_DESKTOP_DIR = 0x80,
        VLC_DOWNLOAD_DIR,
        VLC_TEMPLATES_DIR,
        VLC_PUBLICSHARE_DIR,
        VLC_DOCUMENTS_DIR,
        VLC_MUSIC_DIR,
        VLC_PICTURES_DIR,
        VLC_VIDEOS_DIR,
    } vlc_userdir_t;

    VLC_API char *config_GetUserDir(vlc_userdir_t) VLC_USED VLC_MALLOC;

    VLC_API void config_AddIntf(vlc_object_t *, const char *);
    VLC_API void config_RemoveIntf(vlc_object_t *, const char *);
    VLC_API bool config_ExistIntf(vlc_object_t *, const char *) VLC_USED;

#define config_GetType(a, b) config_GetType(VLC_OBJECT(a), b)
#define config_GetInt(a, b) config_GetInt(VLC_OBJECT(a), b)
#define config_PutInt(a, b, c) config_PutInt(VLC_OBJECT(a), b, c)
#define config_GetFloat(a, b) config_GetFloat(VLC_OBJECT(a), b)
#define config_PutFloat(a, b, c) config_PutFloat(VLC_OBJECT(a), b, c)
#define config_GetPsz(a, b) config_GetPsz(VLC_OBJECT(a), b)
#define config_PutPsz(a, b, c) config_PutPsz(VLC_OBJECT(a), b, c)

#define config_AddIntf(a, b) config_AddIntf(VLC_OBJECT(a), b)
#define config_RemoveIntf(a, b) config_RemoveIntf(VLC_OBJECT(a), b)
#define config_ExistIntf(a, b) config_ExistIntf(VLC_OBJECT(a), b)

    struct config_chain_t
    {
        config_chain_t *p_next;

        char *psz_name;
        char *psz_value;
    };

    VLC_API void config_ChainParse(vlc_object_t *, const char *psz_prefix, const char *const *ppsz_options, config_chain_t *);
#define config_ChainParse(a, b, c, d) config_ChainParse(VLC_OBJECT(a), b, c, d)

    VLC_API const char *config_ChainParseOptions(config_chain_t **pp_cfg, const char *ppsz_opts);

    VLC_API char *config_ChainCreate(char **ppsz_name, config_chain_t **pp_cfg, const char *psz_string) VLC_USED VLC_MALLOC;

    VLC_API void config_ChainDestroy(config_chain_t *);

    VLC_API config_chain_t *config_ChainDuplicate(const config_chain_t *) VLC_USED VLC_MALLOC;

    VLC_API char *config_StringUnescape(char *psz_string);

    VLC_API char *config_StringEscape(const char *psz_string) VLC_USED VLC_MALLOC;

#ifdef __cplusplus
}
#endif

#endif
