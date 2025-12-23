unit Unit_Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus,
  D2Bridge.Forms; // Declare D2Bridge.Forms always in the last unit

type
  TFormMenu = class(TD2BridgeForm)
    MainMenu1: TMainMenu;
    Dashboard1: TMenuItem;
    Config1: TMenuItem;
    Logout1: TMenuItem;
    Checkout1: TMenuItem;
    Product1: TMenuItem;
    Category1: TMenuItem;
    Tag1: TMenuItem;
    User1: TMenuItem;
    procedure Logout1Click(Sender: TObject);
    procedure Tag1Click(Sender: TObject);
    procedure Category1Click(Sender: TObject);
    procedure Product1Click(Sender: TObject);
    procedure Dashboard1Click(Sender: TObject);
    procedure Checkout1Click(Sender: TObject);
  private

  public

  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

function FormMenu: TFormMenu;

implementation

uses
  D2RestaurantWebApp, Unit_Tag, Unit_ProductCategory, Unit_Product, Unit_Dashboard, Unit_TagSalesOrder;

function FormMenu: TFormMenu;
begin
  Result := TFormMenu(TFormMenu.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TFormMenu.Checkout1Click(Sender: TObject);
begin
  if FormTagSalesOrder = nil then
    TFormTagSalesOrder.CreateInstance;
  FormTagSalesOrder.Show;
end;

procedure TFormMenu.Dashboard1Click(Sender: TObject);
begin
  if FormDashboard = nil then
    TFormDashboard.CreateInstance;
  FormDashboard.Show;
end;

procedure TFormMenu.ExportD2Bridge;
begin
  inherited;
  Title    := 'Menu';
  SubTitle := '';

  // TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile   := '';

  // Export yours Controls
  with D2Bridge.Items.add do
  begin
    with SideMenu(MainMenu1) do
    begin
      Color       := $003277EF;
      Image.Local := 'support\images\logo\logod2restaurant2.png';
    end;
  end;
end;

procedure TFormMenu.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
  inherited;
  if PrismControl.VCLComponent = MainMenu1 then
  begin
    with PrismControl.AsSideMenu do
    begin
      MenuItemFromVCLComponent(Dashboard1).Icon := 'fas fa-gauge';
      MenuItemFromCaption('Checkout').Icon      := 'fas fa-dollar-sign';
      MenuItemFromCaption('Config').Icon        := 'fas fa-screwdriver-wrench';
      MenuItemFromCaption('Product').Icon       := 'fas fa-box-open';
      MenuItemFromCaption('Category').Icon      := 'fas fa-object-group';
      MenuItemFromCaption('Tag').Icon           := 'fas fa-tags';
      MenuItemFromCaption('User').Icon          := 'fas fa-users';
      MenuItemFromCaption('Logout').Icon        := 'fas fa-door-open';
    end;
  end;

  // Menu example
  {
    if PrismControl.VCLComponent = MainMenu1 then
    PrismControl.AsMainMenu.Title:= 'AppTeste'; //or in SideMenu use asSideMenu

    if PrismControl.VCLComponent = MainMenu1 then
    PrismControl.AsMainMenu.Image.URL:= 'https://d2bridge.com.br/images/LogoD2BridgeTransp.png'; //or in SideMenu use asSideMenu

    //GroupIndex example
    if PrismControl.VCLComponent = MainMenu1 then
    with PrismControl.AsMainMenu do  //or in SideMenu use asSideMenu
    begin
    MenuGroups[0].Caption:= 'Principal';
    MenuGroups[1].Caption:= 'Services';
    MenuGroups[2].Caption:= 'Items';
    end;

    //Chance Icon and Propertys MODE 1 *Using MenuItem component
    PrismControl.AsMainMenu.MenuItemFromVCLComponent(Abrout1).Icon:= 'fa-solid fa-rocket';

    //Chance Icon and Propertys MODE 2 *Using MenuItem name
    PrismControl.AsMainMenu.MenuItemFromName('Abrout1').Icon:= 'fa-solid fa-rocket';
  }

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

procedure TFormMenu.Logout1Click(Sender: TObject);
begin
  Session.Close(True);
end;

procedure TFormMenu.Product1Click(Sender: TObject);
begin
  if FormProduct = nil then
    TFormProduct.CreateInstance;
  FormProduct.Show;
end;

procedure TFormMenu.Category1Click(Sender: TObject);
begin
  if FormProductCategory = nil then
    TFormProductCategory.CreateInstance;
  FormProductCategory.Show;
end;

procedure TFormMenu.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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

procedure TFormMenu.Tag1Click(Sender: TObject);
begin
  if FormTag = nil then
    TFormTag.CreateInstance;
  FormTag.Show;
end;

end.
