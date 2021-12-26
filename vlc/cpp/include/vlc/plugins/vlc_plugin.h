#ifndef LIBVLC_MODULES_MACROS_H
#define LIBVLC_MODULES_MACROS_H 1

enum vlc_module_properties
{
    VLC_MODULE_CREATE,
    VLC_CONFIG_CREATE,

    VLC_MODULE_CPU_REQUIREMENT = 0x100,
    VLC_MODULE_SHORTCUT,
    VLC_MODULE_CAPABILITY,
    VLC_MODULE_SCORE,
    VLC_MODULE_CB_OPEN,
    VLC_MODULE_CB_CLOSE,
    VLC_MODULE_NO_UNLOAD,
    VLC_MODULE_NAME,
    VLC_MODULE_SHORTNAME,
    VLC_MODULE_DESCRIPTION,
    VLC_MODULE_HELP,
    VLC_MODULE_TEXTDOMAIN,

    VLC_CONFIG_NAME = 0x1000,

    VLC_CONFIG_VALUE,

    VLC_CONFIG_RANGE,

    VLC_CONFIG_ADVANCED,

    VLC_CONFIG_VOLATILE,

    VLC_CONFIG_PERSISTENT_OBSOLETE,

    VLC_CONFIG_PRIVATE,

    VLC_CONFIG_REMOVED,

    VLC_CONFIG_CAPABILITY,

    VLC_CONFIG_SHORTCUT,

    VLC_CONFIG_OLDNAME_OBSOLETE,

    VLC_CONFIG_SAFE,

    VLC_CONFIG_DESC,

    VLC_CONFIG_LIST_OBSOLETE,

    VLC_CONFIG_ADD_ACTION_OBSOLETE,

    VLC_CONFIG_LIST,

    VLC_CONFIG_LIST_CB,

};

#define CONFIG_HINT_CATEGORY 0x02
#define CONFIG_HINT_SUBCATEGORY 0x03
#define CONFIG_HINT_SUBCATEGORY_END 0x04
#define CONFIG_HINT_USAGE 0x05

#define CONFIG_CATEGORY 0x06
#define CONFIG_SUBCATEGORY 0x07
#define CONFIG_SECTION 0x08

#define CONFIG_ITEM_FLOAT 0x20
#define CONFIG_ITEM_INTEGER 0x40
#define CONFIG_ITEM_RGB 0x41
#define CONFIG_ITEM_BOOL 0x60
#define CONFIG_ITEM_STRING 0x80
#define CONFIG_ITEM_PASSWORD 0x81
#define CONFIG_ITEM_KEY 0x82
#define CONFIG_ITEM_MODULE 0x84
#define CONFIG_ITEM_MODULE_CAT 0x85
#define CONFIG_ITEM_MODULE_LIST 0x86
#define CONFIG_ITEM_MODULE_LIST_CAT 0x87
#define CONFIG_ITEM_LOADFILE 0x8C
#define CONFIG_ITEM_SAVEFILE 0x8D
#define CONFIG_ITEM_DIRECTORY 0x8E
#define CONFIG_ITEM_FONT 0x8F

#define CONFIG_ITEM(x) (((x) & ~0xF) != 0)

#define CAT_INTERFACE 1
#define SUBCAT_INTERFACE_GENERAL 101
#define SUBCAT_INTERFACE_MAIN 102
#define SUBCAT_INTERFACE_CONTROL 103
#define SUBCAT_INTERFACE_HOTKEYS 104

#define CAT_AUDIO 2
#define SUBCAT_AUDIO_GENERAL 201
#define SUBCAT_AUDIO_AOUT 202
#define SUBCAT_AUDIO_AFILTER 203
#define SUBCAT_AUDIO_VISUAL 204
#define SUBCAT_AUDIO_MISC 205

#define CAT_VIDEO 3
#define SUBCAT_VIDEO_GENERAL 301
#define SUBCAT_VIDEO_VOUT 302
#define SUBCAT_VIDEO_VFILTER 303
#define SUBCAT_VIDEO_SUBPIC 305

