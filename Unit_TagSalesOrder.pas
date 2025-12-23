unit Unit_TagSalesOrder;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls;

type
  TFormTagSalesOrder = class(TD2BridgeForm)
    DscTagSalesOrder: TDataSource;
    QryTagSalesOrder: TFDQuery;
    EdtSearch: TEdit;
    BtnSearch: TButton;
    PnlTag: TPanel;
    DBTxtTagName: TDBText;
    BtnConfig: TButton;
    LblTotalPrice: TLabel;
    DBTxtTotalPrice: TDBText;
    DBTxtStatus: TDBText;
    procedure FormShow(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure BtnConfigClick(Sender: TObject);
  private
    { Private declarations }
    FFormCheckout: TD2BridgeForm;
    procedure OpenQuery;
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String); override;
  end;

function FormTagSalesOrder: TFormTagSalesOrder;

implementation

uses
  D2RestaurantWebApp, D2BridgeFormTemplate, Unit_DM, Unit_Checkout;

const
  POPUP_FORM_CHECKOUT = 'PopupFormCheckout';

{$R *.dfm}

function FormTagSalesOrder: TFormTagSalesOrder;
begin
  Result := TFormTagSalesOrder(TFormTagSalesOrder.GetInstance);
end;

procedure TFormTagSalesOrder.BtnConfigClick(Sender: TObject);
begin
  if SameText(QryTagSalesOrder.FieldByname('status').AsString, 'Available') then
  begin
    ShowMessage('Tag not Open', True, True, 4000, TMsgDlgType.mtError);
  end
  else begin
    TFormCheckout(FFormCheckout).IdTag := QryTagSalesOrder.FieldByname('id_tag').AsInteger;
    ShowPopupModal(POPUP_FORM_CHECKOUT);
    Self.OpenQuery;
  end;
end;

procedure TFormTagSalesOrder.BtnSearchClick(Sender: TObject);
begin
  Self.OpenQuery;
end;

procedure TFormTagSalesOrder.ExportD2Bridge;
begin
  inherited;
  Title := 'Checkout';

  TemplateClassForm := TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile   := '';

  if FFormCheckout = nil then
    FFormCheckout := TFormCheckout.Create(Self);
  D2Bridge.AddNested(FFormCheckout);

  with D2Bridge.Items.Add do
  begin
    with Row(CSSClass.Col.Align.center).Items.Add do
    begin
      with Col6.Items.Add do
      begin
        VCLObj(EdtSearch);
        VCLObj(BtnSearch, CSSClass.Button.search);
      end;
    end;

    with Row.Items.Add do
    begin
      with Col.Add.CardGrid(DscTagSalesOrder) do
      begin
        CardGridSize := CSSClass.CardGrid.CardGridX3;
        Space        := CSSClass.Space.gutter4;
        CSSClasses   := CSSClass.Col.Align.center;

        with CardDataModel do
        begin
          with BodyItems.Add do
          begin
            with Row.Items.Add do
            begin
              ColFull.Add.VCLObj(DBTxtTagName);
              ColAuto.Add.VCLObj(BtnConfig, CSSClass.Button.TypeButton.Default.success + ' ' + CSSClass.Button.Iconbutton('fa-solid fa-dollar-sign'));
            end;

            with Row.Items.Add do
            begin
              with Col(CSSClass.Col.Align.right).Items.Add do
              begin
                VCLObj(LblTotalPrice);
                VCLObj(DBTxtTotalPrice);
              end;
            end;

            with Row.Items.Add do
              ColAuto(CSSClass.Col.Align.right).Add.BadgePillText(DBTxtStatus);
          end;
        end;
      end;
    end;

    Popup(POPUP_FORM_CHECKOUT, '', False).Items.Add.Nested(FFormCheckout);
  end;
end;

procedure TFormTagSalesOrder.FormShow(Sender: TObject);
begin
  Self.OpenQuery;
end;

procedure TFormTagSalesOrder.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
  inherited;
  if PrismControl.IsCardDataModel then
  begin
    if SameText(QryTagSalesOrder.FieldByName('status').AsString, 'Available') then
      DBTxtStatus.Color := clGray
    else
      DBTxtStatus.Color := clGreen;
  end;
end;

procedure TFormTagSalesOrder.OpenQuery;
begin
  QryTagSalesOrder.Close;
  QryTagSalesOrder.ParamByName('id_account').AsInteger := D2Restaurant.IdAccount;
  QryTagSalesOrder.ParamByName('name').AsString        := '%' + EdtSearch.Text + '%';
  QryTagSalesOrder.ParamByName('number').AsString      := EdtSearch.Text;
  QryTagSalesOrder.Open;
end;

procedure TFormTagSalesOrder.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String);
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
