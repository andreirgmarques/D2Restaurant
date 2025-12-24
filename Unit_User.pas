unit Unit_User;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, D2Bridge.Forms, Unit_CrudTemplate, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.DBCtrls, Vcl.Mask;

type
  TFormUser = class(TFormCrudTemplate)
    LblName: TLabel;
    DBEdtName: TDBEdit;
    DBEdtPhone: TDBEdit;
    LblPhone: TLabel;
    DBEdtEmail: TDBEdit;
    LblEmail: TLabel;
    LblAdmin: TLabel;
    DBChkAdmin: TDBCheckBox;
    DBCbxStatus: TDBComboBox;
    LblStatus: TLabel;
    BtnChangePassword: TButton;
    GpxPassword: TGroupBox;
    LblOldPassword: TLabel;
    EdtOldPassword: TEdit;
    EdtNewPassword: TEdit;
    LblNewPassword: TLabel;
    EdtConfirmPassword: TEdit;
    LblConfirmPassword: TLabel;
    BtnSaveNewPassword: TButton;
    QryUserValidEmail: TFDQuery;
    procedure BtnChangePasswordClick(Sender: TObject);
    procedure BtnSaveNewPasswordClick(Sender: TObject);
  private
    { Private declarations }
    function IsValidEmail: Boolean;
    procedure OpenQuery(AId: Integer);
    procedure StatusComponents;
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String); override;
    // CRUD Events
    procedure CrudOnOpen; override;
    procedure CrudOnSearch(AText: String); override;
    function CrudOnEdit: Boolean; override;
    function CrudOnInsert: Boolean; override;
    function CrudOnSave: Boolean; override;
    function CrudOnDelete: Boolean; override;
    function CrudOnBack: Boolean; override;
    function CrudOnClose: Boolean; override;
  end;

function FormUser: TFormUser;

implementation

uses
  D2RestaurantWebApp, Unit_DM, Useful;

const
  POPUP_ALTER_PASSWORD = 'PopupAlterPassword';

{$R *.dfm}

function FormUser: TFormUser;
begin
  Result := TFormUser(TFormUser.GetInstance);
end;

procedure TFormUser.ExportD2Bridge;
begin
  inherited;
  Title    := 'User';
  SubTitle := '';

  Crud_PanelTitle.Caption    := 'User';
  Crud_PanelSubTitle.Caption := '';

  // TemplateClassForm:= TD2BridgeFormTemplate;
  // D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  // D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

  with D2Bridge.Items.Add do
  begin
    with Popup(POPUP_ALTER_PASSWORD, 'Password', True, CSSClass.Popup.Small).Items.Add do
    begin
      with Row.Items.Add do
        FormGroup(LblOldPassword, CSSClass.Col.col).AddVCLObj(EdtOldPassword, 'ValidPassword', True);

      with Row.Items.Add do
        FormGroup(LblNewPassword, CSSClass.Col.col).AddVCLObj(EdtNewPassword, 'ValidPassword', True);

      with Row.Items.Add do
        FormGroup(LblConfirmPassword, CSSClass.Col.col).AddVCLObj(EdtConfirmPassword, 'ValidPassword', True);

      with Row(CSSClass.Space.margim_top4).Items.Add do
        Col.Add.VCLObj(BtnSaveNewPassword, 'ValidPassword', False, CSSClass.Button.save + ' ' + CSSClass.Col.colsize12);
    end;
  end;

  with Crud_CardData.Items.Add do
  begin
    with Row.Items.Add do
      Col8.Add.FormGroup(LblName).AddVCLObj(DBEdtName, CrudValidationGroup, True);

    with Row.Items.Add do
      Col8.Add.FormGroup(LblPhone).AddVCLObj(DBEdtPhone);

    with Row.Items.Add do
      Col8.Add.FormGroup(LblEmail).AddVCLObj(DBEdtEmail, CrudValidationGroup, True);

    with Row.Items.Add do
    begin
      ColAuto.Add.VCLObj(LblAdmin);
      ColAuto.Add.VCLObj(DBChkAdmin);
    end;

    with Row.Items.Add do
      Col4.Add.FormGroup(LblStatus).AddVCLObj(DBCbxStatus, CrudValidationGroup, True);

    with Row.Items.Add do
      ColAuto.Add.VCLObj(BtnChangePassword, CSSClass.Button.TypeButton.Default.info);
  end;

  with Crud_CardData.Footer.Items.Add do
  begin
    { Aditional buttons in Footer }
  end;
end;

procedure TFormUser.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
  inherited;
  // Change CRUD Component property
  {
    if PrismControl.VCLComponent = Crud_DBGrid_Search then
    begin
    with PrismControl.AsDBGrid do
    begin
    with Columns.ColumnByIndex(0) do
    begin
    //Example button EDIT invisible
    ButtonFromButtonModel(TButtonModel.Edit).Visible:= false;
    //Example button EDIT disabled
    ButtonFromButtonModel(TButtonModel.Edit).Enabled:= false;

    //Example Add new Button
    Width:= 105;
    with Buttons.Add do
    begin
    ButtonModel:= TButtonModel.Options;
    Caption:= '';
    end;
    end;
    end;
    end;
  }
end;

function TFormUser.IsValidEmail: Boolean;
begin
  Result := False;

  if not D2Bridge.API.Mail.IsValiAddress(DM.QryUser.FieldByName('email').AsString) then
  begin
    D2Bridge.Validation(DBEdtEmail, False, 'Email invalid');
    Exit;
  end;

  QryUserValidEmail.Close;
  QryUserValidEmail.ParamByName('id').AsInteger   := DM.QryUser.FieldByName('id').AsInteger;
  QryUserValidEmail.ParamByName('email').AsString := DM.QryUser.FieldByName('email').AsString;
  QryUserValidEmail.Open;
  if not QryUserValidEmail.IsEmpty then
  begin
    QryUserValidEmail.Close;
    D2Bridge.Validation(DBEdtEmail, False, 'Email already exists in another registry');
    Exit;
  end;
  QryUserValidEmail.Close;

  Result := True;