#define CAT_INPUT 4
#define SUBCAT_INPUT_GENERAL 401
#define SUBCAT_INPUT_ACCESS 402
#define SUBCAT_INPUT_DEMUX 403
#define SUBCAT_INPUT_VCODEC 404
#define SUBCAT_INPUT_ACODEC 405
#define SUBCAT_INPUT_SCODEC 406
#define SUBCAT_INPUT_STREAM_FILTER 407

#define CAT_SOUT 5
#define SUBCAT_SOUT_GENERAL 501
#define SUBCAT_SOUT_STREAM 502
#define SUBCAT_SOUT_MUX 503
#define SUBCAT_SOUT_ACO 504
#define SUBCAT_SOUT_PACKETIZER 505
#define SUBCAT_SOUT_VOD 507

#define CAT_ADVANCED 6
#define SUBCAT_ADVANCED_MISC 602
#define SUBCAT_ADVANCED_NETWORK 603

#define CAT_PLAYLIST 7
#define SUBCAT_PLAYLIST_GENERAL 701
#define SUBCAT_PLAYLIST_SD 702
#define SUBCAT_PLAYLIST_EXPORT 703

#define MODULE_SYMBOL 2_1_0a
#define MODULE_SUFFIX "__2_1_0a"

#define CONCATENATE(y, z) CRUDE_HACK(y, z)
#define CRUDE_HACK(y, z) y##__##z

#ifdef __PLUGIN__
#define __VLC_SYMBOL(symbol) CONCATENATE(symbol, MODULE_SYMBOL)
#else
#define __VLC_SYMBOL(symbol) CONCATENATE(symbol, MODULE_NAME)
#endif

#define CDECL_SYMBOL
#if defined(__PLUGIN__)
#if defined(_WIN32)
#define DLL_SYMBOL __declspec(dllexport)
#undef CDECL_SYMBOL
#define CDECL_SYMBOL __cdecl
#elif VLC_GCC_VERSION(4, 0)
#define DLL_SYMBOL __attribute__((visibility("default")))
#else
#define DLL_SYMBOL
#endif
#else
#define DLL_SYMBOL
#endif

#if defined(__cplusplus)
#define EXTERN_SYMBOL extern "C"
#else
#define EXTERN_SYMBOL
#endif

typedef int (*vlc_set_cb)(void *, void *, int, ...);

#define vlc_plugin_set(...) vlc_set(opaque, NULL, __VA_ARGS__)
#define vlc_module_set(...) vlc_set(opaque, module, __VA_ARGS__)
#define vlc_config_set(...) vlc_set(opaque, config, __VA_ARGS__)

#define vlc_module_begin()                                                                              \
    EXTERN_SYMBOL DLL_SYMBOL int CDECL_SYMBOL __VLC_SYMBOL(vlc_entry)(vlc_set_cb, void *);              \
    EXTERN_SYMBOL DLL_SYMBOL int CDECL_SYMBOL __VLC_SYMBOL(vlc_entry)(vlc_set_cb vlc_set, void *opaque) \
    {                                                                                                   \
        module_t *module;                                                                               \
        module_config_t *config = NULL;                                                                 \
        if (vlc_plugin_set(VLC_MODULE_CREATE, &module))                                                 \
            goto error;                                                                                 \
        if (vlc_module_set(VLC_MODULE_NAME, (MODULE_STRING)))                                           \
            goto error;

#define vlc_module_end() \
    (void)config;        \
    return 0;            \
    error:               \
    return -1;           \
    }                    \
    VLC_METADATA_EXPORTS

#define add_submodule()                             \
    if (vlc_plugin_set(VLC_MODULE_CREATE, &module)) \
        goto error;

#define add_shortcut(...)                                                        \
    {                                                                            \
        const char *shortcuts[] = {__VA_ARGS__};                                 \
        if (vlc_module_set(VLC_MODULE_SHORTCUT,                                  \
                           sizeof(shortcuts) / sizeof(shortcuts[0]), shortcuts)) \
            goto error;                                                          \
    }

