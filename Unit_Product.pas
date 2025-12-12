unit Unit_Product;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Unit_CrudTemplate, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.Mask,
  System.IOUtils, Vcl.Imaging.GIFImg;

type
  TFormProduct = class(TFormCrudTemplate)
    ImgProduct: TImage;
    LblId: TLabel;
    DBTxtId: TDBText;
    LblProduct: TLabel;
    DBEdtProduct: TDBEdit;
    LblCategory: TLabel;
    DBEdtPrice: TDBEdit;
    LblPrice: TLabel;
    DBMemDescription: TDBMemo;
    LblDescription: TLabel;
    DBCbxStatus: TDBComboBox;
    LblStatus: TLabel;
    DBCbxCategory: TDBLookupComboBox;
  private
    { Private declarations }
    FImagePath: String;
    procedure OpenQuery;
    procedure OpenDependencies;
    procedure OpenImage;
    procedure SaveImage;
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String); override;
    // CRUD Events
    procedure CrudOnOpen; override;
    procedure CrudOnSearch(AText: String); override;
    function CrudOnEdit: Boolean; override;
    function CrudOnInsert: Boolean; override;
    function CrudOnSave: Boolean; override;
    function CrudOnDelete: Boolean; override;
    function CrudOnBack: Boolean; override;
    function CrudOnClose: Boolean; override;
    // Upload
    procedure Upload(AFiles: TStrings; ASender: TObject); override;
  end;

function FormProduct: TFormProduct;

implementation

uses
  D2RestaurantWebApp, Unit_DM;

{$R *.dfm}

function FormProduct: TFormProduct;
begin
  Result := TFormProduct(TFormProduct.GetInstance);
end;

procedure TFormProduct.ExportD2Bridge;
begin
  inherited;

  Title    := 'Product';
  SubTitle := '';

  Crud_PanelTitle.Caption    := 'My Products';
  Crud_PanelSubTitle.Caption := '';

  // TemplateClassForm:= TD2BridgeFormTemplate;
  // D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  // D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

  with Crud_CardData.Items.Add do
  begin
    with Row.Items.Add do
    begin
      // Left
      with Col3.Items.Add do
      begin
        with Row.Items.Add do
          Col8.Add.VCLObj(ImgProduct);

        with Row.Items.Add do
        begin
          with Col8.Add.Upload do
          begin
            MaxFileSize  := 3;
            MaxFiles     := 1;
            InputVisible := False;
          end;
        end;
      end;

      // Right
      with Col6.Items.Add do
      begin
        with Row.Items.Add do
        begin
          with ColAuto.Items.Add do
          begin
            VCLObj(LblId);
            VCLObj(DBTxtId);
          end;

          with Row.Items.Add do
            Col6.Add.FormGroup(LblProduct).AddVCLObj(DBEdtProduct, CrudValidationGroup, True);

          with Row.Items.Add do
            Col6.Add.FormGroup(LblCategory).AddVCLObj(DBCbxCategory, CrudValidationGroup, True);

          with Row.Items.Add do
            Col4.Add.FormGroup(LblPrice).AddVCLObj(DBEdtPrice, CrudValidationGroup, True);

          with Row.Items.Add do
            Col6.Add.FormGroup(LblDescription).AddVCLObj(DBMemDescription);

          with Row.Items.Add do
            Col6.Add.FormGroup(LblStatus).AddVCLObj(DBCbxStatus, CrudValidationGroup, True);
        end;
      end;
    end;
  end;

  with Crud_CardData.Footer.Items.Add do
  begin
    { Aditional buttons in Footer }
  end;
end;

procedure TFormProduct.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TFormProduct.OpenDependencies;
begin
  DM.QryProductCategory.Close;
  DM.QryProductCategory.MacroByName('filter').AsRaw         := 'WHERE id_account = :id_account AND status = ''Active''';
  DM.QryProductCategory.ParamByName('id_account').AsInteger := D2Restaurant.IdAccount;
  DM.QryProductCategory.Open;
  DM.QryProductCategory.IndexFieldNames := 'name';
end;

procedure TFormProduct.OpenImage;
begin
  FImagePath         := '';
  ImgProduct.Picture := nil;
  if DM.QryProduct.FieldByName('image_file').AsString <> '' then
  begin
    var LImageFile := APPConfig.Path.Data + 'support\images\product\' + DM.QryProduct.FieldByName('image_file').AsString;
    if TFile.Exists(LImageFile) then
      ImgProduct.Picture.LoadFromFile(LImageFile);
  end;
