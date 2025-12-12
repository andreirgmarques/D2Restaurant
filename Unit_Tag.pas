unit Unit_Tag;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Unit_CrudTemplate, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.Mask;

type
  TFormTag = class(TFormCrudTemplate)
    LblId: TLabel;
    DBTxtId: TDBText;
    LblTagType: TLabel;
    DBCbxTagType: TDBComboBox;
    LblName: TLabel;
    DBEdtName: TDBEdit;
    LblNumber: TLabel;
    DBEdtNumber: TDBEdit;
    LblDescription: TLabel;
    DBMemDescription: TDBMemo;
    DBCbxStatus: TDBComboBox;
    LblStatus: TLabel;
    PnlBulkInsert: TPanel;
    LblBulkType: TLabel;
    CbxBulkType: TComboBox;
    LblBulkPrefix: TLabel;
    EdtBulkPrefix: TEdit;
    EdtBulkQty: TEdit;
    LblBulkQty: TLabel;
    BtnBulkCreate: TButton;
    BtnBulkInsert: TButton;
    procedure BtnBulkCreateClick(Sender: TObject);
    procedure BtnBulkInsertClick(Sender: TObject);
  private
    { Private declarations }
    procedure OpenQuery;
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
    // CRUD Events
    procedure CrudOnOpen; override;
    procedure CrudOnSearch(AText: string); override;
    function CrudOnEdit: boolean; override;
    function CrudOnInsert: boolean; override;
    function CrudOnSave: boolean; override;
    function CrudOnDelete: boolean; override;
    function CrudOnBack: boolean; override;
    function CrudOnClose: boolean; override;
    // Popup Events
    procedure PopupClosed(const AName: string; const ACloseParam: Variant); override;
  end;

function FormTag: TFormTag;

implementation

uses
  D2RestaurantWebApp, Unit_DM;

{$R *.dfm}

const
  POPUP_BULK_INSERT = 'PopupBulkInsert';

function FormTag: TFormTag;
begin
  Result := TFormTag(TFormTag.GetInstance);
end;

procedure TFormTag.ExportD2Bridge;
begin
  inherited;

  Title    := 'Tag';
  SubTitle := '';

  Crud_PanelTitle.Caption    := 'My Tags';
  Crud_PanelSubTitle.Caption := '';

  // TemplateClassForm:= TD2BridgeFormTemplate;
  // D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  // D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

  with D2Bridge.Items.Add do
  begin
    with Popup(POPUP_BULK_INSERT, 'Bulk Insert').Items.Add do
    begin
      with Row.Items.Add do
        Col.Add.FormGroup(LblBulkType).AddVCLObj(CbxBulkType, 'ValBulk', True);

      with Row.Items.Add do
        Col.Add.FormGroup(LblBulkPrefix).AddVCLObj(EdtBulkPrefix, 'ValBulk', True);

      with Row.Items.Add do
        ColAuto.Add.FormGroup(LblBulkQty).AddVCLObj(EdtBulkQty, 'ValBulk', True);

      with Row.Items.Add do
        ColAuto.Add.VCLObj(BtnBulkCreate, 'ValBulk', False, CSSClass.Button.apply);
    end;
  end;

  with Crud_RowBarSearch.Items.Add do
    ColAuto.Add.VCLObj(BtnBulkInsert);

  with Crud_CardData.Items.Add do
  begin
    with Row.Items.Add do
    begin
      with ColAuto.Items.Add do
      begin
        VCLObj(LblId);
        VCLObj(DBTxtId);
      end;

      with Row.Items.Add do
        Col6.Add.FormGroup(LblTagType).AddVCLObj(DBCbxTagType, CrudValidationGroup, True);

      with Row.Items.Add do
        Col6.Add.FormGroup(LblName).AddVCLObj(DBEdtName, CrudValidationGroup, True);

      with Row.Items.Add do
        Col4.Add.FormGroup(LblNumber).AddVCLObj(DBEdtNumber, CrudValidationGroup, True);

      with Row.Items.Add do
        Col6.Add.FormGroup(LblDescription).AddVCLObj(DBMemDescription);

      with Row.Items.Add do
        Col6.Add.FormGroup(LblStatus).AddVCLObj(DBCbxStatus, CrudValidationGroup, True);
    end;
  end;

  with Crud_CardData.Footer.Items.Add do
  begin
    { Aditional buttons in Footer }
  end;
end;

