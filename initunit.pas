unit InitUnit;

{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}
{$hints off}

interface

uses GlobalConst, GlobalConfig;

implementation

initialization
  {Disable Console Autocreate}
  FRAMEBUFFER_CONSOLE_AUTOCREATE := false;
  FRAMEBUFFER_DEFAULT_WIDTH := 800;
  FRAMEBUFFER_DEFAULT_HEIGHT := 480;
  FRAMEBUFFER_CONSOLE_AUTOCREATE:=True;


end.
