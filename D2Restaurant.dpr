{$IFDEF D2DOCKER}library {$ELSE}program {$ENDIF} D2Restaurant;

{$IFDEF D2BRIDGE}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Vcl.Forms,
  D2Bridge.ServerControllerBase in 'D:\DESEN\Delphi\Componentes\d2bridgeframework\Beta\D2Bridge Framework\D2Bridge.ServerControllerBase.pas' {D2BridgeServerControllerBase: TDataModule},
  Prism.SessionBase in 'D:\DESEN\Delphi\Componentes\d2bridgeframework\Beta\D2Bridge Framework\Prism\Prism.SessionBase.pas' {PrismSessionBase: TPrismSessionBase},
  D2RestaurantWebApp in 'D2RestaurantWebApp.pas' {D2RestaurantWebAppGlobal},
  D2Restaurant_Session in 'D2Restaurant_Session.pas' {D2RestaurantSession},
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
  Unit_Login in 'Unit_Login.pas' {FormLogin},
  Unit_D2Bridge_Server_Console in 'Unit_D2Bridge_Server_Console.pas',
  Unit_Menu in 'Unit_Menu.pas' {FormMenu},
  Unit_Dashboard in 'Unit_Dashboard.pas' {FormDashboard},
  Unit_DM in 'Common\Unit_DM.pas' {DM: TDataModule},
  Unit_MailConfirmation in 'Unit_MailConfirmation.pas' {FormMailConfirmation},
  Unit_CreateAccount in 'Unit_CreateAccount.pas' {FormCreateAccount},
  Useful in 'Common\Useful.pas',
  Unit_CrudTemplate in 'Unit_CrudTemplate.pas' {FormCrudTemplate},
  Unit_Tag in 'Unit_Tag.pas' {FormTag},
  Unit_ProductCategory in 'Unit_ProductCategory.pas' {FormProductCategory},
  Unit_Product in 'Unit_Product.pas' {FormProduct},
  Unit_SalesOrder in 'Unit_SalesOrder.pas' {FormSalesOrder},
  Unit_SalesOrderCategory in 'Unit_SalesOrderCategory.pas' {FormSalesOrderCategory},
  Unit_SalesOrderProduct in 'Unit_SalesOrderProduct.pas' {FormSalesOrderProduct},
  Unit_SalesOrderItem in 'Unit_SalesOrderItem.pas' {FormSalesOrderItem};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  TD2BridgeServerConsole.Run
end.
