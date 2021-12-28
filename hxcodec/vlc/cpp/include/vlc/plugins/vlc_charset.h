#ifndef VLC_CHARSET_H
#define VLC_CHARSET_H 1

typedef void *vlc_iconv_t;
VLC_API vlc_iconv_t vlc_iconv_open(const char *, const char *) VLC_USED;
VLC_API size_t vlc_iconv(vlc_iconv_t, const char **, size_t *, char **, size_t *) VLC_USED;
VLC_API int vlc_iconv_close(vlc_iconv_t);

#include <stdarg.h>

VLC_API int utf8_vfprintf(FILE *stream, const char *fmt, va_list ap);
VLC_API int utf8_fprintf(FILE *, const char *, ...) VLC_FORMAT(2, 3);
VLC_API char *vlc_strcasestr(const char *, const char *) VLC_USED;

VLC_API char *EnsureUTF8(char *);
VLC_API const char *IsUTF8(const char *) VLC_USED;

VLC_API char *FromCharset(const char *charset, const void *data, size_t data_size) VLC_USED;
VLC_API void *ToCharset(const char *charset, const char *in, size_t *outsize) VLC_USED;

#ifdef _WIN32
VLC_USED
static inline char *FromWide(const wchar_t *wide)
{
    size_t len = WideCharToMultiByte(CP_UTF8, 0, wide, -1, NULL, 0, NULL, NULL);
    if (len == 0)
        return NULL;

    char *out = (char *)malloc(len);

    if (likely(out))
        WideCharToMultiByte(CP_UTF8, 0, wide, -1, out, len, NULL, NULL);
    return out;
}

VLC_USED
static inline wchar_t *ToWide(const char *utf8)
{
    int len = MultiByteToWideChar(CP_UTF8, 0, utf8, -1, NULL, 0);
    if (len == 0)
        return NULL;

    wchar_t *out = (wchar_t *)malloc(len * sizeof(wchar_t));

    if (likely(out))
        MultiByteToWideChar(CP_UTF8, 0, utf8, -1, out, len);
    return out;
}

VLC_USED VLC_MALLOC static inline char *ToCodePage(unsigned cp, const char *utf8)
{
    wchar_t *wide = ToWide(utf8);
    if (wide == NULL)
        return NULL;

    size_t len = WideCharToMultiByte(cp, 0, wide, -1, NULL, 0, NULL, NULL);
    if (len == 0)
        return NULL;

    char *out = (char *)malloc(len);
    if (likely(out != NULL))
        WideCharToMultiByte(cp, 0, wide, -1, out, len, NULL, NULL);
    free(wide);
    return out;
}

VLC_USED VLC_MALLOC static inline char *FromCodePage(unsigned cp, const char *mb)
{
    int len = MultiByteToWideChar(cp, 0, mb, -1, NULL, 0);
    if (len == 0)
        return NULL;

    wchar_t *wide = (wchar_t *)malloc(len * sizeof(wchar_t));
    if (unlikely(wide == NULL))
        return NULL;
    MultiByteToWideChar(cp, 0, mb, -1, wide, len);

    char *utf8 = FromWide(wide);
    free(wide);
    return utf8;
}

VLC_USED VLC_MALLOC static inline char *FromANSI(const char *ansi)
{
    return FromCodePage(GetACP(), ansi);
}

VLC_USED VLC_MALLOC static inline char *ToANSI(const char *utf8)
{
    return ToCodePage(GetACP(), utf8);
}

#ifdef UNICODE
#define FromT FromWide
#define ToT ToWide
#else
#define FromT FromANSI
#define ToT ToANSI
#endif
#define FromLocale FromANSI
#define ToLocale ToANSI
#define LocaleFree(s) free((char *)(s))
#define FromLocaleDup FromANSI
#define ToLocaleDup ToANSI

#elif defined(__OS2__)

VLC_USED static inline char *FromLocale(const char *locale)
{
    return locale ? FromCharset((char *)"", locale, strlen(locale)) : NULL;
}

VLC_USED static inline char *ToLocale(const char *utf8)
{
    size_t outsize;
    return utf8 ? (char *)ToCharset("", utf8, &outsize) : NULL;
}

VLC_USED static inline void LocaleFree(const char *str)
{
    free((char *)str);
}

VLC_USED static inline char *FromLocaleDup(const char *locale)
{
    return FromCharset("", locale, strlen(locale));
}

VLC_USED static inline char *ToLocaleDup(const char *utf8)
{
    size_t outsize;
    return (char *)ToCharset("", utf8, &outsize);
}

#else

#define FromLocale(l) (l)
#define ToLocale(u) (u)
#define LocaleFree(s) ((void)(s))
#define FromLocaleDup strdup
#define ToLocaleDup strdup
#endif

static inline char *FromLatin1(const char *latin)
{
    char *str = (char *)malloc(2 * strlen(latin) + 1), *utf8 = str;
    unsigned char c;

    if (str == NULL)
        return NULL;

    while ((c = *(latin++)) != '\0')
    {
        if (c >= 0x80)
        {
            *(utf8++) = 0xC0 | (c >> 6);
            *(utf8++) = 0x80 | (c & 0x3F);
        }
        else
            *(utf8++) = c;
    }
    *(utf8++) = '\0';

    utf8 = (char *)realloc(str, utf8 - str);
    return utf8 ? utf8 : str;
}

VLC_API double us_strtod(const char *, char **) VLC_USED;
VLC_API float us_strtof(const char *, char **) VLC_USED;
VLC_API double us_atof(const char *) VLC_USED;
VLC_API int us_vasprintf(char **, const char *, va_list);
VLC_API int us_asprintf(char **, const char *, ...) VLC_USED;

#endif
