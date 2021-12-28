#ifndef VLC_BLOCK_HELPER_H
#define VLC_BLOCK_HELPER_H 1

#include <vlc_block.h>

typedef struct block_bytestream_t
{
    block_t *p_chain;
    block_t *p_block;
    size_t i_offset;

} block_bytestream_t;

static inline void block_BytestreamInit(block_bytestream_t *p_bytestream)
{
    p_bytestream->p_chain = p_bytestream->p_block = NULL;
    p_bytestream->i_offset = 0;
}

static inline void block_BytestreamRelease(block_bytestream_t *p_bytestream)
{
    for (block_t *block = p_bytestream->p_chain; block != NULL;)
    {
        block_t *p_next = block->p_next;

        block_Release(block);
        block = p_next;
    }
}

static inline void block_BytestreamEmpty(block_bytestream_t *p_bytestream)
{
    block_BytestreamRelease(p_bytestream);
    block_BytestreamInit(p_bytestream);
}

static inline void block_BytestreamFlush(block_bytestream_t *p_bytestream)
{
    block_t *block = p_bytestream->p_chain;

    while (block != p_bytestream->p_block)
    {
        block_t *p_next = block->p_next;

        block_Release(block);
        block = p_next;
    }

    while (block != NULL && block->i_buffer == p_bytestream->i_offset)
    {
        block_t *p_next = block->p_next;

        block_Release(block);
        block = p_next;
        p_bytestream->i_offset = 0;
    }

    p_bytestream->p_chain = p_bytestream->p_block = block;
}

static inline void block_BytestreamPush(block_bytestream_t *p_bytestream,
                                        block_t *p_block)
{
    block_ChainAppend(&p_bytestream->p_chain, p_block);
    if (!p_bytestream->p_block)
        p_bytestream->p_block = p_block;
}

VLC_USED
static inline block_t *block_BytestreamPop(block_bytestream_t *p_bytestream)
{
    block_t *p_block;

    block_BytestreamFlush(p_bytestream);

    p_block = p_bytestream->p_block;
    if (p_block == NULL)
    {
        return NULL;
    }
    else if (!p_block->p_next)
    {
        p_block->p_buffer += p_bytestream->i_offset;
        p_block->i_buffer -= p_bytestream->i_offset;
        p_bytestream->i_offset = 0;
        p_bytestream->p_chain = p_bytestream->p_block = NULL;
        return p_block;
    }

    while (p_block->p_next && p_block->p_next->p_next)
        p_block = p_block->p_next;

    block_t *p_block_old = p_block;
    p_block = p_block->p_next;
    p_block_old->p_next = NULL;

    return p_block;
}

static inline int block_SkipByte(block_bytestream_t *p_bytestream)
{

    if (p_bytestream->p_block->i_buffer - p_bytestream->i_offset)
    {
        p_bytestream->i_offset++;
        return VLC_SUCCESS;
    }
    else
    {
        block_t *p_block;

        for (p_block = p_bytestream->p_block->p_next;
             p_block != NULL; p_block = p_block->p_next)
        {
            if (p_block->i_buffer)
            {
                p_bytestream->i_offset = 1;
                p_bytestream->p_block = p_block;
                return VLC_SUCCESS;
            }
        }
    }

    return VLC_EGENERIC;
}

static inline int block_PeekByte(block_bytestream_t *p_bytestream,
                                 uint8_t *p_data)
{

    if (p_bytestream->p_block->i_buffer - p_bytestream->i_offset)
    {
        *p_data = p_bytestream->p_block->p_buffer[p_bytestream->i_offset];
        return VLC_SUCCESS;
    }
    else
    {
        block_t *p_block;

        for (p_block = p_bytestream->p_block->p_next;
             p_block != NULL; p_block = p_block->p_next)
        {
            if (p_block->i_buffer)
            {
                *p_data = p_block->p_buffer[0];
                return VLC_SUCCESS;
            }
        }
    }

    return VLC_EGENERIC;
}

static inline int block_GetByte(block_bytestream_t *p_bytestream,
                                uint8_t *p_data)
{

    if (p_bytestream->p_block->i_buffer - p_bytestream->i_offset)
    {
        *p_data = p_bytestream->p_block->p_buffer[p_bytestream->i_offset];
        p_bytestream->i_offset++;
        return VLC_SUCCESS;
    }
    else
    {
        block_t *p_block;

        for (p_block = p_bytestream->p_block->p_next;
             p_block != NULL; p_block = p_block->p_next)
        {
            if (p_block->i_buffer)
            {
                *p_data = p_block->p_buffer[0];
                p_bytestream->i_offset = 1;
                p_bytestream->p_block = p_block;
                return VLC_SUCCESS;
            }
        }
    }

    return VLC_EGENERIC;
}

static inline int block_WaitBytes(block_bytestream_t *p_bytestream,
                                  size_t i_data)
{
    block_t *p_block;
    size_t i_offset, i_copy, i_size;

    i_offset = p_bytestream->i_offset;
    i_size = i_data;
    i_copy = 0;
    for (p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next)
    {
        i_copy = __MIN(i_size, p_block->i_buffer - i_offset);
        i_size -= i_copy;
        i_offset = 0;

        if (!i_size)
            break;
    }

    if (i_size)
    {

        return VLC_EGENERIC;
    }
    return VLC_SUCCESS;
}

