TYPEDEF_ARRAY(input_item_t *, input_item_array_t)

struct hotkey;

struct libvlc_int_t
{
    VLC_COMMON_MEMBERS

    const struct hotkey *p_hotkeys;
};
