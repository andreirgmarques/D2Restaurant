unit Auth.API.Client;

interface

uses
  System.Classes, System.SysUtils, System.DateUtils, Data.DB, System.JSON, D2Bridge.Rest.Http;

type
  TAuthRestAPIClient = class(TD2BridgeRestClientModule)
  private
    FUser: string;
    FPassword: string;
    FUserId: string;
    FUserName: string;
    FToken: string;
    FTokenRefresh: string;
    FTokenExpires: TDateTime;
    FLogged: boolean;
  protected
  public
    constructor Create(APICore: TObject);

    function Route: string; override;

    procedure Logout;

    function UserId: string;
    function UserName: string;

    function Token: string;
    function TokenExpires: TDateTime;

    function Logged: boolean;

    // Class API
    function Login(AUser, APassword: string): ID2BridgeRestResponse;
    function RefreshToken(ARefreshToken: string): ID2BridgeRestResponse;
    function CurrentUser: ID2BridgeRestResponse;

    // Your other Class API

  end;

implementation

{ TAuthRestAPIClient }

function TAuthRestAPIClient.RefreshToken(ARefreshToken: string): ID2BridgeRestResponse;
var
  vURL: string;
  vJSONAuth: TJSONObject;
begin
  Result := nil;

  vURL := BuildURL(FullEndpoint, 'refreshtoken', []);

  try
    Result := RESTPostToJSON(vURL, ARefreshToken);
  except
  end;

  if not Result.Success then
  begin
    if (Result.StatusCode = HTTPStatus.ErrorUnauthorized) then
      Logout;

    Exit;
  end;

  FLogged   := True;
  vJSONAuth := Result.AsJSONObject;

  FToken        := vJSONAuth.Get('accessToken').JsonValue.AsType<String>;
  FTokenRefresh := ARefreshToken;
  FTokenExpires := IncSecond(IncSecond(Now, vJSONAuth.Get('expiresIn').JsonValue.AsType<Integer>), -20);
end;

function TAuthRestAPIClient.CurrentUser: ID2BridgeRestResponse;
var
  vURL: string;
begin
  Result := nil;

  vURL := BuildURL(FullEndpoint, 'currentuser', []);

  try
    Result := RESTGetToJSON(vURL, FToken);
  except
  end;

  if not Result.Success then
  begin
    if (Result.StatusCode = HTTPStatus.ErrorForbidden) then
      Logout;

    Exit;
  end;
end;

function TAuthRestAPIClient.Route: string;
begin
  Result := 'auth';
end;

constructor TAuthRestAPIClient.Create(APICore: TObject);
begin
  FTokenExpires := 0;
  FLogged       := False;

  inherited Create(APICore);

  TD2BridgeRestClientCore(APICore).OnGetToken := Token;
end;

function TAuthRestAPIClient.Login(AUser, APassword: string): ID2BridgeRestResponse;
var
  vURL: string;
  vJSONAuth: TJSONObject;
begin
  FUser     := AUser;
  FPassword := APassword;

  Result := nil;

  vURL := BuildURL(FullEndpoint, 'login', []);

  try
    Result := RESTPostToJSON(vURL, FUser, FPassword);
  except
  end;

  if not Result.Success then
  begin
    Logout;
    Exit;
  end;

  FLogged   := True;
  vJSONAuth := Result.AsJSONObject;

  FToken        := vJSONAuth.Get('accessToken').JsonValue.AsType<String>;
  FTokenRefresh := vJSONAuth.Get('refreshToken').JsonValue.AsType<String>;
  FTokenExpires := IncSecond(IncSecond(Now, vJSONAuth.Get('expiresIn').JsonValue.AsType<Integer>) - 20);
end;

procedure TAuthRestAPIClient.Logout;
begin
  FTokenExpires := 0;
  FToken        := '';
  FTokenRefresh := '';
  FUserName     := '';
  FUserId       := '';
end;

function TAuthRestAPIClient.UserId: string;
begin
  Result := FUserId;
end;

function TAuthRestAPIClient.UserName: string;
begin
  Result := FUserName;
end;

function TAuthRestAPIClient.Token: string;
begin
  Result := '';

  if (FLogged) and (FTokenExpires < now) and (FTokenRefresh <> '') then
  begin
    if (not RefreshToken(FTokenRefresh).Success) and (FUser <> '') and (FPassword <> '') then
      Login(FUser, FPassword);
  end
  else if (not FLogged) and (FUser <> '') and (FPassword <> '') then
    Login(FUser, FPassword);

  Result := FToken;
end;

function TAuthRestAPIClient.TokenExpires: TDateTime;
begin
  Result := FTokenExpires;
end;

function TAuthRestAPIClient.Logged: boolean;
begin
  Result := FLogged and (FToken <> '');
end;

end.
