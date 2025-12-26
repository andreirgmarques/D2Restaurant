unit API.SalesOrder;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils, JSON,
  Prism.Types,
  D2Bridge.JSON,
  D2Bridge.Rest.Server.Functions,
  D2Bridge.Rest.Session;


implementation

procedure GetSalesOrder(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
begin
  var LStatus := Request.Query('status');
  var LFilter := 'WHERE id_account = :id_account';
  if LStatus <> '' then
    LFilter   := Format('%s AND status = :status', [LFilter]);

  RestSession.DM.QrySalesOrder.Close;
  RestSession.DM.QrySalesOrder.MacroByName('filter').AsRaw         := LFilter;
  RestSession.DM.QrySalesOrder.ParamByName('id_account').AsInteger := Request.JWTidentity.ToInteger;
  if LStatus <> '' then
    RestSession.DM.QrySalesOrder.ParamByName('status').AsString    := LStatus;
  RestSession.DM.QrySalesOrder.Open;
  RestSession.DM.QrySalesOrder.IndexFieldNames := 'id';

  Response.JSON(HTTPStatus.SuccessOK, RestSession.DM.QrySalesOrder);
end;

initialization
  AddGet('/api/salesorder', GetSalesOrder, True);

end.
