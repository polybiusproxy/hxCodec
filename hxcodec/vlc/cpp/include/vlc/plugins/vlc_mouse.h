#ifndef _VLC_MOUSE_H
#define _VLC_MOUSE_H 1

enum
{
    MOUSE_BUTTON_LEFT = 0,
    MOUSE_BUTTON_CENTER,
    MOUSE_BUTTON_RIGHT,
    MOUSE_BUTTON_WHEEL_UP,
    MOUSE_BUTTON_WHEEL_DOWN,
    MOUSE_BUTTON_WHEEL_LEFT,
    MOUSE_BUTTON_WHEEL_RIGHT,
    MOUSE_BUTTON_MAX
};

typedef struct
{

    int i_x;
    int i_y;

    int i_pressed;

    bool b_double_click;
} vlc_mouse_t;

static inline void vlc_mouse_Init(vlc_mouse_t *p_mouse)
{
    p_mouse->i_x = 0;
    p_mouse->i_y = 0;
    p_mouse->i_pressed = 0;
    p_mouse->b_double_click = false;
}

static inline void vlc_mouse_SetPressed(vlc_mouse_t *p_mouse,
                                        int i_button)
{
    p_mouse->i_pressed |= 1 << i_button;
}
static inline void vlc_mouse_SetReleased(vlc_mouse_t *p_mouse,
                                         int i_button)
{
    p_mouse->i_pressed &= ~(1 << i_button);
}
static inline void vlc_mouse_SetPosition(vlc_mouse_t *p_mouse,
                                         int i_x, int i_y)
{
    p_mouse->i_x = i_x;
    p_mouse->i_y = i_y;
}

static inline bool vlc_mouse_IsPressed(const vlc_mouse_t *p_mouse,
                                       int i_button)
{
    return (p_mouse->i_pressed & (1 << i_button)) != 0;
}
static inline bool vlc_mouse_IsLeftPressed(const vlc_mouse_t *p_mouse)
{
    return vlc_mouse_IsPressed(p_mouse, MOUSE_BUTTON_LEFT);
}
static inline bool vlc_mouse_IsCenterPressed(const vlc_mouse_t *p_mouse)
{
    return vlc_mouse_IsPressed(p_mouse, MOUSE_BUTTON_CENTER);
}
static inline bool vlc_mouse_IsRightPressed(const vlc_mouse_t *p_mouse)
{
    return vlc_mouse_IsPressed(p_mouse, MOUSE_BUTTON_RIGHT);
}
static inline bool vlc_mouse_IsWheelUpPressed(const vlc_mouse_t *p_mouse)
{
    return vlc_mouse_IsPressed(p_mouse, MOUSE_BUTTON_WHEEL_UP);
}
static inline bool vlc_mouse_IsWheelDownPressed(const vlc_mouse_t *p_mouse)
{
    return vlc_mouse_IsPressed(p_mouse, MOUSE_BUTTON_WHEEL_DOWN);
}
static inline void vlc_mouse_GetMotion(int *pi_x, int *pi_y,
                                       const vlc_mouse_t *p_old,
                                       const vlc_mouse_t *p_new)
{
    *pi_x = p_new->i_x - p_old->i_x;
    *pi_y = p_new->i_y - p_old->i_y;
}

static inline bool vlc_mouse_HasChanged(const vlc_mouse_t *p_old,
                                        const vlc_mouse_t *p_new)
{
    return p_old->i_x != p_new->i_x || p_old->i_y != p_new->i_y ||
           p_old->i_pressed != p_new->i_pressed;
}
static inline bool vlc_mouse_HasMoved(const vlc_mouse_t *p_old,
                                      const vlc_mouse_t *p_new)
{
    return p_old->i_x != p_new->i_x || p_old->i_y != p_new->i_y;
}
static inline bool vlc_mouse_HasButton(const vlc_mouse_t *p_old,
                                       const vlc_mouse_t *p_new)
{
    return p_old->i_pressed != p_new->i_pressed;
}
static inline bool vlc_mouse_HasPressed(const vlc_mouse_t *p_old,
                                        const vlc_mouse_t *p_new,
                                        int i_button)
{
    const int i_mask = 1 << i_button;
    return (p_old->i_pressed & i_mask) == 0 && (p_new->i_pressed & i_mask);
}
static inline bool vlc_mouse_HasReleased(const vlc_mouse_t *p_old,
                                         const vlc_mouse_t *p_new,
                                         int i_button)
{
    const int i_mask = 1 << i_button;
    return (p_old->i_pressed & i_mask) && (p_new->i_pressed & i_mask) == 0;
}
#endif