#define set_shortname(shortname)                                         \
    if (vlc_module_set(VLC_MODULE_SHORTNAME, (const char *)(shortname))) \
        goto error;

#define set_description(desc)                                         \
    if (vlc_module_set(VLC_MODULE_DESCRIPTION, (const char *)(desc))) \
        goto error;

#define set_help(help)                                         \
    if (vlc_module_set(VLC_MODULE_HELP, (const char *)(help))) \
        goto error;

#define set_capability(cap, score)                                                                                    \
    if (vlc_module_set(VLC_MODULE_CAPABILITY, (const char *)(cap)) || vlc_module_set(VLC_MODULE_SCORE, (int)(score))) \
        goto error;

#define set_callbacks(activate, deactivate)                                                              \
    if (vlc_module_set(VLC_MODULE_CB_OPEN, activate) || vlc_module_set(VLC_MODULE_CB_CLOSE, deactivate)) \
        goto error;

#define cannot_unload_broken_library()        \
    if (vlc_module_set(VLC_MODULE_NO_UNLOAD)) \
        goto error;

#define set_text_domain(dom)                          \
    if (vlc_plugin_set(VLC_MODULE_TEXTDOMAIN, (dom))) \
        goto error;

#define add_type_inner(type) \
    vlc_plugin_set(VLC_CONFIG_CREATE, (type), &config);

#define add_typedesc_inner(type, text, longtext) \
    add_type_inner(type)                         \
        vlc_config_set(VLC_CONFIG_DESC,          \
                       (const char *)(text), (const char *)(longtext));

#define add_typeadv_inner(type, text, longtext, advc) \
    add_typedesc_inner(type, text, longtext) if (advc) vlc_config_set(VLC_CONFIG_ADVANCED);

#define add_typename_inner(type, name, text, longtext, advc) \
    add_typeadv_inner(type, text, longtext, advc)            \
        vlc_config_set(VLC_CONFIG_NAME, (const char *)(name));

#define add_string_inner(type, name, text, longtext, advc, v) \
    add_typename_inner(type, name, text, longtext, advc)      \
        vlc_config_set(VLC_CONFIG_VALUE, (const char *)(v));

#define add_int_inner(type, name, text, longtext, advc, v) \
    add_typename_inner(type, name, text, longtext, advc)   \
        vlc_config_set(VLC_CONFIG_VALUE, (int64_t)(v));

#define set_category(i_id)          \
    add_type_inner(CONFIG_CATEGORY) \
        vlc_config_set(VLC_CONFIG_VALUE, (int64_t)(i_id));

#define set_subcategory(i_id)          \
    add_type_inner(CONFIG_SUBCATEGORY) \
        vlc_config_set(VLC_CONFIG_VALUE, (int64_t)(i_id));

#define set_section(text, longtext) \
    add_typedesc_inner(CONFIG_SECTION, text, longtext)

#define add_category_hint(text, longtext, advc) \
    add_typeadv_inner(CONFIG_HINT_CATEGORY, text, longtext, advc)

#define add_subcategory_hint(text, longtext) \
    add_typedesc_inner(CONFIG_HINT_SUBCATEGORY, text, longtext)

#define end_subcategory_hint \
    add_type_inner(CONFIG_HINT_SUBCATEGORY_END)

#define add_usage_hint(text) \
    add_typedesc_inner(CONFIG_HINT_USAGE, text, NULL)

#define add_string(name, value, text, longtext, advc)                \
    add_string_inner(CONFIG_ITEM_STRING, name, text, longtext, advc, \
                     value)

#define add_password(name, value, text, longtext, advc)                \
    add_string_inner(CONFIG_ITEM_PASSWORD, name, text, longtext, advc, \
                     value)