end;

procedure TFormProduct.OpenQuery;
begin
  DM.QryProduct.Close;
  DM.QryProduct.MacroByName('filter').AsRaw := 'WHERE id = :id';
  DM.QryProduct.ParamByName('id').AsInteger := Crud_Query.FieldByName('id').AsInteger;
  DM.QryProduct.Open;
  Self.OpenDependencies;
end;

procedure TFormProduct.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: String);
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

procedure TFormProduct.SaveImage;
begin
  if (FImagePath <> '') and TFile.Exists(FImagePath) then
  begin
    var LFolderImage := APPConfig.Path.Data + 'support\images\product\';
    if (DM.QryProduct.FieldByName('image_file').AsString <> '') and (DM.QryProduct.FieldByName('image_file').AsString <> 'nopicture.gif') and
       TFile.Exists(LFolderImage + DM.QryProduct.FieldByName('image_file').AsString) then
    begin
      TFile.Delete(LFolderImage + DM.QryProduct.FieldByName('image_file').AsString);
    end;

    var LImageFile    := D2Restaurant.IdAccount.ToString + '_' + D2Bridge.RandomHash + TPath.GetExtension(FImagePath);
    var LNewImagePath := LFolderImage + LImageFile;

    TFile.Move(FImagePath, LNewImagePath);

    DM.QryProduct.FieldByName('image_file').AsString := LImageFile;
  end;
end;

procedure TFormProduct.Upload(AFiles: TStrings; ASender: TObject);
begin
  FImagePath := AFiles[0];
  ImgProduct.Picture.LoadFromFile(FImagePath);
end;

procedure TFormProduct.CrudOnOpen;
begin
  inherited;

  CrudOperation(OpSearch);
end;

procedure TFormProduct.CrudOnSearch(AText: String);
begin
  inherited;

  Crud_Query.Close;
  Crud_Query.ParamByName('id_account').Value := D2Restaurant.IdAccount;
  Crud_Query.ParamByName('name').Value       := '%' + AText + '%';
  Crud_Query.Open;
end;

function TFormProduct.CrudOnEdit: Boolean;
begin
  Result := inherited;

  Self.OpenQuery;
  DM.QryProduct.Edit;
  Self.OpenImage;
end;

function TFormProduct.CrudOnInsert: Boolean;
begin
  Result := inherited;

  Self.OpenQuery;
  DM.QryProduct.Insert;
  DM.QryProduct.FieldByName('id_account').AsInteger := D2Restaurant.IdAccount;
  DM.QryProduct.FieldByName('status').AsString      := 'Active';
  DM.QryProduct.FieldByName('image_file').AsString  := 'nopicture.gif';
  Self.OpenImage;
end;

function TFormProduct.CrudOnSave: Boolean;
begin
  Result := inherited;

  Self.SaveImage;
  DM.QryProduct.Post;
end;

function TFormProduct.CrudOnDelete: Boolean;
begin
  Result := inherited;

  if DM.QryProduct.FieldByName('id').AsInteger > 0 then
  begin
    DM.QrySalesOrderItem.Close;
    DM.QrySalesOrderItem.MacroByName('filter').AsRaw         := 'WHERE id_product = :id_product';
    DM.QrySalesOrderItem.ParamByName('id_product').AsInteger := DM.QryProduct.FieldByName('id').AsInteger;
    DM.QrySalesOrderItem.Open;
    if not DM.QrySalesOrderItem.IsEmpty then
    begin
      MessageDlg('In use, cannot delete!', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
      Exit(False);
    end;
  end;

  var LFolderImage := APPConfig.Path.Data + 'support\images\product';
  if (DM.QryProduct.FieldByName('image_file').AsString <> '') and (DM.QryProduct.FieldByName('image_file').AsString <> 'nopicture.gif') and
     TFile.Exists(LFolderImage + DM.QryProduct.FieldByName('image_file').AsString) then
  begin
    TFile.Delete(LFolderImage + DM.QryProduct.FieldByName('image_file').AsString);
  end;
  DM.QryTag.Delete;
end;

function TFormProduct.CrudOnBack: Boolean;
begin
  Result := inherited;

end;

function TFormProduct.CrudOnClose: Boolean;
begin
  Result := inherited;

  DM.QryTag.Close;
end;

end.
