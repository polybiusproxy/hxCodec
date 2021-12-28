#ifndef VLC_STRINGS_H
#define VLC_STRINGS_H 1

VLC_API void resolve_xml_special_chars(char *psz_value);
VLC_API char *convert_xml_special_chars(const char *psz_content);

VLC_API char *vlc_b64_encode_binary(const uint8_t *, size_t);
VLC_API char *vlc_b64_encode(const char *);

VLC_API size_t vlc_b64_decode_binary_to_buffer(uint8_t *p_dst, size_t i_dst_max, const char *psz_src);
VLC_API size_t vlc_b64_decode_binary(uint8_t **pp_dst, const char *psz_src);
VLC_API char *vlc_b64_decode(const char *psz_src);

VLC_API char *str_format_time(const char *);
VLC_API char *str_format_meta(playlist_t *, const char *);

static inline char *str_format(playlist_t *pl, const char *fmt)
{
    char *s1 = str_format_time(fmt);
    char *s2 = str_format_meta(pl, s1);
    free(s1);
    return s2;
}

VLC_API void filename_sanitize(char *);
VLC_API void path_sanitize(char *);

VLC_API time_t str_duration(const char *);

#endif
