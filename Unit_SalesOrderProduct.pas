unit Unit_SalesOrderProduct;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Vcl.DBCtrls, Vcl.ExtCtrls;

type
  TFormSalesOrderProduct = class(TD2BridgeForm)
    DBTxtProductCategory: TDBText;
    PnlProduct: TPanel;
    DBTxtProduct: TDBText;
    LblPrice: TLabel;
    DBTxtPrice: TDBText;
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
    procedure CardGridClick(APrismControlClick: TPrismControl; ARow: Integer; APrismCardGrid: TPrismCardGridDataModel); override;
  end;

function FormSalesOrderProduct: TFormSalesOrderProduct;

implementation

uses
  D2RestaurantWebApp, Unit_DM, Unit_SalesOrder;

{$R *.dfm}

function FormSalesOrderProduct: TFormSalesOrderProduct;
begin
  Result := TFormSalesOrderProduct(TFormSalesOrderProduct.GetInstance);
end;

procedure TFormSalesOrderProduct.CardGridClick(APrismControlClick: TPrismControl; ARow: Integer;
  APrismCardGrid: TPrismCardGridDataModel);
begin
  inherited;
  FormSalesOrder.AddSalesOrderItem;
end;

procedure TFormSalesOrderProduct.ExportD2Bridge;
begin
  inherited;
  Title := 'My D2Bridge Form';

  // TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile   := '';

  var LFolderImage := APPConfig.Path.Data + 'support\images\product\';
  with D2Bridge.Items.add do
  begin
    with Row(CSSClass.Space.SpaceMin_top_bottom).Items.Add do
      Col.Add.VCLObj(DBTxtProductCategory);

    with Row.Items.Add do
    begin
      with Col.Add do
      begin
        with CardGrid(DM.DscProduct) do
        begin
          CardGridSize := CSSClass.CardGrid.CardGridX3;
          Space        := CSSClass.Space.gutter4;

          with CardDataModel do
          begin
            BorderColor := clSilver;
            ImageTOPFromDB(LFolderImage, DM.DscProduct, 'image_file', CSSClass.Image.Image_Card_Square);

            with BodyItems.Add do
            begin
              with Row.Items.Add do
                Col.Add.VCLObj(DBTxtProduct);

              with Row.Items.Add do
              begin
                with Col(CSSClass.Col.Align.right).Items.Add do
                begin
                  VCLObj(LblPrice);
                  VCLObj(DBTxtPrice);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TFormSalesOrderProduct.FormShow(Sender: TObject);
begin
  Self.OpenQuery;
end;

procedure TFormSalesOrderProduct.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TFormSalesOrderProduct.OpenQuery;
begin
  DM.QryProduct.Close;
  DM.QryProduct.MacroByName('filter').AsRaw := 'WHERE id_product_category = :id_product_category AND status = ''Active''';
  DM.QryProduct.ParamByName('id_product_category').AsInteger := DM.QryProductCategory.FieldByName('id').AsInteger;
  DM.QryProduct.Open;
  DM.QryProduct.IndexFieldNames := 'name';
end;

procedure TFormSalesOrderProduct.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String);
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
