{
  +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  Module: Console D2Bridge Server

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not be sublicensed without
  express written authorization from the author (Talis Jonatas Gomes).
  This includes creating derivative works or distributing the source code
  through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
  +--------------------------------------------------------------------------+
}

unit Unit_D2Bridge_Server_Console;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, IniFiles,
{$IFDEF HAS_UNIT_SYSTEM_THREADING}
  System.Threading,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  DateUtils;

type
  TD2BridgeServerConsole = class
  private
  class var
    hIn: THandle;
    hTimer: THandle;
    threadID: cardinal;
    TimeoutAt: TDateTime;
    WaitingForReturn: boolean;
    TimerThreadTerminated: boolean;
    vServerPort: Integer;
    VServerName: string;
    vInputConsole: string;
    class procedure DisplayInfo;
    class procedure DisplayStartConfigServer;
    class procedure ClearLine(Line: Integer);
    class procedure SetCursorPosition(X, Y: Integer);
    class function ConsoleWidth: Integer;
  public
    class procedure Run;
  end;

implementation

uses
  D2RestaurantWebApp, Unit_Login;

{ Thread Get Port and Name Server }

function TimerThread(Parameter: pointer): {$IFDEF CPU32}Longint{$ELSE}{$IFNDEF FPC}Integer{$ELSE}Int64{$ENDIF}{$ENDIF};
var
  IR: TInputRecord;
  amt: cardinal;
begin
  Result                            := 0;
  IR.EventType                      := KEY_EVENT;
  IR.Event.KeyEvent.bKeyDown        := True;
  IR.Event.KeyEvent.wVirtualKeyCode := VK_RETURN;
  while not TD2BridgeServerConsole.TimerThreadTerminated do
  begin
    if TD2BridgeServerConsole.WaitingForReturn and (Now >= TD2BridgeServerConsole.TimeoutAt) then
      WriteConsoleInput(TD2BridgeServerConsole.hIn, IR, 1, amt);
    Sleep(500);
  end;
end;

procedure StartTimerThread;
begin
  TD2BridgeServerConsole.hTimer := BeginThread(nil, 0, TimerThread, nil, 0, TD2BridgeServerConsole.threadID);
end;

procedure EndTimerThread;
begin
  TD2BridgeServerConsole.TimerThreadTerminated := True;
  WaitForSingleObject(TD2BridgeServerConsole.hTimer, 1000);
  CloseHandle(TD2BridgeServerConsole.hTimer);
end;

procedure TimeoutWait(const Time: cardinal);
var
  IR: TInputRecord;
  nEvents: cardinal;
  ConsoleInfo: TConsoleScreenBufferInfo;
begin
  TD2BridgeServerConsole.TimeoutAt        := IncSecond(Now, Time);
  TD2BridgeServerConsole.WaitingForReturn := True;

  while ReadConsoleInput(TD2BridgeServerConsole.hIn, IR, 1, nEvents) do
  begin
    if (IR.EventType = KEY_EVENT) and (TKeyEventRecord(IR.Event).wVirtualKeyCode = VK_RETURN) and
      (TKeyEventRecord(IR.Event).bKeyDown) then
    begin
      TD2BridgeServerConsole.WaitingForReturn := False;
      break;
    end;

    if (TKeyEventRecord(IR.Event).bKeyDown) and (TKeyEventRecord(IR.Event).AsciiChar <> #0) then
    begin
      if Char(TKeyEventRecord(IR.Event).AsciiChar) = Char(VK_Back) then
      begin
        if TD2BridgeServerConsole.vInputConsole <> '' then
        begin
          Write(Char(TKeyEventRecord(IR.Event).AsciiChar));
          Write(StringOfChar(' ', 1));
          Write(Char(TKeyEventRecord(IR.Event).AsciiChar));

          TD2BridgeServerConsole.vInputConsole := Copy(TD2BridgeServerConsole.vInputConsole, 1, Length(TD2BridgeServerConsole.vInputConsole) - 1);
        end;
      end
      else
      begin
        Write(Char(TKeyEventRecord(IR.Event).AsciiChar));
        TD2BridgeServerConsole.vInputConsole := TD2BridgeServerConsole.vInputConsole + TKeyEventRecord(IR.Event).AsciiChar;
      end;

      TD2BridgeServerConsole.TimeoutAt := IncSecond(Now, Time);
    end;
  end;

end;

{ TD2BridgeServerConsole }

class procedure TD2BridgeServerConsole.ClearLine(Line: Integer);
begin
  SetCursorPosition(0, Line);
  Write(StringOfChar(' ', ConsoleWidth));
  SetCursorPosition(0, Line);
end;

class function TD2BridgeServerConsole.ConsoleWidth: Integer;
var
  ConsoleInfo: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), ConsoleInfo);
  Result := ConsoleInfo.dwSize.X;
