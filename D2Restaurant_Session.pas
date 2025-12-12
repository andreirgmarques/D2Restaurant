unit D2Restaurant_Session;

interface

uses
  SysUtils, Classes, Prism.SessionBase;

type
  TD2RestaurantSession = class(TPrismSessionBase)
  private
    FIdUser: Integer;
    FIdAccount: Integer;
    FUserName: String;
    FUserAdmin: Boolean;
    FUserAccount: Boolean;
    FUserEmail: String;
  public
    property IdUser: Integer read FIdUser write FIdUser;
    property IdAccount: Integer read FIdAccount write FIdAccount;
    property UserName: String read FUserName write FUserName;
    property UserAdmin: Boolean read FUserAdmin write FUserAdmin;
    property UserAccount: Boolean read FUserAccount write FUserAccount;
    property UserEmail: String read FUserEmail write FUserEmail;

    constructor Create(APrismSession: TPrismSession); override; // OnNewSession
    destructor Destroy; override; // OnCloseSession
  end;

implementation

uses
  D2Bridge.Instance,
  D2RestaurantWebApp;

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

constructor TD2RestaurantSession.Create(APrismSession: TPrismSession); // OnNewSession
begin
  inherited;
  // Your code

end;

destructor TD2RestaurantSession.Destroy; // OnCloseSession
begin
  // Close ALL DataBase connection
  // Ex: Dm.DBConnection.Close;

  inherited;
end;

end.
