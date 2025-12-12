unit Unit_MailConfirmation;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Vcl.ExtCtrls;

type
  TFormMailConfirmation = class(TD2BridgeForm)
    PnlVerify: TPanel;
    LblCodeVerify: TLabel;
    EdtCodeVerify: TEdit;
    BtnVerify: TButton;
    PnlEmail: TPanel;
    LblEnterYourEmail: TLabel;
    EdtEnterYourEmail: TEdit;
    BtnClose: TButton;
    BtnSendCode: TButton;
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnSendCodeClick(Sender: TObject);
    procedure BtnVerifyClick(Sender: TObject);
  private
    { Private declarations }
    FAttempts: Integer;
    FSecret: String;
    procedure SendConfirmationMail;
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String); override;
  end;

function FormMailConfirmation: TFormMailConfirmation;

implementation

uses
  D2RestaurantWebApp, Unit_DM, Unit_CreateAccount;

{$R *.dfm}

function FormMailConfirmation: TFormMailConfirmation;
begin
  Result := TFormMailConfirmation(TFormMailConfirmation.GetInstance);
end;

procedure TFormMailConfirmation.BtnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFormMailConfirmation.BtnSendCodeClick(Sender: TObject);
begin
  if not D2Bridge.API.Mail.IsValiAddress(EdtEnterYourEmail.Text) then
  begin
    D2Bridge.Validation(EdtEnterYourEmail, False, 'Email invalid');
    Exit;
  end;

  if DM = nil then
    TDM.CreateInstance;

  DM.QryUser.Close;
  DM.QryUser.MacroByName('filter').AsRaw   := 'WHERE email = :email';
  DM.QryUser.ParamByName('email').AsString := EdtEnterYourEmail.Text;
  DM.QryUser.Open;

  if not DM.QryUser.IsEmpty then
  begin
    ShowMessage('Email already exists', True, True);
    Exit;
  end;

  FAttempts := 5;

  Self.SendConfirmationMail;

  PnlEmail.Visible       := False;
  PnlVerify.Visible      := True;
end;

procedure TFormMailConfirmation.BtnVerifyClick(Sender: TObject);
begin
  if FAttempts <= 0 then
    Exit;

  Dec(FAttempts);

  var LCode := 0;
  if (not TryStrToInt(Trim(EdtCodeVerify.Text), LCode)) or (LCode <> StrToInt(FSecret)) then
  begin
    D2Bridge.Validation(EdtCodeVerify, False, 'Invalid code ' + FAttempts.ToString + ' attempts remaining');
  end
  else begin
    DM.QryAccount.Close;
    DM.QryAccount.MacroByName('filter').AsRaw    := 'WHERE false';
    DM.QryAccount.Open;
    DM.QryAccount.Insert;
    DM.QryAccount.FieldByName('email').AsString  := EdtEnterYourEmail.Text;
    DM.QryAccount.FieldByName('date').AsDateTime := Now;
    DM.QryAccount.FieldByName('status').AsString := 'Active';

    if FormCreateAccount = nil then
      TFormCreateAccount.CreateInstance;
    FormCreateAccount.Show;
    Exit;
  end;

  if FAttempts <= 0 then
  begin
    MessageDlg('Your attempts have been exhausted', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbCancel], 0);
    Session.Close(False);
  end;
end;

procedure TFormMailConfirmation.ExportD2Bridge;
begin
  inherited;
  Title := 'My D2Bridge Form';

  // TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile   := '';

  with D2Bridge.Items.Add do
  begin
    with Row(CSSClass.Space.spacemode).Items.Add do
      Col.Add.FormGroup(LblEnterYourEmail).AddVCLObj(EdtEnterYourEmail, 'ValEmail', True);

    with Row(CSSClass.Space.spacemode).Items.Add do
    begin
      Col.Add.VCLObj(BtnClose, CSSClass.Button.close + ' ' + CSSClass.Col.col12);
      Col.Add.VCLObj(BtnSendCode, 'ValEmail', False, CSSClass.Button.send + ' ' + CSSClass.Col.col12);
    end;

    with Row(CSSClass.Space.spacemode).Items.Add do
      Col.Add.FormGroup(LblCodeVerify).AddVCLObj(EdtCodeVerify, 'ValVerify', True);

    with Row(CSSClass.Space.spacemode).Items.Add do
      Col.Add.VCLObj(BtnVerify, 'ValVerify', False, CSSClass.Button.send + ' ' + CSSClass.Col.col12);
  end;
end;

procedure TFormMailConfirmation.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
  inherited;
  if PrismControl.VCLComponent = EdtEnterYourEmail then
    PrismControl.AsEdit.TextMask := TPrismTextMask.Email;
end;

procedure TFormMailConfirmation.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String);
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

procedure TFormMailConfirmation.SendConfirmationMail;
begin
  FSecret := '';

  while FSecret.Length < 6 do
    FSecret := FSecret + Random(9).ToString;

  with DM.ACBrMail do
  begin
    FromName                 := 'D2Restaurant';
    From                     := 'd2restaurant@fontdata.com.br';
    Subject                  := 'D2Restaurant confirmation code ' + FSecret;
    AddAddress(EdtEnterYourEmail.Text);
    Body.LoadFromFile(APPConfig.Path.App + 'support' + PathDelim + 'email' + PathDelim + 'confirmationcode.html');
    Body.Text                := Body.Text.Replace('{{code}}', FSecret, [rfIgnoreCase, rfReplaceAll]);
    Send(False);
  end;
end;

end.