#define add_loadfile(name, value, text, longtext, advc)                \
    add_string_inner(CONFIG_ITEM_LOADFILE, name, text, longtext, advc, \
                     value)

#define add_savefile(name, value, text, longtext, advc)                \
    add_string_inner(CONFIG_ITEM_SAVEFILE, name, text, longtext, advc, \
                     value)

#define add_directory(name, value, text, longtext, advc)                \
    add_string_inner(CONFIG_ITEM_DIRECTORY, name, text, longtext, advc, \
                     value)

#define add_font(name, value, text, longtext, advc)                \
    add_string_inner(CONFIG_ITEM_FONT, name, text, longtext, advc, \
                     value)

#define add_module(name, psz_caps, value, text, longtext, advc)      \
    add_string_inner(CONFIG_ITEM_MODULE, name, text, longtext, advc, \
                     value)                                          \
        vlc_config_set(VLC_CONFIG_CAPABILITY, (const char *)(psz_caps));

#define add_module_list(name, psz_caps, value, text, longtext, advc)      \
    add_string_inner(CONFIG_ITEM_MODULE_LIST, name, text, longtext, advc, \
                     value)                                               \
        vlc_config_set(VLC_CONFIG_CAPABILITY, (const char *)(psz_caps));

#ifndef __PLUGIN__
#define add_module_cat(name, i_subcategory, value, text, longtext, advc) \
    add_string_inner(CONFIG_ITEM_MODULE_CAT, name, text, longtext, advc, \
                     value)                                              \
        change_integer_range(i_subcategory, 0);

#define add_module_list_cat(name, i_subcategory, value, text, longtext, advc) \
    add_string_inner(CONFIG_ITEM_MODULE_LIST_CAT, name, text, longtext,       \
                     advc, value)                                             \
        change_integer_range(i_subcategory, 0);
#endif

#define add_integer(name, value, text, longtext, advc) \
    add_int_inner(CONFIG_ITEM_INTEGER, name, text, longtext, advc, value)

#define add_rgb(name, value, text, longtext, advc)                    \
    add_int_inner(CONFIG_ITEM_RGB, name, text, longtext, advc, value) \
        change_integer_range(0, 0xFFFFFF)

#define add_key(name, value, text, longtext, advc)                          \
    add_string_inner(CONFIG_ITEM_KEY, "global-" name, text, longtext, advc, \
                     KEY_UNSET)                                             \
        add_string_inner(CONFIG_ITEM_KEY, name, text, longtext, advc, value)

#define add_integer_with_range(name, value, i_min, i_max, text, longtext, advc) \
    add_integer(name, value, text, longtext, advc)                              \
        change_integer_range(i_min, i_max)

#define add_float(name, v, text, longtext, advc)                      \
    add_typename_inner(CONFIG_ITEM_FLOAT, name, text, longtext, advc) \
        vlc_config_set(VLC_CONFIG_VALUE, (double)(v));

#define add_float_with_range(name, value, f_min, f_max, text, longtext, advc) \
    add_float(name, value, text, longtext, advc)                              \
        change_float_range(f_min, f_max)

#define add_bool(name, v, text, longtext, advc) \
    add_typename_inner(CONFIG_ITEM_BOOL, name, text, longtext, advc) if (v) vlc_config_set(VLC_CONFIG_VALUE, (int64_t) true);

#define add_obsolete_inner(name, type)                         \
    add_type_inner(type)                                       \
        vlc_config_set(VLC_CONFIG_NAME, (const char *)(name)); \
    vlc_config_set(VLC_CONFIG_REMOVED);

#define add_obsolete_bool(name) \
    add_obsolete_inner(name, CONFIG_ITEM_BOOL)

#define add_obsolete_integer(name) \
    add_obsolete_inner(name, CONFIG_ITEM_INTEGER)

#define add_obsolete_float(name) \
    add_obsolete_inner(name, CONFIG_ITEM_FLOAT)

#define add_obsolete_string(name) \
    add_obsolete_inner(name, CONFIG_ITEM_STRING)

