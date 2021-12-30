#ifndef VLC_MD5_H
#define VLC_MD5_H

struct md5_s
{
    uint32_t A, B, C, D;
    uint32_t nblocks;
    uint8_t buf[64];
    int count;
};

VLC_API void InitMD5(struct md5_s *);
VLC_API void AddMD5(struct md5_s *, const void *, size_t);
VLC_API void EndMD5(struct md5_s *);

static inline char *psz_md5_hash(struct md5_s *md5_s)
{
    char *psz = malloc(33);
    if (likely(psz))
    {
        for (int i = 0; i < 16; i++)
            sprintf(&psz[2 * i], "%02" PRIx8, md5_s->buf[i]);
    }
    return psz;
}

#endif