procedure TFormTag.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TFormTag.OpenQuery;
begin
  DM.QryTag.Close;
  DM.QryTag.MacroByName('filter').AsRaw := 'WHERE id = :id';
  DM.QryTag.ParamByName('id').AsInteger := Crud_Query.FieldByName('id').AsInteger;
  DM.QryTag.Open;
  DM.QryTag.IndexFieldNames := '';
end;

procedure TFormTag.PopupClosed(const AName: string; const ACloseParam: Variant);
begin
  inherited;

  if SameText(AName, POPUP_BULK_INSERT) then
    CrudOperation(OpSearch);
end;

procedure TFormTag.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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

procedure TFormTag.CrudOnOpen;
begin
  inherited;

  CrudOperation(OpSearch);
end;

procedure TFormTag.CrudOnSearch(AText: string);
begin
  inherited;

  Crud_Query.Close;
  Crud_Query.ParamByName('id_account').Value := D2Restaurant.IdAccount;
  Crud_Query.ParamByName('name').Value       := '%' + AText + '%';
  Crud_Query.Open;
end;

function TFormTag.CrudOnEdit: boolean;
begin
  Result := inherited;

  Self.OpenQuery;
  DM.QryTag.Edit;
end;

function TFormTag.CrudOnInsert: boolean;
begin
  Result := inherited;

  Self.OpenQuery;
  DM.QryTag.Insert;
  DM.QryTag.FieldByName('id_account').AsInteger := D2Restaurant.IdAccount;
  DM.QryTag.FieldByName('tag_type').AsString    := 'Table';
  DM.QryTag.FieldByName('status').AsString      := 'Active';
end;

function TFormTag.CrudOnSave: boolean;
begin
  Result := inherited;

  DM.QryTag.Post;
end;

function TFormTag.CrudOnDelete: boolean;
begin
  Result := inherited;

  if DM.QryTag.FieldByName('id').AsInteger > 0 then
  begin
    DM.QrySalesOrder.Close;
    DM.QrySalesOrder.MacroByName('filter').AsRaw     := 'WHERE id_tag = :id_tag';
    DM.QrySalesOrder.ParamByName('id_tag').AsInteger := DM.QryTag.FieldByName('id').AsInteger;
    DM.QrySalesOrder.Open;
    if not DM.QrySalesOrder.IsEmpty then
    begin
      MessageDlg('In use, cannot delete!', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
      Exit(False);
    end;
  end;

  DM.QryTag.Delete;
end;

procedure TFormTag.BtnBulkCreateClick(Sender: TObject);
begin
  inherited;

  var LQty := 0;
  if (not TryStrToInt(EdtBulkQty.Text, LQty)) or (LQty <= 0) then
  begin
    D2Bridge.Validation(EdtBulkQty, False);
    Exit;
  end;

  var LIndex  := 0;
  var LPrefix := Trim(EdtBulkPrefix.Text);

  for var I := 1 to LQty do
  begin
    repeat
      Inc(LIndex);
      DM.QryTag.Close;
      DM.QryTag.MacroByName('filter').AsRaw         := 'WHERE id_account = :id_account AND name LIKE :name';
      DM.QryTag.ParamByName('id_account').AsInteger := D2Restaurant.IdAccount;
      DM.QryTag.ParamByName('name').AsString        := '%' + Format('%s %.3d', [LPrefix, LIndex]) + '%';
      DM.QryTag.Open;
    until DM.QryTag.IsEmpty;

    DM.QryTag.Insert;
    DM.QryTag.FieldByName('id_account').AsInteger   := D2Restaurant.IdAccount;
    DM.QryTag.FieldByName('tag_type').AsString      := CbxBulkType.Text;
    DM.QryTag.FieldByName('name').AsString          := Format('%s %.3d', [LPrefix, LIndex]);
    DM.QryTag.FieldByName('number').AsString        := Format('%.6d', [LIndex]);
    DM.QryTag.FieldByName('status').AsString        := 'Active';
    DM.QryTag.Post;
  end;

  ShowMessage('Bulk created', True, True);
  ClosePopup(POPUP_BULK_INSERT);
end;

procedure TFormTag.BtnBulkInsertClick(Sender: TObject);
begin
  inherited;

  CbxBulkType.ItemIndex := 0;
  EdtBulkPrefix.Text    := 'Table';
  EdtBulkQty.Text       := '1';

  ShowPopup(POPUP_BULK_INSERT);
end;

function TFormTag.CrudOnBack: boolean;
begin
  Result := inherited;

end;

function TFormTag.CrudOnClose: boolean;
begin
  Result := inherited;

  Crud_Query.Close;
end;

end.
