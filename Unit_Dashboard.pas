unit Unit_Dashboard;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms; // Declare D2Bridge.Forms always in the last unit

type
  TFormDashboard = class(TD2BridgeForm)
    BtnNewOrder: TButton;
    procedure BtnNewOrderClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

function FormDashboard: TFormDashboard;

implementation

uses
  D2RestaurantWebApp, D2BridgeFormTemplate, Unit_SalesOrder, Unit_DM;

{$R *.dfm}

function FormDashboard: TFormDashboard;
begin
  Result := TFormDashboard(TFormDashboard.GetInstance);
end;

procedure TFormDashboard.BtnNewOrderClick(Sender: TObject);
begin
  DM.QrySalesOrder.Close;
  DM.QrySalesOrder.MacroByName('filter').AsRaw         := 'WHERE false';
  DM.QrySalesOrder.Open;

  DM.QrySalesOrder.Insert;
  DM.QrySalesOrder.FieldByName('id_account').AsInteger := D2Restaurant.IdAccount;
  DM.QrySalesOrder.FieldByName('id_user').AsInteger    := D2Restaurant.IdUser;
  DM.QrySalesOrder.FieldByName('date').AsDateTime      := Now;
  DM.QrySalesOrder.FieldByName('status').AsString      := SALES_ORDER_STATUS_NEW;
  DM.QrySalesOrder.FieldByName('total_price').AsFloat  := 0;
  DM.QrySalesOrder.FieldByName('total_qty').AsFloat    := 0;

  if FormSalesOrder = nil then
    TFormSalesOrder.CreateInstance;
  FormSalesOrder.Show;
end;

procedure TFormDashboard.ExportD2Bridge;
begin
  inherited;
  Title := 'My D2Bridge Form';

  TemplateClassForm := TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile   := '';

  with D2Bridge.Items.add do
  begin
    with Row.Items.Add do
      ColAuto.Add.VCLObj(BtnNewOrder);
  end;
end;

procedure TFormDashboard.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TFormDashboard.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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
