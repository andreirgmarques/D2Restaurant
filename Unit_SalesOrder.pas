unit Unit_SalesOrder;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Vcl.DBCtrls, Vcl.Menus, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

type
  TFormSalesOrder = class(TD2BridgeForm)
    LblTagName: TLabel;
    DBTxtTagName: TDBText;
    LblDate: TLabel;
    DBTxtDate: TDBText;
    LblStatus: TLabel;
    DBTxtStatus: TDBText;
    BtnOptions: TButton;
    PmuOptions: TPopupMenu;
    DbgItems: TDBGrid;
    LblItems: TLabel;
    LblSummary: TLabel;
    DBTxtQtyItems: TDBText;
    LblQtyItems: TLabel;
    DBTxtPriceTotal: TDBText;
    LblPriceTotal: TLabel;
    DBMemDescription: TDBMemo;
    BtnSave: TButton;
    BtnDelete: TButton;
    BtnClose: TButton;
    MnuMarkAsReady: TMenuItem;
    MnuMarkAsCompleted: TMenuItem;
    BtnAddItem: TButton;
    PnlSelectTag: TPanel;
    LblTag: TLabel;
    BtnSelectTag: TButton;
    DBCbxTag: TDBLookupComboBox;
    procedure FormShow(Sender: TObject);
    procedure BtnSelectTagClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtnAddItemClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
  private
    { Private declarations }
    procedure OpenQuery;
    procedure OpenDependencies;
    procedure StatusComponents;
    procedure CalcTotal;
  public
    { Public declarations }
    procedure AddSalesOrderItem;
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String); override;
    procedure PopupClosed(const AName: String; const ACloseParam: Variant); override;
    procedure CellButtonClick(APrismDBGrid: TPrismDBGrid; APrismCellButton: TPrismGridColumnButton;
      AColIndex: Integer; ARow: Integer); overload; override;
  end;

function FormSalesOrder: TFormSalesOrder;

const
  POPUP_PRODUCT_CATEGORY       = 'PopupProductCategory';
  POPUP_SALES_ORDER_ITEM       = 'PopupSalesOrderItem';
  POPUP_SELECT_TAG             = 'PopupSelectTag';
  SALES_ORDER_STATUS_NEW       = 'New';
  SALES_ORDER_STATUS_PREPARING = 'Preparing';
  SALES_ORDER_STATUS_READY     = 'Ready';
  SALES_ORDER_STATUS_COMPLETED = 'Completed';
  SALES_ORDER_STATUS_CANCELED  = 'Canceled';

implementation

uses
  D2RestaurantWebApp, D2BridgeFormTemplate, Unit_DM, Unit_SalesOrderCategory, Unit_SalesOrderItem;

{$R *.dfm}

function FormSalesOrder: TFormSalesOrder;
begin
  Result := TFormSalesOrder(TFormSalesOrder.GetInstance);
end;

procedure TFormSalesOrder.AddSalesOrderItem;
begin
  ClosePopup(POPUP_PRODUCT_CATEGORY);

  if DM.QrySalesOrder.FieldByName('id').AsInteger <= 0 then
  begin
    DM.QrySalesOrder.Edit;
    DM.QrySalesOrder.Post;
  end;
  DM.QrySalesOrder.Edit;

  DM.QrySalesOrderItem.Insert;
  DM.QrySalesOrderItem.FieldByName('id_account').AsInteger           := D2Restaurant.IdAccount;
  DM.QrySalesOrderItem.FieldByName('id_sales_order').AsInteger       := DM.QrySalesOrder.FieldByName('id').AsInteger;
  DM.QrySalesOrderItem.FieldByName('id_product').AsInteger           := DM.QryProduct.FieldByName('id').AsInteger;
  DM.QrySalesOrderItem.FieldByName('product_name').AsString          := DM.QryProduct.FieldByName('name').AsString;
  DM.QrySalesOrderItem.FieldByName('product_price').AsFloat          := DM.QryProduct.FieldByName('price').AsFloat;
  DM.QrySalesOrderItem.FieldByName('id_product_category').AsInteger  := DM.QryProductCategory.FieldByName('id').AsInteger;
  DM.QrySalesOrderItem.FieldByName('product_category_name').AsString := DM.QryProductCategory.FieldByName('name').AsString;
  DM.QrySalesOrderItem.FieldByName('qty').AsFloat                    := 1;
  DM.QrySalesOrderItem.FieldByName('total_price').AsFloat            := DM.QrySalesOrderItem.FieldByName('product_price').AsFloat *
                                                                        DM.QrySalesOrderItem.FieldByName('qty').AsFloat;

  ShowPopup(POPUP_SALES_ORDER_ITEM);
end;

procedure TFormSalesOrder.BtnAddItemClick(Sender: TObject);
begin
  ShowPopup(POPUP_PRODUCT_CATEGORY);
end;

procedure TFormSalesOrder.BtnCloseClick(Sender: TObject);
begin
  DM.QrySalesOrder.Edit;
  DM.QrySalesOrder.Cancel;

  Self.Close;
