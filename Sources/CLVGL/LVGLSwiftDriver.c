#include <stdlib.h>

#include "CLVGL.h"
#include "LVGLSwiftDriver.h"

#include "sdl/sdl.h"

static lv_disp_t *display;
static lv_disp_draw_buf_t drawBuffer;
static lv_indev_drv_t inputDrv;
static lv_disp_drv_t displayDrv;
static lv_color_t *frameBuffer;

bool LVGLSwiftDriverInit(uint32_t width, uint32_t height)
{
    free(frameBuffer);
    frameBuffer = (lv_color_t *)calloc(width * height, sizeof(lv_color_t));
    if (frameBuffer == NULL)
        return false;

    sdl_init();

    lv_disp_draw_buf_init(&drawBuffer, frameBuffer, NULL, width * height);
    
    lv_disp_drv_init(&displayDrv);
    displayDrv.draw_buf = &drawBuffer;
    displayDrv.hor_res = width;
    displayDrv.ver_res = height;
    displayDrv.flush_cb = sdl_display_flush;
    display = lv_disp_drv_register(&displayDrv);
    
    lv_indev_drv_init(&inputDrv);
    inputDrv.type = LV_INDEV_TYPE_POINTER;
    
    inputDrv.read_cb = sdl_mouse_read;
    lv_indev_drv_register(&inputDrv);
}
