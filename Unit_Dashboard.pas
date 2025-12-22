unit Unit_Dashboard;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Vcl.DBCtrls, Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client; // Declare D2Bridge.Forms always in the last unit

type
  TFormDashboard = class(TD2BridgeForm)
    BtnNewOrder: TButton;
    PnlQtyTags: TPanel;
    LblQtyTags: TLabel;
    DBTxtQtyTags: TDBText;
    PnlClosedTags: TPanel;
    LblClosedTags: TLabel;
    DBTxtClosedTags: TDBText;
    PnlOpenedTags: TPanel;
    LblOpenedTags: TLabel;
    DBTxtOpenedTags: TDBText;
    PnlQtyPreparing: TPanel;
    LblQtyPreparing: TLabel;
    DBTxtQtyPreparing: TDBText;
    Tmr: TTimer;
    BtnRefresh: TButton;
    BtnCompleted: TButton;
    BtnReady: TButton;
    BtnView: TButton;
    DbgOrder: TDBGrid;
    QryDataCards: TFDQuery;
    QrySalesOrder: TFDQuery;
    DscDataCards: TDataSource;
    DscSalesOrder: TDataSource;
    procedure BtnNewOrderClick(Sender: TObject);
    procedure TmrTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnViewClick(Sender: TObject);
    procedure BtnReadyClick(Sender: TObject);
    procedure BtnCompletedClick(Sender: TObject);
  private
    { Private declarations }
    procedure OpenQuery;
    procedure OpenDataCards;
    procedure OpenSalesOrder;
    procedure RecoverySalesOrder;
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

procedure TFormDashboard.BtnCompletedClick(Sender: TObject);
begin
  DM.QrySalesOrder.Close;
  DM.QrySalesOrder.MacroByName('filter').AsRaw := 'WHERE id = :id';
  DM.QrySalesOrder.ParamByName('id').AsInteger := QrySalesOrder.FieldByName('id').AsInteger;
  DM.QrySalesOrder.Open;
  if FormSalesOrder = nil then
    TFormSalesOrder.CreateInstance;
  FormSalesOrder.StatusToCompleted;
  Self.OpenSalesOrder;
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

procedure TFormDashboard.BtnReadyClick(Sender: TObject);
begin
  DM.QrySalesOrder.Close;
  DM.QrySalesOrder.MacroByName('filter').AsRaw := 'WHERE id = :id';
  DM.QrySalesOrder.ParamByName('id').AsInteger := QrySalesOrder.FieldByName('id').AsInteger;
  DM.QrySalesOrder.Open;
  if FormSalesOrder = nil then
    TFormSalesOrder.CreateInstance;
  FormSalesOrder.StatusToReady;
  Self.OpenSalesOrder;
end;

procedure TFormDashboard.BtnRefreshClick(Sender: TObject);
begin
  Self.OpenSalesOrder;
end;

procedure TFormDashboard.BtnViewClick(Sender: TObject);
begin
  DM.QrySalesOrder.Close;
  DM.QrySalesOrder.MacroByName('filter').AsRaw := 'WHERE id = :id';
  DM.QrySalesOrder.ParamByName('id').AsInteger := QrySalesOrder.FieldByName('id').AsInteger;
  DM.QrySalesOrder.Open;
  if FormSalesOrder = nil then
    TFormSalesOrder.CreateInstance;
  FormSalesOrder.Show;
  Self.OpenSalesOrder;
end;

