#ifndef VLC_TEXT_STYLE_H
#define VLC_TEXT_STYLE_H 1

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct
    {
        char *psz_fontname;
        int i_font_size;
        int i_font_color;
        int i_font_alpha;
        int i_style_flags;
        int i_outline_color;
        int i_outline_alpha;
        int i_shadow_color;
        int i_shadow_alpha;
        int i_background_color;
        int i_background_alpha;
        int i_karaoke_background_color;
        int i_karaoke_background_alpha;
        int i_outline_width;
        int i_shadow_width;
        int i_spacing;
    } text_style_t;

#define STYLE_BOLD 1
#define STYLE_ITALIC 2
#define STYLE_OUTLINE 4
#define STYLE_SHADOW 8
#define STYLE_BACKGROUND 16
#define STYLE_UNDERLINE 32
#define STYLE_STRIKEOUT 64

    VLC_API text_style_t *text_style_New(void);

    VLC_API text_style_t *text_style_Copy(text_style_t *, const text_style_t *);

    VLC_API text_style_t *text_style_Duplicate(const text_style_t *);

    VLC_API void text_style_Delete(text_style_t *);

#ifdef __cplusplus
}
#endif

#endif
