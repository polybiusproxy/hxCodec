#ifndef VLC_CODEC_H
#define VLC_CODEC_H 1

#include <vlc_block.h>
#include <vlc_es.h>
#include <vlc_picture.h>
#include <vlc_subpicture.h>

typedef struct decoder_owner_sys_t decoder_owner_sys_t;

struct decoder_t
{
    VLC_COMMON_MEMBERS

    module_t *p_module;
    decoder_sys_t *p_sys;

    es_format_t fmt_in;

    es_format_t fmt_out;

    bool b_need_packetized;

    bool b_pace_control;

    picture_t *(*pf_decode_video)(decoder_t *, block_t **);
    block_t *(*pf_decode_audio)(decoder_t *, block_t **);
    subpicture_t *(*pf_decode_sub)(decoder_t *, block_t **);
    block_t *(*pf_packetize)(decoder_t *, block_t **);

    block_t *(*pf_get_cc)(decoder_t *, bool pb_present[4]);

    vlc_meta_t *p_description;

    picture_t *(*pf_vout_buffer_new)(decoder_t *);
    void (*pf_vout_buffer_del)(decoder_t *, picture_t *);
    void (*pf_picture_link)(decoder_t *, picture_t *);
    void (*pf_picture_unlink)(decoder_t *, picture_t *);

    int i_extra_picture_buffers;

    block_t *(*pf_aout_buffer_new)(decoder_t *, int);

    subpicture_t *(*pf_spu_buffer_new)(decoder_t *, const subpicture_updater_t *);
    void (*pf_spu_buffer_del)(decoder_t *, subpicture_t *);

    int (*pf_get_attachments)(decoder_t *p_dec, input_attachment_t ***ppp_attachment, int *pi_attachment);

    mtime_t (*pf_get_display_date)(decoder_t *, mtime_t);

    int (*pf_get_display_rate)(decoder_t *);

    decoder_owner_sys_t *p_owner;

    bool b_error;
};

struct encoder_t
{
    VLC_COMMON_MEMBERS

    module_t *p_module;
    encoder_sys_t *p_sys;

    es_format_t fmt_in;

    es_format_t fmt_out;

    block_t *(*pf_encode_video)(encoder_t *, picture_t *);
    block_t *(*pf_encode_audio)(encoder_t *, block_t *);
    block_t *(*pf_encode_sub)(encoder_t *, subpicture_t *);

    int i_threads;
    int i_iframes;
    int i_bframes;
    int i_tolerance;

    config_chain_t *p_cfg;
};

VLC_API picture_t *decoder_NewPicture(decoder_t *) VLC_USED;

VLC_API void decoder_DeletePicture(decoder_t *, picture_t *p_picture);

VLC_API void decoder_LinkPicture(decoder_t *, picture_t *);

VLC_API void decoder_UnlinkPicture(decoder_t *, picture_t *);

VLC_API block_t *decoder_NewAudioBuffer(decoder_t *, int i_size) VLC_USED;

VLC_API subpicture_t *decoder_NewSubpicture(decoder_t *, const subpicture_updater_t *) VLC_USED;

VLC_API void decoder_DeleteSubpicture(decoder_t *, subpicture_t *p_subpicture);

VLC_API int decoder_GetInputAttachments(decoder_t *, input_attachment_t ***ppp_attachment, int *pi_attachment);

VLC_API mtime_t decoder_GetDisplayDate(decoder_t *, mtime_t) VLC_USED;

VLC_API int decoder_GetDisplayRate(decoder_t *) VLC_USED;

#endif