procedure TFormDashboard.ExportD2Bridge;
begin
  inherited;
  Title := 'Dashboard';

  TemplateClassForm := TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile   := '';

  with D2Bridge.Items.add do
  begin
    with Row.Items.Add do
    begin
      with Col.Add.CardGrid do
      begin
        EqualHeight := True;
        RowColsSize := 'row-cols-2 row-cols-sm-2 row-cols-md-4';

        // Qty Tags
        with AddCard do
        begin
          ColSize        := CSSClass.Col.colauto;
          Color          := PnlQtyTags.Color;
          CSSClassesBody := CSSClass.Space.padding_top_bottom_1;
          with BodyItems.Add do
          begin
            with Row.Items.Add do
              Col.Add.VCLObj(LblQtyTags);
            with Row.Items.Add do
              Col.Add.VCLObj(DBTxtQtyTags);
          end;
        end;

        // Closed Tags
        with AddCard do
        begin
          ColSize        := CSSClass.Col.colauto;
          Color          := PnlClosedTags.Color;
          CSSClassesBody := CSSClass.Space.padding_top_bottom_1;
          with BodyItems.Add do
          begin
            with Row.Items.Add do
              Col.Add.VCLObj(LblClosedTags);
            with Row.Items.Add do
              Col.Add.VCLObj(DBTxtClosedTags);
          end;
        end;

        // Opened Tags
        with AddCard do
        begin
          ColSize        := CSSClass.Col.colauto;
          Color          := PnlOpenedTags.Color;
          CSSClassesBody := CSSClass.Space.padding_top_bottom_1;
          with BodyItems.Add do
          begin
            with Row.Items.Add do
              Col.Add.VCLObj(LblOpenedTags);
            with Row.Items.Add do
              Col.Add.VCLObj(DBTxtOpenedTags);
          end;
        end;

        // Qty Preparing
        with AddCard do
        begin
          ColSize        := CSSClass.Col.colauto;
          Color          := PnlQtyPreparing.Color;
          CSSClassesBody := CSSClass.Space.padding_top_bottom_1;
          with BodyItems.Add do
          begin
            with Row.Items.Add do
              Col.Add.VCLObj(LblQtyPreparing);
            with Row.Items.Add do
              Col.Add.VCLObj(DBTxtQtyPreparing);
          end;
        end;
      end;
    end;

    with Row.Items.Add do
    begin
      with Col.Add.Card('Cards').Items.Add do
      begin
        with Row.Items.Add do
        begin
          ColAuto.Add.VCLObj(BtnNewOrder, CSSClass.Button.add);
          ColAuto.Add.VCLObj(BtnRefresh, CSSClass.Button.refresh);
        end;

        with Row.Items.Add do
          Col.Add.VCLObj(DbgOrder);
      end;
    end;
  end;
end;

procedure TFormDashboard.FormActivate(Sender: TObject);
begin
  Self.RecoverySalesOrder;
end;

procedure TFormDashboard.FormDeactivate(Sender: TObject);
begin
  Tmr.Enabled := False;
end;

procedure TFormDashboard.FormShow(Sender: TObject);
begin
  Self.OpenQuery;
  Tmr.Enabled := True;
end;

procedure TFormDashboard.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
  inherited;
  if PrismControl.VCLComponent = DbgOrder then
  begin
    with PrismControl.AsDBGrid do
    begin
      ShowPager := False;

      with Columns.Add do
      begin
        ColumnIndex := 0;
        Title       := '';
        Width       := 60;

        with Buttons.Add do
        begin
          ButtonModel := TButtonModel.View;
          Caption     := '';
          OnClick     := Self.BtnViewClick;
        end;

        with Buttons.Add do
        begin
          ButtonModel := TButtonModel.Config;
          Caption     := '';

          with Add do
          begin
            ButtonModel := TButtonModel.checkmark;
            Caption     := 'Mark as Ready';
            OnClick     := Self.BtnReadyClick;
          end;

          with Add do
          begin
            ButtonModel := TButtonModel.Select;
            Caption     := 'Mark as Completed';
            OnClick     := Self.BtnCompletedClick;
          end;
        end;
      end;
    end;
  end;
end;

procedure TFormDashboard.OpenDataCards;
begin
  QryDataCards.Close;
  QryDataCards.ParamByName('id_account').AsInteger := D2Restaurant.IdAccount;
  QryDataCards.Open;
end;

procedure TFormDashboard.OpenQuery;
begin
  Self.OpenDataCards;
  Self.OpenSalesOrder;
end;

procedure TFormDashboard.OpenSalesOrder;
begin
  QrySalesOrder.Close;
  QrySalesOrder.ParamByName('id_account').AsInteger := D2Restaurant.IdAccount;
  QrySalesOrder.Open;
end;

procedure TFormDashboard.RecoverySalesOrder;
begin
  DM.QrySalesOrder.Close;
  DM.QrySalesOrder.MacroByName('filter').AsRaw      := 'WHERE id_user = :id_user AND status = ''New''';
  DM.QrySalesOrder.ParamByName('id_user').AsInteger := D2Restaurant.IdUser;
  DM.QrySalesOrder.Open;
  if not DM.QrySalesOrder.IsEmpty then
  begin
    if FormSalesOrder = nil then
      TFormSalesOrder.CreateInstance;
    FormSalesOrder.Show;
  end;
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

procedure TFormDashboard.TmrTimer(Sender: TObject);
begin
//  Self.OpenDataCards;
end;

end.
