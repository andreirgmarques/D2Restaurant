unit Unit_CreateAccount;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Vcl.DBCtrls, Vcl.Mask, Vcl.ExtCtrls;

type
  TFormCreateAccount = class(TD2BridgeForm)
    LblFullName: TLabel;
    LblEmail: TLabel;
    LblComplement: TLabel;
    LblCity: TLabel;
    LblCountry: TLabel;
    LblPostalCode: TLabel;
    LblAddress: TLabel;
    LblNumber: TLabel;
    LblDocument: TLabel;
    LblPhone: TLabel;
    LblNeighborhood: TLabel;
    LblState: TLabel;
    LblPassword: TLabel;
    LblConfirmation: TLabel;
    BtnCreateAccount: TButton;
    EdtFullName: TDBEdit;
    EdtEmail: TDBEdit;
    EdtComplement: TDBEdit;
    EdtCity: TDBEdit;
    EdtPostalCode: TDBEdit;
    EdtAddress: TDBEdit;
    EdtNumber: TDBEdit;
    EdtDocument: TDBEdit;
    EdtPhone: TDBEdit;
    EdtNeighborhood: TDBEdit;
    EdtState: TDBEdit;
    EdtPassword: TDBEdit;
    CbxCountry: TDBComboBox;
    EdtConfirmation: TEdit;
    procedure BtnCreateAccountClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

function FormCreateAccount: TFormCreateAccount;

implementation

uses
  D2RestaurantWebApp, Unit_DM, Useful;

{$R *.dfm}

function FormCreateAccount: TFormCreateAccount;
begin
  Result := TFormCreateAccount(TFormCreateAccount.GetInstance);
end;

procedure TFormCreateAccount.BtnCreateAccountClick(Sender: TObject);
begin
  if DM.QryUser.FieldByName('password').AsString.Length < 6 then
  begin
    D2Bridge.Validation(EdtPassword, False, 'Invalid password length');
    Exit;
  end;

  if DM.QryUser.FieldByName('password').AsString <> EdtConfirmation.Text then
  begin
    D2Bridge.Validation(EdtPassword, False, 'Password mismatch');
    D2Bridge.Validation(EdtConfirmation, False, 'Password mismatch');
    Exit;
  end;

  DM.QryAccount.Post;

  DM.QryUser.FieldByName('id_account').AsInteger  := DM.QryAccount.FieldByName('id').AsInteger;
  DM.QryUser.FieldByName('name').AsString         := DM.QryAccount.FieldByName('name').AsString;
  DM.QryUser.FieldByName('email').AsString        := DM.QryAccount.FieldByName('email').AsString;
  DM.QryUser.FieldByName('password').AsString     := EncryptPassword(DM.QryUser.FieldByName('password').AsString);
  DM.QryUser.FieldByName('admin').AsString        := 'Yes';
  DM.QryUser.FieldByName('account_user').AsString := 'Yes';
  DM.QryUser.FieldByName('status').AsString       := 'Active';
  DM.QryUser.Post;

  DM.QryAccount.Edit;
  DM.QryAccount.FieldByName('id_user').AsInteger  := DM.QryUser.FieldByName('id').AsInteger;
  DM.QryAccount.Post;

  Self.Close;
end;

procedure TFormCreateAccount.ExportD2Bridge;
begin
  inherited;
  Title := 'My D2Bridge Form';

  // TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile   := '';

  with D2Bridge.Items.Add do
  begin
    ImageFromLocal('support\images\bg\bgcreateaccount.jpg', CSSClass.Image.Image_BG40_FullSize);

    with Row.Items.Add do
    begin
      with Card do
      begin
        CSSClasses := CSSClass.Card.Card_Center_ExtraLarge;

        with BodyItems.Add do
        begin
          with Row.Items.Add do
          begin
            Col6.Add.FormGroup(LblFullName).AddVCLObj(EdtFullName, 'ValidationAccount', True);
            Col6.Add.FormGroup(LblDocument).AddVCLObj(EdtDocument);
          end;

          with Row.Items.Add do
          begin
            Col6.Add.FormGroup(LblEmail).AddVCLObj(EdtEmail, 'ValidationAccount', True);
            Col6.Add.FormGroup(LblPhone).AddVCLObj(EdtPhone);
          end;

          with Row.Items.Add do
          begin
            Col.Add.FormGroup(LblCountry).AddVCLObj(CbxCountry, 'ValidationAccount', True);
          end;

          with Row.Items.Add do
          begin
            Col3.Add.FormGroup(LblPostalCode).AddVCLObj(EdtPostalCode, 'ValidationAccount', True);
            Col6.Add.FormGroup(LblAddress).AddVCLObj(EdtAddress, 'ValidationAccount', True);
            Col3.Add.FormGroup(LblNumber).AddVCLObj(EdtNumber);
          end;

          with Row.Items.Add do
          begin
            Col6.Add.FormGroup(LblComplement).AddVCLObj(EdtComplement);
            Col6.Add.FormGroup(LblNeighborhood).AddVCLObj(EdtNeighborhood, 'ValidationAccount', True);
          end;

          with Row.Items.Add do
          begin
            Col6.Add.FormGroup(LblCity).AddVCLObj(EdtCity, 'ValidationAccount', True);
            Col6.Add.FormGroup(LblState).AddVCLObj(EdtState, 'ValidationAccount', True);
          end;

          with Row.Items.Add do
          begin
            Col6.Add.FormGroup(LblPassword).AddVCLObj(EdtPassword, 'ValidationAccount', True);
            Col6.Add.FormGroup(LblConfirmation).AddVCLObj(EdtConfirmation, 'ValidationAccount', True);
          end;
        end;

        with Footer.Items.Add do
        begin
          with Row.Items.Add do
          begin
            ColAuto.Add.VCLObj(BtnCreateAccount, 'ValidationAccount', False, CSSClass.Button.save);
          end;
        end;
      end;
    end;
  end;
end;

procedure TFormCreateAccount.FormShow(Sender: TObject);
begin
  DM.QryUser.Close;
  DM.QryUser.MacroByName('filter').AsRaw := 'WHERE false';
  DM.QryUser.Open;
  DM.QryUser.Insert;
end;

procedure TFormCreateAccount.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
  inherited;
  // Change Init Property of Prism Controls
  {
    if PrismControl.VCLComponent = Edit1 then
    PrismControl.AsEdit.DataType:= TPrismFieldType.PrismFieldTypeInteger;

    if PrismControl.IsDBGrid then
    begin
    PrismControl.AsDBGrid.RecordsPerPage:= 10;
    PrismControl.AsDBGrid.MaxRecords:= 2000;
    end;
  }
end;

procedure TFormCreateAccount.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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

end.