#define change_short(ch) \
    vlc_config_set(VLC_CONFIG_SHORTCUT, (int)(ch));

#define change_string_list(list, list_text)                 \
    vlc_config_set(VLC_CONFIG_LIST,                         \
                   (size_t)(sizeof(list) / sizeof(char *)), \
                   (const char *const *)(list),             \
                   (const char *const *)(list_text));

#define change_string_cb(cb) \
    vlc_config_set(VLC_CONFIG_LIST_CB, (cb));

#define change_integer_list(list, list_text)             \
    vlc_config_set(VLC_CONFIG_LIST,                      \
                   (size_t)(sizeof(list) / sizeof(int)), \
                   (const int *)(list),                  \
                   (const char *const *)(list_text));

#define change_integer_cb(cb) \
    vlc_config_set(VLC_CONFIG_LIST_CB, (cb));

#define change_integer_range(minv, maxv) \
    vlc_config_set(VLC_CONFIG_RANGE, (int64_t)(minv), (int64_t)(maxv));

#define change_float_range(minv, maxv) \
    vlc_config_set(VLC_CONFIG_RANGE, (double)(minv), (double)(maxv));

#define change_action_add(pf_action, text) \
    (void)(pf_action, text);

#define change_private() \
    vlc_config_set(VLC_CONFIG_PRIVATE);

#define change_volatile() \
    change_private()      \
        vlc_config_set(VLC_CONFIG_VOLATILE);

#define change_safe() \
    vlc_config_set(VLC_CONFIG_SAFE);

#define VLC_META_EXPORT(name, value)                  \
    EXTERN_SYMBOL DLL_SYMBOL const char *CDECL_SYMBOL \
        __VLC_SYMBOL(vlc_entry_##name)(void);         \
    EXTERN_SYMBOL DLL_SYMBOL const char *CDECL_SYMBOL \
        __VLC_SYMBOL(vlc_entry_##name)(void)          \
    {                                                 \
        return value;                                 \
    }

#if defined(__LIBVLC__)
#define VLC_COPYRIGHT_EXPORT VLC_META_EXPORT(copyright,                                                         \
                                             "\x43\x6f\x70\x79\x72\x69\x67\x68\x74\x20\x28\x43\x29\x20\x74\x68" \
                                             "\x65\x20\x56\x69\x64\x65\x6f\x4c\x41\x4e\x20\x56\x4c\x43\x20\x6d" \
                                             "\x65\x64\x69\x61\x20\x70\x6c\x61\x79\x65\x72\x20\x64\x65\x76\x65" \
                                             "\x6c\x6f\x70\x65\x72\x73")
#define VLC_LICENSE_EXPORT VLC_META_EXPORT(license,                                                           \
                                           "\x4c\x69\x63\x65\x6e\x73\x65\x64\x20\x75\x6e\x64\x65\x72\x20\x74" \
                                           "\x68\x65\x20\x74\x65\x72\x6d\x73\x20\x6f\x66\x20\x74\x68\x65\x20" \
                                           "\x47\x4e\x55\x20\x4c\x65\x73\x73\x65\x72\x20\x47\x65\x6e\x65\x72" \
                                           "\x61\x6c\x20\x50\x75\x62\x6c\x69\x63\x20\x4c\x69\x63\x65\x6e\x73" \
                                           "\x65\x2c\x20\x76\x65\x72\x73\x69\x6f\x6e\x20\x32\x2e\x31\x20\x6f" \
                                           "\x72\x20\x6c\x61\x74\x65\x72\x2e")
#else
#if !defined(VLC_COPYRIGHT_EXPORT)
#define VLC_COPYRIGHT_EXPORT
#endif
#if !defined(VLC_LICENSE_EXPORT)
#define VLC_LICENSE_EXPORT
#endif
#endif

#define VLC_METADATA_EXPORTS \
    VLC_COPYRIGHT_EXPORT     \
    VLC_LICENSE_EXPORT

#endif
