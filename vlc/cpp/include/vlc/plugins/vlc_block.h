#ifndef VLC_BLOCK_H
#define VLC_BLOCK_H 1

#include <sys/types.h>

#define BLOCK_FLAG_DISCONTINUITY 0x0001

#define BLOCK_FLAG_TYPE_I 0x0002

#define BLOCK_FLAG_TYPE_P 0x0004

#define BLOCK_FLAG_TYPE_B 0x0008

#define BLOCK_FLAG_TYPE_PB 0x0010

#define BLOCK_FLAG_HEADER 0x0020

#define BLOCK_FLAG_END_OF_FRAME 0x0040

#define BLOCK_FLAG_NO_KEYFRAME 0x0080

#define BLOCK_FLAG_END_OF_SEQUENCE 0x0100

#define BLOCK_FLAG_CLOCK 0x0200

#define BLOCK_FLAG_SCRAMBLED 0x0400

#define BLOCK_FLAG_PREROLL 0x0800

#define BLOCK_FLAG_CORRUPTED 0x1000

#define BLOCK_FLAG_TOP_FIELD_FIRST 0x2000

#define BLOCK_FLAG_BOTTOM_FIELD_FIRST 0x4000

#define BLOCK_FLAG_INTERLACED_MASK \
    (BLOCK_FLAG_TOP_FIELD_FIRST | BLOCK_FLAG_BOTTOM_FIELD_FIRST)

#define BLOCK_FLAG_TYPE_MASK \
    (BLOCK_FLAG_TYPE_I | BLOCK_FLAG_TYPE_P | BLOCK_FLAG_TYPE_B | BLOCK_FLAG_TYPE_PB)

#define BLOCK_FLAG_CORE_PRIVATE_MASK 0x00ff0000
#define BLOCK_FLAG_CORE_PRIVATE_SHIFT 16

#define BLOCK_FLAG_PRIVATE_MASK 0xff000000
#define BLOCK_FLAG_PRIVATE_SHIFT 24

typedef void (*block_free_t)(block_t *);

struct block_t
{
    block_t *p_next;

    uint8_t *p_buffer;
    size_t i_buffer;
    uint8_t *p_start;
    size_t i_size;

    uint32_t i_flags;
    unsigned i_nb_samples;

    mtime_t i_pts;
    mtime_t i_dts;
    mtime_t i_length;

    block_free_t pf_release;
};

VLC_API void block_Init(block_t *, void *, size_t);
VLC_API block_t *block_Alloc(size_t) VLC_USED VLC_MALLOC;
VLC_API block_t *block_Realloc(block_t *, ssize_t i_pre, size_t i_body) VLC_USED;

static inline void block_CopyProperties(block_t *dst, block_t *src)
{
    dst->i_flags = src->i_flags;
    dst->i_nb_samples = src->i_nb_samples;
    dst->i_dts = src->i_dts;
    dst->i_pts = src->i_pts;
    dst->i_length = src->i_length;
}

VLC_USED
static inline block_t *block_Duplicate(block_t *p_block)
{
    block_t *p_dup = block_Alloc(p_block->i_buffer);
    if (p_dup == NULL)
        return NULL;

    block_CopyProperties(p_dup, p_block);
    memcpy(p_dup->p_buffer, p_block->p_buffer, p_block->i_buffer);

    return p_dup;
}

static inline void block_Release(block_t *p_block)
{
    p_block->pf_release(p_block);
}

VLC_API block_t *block_heap_Alloc(void *, size_t) VLC_USED VLC_MALLOC;
VLC_API block_t *block_mmap_Alloc(void *addr, size_t length) VLC_USED VLC_MALLOC;
VLC_API block_t *block_shm_Alloc(void *addr, size_t length) VLC_USED VLC_MALLOC;
VLC_API block_t *block_File(int fd) VLC_USED VLC_MALLOC;
VLC_API block_t *block_FilePath(const char *) VLC_USED VLC_MALLOC;

static inline void block_Cleanup(void *block)
{
    block_Release((block_t *)block);
}
#define block_cleanup_push(block) vlc_cleanup_push(block_Cleanup, block)

static inline void block_ChainAppend(block_t **pp_list, block_t *p_block)
{
    if (*pp_list == NULL)
    {
        *pp_list = p_block;
    }
    else
    {
        block_t *p = *pp_list;

        while (p->p_next)
            p = p->p_next;
        p->p_next = p_block;
    }
}

static inline void block_ChainLastAppend(block_t ***ppp_last, block_t *p_block)
{
    block_t *p_last = p_block;

    **ppp_last = p_block;

    while (p_last->p_next)
        p_last = p_last->p_next;
    *ppp_last = &p_last->p_next;
}

static inline void block_ChainRelease(block_t *p_block)
{
    while (p_block)
    {
        block_t *p_next = p_block->p_next;
        block_Release(p_block);
        p_block = p_next;
    }
}

static size_t block_ChainExtract(block_t *p_list, void *p_data, size_t i_max)
{
    size_t i_total = 0;
    uint8_t *p = (uint8_t *)p_data;

    while (p_list && i_max)
    {
        size_t i_copy = __MIN(i_max, p_list->i_buffer);
        memcpy(p, p_list->p_buffer, i_copy);
        i_max -= i_copy;
        i_total += i_copy;
        p += i_copy;

        p_list = p_list->p_next;
    }
    return i_total;
}

static inline void block_ChainProperties(block_t *p_list, int *pi_count, size_t *pi_size, mtime_t *pi_length)
{
    size_t i_size = 0;
    mtime_t i_length = 0;
    int i_count = 0;

    while (p_list)
    {
        i_size += p_list->i_buffer;
        i_length += p_list->i_length;
        i_count++;

        p_list = p_list->p_next;
    }

    if (pi_size)
        *pi_size = i_size;
    if (pi_length)
        *pi_length = i_length;
    if (pi_count)
        *pi_count = i_count;
}

static inline block_t *block_ChainGather(block_t *p_list)
{
    size_t i_total = 0;
    mtime_t i_length = 0;
    block_t *g;

    if (p_list->p_next == NULL)
        return p_list;

    block_ChainProperties(p_list, NULL, &i_total, &i_length);

    g = block_Alloc(i_total);
    block_ChainExtract(p_list, g->p_buffer, g->i_buffer);

    g->i_flags = p_list->i_flags;
    g->i_pts = p_list->i_pts;
    g->i_dts = p_list->i_dts;
    g->i_length = i_length;

    block_ChainRelease(p_list);
    return g;
}

VLC_API block_fifo_t *block_FifoNew(void) VLC_USED VLC_MALLOC;
VLC_API void block_FifoRelease(block_fifo_t *);
VLC_API void block_FifoPace(block_fifo_t *fifo, size_t max_depth, size_t max_size);
VLC_API void block_FifoEmpty(block_fifo_t *);
VLC_API size_t block_FifoPut(block_fifo_t *, block_t *);
void block_FifoWake(block_fifo_t *);
VLC_API block_t *block_FifoGet(block_fifo_t *) VLC_USED;
VLC_API block_t *block_FifoShow(block_fifo_t *);
size_t block_FifoSize(const block_fifo_t *p_fifo) VLC_USED;
VLC_API size_t block_FifoCount(const block_fifo_t *p_fifo) VLC_USED;

#endif
