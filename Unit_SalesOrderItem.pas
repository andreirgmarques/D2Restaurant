unit Unit_SalesOrderItem;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Vcl.DBCtrls, Vcl.Mask, Vcl.ExtCtrls;

type
  TFormSalesOrderItem = class(TD2BridgeForm)
    LblTag: TLabel;
    LblProductCategory: TLabel;
    LblProduct: TLabel;
    LblPrice: TLabel;
    LblQty: TLabel;
    LblTotal: TLabel;
    DBTxtTag: TDBText;
    DBTxtProductCategory: TDBText;
    DBTxtProduct: TDBText;
    DBTxtPrice: TDBText;
    DBTxtTotal: TDBText;
    BtnDecQty: TButton;
    DBEdtQty: TDBEdit;
    BtnIncQty: TButton;
    DBMemDescription: TDBMemo;
    BtnSave: TButton;
    BtnDelete: TButton;
    BtnClose: TButton;
    procedure BtnDecQtyClick(Sender: TObject);
    procedure BtnIncQtyClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure CalcTotal;
    procedure StatusComponents;
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String); override;
  end;

function FormSalesOrderItem: TFormSalesOrderItem;

implementation

uses
  D2RestaurantWebApp, Unit_DM, Unit_SalesOrder;

{$R *.dfm}

function FormSalesOrderItem: TFormSalesOrderItem;
begin
  Result := TFormSalesOrderItem(TFormSalesOrderItem.GetInstance);
end;

procedure TFormSalesOrderItem.BtnCloseClick(Sender: TObject);
begin
  DM.QrySalesOrderItem.Edit;
  DM.QrySalesOrderItem.Cancel;
  Self.Close;
end;

procedure TFormSalesOrderItem.BtnDeleteClick(Sender: TObject);
begin
  if MessageDlg('Really delete this item?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    DM.QrySalesOrderItem.Edit;
    DM.QrySalesOrderItem.Delete;
    Self.Close;
  end;
end;

procedure TFormSalesOrderItem.BtnIncQtyClick(Sender: TObject);
begin
  DM.QrySalesOrderItem.Edit;
  DM.QrySalesOrderItem.FieldByName('qty').AsFloat := DM.QrySalesOrderItem.FieldByName('qty').AsFloat + 1;
  Self.CalcTotal;
end;

procedure TFormSalesOrderItem.BtnSaveClick(Sender: TObject);
begin
  DM.QrySalesOrderItem.Edit;
  DM.QrySalesOrderItem.Post;
  Self.Close;
end;

procedure TFormSalesOrderItem.BtnDecQtyClick(Sender: TObject);
begin
  if DM.QrySalesOrderItem.FieldByName('qty').AsFloat > 1 then
  begin
    DM.QrySalesOrderItem.Edit;
    DM.QrySalesOrderItem.FieldByName('qty').AsFloat := DM.QrySalesOrderItem.FieldByName('qty').AsFloat - 1;
    Self.CalcTotal;
  end;
end;

procedure TFormSalesOrderItem.CalcTotal;
begin
  DM.QrySalesOrderItem.Edit;
  DM.QrySalesOrderItem.FieldByName('total_price').AsFloat := DM.QrySalesOrderItem.FieldByName('product_price').AsFloat *
                                                             DM.QrySalesOrderItem.FieldByName('qty').AsFloat;
end;

procedure TFormSalesOrderItem.ExportD2Bridge;
begin
  inherited;
  Title := 'My D2Bridge Form';

  // TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile   := '';

  with D2Bridge.Items.add do
  begin
    with Row.Items.Add do
    begin
      with ColAuto.Items.Add do
      begin
        VCLObj(LblTag);
        VCLObj(DBTxtTag);
      end;
    end;

    with Row.Items.Add do
    begin
      with ColAuto.Items.Add do
      begin
        VCLObj(LblProductCategory);
        VCLObj(DBTxtProductCategory);
      end;
    end;

    with Row.Items.Add do
      ColAuto.Add.FormGroup(LblProduct).AddVCLObj(DBTxtProduct);

    with Row.Items.Add do
    begin
      with ColAuto.Items.Add do
      begin
        VCLObj(LblPrice);
        VCLObj(DBTxtPrice);
      end;
    end;

    with Row.Items.Add do
    begin
      with ColAuto.Items.Add do
      begin
        VCLObj(BtnDecQty, CSSClass.Button.decrease);
        VCLObj(DBEdtQty);
        VCLObj(BtnIncQty, CSSClass.Button.increase);
      end;
    end;

    with Row.Items.Add do
    begin
      with ColAuto.Items.Add do
      begin
        VCLObj(LblTotal);
        VCLObj(DBTxtTotal);
      end;
    end;

    with Row.Items.Add do
      Col.Add.VCLObj(DBMemDescription);

    with Row.Items.Add do
    begin
      ColAuto.Add.VCLObj(BtnSave, CSSClass.Button.save);
      ColAuto.Add.VCLObj(BtnDelete, CSSClass.Button.delete);
      ColAuto.Add.VCLObj(BtnClose, CSSClass.Button.close);
    end;
  end;
end;

procedure TFormSalesOrderItem.FormShow(Sender: TObject);
begin
  Self.StatusComponents;
end;

procedure TFormSalesOrderItem.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TFormSalesOrderItem.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String);
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

procedure TFormSalesOrderItem.StatusComponents;
begin
  BtnDecQty.Enabled        := SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_NEW);
  BtnIncQty.Enabled        := SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_NEW);
  BtnDelete.Enabled        := SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_NEW);
  DBMemDescription.Enabled := SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_NEW);
end;

end.
