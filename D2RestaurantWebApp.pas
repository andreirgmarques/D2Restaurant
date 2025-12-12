unit D2RestaurantWebApp;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, System.UITypes, D2Bridge.ServerControllerBase, D2Bridge.Types, D2Bridge.JSON, Prism.Session,
  Prism.Server.HTTP.Commom, Prism.Types, Prism.Interfaces, D2Restaurant_Session, Data.DB, Datasnap.DBClient;

type
  IPrismSession      = Prism.Interfaces.IPrismSession;
  TSessionChangeType = Prism.Types.TSessionChangeType;
  TD2BridgeLang      = D2Bridge.Types.TD2BridgeLang;

type
  TD2RestaurantWebAppGlobal = class(TD2BridgeServerControllerBase)
  private
    procedure OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
    procedure OnCloseSession(Session: TPrismSession);
    procedure OnDisconnectSession(Session: TPrismSession);
    procedure OnReconnectSession(Session: TPrismSession);
    procedure OnExpiredSession(Session: TPrismSession; var Renew: boolean);
    procedure OnIdleSession(Session: TPrismSession; var Renew: boolean);
    procedure OnException(Form: TObject; Sender: TObject; E: Exception; FormName: string; ComponentName: string;
      EventName: string; APrismSession: IPrismSession);
    procedure OnSecurity(const SecEventInfo: TSecuritEventInfo);
    procedure OnRoute(const RestSession: TD2BridgeRestSession; const Request: TPrismHTTPRequest;
      const Response: TPrismHTTPResponse);
    procedure OnBeforeServerStart;
    procedure OnAfterServerStart;
    procedure OnBeforeServerStop;
    procedure OnAfterServerStop;
    // Routes
    // procedure GetPing(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
  protected
    procedure RegisterRoutes(RestServer: TD2BridgeRestServer); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  D2BridgeServerController: TD2RestaurantWebAppGlobal;

function D2Restaurant: TD2RestaurantSession;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses
  D2Bridge.Instance, D2Bridge.Rest.Commom, Unit_DM;

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

function D2Restaurant: TD2RestaurantSession;
begin
  Result := TD2RestaurantSession(D2BridgeInstance.PrismSession.Data);
end;

constructor TD2RestaurantWebAppGlobal.Create(AOwner: TComponent);
begin
  inherited;
  {$IFDEF D2BRIDGE}
  Prism.OnNewSession        := OnNewSession;
  Prism.OnCloseSession      := OnCloseSession;
  Prism.OnDisconnectSession := OnDisconnectSession;
  Prism.OnReconnectSession  := OnReconnectSession;
  Prism.OnExpiredSession    := OnExpiredSession;
  Prism.OnIdleSession       := OnIdleSession;
  Prism.OnException         := OnException;
  Prism.OnSecurity          := OnSecurity;
  Prism.OnRoute             := OnRoute;
  Prism.OnBeforeServerStart := OnBeforeServerStart;
  Prism.OnAfterServerStart  := OnAfterServerStart;
  Prism.OnBeforeServerStop  := OnBeforeServerStop;
  Prism.OnAfterServerStop   := OnAfterServerStop;
  {$ENDIF}


  // Our Code

  {$IFNDEF D2BRIDGE}
  OnNewSession(nil, nil, D2BridgeInstance.PrismSession as TPrismSession);
  {$ENDIF}
end;

procedure TD2RestaurantWebAppGlobal.RegisterRoutes(RestServer: TD2BridgeRestServer);
begin
  {
    RestServer.AddGet('/api/ping', GetPing);
    //or...
    RestServer.AddGet('/api/test', nil);
  }
end;

procedure TD2RestaurantWebAppGlobal.OnException(Form, Sender: TObject; E: Exception;
  FormName, ComponentName, EventName: string; APrismSession: IPrismSession);
begin
  // Show Error Messages
  {
    if Assigned(APrismSession) then
    APrismSession.ShowMessageError(E.Message);
  }
end;

procedure TD2RestaurantWebAppGlobal.OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse;
  Session: TPrismSession);
begin
  D2BridgeInstance.PrismSession.Data := TD2RestaurantSession.Create(Session);

  // Set Language just this Session
  // Session.Language:= TD2BridgeLang.English;

  // Our Code

end;

procedure TD2RestaurantWebAppGlobal.OnCloseSession(Session: TPrismSession);
begin
  // Close ALL DataBase connection
  // Ex: Dm.DBConnection.Close;

end;

procedure TD2RestaurantWebAppGlobal.OnExpiredSession(Session: TPrismSession; var Renew: boolean);
begin
  // Example of use Renew
  {
    if Session.InfoConnection.Identity = 'UserXYZ' then
    Renew:= true;
  }
end;

procedure TD2RestaurantWebAppGlobal.OnIdleSession(Session: TPrismSession; var Renew: boolean);
begin

end;

procedure TD2RestaurantWebAppGlobal.OnDisconnectSession(Session: TPrismSession);
begin

end;

procedure TD2RestaurantWebAppGlobal.OnReconnectSession(Session: TPrismSession);
begin

end;

procedure TD2RestaurantWebAppGlobal.OnSecurity(const SecEventInfo: TSecuritEventInfo);
begin
  {
    if SecEventInfo.Event = TSecurityEvent.secNotDelistIPBlackList then
    begin
    //Write IP Delist to Reload in WhiteList
    SecEventInfo.IP...
    end;
  }
end;

procedure TD2RestaurantWebAppGlobal.OnRoute(const RestSession: TD2BridgeRestSession; const Request: TPrismHTTPRequest;
  const Response: TPrismHTTPResponse);
begin

end;

procedure TD2RestaurantWebAppGlobal.OnAfterServerStart;
begin
  
end;

procedure TD2RestaurantWebAppGlobal.OnAfterServerStop;
begin

end;

procedure TD2RestaurantWebAppGlobal.OnBeforeServerStart;
begin

end;

procedure TD2RestaurantWebAppGlobal.OnBeforeServerStop;
begin

end;

{$IFNDEF D2BRIDGE}
initialization
  D2BridgeServerController := TD2RestaurantWebAppGlobal.Create(D2BridgeInstance.Owner);
{$ENDIF}

end.
