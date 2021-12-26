#ifndef VLC_URL_H
#define VLC_URL_H

VLC_API char *vlc_path2uri(const char *path, const char *scheme) VLC_MALLOC;

struct vlc_url_t
{
    char *psz_protocol;
    char *psz_username;
    char *psz_password;
    char *psz_host;
    unsigned i_port;
    char *psz_path;
    char *psz_option;

    char *psz_buffer;
};

VLC_API char *decode_URI_duplicate(const char *psz) VLC_MALLOC;
VLC_API char *decode_URI(char *psz);
VLC_API char *encode_URI_component(const char *psz) VLC_MALLOC;
VLC_API char *make_path(const char *url) VLC_MALLOC;

VLC_API void vlc_UrlParse(vlc_url_t *, const char *, unsigned char);
VLC_API void vlc_UrlClean(vlc_url_t *);
#endif
