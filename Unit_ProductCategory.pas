unit Unit_ProductCategory;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Unit_CrudTemplate, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.Mask;

type
  TFormProductCategory = class(TFormCrudTemplate)
    LblName: TLabel;
    DBEdtName: TDBEdit;
    DBMemDescription: TDBMemo;
    LblDescription: TLabel;
    LblStatus: TLabel;
    DBCbxStatus: TDBComboBox;
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
  end;

function FormProductCategory: TFormProductCategory;

implementation

uses
  D2RestaurantWebApp, Unit_DM;

{$R *.dfm}

function FormProductCategory: TFormProductCategory;
begin
  Result := TFormProductCategory(TFormProductCategory.GetInstance);
end;

procedure TFormProductCategory.ExportD2Bridge;
begin
  inherited;

  Title    := 'Category';
  SubTitle := '';

  Crud_PanelTitle.Caption    := 'Product Category';
  Crud_PanelSubTitle.Caption := '';

  // TemplateClassForm:= TD2BridgeFormTemplate;
  // D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  // D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

  with Crud_CardData.Items.Add do
  begin
    with Row.Items.Add do
      Col6.Add.FormGroup(LblName).AddVCLObj(DBEdtName, CrudValidationGroup, True);

    with Row.Items.Add do
      Col6.Add.FormGroup(LblDescription).AddVCLObj(DBMemDescription);

    with Row.Items.Add do
      Col6.Add.FormGroup(LblStatus).AddVCLObj(DBCbxStatus, CrudValidationGroup, True);
  end;

  with Crud_CardData.Footer.Items.Add do
  begin
    { Aditional buttons in Footer }
  end;
end;

procedure TFormProductCategory.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TFormProductCategory.OpenQuery;
begin
  DM.QryProductCategory.Close;
  DM.QryProductCategory.MacroByName('filter').AsRaw := 'WHERE id = :id';
  DM.QryProductCategory.ParamByName('id').AsInteger := Crud_Query.FieldByName('id').AsInteger;
  DM.QryProductCategory.Open;
  DM.QryProductCategory.IndexFieldNames := '';
end;

procedure TFormProductCategory.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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

procedure TFormProductCategory.CrudOnOpen;
begin
  inherited;

  CrudOperation(OpSearch);
end;

procedure TFormProductCategory.CrudOnSearch(AText: string);
begin
  inherited;

  Crud_Query.Close;
  Crud_Query.SQL.Text := 'SELECT * FROM product_category WHERE id_account = :id_account AND name LIKE :name ORDER BY name';
  Crud_Query.ParamByName('id_account').AsInteger := D2Restaurant.IdAccount;
  Crud_Query.ParamByName('name').AsString        := '%' + AText + '%';
  Crud_Query.Open;
end;

function TFormProductCategory.CrudOnEdit: Boolean;
begin
  Result := inherited;

  Self.OpenQuery;
  DM.QryProductCategory.Edit;
end;

function TFormProductCategory.CrudOnInsert: Boolean;
begin
  Result := inherited;

  Self.OpenQuery;
  DM.QryProductCategory.Insert;
  DM.QryProductCategory.FieldByName('id_account').AsInteger := D2Restaurant.IdAccount;
  DM.QryProductCategory.FieldByName('status').AsString      := 'Active';
end;

function TFormProductCategory.CrudOnSave: Boolean;
begin
  Result := inherited;

  DM.QryProductCategory.Post;
end;

function TFormProductCategory.CrudOnDelete: Boolean;
begin
  Result := inherited;

  if DM.QryProductCategory.FieldByName('id').AsInteger > 0 then
  begin
    DM.QryProduct.Close;
    DM.QryProduct.MacroByName('filter').AsRaw                  := 'WHERE id_product_category = :id_product_category';
    DM.QryProduct.ParamByName('id_product_category').AsInteger := DM.QryProductCategory.FieldByName('id').AsInteger;
    DM.QryProduct.Open;
    if not DM.QryProduct.IsEmpty then
    begin
      MessageDlg('In use, cannot delete!', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
      Exit(False);
    end;
  end;

  DM.QryProductCategory.Delete;
end;

function TFormProductCategory.CrudOnBack: Boolean;
begin
  Result := inherited;

end;

function TFormProductCategory.CrudOnClose: Boolean;
begin
  Result := inherited;

  DM.QryProductCategory.Close;
end;

end.
