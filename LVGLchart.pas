program LVGLchart;

{$mode objfpc}{$H+}
{
     Ultibo Demo Program for LVGL
     pjde 2020

     MIT licence
     LVGL Copyright (c) 2016 Gábor Kiss-Vámosi
     For licencing aggreement refer uLVGL.pas
}

uses
  InitUnit,
  QEMUVersatilePB,
  //RaspberryPi,
  GlobalConst,
  GlobalTypes,
  GlobalConfig,
  Platform,
  SysUtils,
  Threads,
  Mouse,
  Framebuffer,
  //SysCalls,
  ulvgl;

{$linklib lvgl}
{$hints off}
{$notes off}

procedure lv_test (no_ : integer); cdecl; external;

var
  FramebufferDevice : PFramebufferDevice;
  FramebufferProperties : TFramebufferProperties;
  x : integer;

  view : Plv_obj;
  cursor : Plv_obj;
  b, l, c, g, s : Plv_obj;
  s1, s2 : Plv_chart_series;
  fl : Plv_obj;

  ScreenWidth : LongWord;
  ScreenHeight : LongWord;
  VideoBuffer : pointer;

  disp_buf : Tlv_disp_buf;
  disp_drv : Tlv_disp_drv;
  indev_drv : Tlv_indev_drv;

  buf : pointer;


procedure ultibo_fbddev_flush (drv : Plv_disp_drv; const area : Plv_area; color_p : Plv_color); cdecl;
var
  act_x1, act_x2, act_y1, act_y2 : integer;
  y : integer;
  s, d : PCardinal;
begin
  if area^.x1 < 0 then act_x1 := 0 else act_x1 := area^.x1;
  if area^.y1 < 0 then act_y1 := 0 else act_y1 := area^.y1;
  if area^.x2 > ScreenWidth - 1 then act_x2 := ScreenWidth - 1 else act_x2 := area^.x2;
  if area^.y2 > ScreenHeight - 1 then act_y2 := ScreenHeight - 1 else act_y2 := area^.y2;
  s := pointer (color_p);
	for y := act_y1 to act_y2 do
	  begin
		  cardinal (d) := cardinal (VideoBuffer) + (act_x1 + y * ScreenWidth) * 4;
      move (s^, d^, (act_x2 + 1 - act_x1) * 4);
      inc (s, (act_x2 + 1 - act_x1));
    end;
  lv_disp_flush_ready (drv);
end;


begin
  fl := nil;
  FramebufferDevice := FramebufferDeviceGetDefault;
  FramebufferDeviceGetProperties (FramebufferDevice, @FramebufferProperties);
  FramebufferDeviceFillRect (FramebufferDevice, 0, 0, FramebufferProperties.PhysicalWidth,
                            FramebufferProperties.PhysicalHeight, COLOR_BLACK, FRAMEBUFFER_TRANSFER_DMA);
  //while not DirectoryExists ('C:\') do Sleep (100);

  ScreenWidth := 800;
  ScreenHeight := 480;
  buf := GetMem (ScreenWidth * ScreenHeight * 4);
  VideoBuffer := GetMem (ScreenWidth * ScreenHeight * 4);

  lv_init;                                                  // initialise lv

  lv_disp_buf_init (@disp_buf, buf, nil, ScreenWidth * ScreenHeight * 4);
  lv_disp_drv_init (@disp_drv);
  disp_drv.buffer := @disp_buf;
  disp_drv.flush_cb := @ultibo_fbddev_flush;
  lv_disp_drv_register (@disp_drv);
  lv_indev_drv_init (@indev_drv);      // Basic initialization
  indev_drv._type := LV_INDEV_TYPE_POINTER;

  view := lv_tabview_create (lv_scr_act, nil);

  c := lv_chart_create (view, nil);
  lv_chart_set_type (c, LV_CHART_TYPE_LINE);
  lv_obj_set_pos (c, 10, 10);                             // Set its position
  lv_obj_set_size (c, 780, 300);                          // Set its size

  s1 := lv_chart_add_series (c, LV_THEME_DEFAULT_COLOR_PRIMARY);
  s2 := lv_chart_add_series (c, LV_THEME_DEFAULT_COLOR_SECONDARY);
  lv_chart_set_next (c, s1, 10);
  lv_chart_set_next (c, s1, 90);
  lv_chart_set_next (c, s1, 30);
  lv_chart_set_next (c, s1, 60);
  lv_chart_set_next (c, s1, 10);
  lv_chart_set_next (c, s1, 90);
  lv_chart_set_next (c, s1, 30);
  lv_chart_set_next (c, s1, 60);
  lv_chart_set_next (c, s1, 10);
  lv_chart_set_next (c, s1, 90);

  lv_chart_set_next (c, s2, 32);
  lv_chart_set_next (c, s2, 66);
  lv_chart_set_next (c, s2, 5);
  lv_chart_set_next (c, s2, 47);
  lv_chart_set_next (c, s2, 32);
  lv_chart_set_next (c, s2, 32);
  lv_chart_set_next (c, s2, 66);
  lv_chart_set_next (c, s2, 5);
  lv_chart_set_next (c, s2, 47);
  lv_chart_set_next (c, s2, 66);
  lv_chart_set_next (c, s2, 5);
  lv_chart_set_next (c, s2, 47);


  while true do
    begin
      lv_task_handler;

      FramebufferDevicePutRect (FramebufferDevice, 0, 0, VideoBuffer, ScreenWidth, ScreenHeight, 0, FRAMEBUFFER_TRANSFER_DMA);
    end;
  ThreadHalt (0);
end.
