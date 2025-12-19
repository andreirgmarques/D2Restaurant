unit Unit_SalesOrderCategory;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TFormSalesOrderCategory = class(TD2BridgeForm)
    DbgCategory: TDBGrid;
    BtnSelect: TButton;
    procedure BtnSelectClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure OpenQuery;
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String); override;
  end;

function FormSalesOrderCategory: TFormSalesOrderCategory;

implementation

uses
  D2RestaurantWebApp, Unit_DM, Unit_SalesOrderProduct;

const
  POPUP_SALES_ORDER_PRODUCT = 'PopupSalesOrderProduct';

{$R *.dfm}

function FormSalesOrderCategory: TFormSalesOrderCategory;
begin
  Result := TFormSalesOrderCategory(TFormSalesOrderCategory.GetInstance);
end;

procedure TFormSalesOrderCategory.BtnSelectClick(Sender: TObject);
begin
  ShowPopup(POPUP_SALES_ORDER_PRODUCT);
end;

procedure TFormSalesOrderCategory.ExportD2Bridge;
begin
  inherited;
  Title := 'My D2Bridge Form';

  // TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile   := '';

  if FormSalesOrderProduct = nil then
    TFormSalesOrderProduct.CreateInstance;
  D2Bridge.AddNested(FormSalesOrderProduct);

  with D2Bridge.Items.add do
  begin
    with Row.Items.Add do
      Col.Add.VCLObj(DbgCategory);

    Popup(POPUP_SALES_ORDER_PRODUCT, 'Product').Items.Add.Nested(FormSalesOrderProduct);
  end;
end;

procedure TFormSalesOrderCategory.FormShow(Sender: TObject);
begin
  Self.OpenQuery;
end;

procedure TFormSalesOrderCategory.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
  inherited;
  if PrismControl.VCLComponent = DbgCategory then
  begin
    PrismControl.AsDBGrid.ShowPager := False;

    with PrismControl.AsDBGrid.Columns.Add do
    begin
      ColumnIndex := 0;
      Title       := D2Bridge.LangNav.Button.CaptionOptions;
      Width       := 64;

      with Buttons.Add do
      begin
        ButtonModel := TButtonModel.checkmark;
        Caption     := BtnSelect.Caption;
        OnClick     := BtnSelectClick;
      end;
    end;
  end;
end;

procedure TFormSalesOrderCategory.OpenQuery;
begin
  DM.QryProductCategory.Close;
  DM.QryProductCategory.MacroByName('filter').AsRaw         := 'WHERE id_account = :id_account AND status = ''Active''';
  DM.QryProductCategory.ParamByName('id_account').AsInteger := D2Restaurant.IdAccount;
  DM.QryProductCategory.Open;
  DM.QryProductCategory.IndexFieldNames := 'name';
end;

procedure TFormSalesOrderCategory.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String);
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