end;

procedure TFormUser.OpenQuery(AId: Integer);
begin
  DM.QryUser.Close;
  DM.QryUser.MacroByName('filter').AsRaw := 'WHERE id = :id';
  DM.QryUser.ParamByName('id').AsInteger := AId;
  DM.QryUser.Open;
  Self.StatusComponents;
end;

procedure TFormUser.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String);
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

procedure TFormUser.StatusComponents;
begin
  DBEdtEmail.Enabled        := not SameText(DM.QryUser.FieldByName('account_user').AsString, 'Yes');
  DBChkAdmin.Enabled        := not SameText(DM.QryUser.FieldByName('account_user').AsString, 'Yes');
  DBCbxStatus.Enabled       := not SameText(DM.QryUser.FieldByName('account_user').AsString, 'Yes');
  BtnChangePassword.Visible := ActiveOperation <> OpInsert;
end;

procedure TFormUser.CrudOnOpen;
begin
  inherited;
  CrudOperation(OpSearch);
end;

procedure TFormUser.CrudOnSearch(AText: String);
begin
  inherited;
  Crud_Query.Close;
  Crud_Query.ParamByName('id_account').AsInteger := D2Restaurant.IdAccount;
  Crud_Query.ParamByName('name').AsString        := '%' + AText + '%';
  Crud_Query.Open;
end;

function TFormUser.CrudOnEdit: Boolean;
begin
  Result := inherited;
  Self.OpenQuery(Crud_Query.FieldByName('id').AsInteger);
  DM.QryUser.Edit;
end;

function TFormUser.CrudOnInsert: Boolean;
begin
  Result := inherited;
  Self.OpenQuery(0);
  DM.QryUser.Insert;
  DM.QryUser.FieldByName('id_account').AsInteger  := D2Restaurant.IdAccount;
  DM.QryUser.FieldByName('admin').AsString        := 'No';
  DM.QryUser.FieldByName('account_user').AsString := 'No';
  DM.QryUser.FieldByName('status').AsString       := 'Active';
end;

function TFormUser.CrudOnSave: Boolean;
begin
  Result := False;

  if DM.QryUser.FieldByName('name').AsString.Length < 10 then
  begin
    D2Bridge.Validation(DBEdtName, False, 'Name invalid');
    Exit;
  end;

  if not Self.IsValidEmail then
    Exit;

  if DM.QryUser.FieldByName('id').AsInteger <= 0 then
  begin
    EdtOldPassword.Visible := False;
    ShowPopupModal(POPUP_ALTER_PASSWORD);
    if DM.QryUser.FieldByName('password').AsString = '' then
      Exit;
  end;

  DM.QryUser.Post;

  Result := True;
end;

function TFormUser.CrudOnDelete: Boolean;
begin
  Result := inherited;

  // FIX Closed Query
  if ActiveOperation = OpSearch then
    Self.OpenQuery(Crud_Query.FieldByName('id').AsInteger);

  if DM.QryUser.FieldByName('id').AsInteger > 0 then
  begin
    var LQtdSalesOrder := DM.DBConnection.ExecSQLScalar(
                            'SELECT COALESCE(count(*),0) FROM sales_order WHERE id_user = :id_user',
                            [DM.QryUser.FieldByName('id').AsInteger],
                            [ftInteger]
                          );
    if LQtdSalesOrder > 0 then
    begin
      MessageDlg('In use, cannot delete!', mtError, [mbOK], 0);
      Result := False;
      Exit;
    end;
  end;

  DM.QryUser.Delete;
end;

procedure TFormUser.BtnChangePasswordClick(Sender: TObject);
begin
  inherited;
  EdtOldPassword.Visible  := D2Restaurant.IdUser = DM.QryUser.FieldByName('id').AsInteger;
  EdtNewPassword.Text     := '';
  EdtConfirmPassword.Text := '';
  ShowPopup(POPUP_ALTER_PASSWORD);
end;

procedure TFormUser.BtnSaveNewPasswordClick(Sender: TObject);
begin
  inherited;
  if EdtOldPassword.Visible and (EncryptPassword(EdtOldPassword.Text) <> DM.QryUser.FieldByName('password').AsString) then
  begin
    D2Bridge.Validation(EdtOldPassword, False, 'Old Password incorrect');
    Exit;
  end;

  if Length(EdtNewPassword.Text) < 6 then
  begin
    D2Bridge.Validation(EdtNewPassword, False, 'Length Password is minor than 6 caracteres');
    Exit;
  end;

  if (EdtNewPassword.Text <> EdtConfirmPassword.Text) then
  begin
    D2Bridge.Validation(EdtNewPassword, False);
    D2Bridge.Validation(EdtConfirmPassword, False, 'Password not match');
    Exit;
  end;

  DM.QryUser.Edit;
  DM.QryUser.FieldByName('password').AsString := EncryptPassword(EdtConfirmPassword.Text);

  if ActiveOperation <> OpInsert then
    ShowMessage('Password change successfully save to apply', True, True);

  ClosePopup(POPUP_ALTER_PASSWORD);
end;

function TFormUser.CrudOnBack: Boolean;
begin
  Result := inherited;
end;

function TFormUser.CrudOnClose: Boolean;
begin
  Result := inherited;
  Crud_Query.Close;
end;

end.
