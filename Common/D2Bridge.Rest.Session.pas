unit D2Bridge.Rest.Session;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  Prism.Types,
  D2Bridge.Rest.Session.Interfaces,
  D2Bridge.Rest.Session.BaseClass,
  Unit_DM; // , Adds Your Uses units

type
  TD2BridgeRestSession = class(TD2BridgeRestSessionBaseClass, ID2BridgeRestSession)
  private
    FDM: TDM;
  public
    // Variables
    // Classes

    function DM: TDM;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TD2BridgeRestSession }

constructor TD2BridgeRestSession.Create;
begin
  inherited;
  FDM := TDM.Create(nil);

  {
    Data:= TMyCLass.Create;

    if WebMethod = wmtGET then //Get
    begin
    if Path = '/api/ping' then
    begin
    //Instance Class...
    end;

    if RequireJWT then
    begin

    end;
    end;
  }

end;

destructor TD2BridgeRestSession.Destroy;
begin
  try
    // Destroy all instanced Object
    if Assigned(FDM) then
      FDM.Free;
  except
  end;

  inherited;
end;

function TD2BridgeRestSession.DM: TDM;
begin
  Result := FDM;
end;

end.
