#include <SDL2/SDL.h>

#include "../lvgl/lvgl.h"
#include "../lv_drivers/sdl/sdl.h"

#include "LVGLSwiftDriver.h"

static lv_disp_t *display;
static lv_disp_draw_buf_t drawBuffer;
static lv_indev_drv_t inputDrv;
static lv_disp_drv_t displayDrv;
    
void LVGLSwiftDriverInit(void)
{
    lv_color_t frameBuffer[LV_HOR_RES * LV_VER_RES];

    sdl_init();

    lv_disp_draw_buf_init(&drawBuffer, frameBuffer, NULL, LV_HOR_RES * LV_VER_RES);
    
    lv_disp_drv_init(&displayDrv);
    displayDrv.draw_buf = &drawBuffer;
    displayDrv.hor_res = LV_HOR_RES;
    displayDrv.ver_res = LV_VER_RES;
    displayDrv.flush_cb = sdl_display_flush;
    display = lv_disp_drv_register(&displayDrv);
    
    lv_indev_drv_init(&inputDrv);
    inputDrv.type = LV_INDEV_TYPE_POINTER;
    
    inputDrv.read_cb = sdl_mouse_read;
    lv_indev_drv_register(&inputDrv);
}
