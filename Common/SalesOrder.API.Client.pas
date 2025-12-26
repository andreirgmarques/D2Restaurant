unit SalesOrder.API.Client;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, DateUtils, DB,
{$IFNDEF FPC}
  JSON,
{$ELSE}
  fpjson,
{$ENDIF}
  D2Bridge.Rest.Http;

type
  { TSalesOrderAPIClient }
  TSalesOrderAPIClient = class(TD2BridgeRestClientModule)
  private

  public
    function Route: string; override;

    // EndPoints
    function SalesOrderPreparing: ID2BridgeRestResponse;
  end;

implementation

{ TSalesOrderAPIClient }

function TSalesOrderAPIClient.Route: string;
begin
  Result := 'salesorder';
end;

function TSalesOrderAPIClient.SalesOrderPreparing: ID2BridgeRestResponse;
var
  LURL: String;
begin
  Result := nil;

  LURL := BuildURL(FullEndpoint, [], ['status=Preparing']);

  try
    Result := RESTGetToJSON(LURL, Token);
  except
  end;
end;

end.