end;

procedure TFormSalesOrder.BtnDeleteClick(Sender: TObject);
begin
  if DM.QrySalesOrderItem.IsEmpty or (MessageDlg('Delete this Sales Order?', mtConfirmation, mbYesNo, 0) = mrYes) then
  begin
    if not DM.QrySalesOrderItem.IsEmpty then
    begin
      DM.QrySalesOrderItem.DisableControls;
      try
        while not DM.QrySalesOrderItem.IsEmpty do
          DM.QrySalesOrderItem.Delete;
      finally
        DM.QrySalesOrderItem.EnableControls;
      end;
    end;

    DM.QrySalesOrder.Delete;
  end;

  Self.Close;
end;

procedure TFormSalesOrder.BtnSaveClick(Sender: TObject);
begin
  if DM.QrySalesOrderItem.IsEmpty then
  begin
    MessageDlg('No item found', mtError, [mbOK], 0);
    Exit;
  end;

  if SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_NEW) then
  begin
    DM.QrySalesOrder.Edit;
    DM.QrySalesOrder.FieldByName('status').AsString := SALES_ORDER_STATUS_PREPARING;
    DM.QrySalesOrder.Post;
  end;

  Self.Close;
end;

procedure TFormSalesOrder.BtnSelectTagClick(Sender: TObject);
begin
  DM.QrySalesOrder.FieldByName('tag_name').AsString := DBCbxTag.Text;
  ClosePopup(POPUP_SELECT_TAG);
end;

procedure TFormSalesOrder.CalcTotal;
begin
  var LQty   := 0;
  var LTotal := 0.00;

  DM.QrySalesOrderItem.DisableControls;
  try
    DM.QrySalesOrderItem.First;
    while not DM.QrySalesOrderItem.Eof do
    begin
      LQty   := LQty   + DM.QrySalesOrderItem.FieldByName('qty').AsInteger;
      LTotal := LTotal + DM.QrySalesOrderItem.FieldByName('total_price').AsFloat;
      DM.QrySalesOrderItem.Next;
    end;
  finally
    DM.QrySalesOrderItem.First;
    DM.QrySalesOrderItem.EnableControls;
  end;

  DM.QrySalesOrder.Edit;
  DM.QrySalesOrder.FieldByName('total_qty').AsInteger := LQty;
  DM.QrySalesOrder.FieldByName('total_price').AsFloat := LTotal;
end;

procedure TFormSalesOrder.CellButtonClick(APrismDBGrid: TPrismDBGrid; APrismCellButton: TPrismGridColumnButton;
  AColIndex, ARow: Integer);
begin
  if APrismCellButton.Identify = TButtonModel.Edit.Identity then
  begin
    ShowPopup(POPUP_SALES_ORDER_ITEM);
  end
  else if APrismCellButton.Identify = TButtonModel.Delete.Identity then
  begin
    if SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_NEW) then
    begin
      DM.QrySalesOrderItem.Delete;
      Self.CalcTotal;
    end
    else begin
      ShowMessage('Sales Order not in edit mode', True, True, 4000, TMsgDlgType.mtError);
    end;
  end;
end;

procedure TFormSalesOrder.ExportD2Bridge;
begin
  inherited;
  Title := 'Orders';

  TemplateClassForm := TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile   := '';

  if FormSalesOrderCategory = nil then
    TFormSalesOrderCategory.CreateInstance;
  D2Bridge.AddNested(FormSalesOrderCategory);

  if FormSalesOrderItem = nil then
    TFormSalesOrderItem.CreateInstance;
  D2Bridge.AddNested(FormSalesOrderItem);

  with D2Bridge.Items.Add do
  begin
    with Row.Items.Add do
    begin
      with Col10.Add.Card('Sales Order') do
      begin
        with BodyItems.Add do
        begin
          with Row.Items.Add do
          begin
            with ColAuto.Items.Add do
            begin
              VCLObj(LblTagName);
              VCLObj(DBTxtTagName);
            end;

            with Col(CSSClass.Col.Align.right).Items.Add do
            begin
              VCLObj(LblStatus);
              BadgePillText(DBTxtStatus);
            end;

            ColAuto.Add.VCLObj(BtnOptions, PmuOptions, CSSClass.Button.options);
          end;

          with Row.Items.Add do
          begin
            with Col.Add.PanelGroup.Items.Add do
            begin
              with Row.Items.Add do
                ColAuto.Add.VCLObj(BtnAddItem, CSSClass.Button.add);

              ColAuto.Add.VCLObj(DbgItems);
            end;
          end;

          with Row(CSSClass.Space.SpaceMin_top_bottom).Items.Add do
          begin
            with ColAuto.Add.PanelGroup(LblSummary.Caption).Items.Add do
            begin
              with Row.Items.Add do
              begin
                with ColAuto.Items.Add do
                begin
                  VCLObj(LblQtyItems);
                  VCLObj(DBTxtQtyItems);
                end;
              end;

              with Row.Items.Add do
              begin
                with ColAuto.Items.Add do
                begin
                  VCLObj(LblPriceTotal);
                  VCLObj(DBTxtPriceTotal);
                end;
              end;
            end;
          end;

          with Row.Items.Add do
            Col.Add.VCLObj(DBMemDescription);
        end;

        with Footer.Items.Add do
        begin
          with Row.Items.Add do
          begin
            ColAuto.Add.VCLObj(BtnSave, CSSClass.Button.save);
            ColAuto.Add.VCLObj(BtnDelete, CSSClass.Button.delete);
            ColAuto.Add.VCLObj(BtnClose, CSSClass.Button.close);
          end;
        end;
      end;
    end;

    with Popup(POPUP_SELECT_TAG, 'Select Tag').Items.Add do
    begin
      with Row.Items.Add do
      begin
        Col.Add.FormGroup(LblTag).AddVCLObj(DBCbxTag);
        ColAuto.Add.VCLObj(BtnSelectTag, CSSClass.Button.select);
      end;
    end;

    with Popup(POPUP_PRODUCT_CATEGORY, 'Category').Items.Add do
      Nested(FormSalesOrderCategory);

    with Popup(POPUP_SALES_ORDER_ITEM, 'Item').Items.Add do
      Nested(FormSalesOrderItem);
  end;
