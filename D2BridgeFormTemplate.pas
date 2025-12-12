unit D2BridgeFormTemplate;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, D2Bridge.Prism.Form;

type
  TD2BridgeFormTemplate = class(TD2BridgePrismForm)
  private
    procedure ProcessHTML(Sender: TObject; var AHTMLText: string);
    procedure ProcessTagHTML(const TagString: string; var ReplaceTag: string);
    // function OpenMenuItem(EventParams: TStrings): String;
  protected
    procedure DoInitPrismControl(const PrismControl: TPrismControl); override;
  public
    constructor Create(AOwner: TComponent; D2BridgePrismFramework: TObject); override;
  end;

implementation

uses
  D2RestaurantWebApp, Unit_Menu;

{ TD2BridgeFormTemplate }

constructor TD2BridgeFormTemplate.Create(AOwner: TComponent; D2BridgePrismFramework: TObject);
begin
  inherited;
  // Events
  OnProcessHTML := ProcessHTML;
  OnTagHTML     := ProcessTagHTML;

  if FormMenu = nil then
    TFormMenu.CreateInstance;
  FormMenu.ExportWithD2Bridge(D2Bridge);

  // Yours CallBacks Ex:
  // Session.CallBacks.Register('OpenMenuItem', OpenMenuItem);

  // Other Example CallBack embed
  {
    Session.CallBacks.Register('OpenMenuItem',
    function(EventParams: TStrings): string
    begin
    if MyForm = nil then
    TMyForm.CreateInstance;
    MyForm.Show;
    end);
  }
end;

procedure TD2BridgeFormTemplate.DoInitPrismControl(const PrismControl: TPrismControl);
begin
  inherited DoInitPrismControl(PrismControl);
  if PrismControl.IsSideMenu then
    FormMenu.DoInitPrismControl(PrismControl);
end;

procedure TD2BridgeFormTemplate.ProcessHTML(Sender: TObject; var AHTMLText: string);
begin
  // Intercep HTML Code

end;

procedure TD2BridgeFormTemplate.ProcessTagHTML(const TagString: string; var ReplaceTag: string);
begin
  // Process TAGs HTML {{TAGNAME}}
  if TagString = 'UserName' then
  begin
    ReplaceTag := 'Name of User';
  end;
end;

end.