end;

class procedure TD2BridgeServerConsole.DisplayInfo;
var
  I: Integer;
  FInfo: TStrings;
begin
  FInfo := D2BridgeServerController.ServerInfoConsole;

  for I := 0 to Pred(FInfo.Count) do
  begin
    ClearLine(I);
    Writeln(FInfo[I]);
  end;

  FreeAndNil(FInfo);
end;

class procedure TD2BridgeServerConsole.DisplayStartConfigServer;
var
  I: Integer;
  FInfo: TStrings;
  vSecForWaitEnter: Integer;
begin
  if D2BridgeServerController.IsD2DockerContext then
    Exit;

  WaitingForReturn      := False;
  TimerThreadTerminated := False;

  if not IsDebuggerPresent then
    vSecForWaitEnter := 5
  else
    vSecForWaitEnter := 1;

  hIn := GetStdHandle(STD_INPUT_HANDLE);
  StartTimerThread;

  FInfo := D2BridgeServerController.ServerInfoConsoleHeader;

  for I := 0 to Pred(FInfo.Count) do
  begin
    ClearLine(I);
    Writeln(FInfo[I]);
  end;

  vInputConsole := IntToStr(vServerPort);
  Writeln('Enter the Server Port and press [ENTER]');
  Write('Server Port: ' + TD2BridgeServerConsole.vInputConsole);
  TimeoutWait(vSecForWaitEnter);
  vServerPort := StrToInt(vInputConsole);

  Writeln('');
  Writeln('');

  vInputConsole := VServerName;
  Writeln('Enter the Server Name and press [ENTER]');
  Write('Server Name: ' + TD2BridgeServerConsole.vInputConsole);
  TimeoutWait(vSecForWaitEnter);
  VServerName := vInputConsole;

  SetCursorPosition(0, 0);

  FreeAndNil(FInfo);
end;

