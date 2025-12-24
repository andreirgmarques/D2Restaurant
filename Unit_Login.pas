unit Unit_Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  D2Bridge.Forms, System.DateUtils; // Declare D2Bridge.Forms always in the last unit

type
  TFormLogin = class(TD2BridgeForm)
    Panel1: TPanel;
    Image_Logo: TImage;
    Label_Login: TLabel;
    Edit_UserName: TEdit;
    Edit_Password: TEdit;
    Button_Login: TButton;
    Image_BackGround: TImage;
    Button_ShowPass: TButton;
    LblDontHaveAccount: TLabel;
    LblSignUp: TLabel;
    procedure Button_LoginClick(Sender: TObject);
    procedure Button_ShowPassClick(Sender: TObject);
    procedure LblSignUpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure LoadCookieUser;
    procedure SaveCookieUser;
    procedure SaveSessionValues;
  public

  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

function FormLogin: TFormLogin;

implementation

uses
  D2RestaurantWebApp, Unit_Dashboard, Unit_MailConfirmation, Unit_DM, Useful;

const
  SESSION_COOKIE_NAME     = 'd2restaurantsession';
  POPUP_MAIL_CONFIRMATION = 'PopupMailConfirmation';

function FormLogin: TFormLogin;
begin
  Result := TFormLogin(TFormLogin.GetInstance);
end;

{$R *.dfm}
{ TForm_Login }

procedure TFormLogin.Button_LoginClick(Sender: TObject);
begin
  if not D2Bridge.API.Mail.IsValiAddress(Edit_UserName.Text) then
  begin
    D2Bridge.Validation(Edit_UserName, False);
    D2Bridge.Validation(Edit_Password, False, 'Email invalid');
    Exit;
  end;

  if Length(Edit_Password.Text) < 6 then
  begin
    D2Bridge.Validation(Edit_UserName, False);
    D2Bridge.Validation(Edit_Password, False, 'Invalid username or password');
    Exit;
  end;

  if DM = nil then
    TDM.CreateInstance;

  DM.QryUser.Close;
  DM.QryUser.MacroByName('filter').AsRaw      := 'WHERE email = :email AND password = :password AND status = ''Active''';
  DM.QryUser.ParamByName('email').AsString    := Edit_UserName.Text;
  DM.QryUser.ParamByName('password').AsString := EncryptPassword(Edit_Password.Text);
  DM.QryUser.Open;

  if DM.QryUser.IsEmpty then
  begin
    D2Bridge.Validation(Edit_UserName, False);
    D2Bridge.Validation(Edit_Password, False, 'Invalid username or password');
    Exit;
  end;

  Self.SaveSessionValues;
  Self.SaveCookieUser;

  if FormDashboard = nil then
    TFormDashboard.CreateInstance;
  FormDashboard.Show;
end;

procedure TFormLogin.Button_ShowPassClick(Sender: TObject);
begin
  if Edit_Password.PasswordChar = '*' then
  begin
    Edit_Password.PasswordChar := #0;

    if IsD2BridgeContext then
      D2Bridge.PrismControlFromVCLObj(Edit_Password).AsEdit.DataType := TPrismFieldType.PrismFieldTypeString;
  end
  else begin
    Edit_Password.PasswordChar := '*';

    if IsD2BridgeContext then
      D2Bridge.PrismControlFromVCLObj(Edit_Password).AsEdit.DataType := TPrismFieldType.PrismFieldTypePassword;
  end;
end;

procedure TFormLogin.ExportD2Bridge;
begin
  inherited;
  Title    := 'My D2Bridge Web Application';
  SubTitle := 'My WebApp';

  // Background color
  D2Bridge.HTML.Render.BodyStyle := 'background-color: #f0f0f0;';

  // TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile   := '';

  if FormMailConfirmation = nil then
    TFormMailConfirmation.CreateInstance;
  D2Bridge.AddNested(FormMailConfirmation);

  // Export yours Controls
  with D2Bridge.Items.add do
  begin
    // Image Backgroup Full Size *Use also ImageFromURL...
//    ImageFromTImage(Image_BackGround, CSSClass.Image.Image_BG20_FullSize);
    ImageFromLocal('support\images\bg\bg.jpg', CSSClass.Image.Image_BG40_FullSize);

    with Card do
    begin
      CSSClasses := CSSClass.Card.Card_Center + ' ' + CSSClass.Space.spacemode;

