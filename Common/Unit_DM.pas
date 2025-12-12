unit Unit_DM;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, ACBrBase, ACBrMail;

type
  TDM = class(TDataModule)
    DBConnection: TFDConnection;
    PGDriver: TFDPhysPgDriverLink;
    QryAccount: TFDQuery;
    DscAccount: TDataSource;
    QryProduct: TFDQuery;
    DscProduct: TDataSource;
    QryProductCategory: TFDQuery;
    DscProductCategory: TDataSource;
    QrySalesOrder: TFDQuery;
    DscSalesOrder: TDataSource;
    QrySalesOrderItem: TFDQuery;
    DscSalesOrderItem: TDataSource;
    QryTag: TFDQuery;
    DscTag: TDataSource;
    QryUser: TFDQuery;
    DscUser: TDataSource;
    ACBrMail: TACBrMail;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ConfigureEmail;
    procedure ConnectDatabase;
  public
    class procedure CreateInstance;
    procedure DestroyInstance;
  end;

function DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  D2Bridge.Instance, D2RestaurantWebApp;

{$R *.dfm}

procedure TDM.ConfigureEmail;
begin
  ACBrMail.Host     := 'sandbox.smtp.mailtrap.io';
  ACBrMail.Username := '9f7488f22ec632';
  ACBrMail.Password := '4aea71ed8cd73d';
  ACBrMail.Port     := '587';
end;

procedure TDM.ConnectDatabase;
begin
  try
    var LParams      := TFDPhysPGConnectionDefParams(DBConnection.Params);
    LParams.DriverID := 'PG';
    LParams.Server   := AppConfig.Database.PostgreSQL.Host;
    LParams.Port     := AppConfig.Database.PostgreSQL.Port;
    LParams.Database := AppConfig.Database.PostgreSQL.Database;
    LParams.UserName := 'fontdata';
    LParams.Password := 'FDTI1252';
    DBConnection.Open;
  except
    on E: Exception do
      raise Exception.CreateFmt('Falha na Conexão com Banco de Dados.%s%s', [sLineBreak, E.Message]);
  end;
end;

class procedure TDM.CreateInstance;
begin
  D2BridgeInstance.CreateInstance(Self);
end;

function DM: TDM;
begin
  Result := TDM(D2BridgeInstance.GetInstance(TDM));
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  Self.ConfigureEmail;
  Self.ConnectDatabase;
end;

procedure TDM.DestroyInstance;
begin
  D2BridgeInstance.DestroyInstance(Self);
end;

end.
