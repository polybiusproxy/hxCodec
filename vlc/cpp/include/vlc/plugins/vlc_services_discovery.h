#ifndef VLC_SERVICES_DISCOVERY_H_
#define VLC_SERVICES_DISCOVERY_H_

#include <vlc_input.h>
#include <vlc_events.h>
#include <vlc_probe.h>

#ifdef __cplusplus
extern "C"
{
#endif

    struct services_discovery_t
    {
        VLC_COMMON_MEMBERS
        module_t *p_module;

        vlc_event_manager_t event_manager;

        char *psz_name;
        config_chain_t *p_cfg;

        int (*pf_control)(services_discovery_t *, int, va_list);

        services_discovery_sys_t *p_sys;
    };

    enum services_discovery_category_e
    {
        SD_CAT_DEVICES = 1,
        SD_CAT_LAN,
        SD_CAT_INTERNET,
        SD_CAT_MYCOMPUTER
    };

    enum services_discovery_command_e
    {
        SD_CMD_SEARCH = 1,
        SD_CMD_DESCRIPTOR
    };

    enum services_discovery_capability_e
    {
        SD_CAP_SEARCH = 1
    };

    typedef struct
    {
        char *psz_short_desc;
        char *psz_icon_url;
        char *psz_url;
        int i_capabilities;
    } services_discovery_descriptor_t;

    static inline int vlc_sd_control(services_discovery_t *p_sd, int i_control, va_list args)
    {
        if (p_sd->pf_control)
            return p_sd->pf_control(p_sd, i_control, args);
        else
            return VLC_EGENERIC;
    }

    VLC_API char **vlc_sd_GetNames(vlc_object_t *, char ***, int **) VLC_USED;
#define vlc_sd_GetNames(obj, pln, pcat) \
    vlc_sd_GetNames(VLC_OBJECT(obj), pln, pcat)

    VLC_API services_discovery_t *vlc_sd_Create(vlc_object_t *, const char *) VLC_USED;
    VLC_API bool vlc_sd_Start(services_discovery_t *);
    VLC_API void vlc_sd_Stop(services_discovery_t *);
    VLC_API void vlc_sd_Destroy(services_discovery_t *);

    static inline void vlc_sd_StopAndDestroy(services_discovery_t *p_this)
    {
        vlc_sd_Stop(p_this);
        vlc_sd_Destroy(p_this);
    }

    VLC_API char *services_discovery_GetLocalizedName(services_discovery_t *p_this) VLC_USED;

    VLC_API vlc_event_manager_t *services_discovery_EventManager(services_discovery_t *p_this) VLC_USED;

    VLC_API void services_discovery_AddItem(services_discovery_t *p_this, input_item_t *p_item, const char *psz_category);
    VLC_API void services_discovery_RemoveItem(services_discovery_t *p_this, input_item_t *p_item);
    VLC_API void services_discovery_RemoveAll(services_discovery_t *p_sd);

    VLC_API int vlc_sd_probe_Add(vlc_probe_t *, const char *, const char *, int category);

#define VLC_SD_PROBE_SUBMODULE                \
    add_submodule()                           \
        set_capability("services probe", 100) \
            set_callbacks(vlc_sd_probe_Open, NULL)

#define VLC_SD_PROBE_HELPER(name, longname, cat)                    \
    static int vlc_sd_probe_Open(vlc_object_t *obj)                 \
    {                                                               \
        return vlc_sd_probe_Add((struct vlc_probe_t *)obj,          \
                                name "{longname=\"" longname "\"}", \
                                longname, cat);                     \
    }

#ifdef __cplusplus
}
#endif

#endif