//      ImageICOFromTImage(Image_Logo, CSSClass.Col.ColSize4);
      ImageICOFromLocal('support\images\logo\logod2restaurant.png', CSSClass.Col.colsize4);

      with BodyItems.add do
      begin
        with Row.Items.add do
          Col.add.VCLObj(Label_Login);

        with Row.Items.add do
          Col.add.VCLObj(Edit_UserName, 'ValidationLogin', true);

        with Row.Items.add do
          with Col.Items.add do // Example Edit + Button same row and col
          begin
            VCLObj(Edit_Password, 'ValidationLogin', true);
            VCLObj(Button_ShowPass, CSSClass.Button.view);
          end;

        with Row.Items.add do
          Col.add.VCLObj(Button_Login, 'ValidationLogin', false, CSSClass.Col.colsize12);

        with Row(CSSClass.Space.SpaceMin_top_bottom).Items.Add do
        begin
          with Col(CSSClass.Col.Align.center).Items.Add do
          begin
            VCLObj(LblDontHaveAccount);
            Link(LblSignUp);
          end;
        end;
      end;
    end;

    with Popup(POPUP_MAIL_CONFIRMATION, '', False, CSSClass.Popup.default).Items.Add do
      Nested(FormMailConfirmation);
  end;
end;

procedure TFormLogin.FormActivate(Sender: TObject);
begin
  Self.LoadCookieUser;
end;

procedure TFormLogin.FormShow(Sender: TObject);
begin
  if IsDebuggerPresent then
  begin
    Edit_UserName.Text := 'andrei@fontdata.com.br';
    Edit_Password.Text := '123456789';
  end;
end;

procedure TFormLogin.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
  inherited;

end;

procedure TFormLogin.LblSignUpClick(Sender: TObject);
begin
  ShowPopup(POPUP_MAIL_CONFIRMATION);
end;

procedure TFormLogin.LoadCookieUser;
begin
  if Session.Cookies.Exist(SESSION_COOKIE_NAME) then
  begin
    var LHash := Session.Cookies.Value[SESSION_COOKIE_NAME];
    if LHash <> '' then
    begin
      if DM = nil then
        TDM.CreateInstance;

      DM.QryUser.Close;
      DM.QryUser.MacroByName('filter').AsRaw  := 'WHERE hash = :hash AND hash_expires > current_timestamp(0) AND status = ''Active''';
      DM.QryUser.ParamByName('hash').AsString := LHash;
      DM.QryUser.Open;
      if not DM.QryUser.IsEmpty then
      begin
        Self.SaveCookieUser;
        Self.SaveSessionValues;

        if FormDashboard = nil then
          TFormDashboard.CreateInstance;
        FormDashboard.Show;
      end
      else begin
        Session.Cookies.Delete(SESSION_COOKIE_NAME);
      end;
    end;
  end;
end;

procedure TFormLogin.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
begin
  inherited;
  // Intercept HTML
  {
    if PrismControl.VCLComponent = Edit1 then
    begin
    HTMLControl:= '</>';
    end;
  }
end;

procedure TFormLogin.SaveCookieUser;
begin
  var LHash    := Session.PushID;
  var LExpires := IncHour(Now, 8);

  try
    DM.QryUser.Edit;
    DM.QryUser.FieldByName('hash').AsString           := LHash;
    DM.QryUser.FieldByName('hash_expires').AsDateTime := LExpires;
    DM.QryUser.Post;
  except
  end;

  // Save cookie value
  Session.Cookies.Add(SESSION_COOKIE_NAME, LHash, LExpires, '/');
end;

procedure TFormLogin.SaveSessionValues;
begin
  D2Restaurant.IdUser      := DM.QryUser.FieldByName('id').AsInteger;
  D2Restaurant.IdAccount   := DM.QryUser.FieldByName('id_account').AsInteger;
  D2Restaurant.UserName    := DM.QryUser.FieldByName('name').AsString;
  D2Restaurant.UserAdmin   := SameText(DM.QryUser.FieldByName('admin').AsString, 'Yes');
  D2Restaurant.UserAccount := SameText(DM.QryUser.FieldByName('account_user').AsString, 'Yes');
  D2Restaurant.UserEmail   := DM.QryUser.FieldByName('email').AsString;
end;

end.
