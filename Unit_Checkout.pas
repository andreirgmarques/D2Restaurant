unit Unit_Checkout;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Vcl.DBCtrls, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFormCheckout = class(TD2BridgeForm)
    LblTagName: TLabel;
    DBTxtTagName: TDBText;
    ImgProduct: TImage;
    LblOrderId: TLabel;
    LblItem: TLabel;
    LblQty: TLabel;
    DBTxtOrderId: TDBText;
    DBTxtItem: TDBText;
    DBTxtQty: TDBText;
    DBTxtUnitPrice: TDBText;
    LblUnitPrice: TLabel;
    DBTxtTotalPrice: TDBText;
    LblTotalPrice: TLabel;
    LblSummary: TLabel;
    LblSummaryQty: TLabel;
    LblSummaryQtyValue: TLabel;
    LblSummaryTotalValue: TLabel;
    LblSummaryTotal: TLabel;
    BtnReceive: TButton;
    BtnCancel: TButton;
    QryCheckout: TFDQuery;
    DscCheckout: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure BtnReceiveClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FIdTag: Integer;
    procedure CalcTotal;
    procedure OpenQuery;
  public
    { Public declarations }
    property IdTag: Integer write FIdTag;
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String); override;
  end;

function FormCheckout: TFormCheckout;

implementation

uses
  D2RestaurantWebApp, Unit_DM;

{$R *.dfm}

function FormCheckout: TFormCheckout;
begin
  Result := TFormCheckout(TFormCheckout.GetInstance);
end;

procedure TFormCheckout.BtnCancelClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFormCheckout.BtnReceiveClick(Sender: TObject);
begin
  if MessageDlg('Confirm finalize this tag?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    DM.DBConnection.ExecSQL(
      Format(
        '''
        UPDATE sales_order
        SET status = 'Completed'
        WHERE id_tag = %d AND
              status NOT IN ('Canceled', 'Completed')
        ''',
        [FIdTag]
      )
    );
    Self.Close;
  end;
end;

procedure TFormCheckout.CalcTotal;
begin
  var LQty   := 0;
  var LTotal := 0.00;

  QryCheckout.First;
  try
    while not QryCheckout.Eof do
    begin
      LQty   := LQty   + QryCheckout.FieldByName('qty').AsInteger;
      LTotal := LTotal + QryCheckout.FieldByName('total_price').AsFloat;
      QryCheckout.Next;
    end;
  finally
    QryCheckout.First;
  end;

  LblSummaryQtyValue.Caption   := LQty.ToString;
  LblSummaryTotalValue.Caption := FormatFloat('0.00', LTotal);
end;

procedure TFormCheckout.ExportD2Bridge;
begin
  inherited;
  Title := 'Checkout';

  // TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile   := '';

  var LFolderImage := APPConfig.Path.Data + 'support\images\product\';

  with D2Bridge.Items.Add do
  begin
    with Row.Items.Add do
    begin
      with ColAuto.Items.Add do
      begin
        VCLObj(LblTagName);
        VCLObj(DBTxtTagName);
      end;
    end;

    with Row(CSSClass.Space.SpaceMin_top_bottom).Items.Add do
    begin
      with Col.Add.CardGrid(DscCheckout) do
      begin
        CardGridSize := CSSClass.CardGrid.CardGridX1;
        //Space := CSSClass.Space.gutter4;

        with CardDataModel do
        begin
          BorderColor := clSilver;

          with BodyItems.Add do
          begin
            with Row.Items.Add do
            begin
              // Left
              with Col2(False).Add do
              begin
                ImageFromDB(LFolderImage, DscCheckout, 'image_file', CSSClass.Image.Image_Col_Square);
              end;

              // Right
              with Col.Items.Add do
              begin
                with Row.Items.Add do
                begin
                  with ColAuto.Items.Add do
                  begin
                    VCLObj(LblOrderId);
                    VCLObj(DBTxtOrderId);
                  end;
                end;

                with Row.Items.Add do
                begin
                  with ColAuto.Items.Add do
                  begin
                    VCLObj(LblItem);
                    VCLObj(DBTxtItem);
                  end;
                end;

                with Row.Items.Add do
                begin
                  with Col.Items.Add do
                  begin
                    VCLObj(LblQty);
                    VCLObj(DBTxtQty);
                  end;

                  with Col.Items.Add do
                  begin
                    VCLObj(LblUnitPrice);
                    VCLObj(DBTxtUnitPrice);
                  end;

                  with Col.Items.Add do
                  begin
                    VCLObj(LblTotalPrice);
                    VCLObj(DBTxtTotalPrice);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;

    with Row(CSSClass.Space.SpaceMin_top_bottom).Items.Add do
    begin
      // Left
      with Col.Add.PanelGroup('Qty Items').Items.Add do
      begin
        with Row(CSSClass.Space.SpaceMin_top_bottom).Items.Add do
          ColAuto.Add.VCLObj(LblSummaryQtyValue);
      end;

      // Right
      with Col.Add.PanelGroup('Total Value').Items.Add do
      begin
        with Row(CSSClass.Space.SpaceMin_top_bottom).Items.Add do
          ColAuto.Add.VCLObj(LblSummaryTotalValue);
      end;
    end;

    with Row.Items.Add do
    begin
      Col.Add.VCLObj(BtnReceive, CSSClass.Button.apply + ' ' + CSSClass.Col.col12);
      Col.Add.VCLObj(BtnCancel, CSSClass.Button.cancel + ' ' + CSSClass.Col.col12);
    end;
  end;
end;

procedure TFormCheckout.FormShow(Sender: TObject);
begin
  Self.OpenQuery;
end;

procedure TFormCheckout.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TFormCheckout.OpenQuery;
begin
  QryCheckout.DisableControls;
  try
    QryCheckout.Close;
    QryCheckout.ParamByName('id_tag').AsInteger := FIdTag;
    QryCheckout.Open;
    Self.CalcTotal;
  finally
    QryCheckout.EnableControls;
  end;
end;

procedure TFormCheckout.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String);
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