class procedure TD2BridgeServerConsole.Run;
begin
  D2BridgeServerController := TD2RestaurantWebAppGlobal.Create(nil);

  // App Information
  D2BridgeServerController.ServerAppTitle       := 'D2Restaurant';
  D2BridgeServerController.ServerAppDescription := 'APP Course D2Restaurant';
  D2BridgeServerController.ServerAppAuthor      := 'My Company';

  vServerPort := D2BridgeServerController.APPConfig.ServerPort(8888);
  VServerName := D2BridgeServerController.APPConfig.ServerName('D2Restaurant Server');

  // D2BridgeServerController.APPName := 'D2Restaurant';
  // D2BridgeServerController.APPDescription:= 'My D2Bridge Web APP';


  // D2BridgeServerController.APPSignature:= '...';

  // Security
  {
    D2BridgeServerController.Prism.Options.Security.Enabled:= False; //True Default
    D2BridgeServerController.Prism.Options.Security.IP.IPv4BlackList.EnableSpamhausList:= False; //Disable Default Blocked Spamhaus list
    D2BridgeServerController.Prism.Options.Security.IP.IPv4BlackList.Add('192.168.10.31'); //Block just IP
    D2BridgeServerController.Prism.Options.Security.IP.IPv4BlackList.Add('200.200.200.0/24'); //Block CDIR
    D2BridgeServerController.Prism.Options.Security.IP.IPv4BlackList.EnableSelfDelist:= False; //Disable Delist
    D2BridgeServerController.Prism.Options.Security.IP.IPv4WhiteList.Add('192.168.0.1'); //Add IP or CDIR to WhiteList
    D2BridgeServerController.Prism.Options.Security.IP.IPConnections.LimitNewConnPerIPMin:= 30; //Limite Connections from IP *minute
    D2BridgeServerController.Prism.Options.Security.IP.IPConnections.LimitActiveSessionsPerIP:= 50; //Limite Sessions from IP
    D2BridgeServerController.Prism.Options.Security.UserAgent.EnableCrawlerUserAgents:= False; //Disable Default Blocked Crawler User Agents
    D2BridgeServerController.Prism.Options.Security.UserAgent.Add('NewUserAgent'); //Block User Agent
    D2BridgeServerController.Prism.Options.Security.UserAgent.Delete('MyUserAgent'); //Allow User Agent
  }

  D2BridgeServerController.PrimaryFormClass := TFormLogin;

  // * REST OPTIONS
  D2BridgeServerController.Prism.Rest.Options.Security.JWTAccess.Secret            := 'tu5d9bWL10L01HrOatebd1bvFinqJ6rh5kp5';
  D2BridgeServerController.Prism.Rest.Options.Security.JWTAccess.ExpirationMinutes := 30;
  D2BridgeServerController.Prism.Rest.Options.Security.JWTRefresh.Secret           := 'mKW64lJ387D5BHCLMRuagYW17CNoQXKes5EzWigBIKLDA8gGa7';
  D2BridgeServerController.Prism.Rest.Options.Security.JWTRefresh.ExpirationDays   := 30;
  {
    D2BridgeServerController.Prism.Rest.Options.MaxRecord:= 2000;
    D2BridgeServerController.Prism.Rest.Options.ShowMetadata:= show;
    D2BridgeServerController.Prism.Rest.Options.FieldNameLowerCase:= True;
    D2BridgeServerController.Prism.Rest.Options.FormatSettings.ShortDateFormat:= 'YYYY-MM-DD';
    D2BridgeServerController.Prism.Rest.Options.EnableRESTServerExternal:= True;
  }

  // seconds to Send Session to TimeOut and Destroy after Disconnected
  // D2BridgeServerController.Prism.Options.SessionTimeOut:= 300;

  // secounds to set Session in Idle
  // D2BridgeServerController.Prism.Options.SessionIdleTimeOut:= 0;

  D2BridgeServerController.Prism.Options.IncludeJQuery := True;

  // D2BridgeServerController.Prism.Options.DataSetLog:= True;

  D2BridgeServerController.Prism.Options.CoInitialize := True;

  // D2BridgeServerController.Prism.Options.VCLStyles:= False;

  // D2BridgeServerController.Prism.Options.ShowError500Page:= False;

  // Uncomment to Dual Mode force http just in Debug Mode
  // if IsDebuggerPresent then
  // D2BridgeServerController.Prism.Options.SSL:= False
  // else
  // D2BridgeServerController.Prism.Options.SSL:= True;

  D2BridgeServerController.Languages := [TD2BridgeLang.English];

  if D2BridgeServerController.Prism.Options.SSL then
  begin
    // Cert File
    D2BridgeServerController.Prism.SSLOptions.CertFile := '';
    // Cert Key Domain File
    D2BridgeServerController.Prism.SSLOptions.KeyFile := '';
    // Cert Intermediate (case Let�s Encrypt)
    D2BridgeServerController.Prism.SSLOptions.RootCertFile := '';
  end;

  D2BridgeServerController.Prism.Options.PathJS  := 'js';
  D2BridgeServerController.Prism.Options.PathCSS := 'css';

  // Wait start D2Docker
  if D2BridgeServerController.IsD2DockerContext then
    Exit;

  DisplayStartConfigServer;

  D2BridgeServerController.Port       := vServerPort;
  D2BridgeServerController.ServerName := VServerName;

  D2BridgeServerController.StartServer;

  try
    while D2BridgeServerController.Started do
    begin
      DisplayInfo;
      Sleep(1);
      SetCursorPosition(0, 0);
    end;
  except
    on E: Exception do
      Writeln('Error: ', E.Message);
  end;
end;

class procedure TD2BridgeServerConsole.SetCursorPosition(X, Y: Integer);
var
  Coord: TCoord;
begin
  Coord.X := X;
  Coord.Y := Y;
  SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), Coord);
end;

end.
