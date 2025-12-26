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

uses Useful;

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
begin
  if (Request.User = '') or (Request.Password = '') then
  begin
    Response.JSON(HTTPStatus.ErrorUnauthorized, 'User or Password not found');
    Exit;
  end;

  var LUserName := Request.User;
  var LPassword := EncryptPassword(Request.Password);

  RestSession.DM.QryUser.Close;
  RestSession.DM.QryUser.MacroByName('filter').AsRaw      := 'WHERE email = :email AND password = :password AND status = ''Active''';
  RestSession.DM.QryUser.ParamByName('email').AsString    := LUserName;
  RestSession.DM.QryUser.ParamByName('password').AsString := LPassword;
  RestSession.DM.QryUser.Open;
  if RestSession.DM.QryUser.IsEmpty then
  begin
    Response.JSON(HTTPStatus.ErrorUnauthorized, 'User or Password invalid');
    Exit;
  end;

  var LUserID   := RestSession.DM.QryUser.FieldByName('id').AsString;
  var LIdentity := RestSession.DM.QryUser.FieldByName('id_account').AsString;

  Response.JSON.AddPair('accessToken', RestSecurity.JWTAccess.Token(LUserID, LIdentity));
  Response.JSON.AddPair('refreshToken', RestSecurity.JWTRefresh.Token(LUserID, LIdentity));
  Response.JSON.AddPair('expiresIn', TJSONNumber.Create(RestSecurity.JWTAccess.ExpirationSeconds));

  // Custom Login information
  Response.JSON.AddPair('userid', LUserID);
  Response.JSON.AddPair('username', Request.User);
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
  RestSession.DM.QryAccount.Close;
  RestSession.DM.QryAccount.MacroByName('filter').AsRaw      := 'WHERE id = :id AND status = ''Active''';
  RestSession.DM.QryAccount.ParamByName('id').AsInteger      := Request.JWTidentity.ToInteger;
  RestSession.DM.QryAccount.Open;
  if RestSession.DM.QryAccount.IsEmpty then
  begin
    Response.JSON(HTTPStatus.ErrorForbidden, 'Account not found');
    Exit;
  end;

  RestSession.DM.QryUser.Close;
  RestSession.DM.QryUser.MacroByName('filter').AsRaw         := 'WHERE id_account = :id_account AND id = :id AND status = ''Active''';
  RestSession.DM.QryUser.ParamByName('id_account').AsInteger := Request.JWTidentity.ToInteger;
  RestSession.DM.QryUser.ParamByName('id').AsInteger         := Request.JWTsub.ToInteger;
  RestSession.DM.QryUser.Open;
  if RestSession.DM.QryUser.IsEmpty then
  begin
    Response.JSON(HTTPStatus.ErrorForbidden, 'User invalid');
    Exit;
  end;

  Response.JSON.AddPair('accountid', RestSession.DM.QryAccount.FieldByName('id').AsInteger);
  Response.JSON.AddPair('accountname', RestSession.DM.QryAccount.FieldByName('name').AsString);
  Response.JSON.AddPair('userid', RestSession.DM.QryUser.FieldByName('id').AsInteger);
  Response.JSON.AddPair('username', RestSession.DM.QryUser.FieldByName('name').AsString);
  Response.JSON.AddPair('useremail', RestSession.DM.QryUser.FieldByName('email').AsString);
  Response.JSON.AddPair('useradmin', SameText(RestSession.DM.QryUser.FieldByName('admin').AsString, 'Yes'));
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