end;

procedure TFormSalesOrder.FormActivate(Sender: TObject);
begin
  if DM.QrySalesOrder.FieldByName('id').AsInteger <= 0 then
    ShowPopup(POPUP_SELECT_TAG);
end;

procedure TFormSalesOrder.FormShow(Sender: TObject);
begin
  Self.OpenQuery;
end;

procedure TFormSalesOrder.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
  inherited;
  if PrismControl.VCLComponent = DbgItems then
  begin
    with PrismControl.AsDBGrid do
    begin
      with Columns.Add do
      begin
        ColumnIndex := 0;
        Title       := '';
        Width       := 75;

        with Buttons.Add do
        begin
          ButtonModel := TButtonModel.Edit;
          Caption     := '';
        end;

        with Buttons.Add do
        begin
          ButtonModel := TButtonModel.Delete;
          Caption     := '';
        end;
      end;
    end;
  end;
end;

procedure TFormSalesOrder.OpenDependencies;
begin
  DM.QryTag.Close;
  DM.QryTag.MacroByName('filter').AsRaw         := 'WHERE id_account = :id_account AND status = ''Active''';
  DM.QryTag.ParamByName('id_account').AsInteger := D2Restaurant.IdAccount;
  DM.QryTag.Open;
  DM.QryTag.IndexFieldNames := 'name';
end;

procedure TFormSalesOrder.OpenQuery;
begin
  DM.QrySalesOrderItem.Close;
  DM.QrySalesOrderItem.MacroByName('filter').AsRaw             := 'WHERE id_sales_order = :id_sales_order';
  DM.QrySalesOrderItem.ParamByName('id_sales_order').AsInteger := DM.QrySalesOrder.FieldByName('id').AsInteger;
  DM.QrySalesOrderItem.Open;

  Self.OpenDependencies;
  Self.StatusComponents;

  if SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_NEW) then
    Self.CalcTotal;
end;

procedure TFormSalesOrder.PopupClosed(const AName: String; const ACloseParam: Variant);
begin
  inherited;
  if SameText(AName, POPUP_SELECT_TAG) then
  begin
    if DM.QrySalesOrder.FieldByName('tag_name').AsString = '' then
    begin
      DM.QrySalesOrder.Cancel;
      Self.Close;
    end
    else begin
      BtnAddItemClick(BtnAddItem);
    end;
  end;

  if SameText(AName, POPUP_SALES_ORDER_ITEM) and SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_NEW) then
    Self.CalcTotal;
end;

procedure TFormSalesOrder.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String);
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

procedure TFormSalesOrder.StatusComponents;
begin
  if SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_NEW) then
  begin
    BtnOptions.Enabled       := False;
    BtnAddItem.Enabled       := True;
    BtnDelete.Enabled        := True;
    BtnClose.Enabled         := False;
    DBMemDescription.Enabled := True;
    DBTxtStatus.Color        := CSSClass.Color.TColor.info;
  end
  else begin
    BtnOptions.Enabled       := True;
    BtnAddItem.Enabled       := False;
    BtnDelete.Enabled        := False;
    BtnClose.Enabled         := True;
    DBMemDescription.Enabled := False;
    if SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_PREPARING) then
      DBTxtStatus.Color      := CSSClass.Color.TColor.primary
    else if SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_READY) then
      DBTxtStatus.Color      := CSSClass.Color.TColor.success
    else if SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_COMPLETED) then
      DBTxtStatus.Color      := CSSClass.Color.TColor.secondary
    else if SameText(DM.QrySalesOrder.FieldByName('status').AsString, SALES_ORDER_STATUS_CANCELED) then
      DBTxtStatus.Color      := CSSClass.Color.TColor.danger;
  end;
end;

end.
