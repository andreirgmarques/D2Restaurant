unit D2Restaurant.API;

interface

uses
  System.Classes, System.SysUtils,
  // Your Rest API Client Modules
  Auth.API.Client, // Insert Module Client Auth or comment this module
  // API Transport Client
  D2Bridge.Rest.Http;

type
  ID2BridgeRestResponse = D2Bridge.Rest.Http.ID2BridgeRestResponse;
  HTTPStatus            = D2Bridge.Rest.Http.THTTPStatus;

type
  { TD2RestaurantAPI }
  TD2RestaurantAPI = class(TD2BridgeRestRootClient)
  private
    FAuth: TAuthRestAPIClient; // Rest API Auth Module
    // Your Variables API Client Modules
  public
    constructor Create;
    destructor Destroy; override;

    // Your Class API Function
    function Auth: TAuthRestAPIClient;
  end;

const
  D2RestaurantAPIUrlProd = 'http://127.0.0.1:8888/api';
  D2RestaurantAPIUrlTest = 'http://127.0.0.1:8888/api';

var
  D2RestaurantAPI: TD2RestaurantAPI;

implementation

{ TD2RestaurantAPI }

constructor TD2RestaurantAPI.Create;
begin
  inherited;
  Core.URLBaseProduction := D2RestaurantAPIUrlProd;
  Core.URLBaseTest       := D2RestaurantAPIUrlTest;

  D2Bridge.Rest.Http.FormatSettings := Core.FormatSettings;

  // Instance Auth Module Client
  FAuth := TAuthRestAPIClient.Create(Core);

  // Instance Client Modules

end;

destructor TD2RestaurantAPI.Destroy;
begin
  FAuth.Free;

  // Destroy Client Module

  inherited Destroy;
end;

function TD2RestaurantAPI.Auth: TAuthRestAPIClient;
begin
  result := FAuth;
end;

end.
