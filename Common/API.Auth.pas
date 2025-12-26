unit API.Auth;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils, JSON,
  Prism.Types,
  D2Bridge.JSON, D2Bridge.Rest.Entity,
  D2Bridge.Rest.Server.Functions,
  D2Bridge.Rest.Session;

type
  TAPIAuth = class(TD2BridgeRestEntity)
  private
    // My Class Var
    // class var FValueStr: string;
    // My EndPoints
    class procedure PostLogin(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
      Response: TPrismHTTPResponse);
    class procedure PostRefreshToken(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
      Response: TPrismHTTPResponse);
    class procedure GetCurrentUser(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
      Response: TPrismHTTPResponse);
    class procedure Health(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
      Response: TPrismHTTPResponse);
  protected
    // Register EndPoints
    class procedure RegisterEndPoints; override;
    // Events
    class procedure OnNewRestSession(const RestSession: TD2BridgeRestSession); override;
    class procedure OnCloseRestSession(const RestSession: TD2BridgeRestSession); override;
    class procedure OnBeforeRestMethod(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
      Response: TPrismHTTPResponse; CanExecute: boolean); override;
    class procedure OnAfterRestMethod(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
      Response: TPrismHTTPResponse); override;
  public
    // class constructor Create;
    // class destructor Destroy;
  end;

implementation

{ TAPIAuth }

// Register Endpoints
class procedure TAPIAuth.RegisterEndPoints;
begin
  AddPost('/api/auth/login', PostLogin);
  AddPost('/api/auth/refreshtoken', PostRefreshToken, True); // True -> Require Auth JWT
  AddGet('/api/auth/currentuser', GetCurrentUser, True); // True -> Require Auth JWT
  AddGet('/api/health', Health);
end;

// Using Basic Auth for User and Password
class procedure TAPIAuth.PostLogin(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
  Response: TPrismHTTPResponse);
var
  vUserID: string;
  vIdentity: string;
begin
  if (Request.User = 'UserD2Bridge') and (Request.Password = '123456') then
  begin
    vUserID   := 'UserD2Bridge'; // ID User *Example
    vIdentity := 'My Unique Identity'; // Identity of Session *Optional

    Response.JSON.AddPair('accessToken', RestSecurity.JWTAccess.Token(vUserID, vIdentity));
    Response.JSON.AddPair('refreshToken', RestSecurity.JWTRefresh.Token(vUserID, vIdentity));
    Response.JSON.AddPair('expiresIn', TJSONNumber.Create(RestSecurity.JWTAccess.ExpirationSeconds));

    // Custom Login information
    Response.JSON.AddPair('userid', vUserID);
    Response.JSON.AddPair('username', Request.User);
  end;
end;

// Refresh Valid Token
class procedure TAPIAuth.PostRefreshToken(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
  Response: TPrismHTTPResponse);
begin
  if (Request.JWTTokenType = JWTTokenRefresh) and (Request.JWTvalid) then
  begin
    // Check User ?
    // if not User then
    // begin
    // Response.JSON(HTTPStatus.ErrorUnauthorized, 'User invalid');
    // exit;
    // end;

    Response.JSON.AddPair('accessToken', RestSecurity.JWTAccess.Token(Request.JWTsub, Request.JWTidentity));
    Response.JSON.AddPair('expiresIn', TJSONNumber.Create(RestSecurity.JWTAccess.ExpirationSeconds));
  end
  else
  begin
    Response.JSON(HTTPStatus.ErrorForbidden, 'Refresh Token Invalid');
    exit;
  end;
end;

// Get User example
class procedure TAPIAuth.GetCurrentUser(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
  Response: TPrismHTTPResponse);
begin
  // Get User ID from Token
  Response.JSON.AddPair('userid', Request.JWTsub);
end;

// Health example
class procedure TAPIAuth.Health(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
  Response: TPrismHTTPResponse);
begin
  Response.JSON(HTTPStatus.SuccessOK, 'Server OK');
end;

// Event NewSession
class procedure TAPIAuth.OnNewRestSession(const RestSession: TD2BridgeRestSession);
begin

end;

// Event Berfore Call Rest Method
class procedure TAPIAuth.OnBeforeRestMethod(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
  Response: TPrismHTTPResponse; CanExecute: boolean);
begin
  {
    if (RestSession.WebMethod = wmtGET) and (RestSession.Path = '/ping') then
    begin
    CanExecute:= false;
    end;
  }
end;

// Event After Call Rest Method
class procedure TAPIAuth.OnAfterRestMethod(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
  Response: TPrismHTTPResponse);
begin
  {
    if (RestSession.WebMethod = wmtGET) and (RestSession.Path = '/ping') then
    begin
    CanExecute:= false;
    end;
  }
end;

// Event Close Session
class procedure TAPIAuth.OnCloseRestSession(const RestSession: TD2BridgeRestSession);
begin

end;

initialization
  TAPIAuth.Initialize;

end.