static inline int block_SkipBytes(block_bytestream_t *p_bytestream,
                                  size_t i_data)
{
    block_t *p_block;
    size_t i_offset, i_copy;

    i_offset = p_bytestream->i_offset;
    i_copy = 0;
    for (p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next)
    {
        i_copy = __MIN(i_data, p_block->i_buffer - i_offset);
        i_data -= i_copy;

        if (!i_data)
            break;

        i_offset = 0;
    }

    if (i_data)
    {

        return VLC_EGENERIC;
    }

    p_bytestream->p_block = p_block;
    p_bytestream->i_offset = i_offset + i_copy;
    return VLC_SUCCESS;
}

static inline int block_PeekBytes(block_bytestream_t *p_bytestream,
                                  uint8_t *p_data, size_t i_data)
{
    block_t *p_block;
    size_t i_offset, i_copy, i_size;

    i_offset = p_bytestream->i_offset;
    i_size = i_data;
    i_copy = 0;
    for (p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next)
    {
        i_copy = __MIN(i_size, p_block->i_buffer - i_offset);
        i_size -= i_copy;
        i_offset = 0;

        if (!i_size)
            break;
    }

    if (i_size)
    {

        return VLC_EGENERIC;
    }

    i_offset = p_bytestream->i_offset;
    i_size = i_data;
    i_copy = 0;
    for (p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next)
    {
        i_copy = __MIN(i_size, p_block->i_buffer - i_offset);
        i_size -= i_copy;

        if (i_copy)
        {
            memcpy(p_data, p_block->p_buffer + i_offset, i_copy);
            p_data += i_copy;
        }

        i_offset = 0;

        if (!i_size)
            break;
    }

    return VLC_SUCCESS;
}

static inline int block_GetBytes(block_bytestream_t *p_bytestream,
                                 uint8_t *p_data, size_t i_data)
{
    block_t *p_block;
    size_t i_offset, i_copy, i_size;

    i_offset = p_bytestream->i_offset;
    i_size = i_data;
    i_copy = 0;
    for (p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next)
    {
        i_copy = __MIN(i_size, p_block->i_buffer - i_offset);
        i_size -= i_copy;
        i_offset = 0;

        if (!i_size)
            break;
    }

    if (i_size)
    {

        return VLC_EGENERIC;
    }

    i_offset = p_bytestream->i_offset;
    i_size = i_data;
    i_copy = 0;
    for (p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next)
    {
        i_copy = __MIN(i_size, p_block->i_buffer - i_offset);
        i_size -= i_copy;

        if (i_copy)
        {
            memcpy(p_data, p_block->p_buffer + i_offset, i_copy);
            p_data += i_copy;
        }

        if (!i_size)
            break;

        i_offset = 0;
    }

    p_bytestream->p_block = p_block;
    p_bytestream->i_offset = i_offset + i_copy;

    return VLC_SUCCESS;
}

static inline int block_PeekOffsetBytes(block_bytestream_t *p_bytestream,
                                        size_t i_peek_offset, uint8_t *p_data, size_t i_data)
{
    block_t *p_block;
    size_t i_offset, i_copy, i_size;

    i_offset = p_bytestream->i_offset;
    i_size = i_data + i_peek_offset;
    i_copy = 0;
    for (p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next)
    {
        i_copy = __MIN(i_size, p_block->i_buffer - i_offset);
        i_size -= i_copy;
        i_offset = 0;

        if (!i_size)
            break;
    }

    if (i_size)
    {

        return VLC_EGENERIC;
    }

    i_offset = p_bytestream->i_offset;
    i_size = i_peek_offset;
    i_copy = 0;
    for (p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next)
    {
        i_copy = __MIN(i_size, p_block->i_buffer - i_offset);
        i_size -= i_copy;

        if (!i_size)
            break;

        i_offset = 0;
    }

    i_offset += i_copy;
    i_size = i_data;
    i_copy = 0;
    for (; p_block != NULL; p_block = p_block->p_next)
    {
        i_copy = __MIN(i_size, p_block->i_buffer - i_offset);
        i_size -= i_copy;

        if (i_copy)
        {
            memcpy(p_data, p_block->p_buffer + i_offset, i_copy);
            p_data += i_copy;
        }

        i_offset = 0;

        if (!i_size)
            break;
    }

    return VLC_SUCCESS;
}

static inline int block_FindStartcodeFromOffset(
    block_bytestream_t *p_bytestream, size_t *pi_offset,
    const uint8_t *p_startcode, int i_startcode_length)
{
    block_t *p_block, *p_block_backup = 0;
    int i_size = 0;
    size_t i_offset, i_offset_backup = 0;
    int i_caller_offset_backup = 0, i_match;

    i_size = *pi_offset + p_bytestream->i_offset;
    for (p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next)
    {
        i_size -= p_block->i_buffer;
        if (i_size < 0)
            break;
    }

    if (i_size >= 0)
    {

        return VLC_EGENERIC;
    }

    i_size += p_block->i_buffer;
    *pi_offset -= i_size;
    i_match = 0;
    for (; p_block != NULL; p_block = p_block->p_next)
    {
        for (i_offset = i_size; i_offset < p_block->i_buffer; i_offset++)
        {
            if (p_block->p_buffer[i_offset] == p_startcode[i_match])
            {
                if (!i_match)
                {
                    p_block_backup = p_block;
                    i_offset_backup = i_offset;
                    i_caller_offset_backup = *pi_offset;
                }

                if (i_match + 1 == i_startcode_length)
                {

                    *pi_offset += i_offset - i_match;
                    return VLC_SUCCESS;
                }

                i_match++;
            }
            else if (i_match)
            {

                p_block = p_block_backup;
                i_offset = i_offset_backup;
                *pi_offset = i_caller_offset_backup;
                i_match = 0;
            }
        }
        i_size = 0;
        *pi_offset += i_offset;
    }

    *pi_offset -= i_match;
    return VLC_EGENERIC;
}

#endif
