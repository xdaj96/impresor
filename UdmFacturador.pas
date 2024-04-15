unit UdmFacturador;

interface

uses
    Winapi.Windows, Winapi.Messages,System.SysUtils, System.Classes, Data.DB, IBX.IBDatabase,registry, Data.DBXFirebird,
  Data.SqlExpr, Data.FMTBcd, Vcl.ComCtrls, IBX.IBCustomDataSet,
  IBX.IBQuery,  Datasnap.DBClient, System.Variants, IBX.IBStoredProc, frxClass,
  frxDBSet;

Const
  RegKey ='Software\Autofarma\Impresor\';

type
  TdmFacturador = class(TDataModule)
    dsfact: TDataSource;
    datosbusqueda: TDataSource;
    databasefire: TIBDatabase;
    transactionprod: TIBTransaction;
    qbusqueda: TIBQuery;
    qbusquedaCOD_ALFABETA: TIntegerField;
    qbusquedaNRO_TROQUEL: TIntegerField;
    qbusquedaCOD_BARRASPRI: TIBStringField;
    qbusquedaNOM_LARGO: TIBStringField;
    qbusquedaCOD_IVA: TIBStringField;
    qbusquedaCAN_STK: TSmallintField;
    qbusquedaPRECIO: TIBBCDField;
    DPRINCIPAL: TClientDataSet;
    DPRINCIPALCOD_ALFABETA: TStringField;
    DPRINCIPALNRO_TROQUEL: TStringField;
    DPRINCIPALCOD_BARRASPRI: TStringField;
    DPRINCIPALNOM_LARGO: TStringField;
    DPRINCIPALCOD_IVA: TStringField;
    DPRINCIPALPRECIO: TCurrencyField;
    DPRINCIPALCANTIDAD: TIntegerField;
    DPRINCIPALPRECIO_TOTAL: TCurrencyField;
    DPRINCIPALimportetotal: TAggregateField;
    qafiliados: TIBQuery;
    dataafiliados: TDataSource;
    tranafiliados: TIBTransaction;
    qiafiliados: TIBQuery;
    dsecundario: TClientDataSet;
    dsbusqueda: TDataSource;
    dsecundarioCOD_ALFABETA: TStringField;
    dsecundarioNRO_TROQUEL: TStringField;
    dsecundarioCOD_BARRASPRI: TStringField;
    dsecundarioNOM_LARGO: TStringField;
    dsecundarioCOD_IVA: TStringField;
    dsecundarioCAN_STK: TIntegerField;
    dsecundarioPRECIO: TStringField;
    dsecundarioDESCUENTO: TStringField;
    DPRINCIPALPRECIO_TOTALDESC: TCurrencyField;
    dsecundarioPRECIO_TOTAL: TFloatField;
    DPRINCIPALDESCUENTOS: TCurrencyField;
    DPRINCIPALporcentaje: TIntegerField;
    DPRINCIPALdescuentos_total: TAggregateField;
    DPRINCIPALnetoxcobrar: TAggregateField;
    dsecundarioRUBRO: TStringField;
    qbusquedaCOD_RUBRO: TIBStringField;
    qosmaplanesos: TIBQuery;
    qNROVALIDACION: TIBQuery;
    IBTransactionVAL: TIBTransaction;
    IBQcodigoprestador: TIBQuery;
    dsecundarioDESCUENTOOS: TStringField;
    dsecundarioDESCUENTOCO1: TStringField;
    dsecundarioDESCUENTOCO2: TStringField;
    DPRINCIPALPORCENTAJEOS: TFloatField;
    DPRINCIPALPORCENTAJECO1: TFloatField;
    DPRINCIPALPORCENTAJECO2: TFloatField;
    DPRINCIPALDESCUENTOSOS: TCurrencyField;
    ibqcaja: TIBQuery;
    icomprobante: TIBQuery;
    ticomprobante: TIBTransaction;
    qvendedor: TIBQuery;
    qcomprobante: TIBQuery;
    qcomprobanteTIP_COMPROBANTE: TIBStringField;
    qcomprobanteTIP_IMPRE: TIBStringField;
    tpanel1: TIBTransaction;
    Dscomprobante: TDataSource;
    qpanel2: TIBQuery;
    qtipocomprob: TIBQuery;
    qcliente: TIBQuery;
    qicliente: TIBQuery;
    traninsertcliente: TIBTransaction;
    DSicliente: TDataSource;
    qupdatecliente: TIBQuery;
    DPRINCIPALDESCUENTOCO1: TCurrencyField;
    DPRINCIPALDESCUENTOCO2: TCurrencyField;
    DPRINCIPALDESCUENTOTOTALOS: TAggregateField;
    DPRINCIPALDESCUENTOTOTALCO1: TAggregateField;
    DPRINCIPALDESCUENTOTOTALCO2: TAggregateField;
    dsecundarioCOD_LABORATORIO: TStringField;
    qbusquedaCOD_LABORATORIO: TIBStringField;
    DPRINCIPALCOD_LABORATORIO: TStringField;
    DPRINCIPALcan_stk: TIntegerField;
    DPRINCIPALVALE: TStringField;
    DPRINCIPALcan_vale: TStringField;
    cdsfactura: TClientDataSet;
    dsfactura: TDataSource;
    cdsfacturacod_alfabeta: TStringField;
    cdsfacturacod_barraspri: TStringField;
    cdsfacturanom_largo: TStringField;
    cdsfacturacantidad: TStringField;
    cdsfacturacantidadcontrol: TStringField;
    frxDBDataset1: TfrxDBDataset;
    reportefactonline: TfrxReport;
    cdsfacturareporte: TClientDataSet;
    cdsfacturareportecod_alfabeta: TStringField;
    cdsfacturareportecod_barraspri: TStringField;
    cdsfacturareportenom_largo: TStringField;
    cdsfacturareportecantidad: TStringField;
    cdsfacturareportecantidadcontrol: TStringField;
    dsfacturareporte: TDataSource;
    qnrocomprob: TIBQuery;
    transcomprob: TIBTransaction;
    CDSetiquetas: TClientDataSet;
    CDSetiquetascod_alfabeta: TStringField;
    CDSetiquetasNRO_TROQUEL: TStringField;
    CDSetiquetasCOD_BARRASPRI: TStringField;
    CDSetiquetasNOM_LARGO: TStringField;
    CDSetiquetasCOD_IVA: TStringField;
    CDSetiquetasCAN_STK: TIntegerField;
    CDSetiquetasPRECIO: TStringField;
    CDSetiquetasDESCUENTO: TStringField;
    CDSetiquetasPRECIO_TOTAL: TFloatField;
    CDSetiquetaSRUBRO: TStringField;
    CDSetiquetasDESCUENTOOS: TStringField;
    CDSetiquetasDESCUENTOCO1: TStringField;
    CDSetiquetasDESCUENTOCO2: TStringField;
    CDSetiquetasCOD_LABORATORIO: TStringField;
    dsetiquetas: TDataSource;
    frxetiquetas: TfrxDBDataset;
    reporteetiquetas: TfrxReport;
    basecfg: TIBDatabase;
    qcaja: TIBQuery;
    trancaja: TIBTransaction;
    qbusquedaVARLABO: TIBBCDField;
    qbusquedaVARRUBRO: TIBBCDField;
    dsecundariocod_tamano: TStringField;
    qbusquedacod_tamano: TSmallintField;
    qlimite: TIBQuery;
    tranlimite: TIBTransaction;
    qlimiteCAN_MAXUNIDXREC: TSmallintField;
    qlimiteCAN_MAXUNIDXREN: TSmallintField;
    qlimiteCAN_MAXUNIDXTICKET: TSmallintField;
    qlimiteCAN_MAXRENXTICKET: TSmallintField;
    DPRINCIPALtamano: TIntegerField;
    qdire: TIBQuery;
    qdireDES_DIRECCION: TIBStringField;
    transdire: TIBTransaction;
    qbusquedaDES_ACCFARM: TIBStringField;
    dsecundariodes_accion: TStringField;
    dsecundariodes_droga: TStringField;
    DPRINCIPALModificado: TBooleanField;
    CDSetiquetascod_tamano: TStringField;
    CDSetiquetasdes_accion: TStringField;
    CDSetiquetasdes_droga: TStringField;
    qcuit: TIBQuery;
    qcuitNRO_CUIT: TIBStringField;
    tcuit: TIBTransaction;
    cdsreporteiva: TClientDataSet;
    qreporteiva: TIBQuery;
    tranreporteiva: TIBTransaction;
    dsreporteiva: TDataSource;
    qreporteivaPUESTOVENTA: TIBStringField;
    qreporteivaMINIMO: TFloatField;
    qreporteivaMAXIMO: TFloatField;
    qreporteivaTIP_COMPROBANTE: TIBStringField;
    qreporteivaPOR_PORCENTAJE: TIBBCDField;
    qreporteivaCUIT: TIBStringField;
    qreporteivaCLIENTE: TIBStringField;
    qreporteivaFECHA: TDateField;
    qreporteivaBRUTO: TIBBCDField;
    qreporteivaIVA: TIBBCDField;
    qreporteivaNETOGRAVADO: TIBBCDField;
    qreporteivaNETONOGRAVADO: TIBBCDField;
    qreporteivaNETOGRAVDESC: TIBBCDField;
    qreporteivaTOTAL: TIBBCDField;
    cdsreporteivafecha: TDateField;
    cdsreporteivacomprobante: TStringField;
    cdsreporteivadescripcion: TStringField;
    cdsreporteivacliente: TStringField;
    cdsreporteivacuit: TStringField;
    cdsreporteivanetogravado: TCurrencyField;
    cdsreporteivatasa: TFloatField;
    cdsreporteivaimporteiva: TCurrencyField;
    cdsreporteivanogravado: TCurrencyField;
    cdsreporteivapercepcionibb: TFloatField;
    cdsreporteivatotal: TCurrencyField;
    qreporteivaDES_COMP: TIBStringField;
    cdsfacturareportenro_factura: TStringField;
    qbusquedaDES_DROGA: TIBStringField;
    qdroga: TIBQuery;
    qdrogaDES_DROGA: TIBStringField;
    dsdroga: TDataSource;
    qtablaiva: TIBQuery;
    qbusquedastock: TIBQuery;
    qinsertlineastock: TIBQuery;
    qranking: TIBQuery;
    tranking: TIBTransaction;
  private
    { Private declarations }
  public

    function getConexion():TIBDatabase;
    procedure AbrirConexion();
    procedure Cerrarconexion();
    function cobertura (codigo: string; alfabeta: string): double ;
    function getPuntoVenta():String;
    function getSucursal(): String;

  end;

var
  dmFacturador: TdmFacturador;
  ptoVenta:String;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmFacturador }

procedure TdmFacturador.AbrirConexion();
var
reg: tregistry;

begin

  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey(RegKey,true);
  databasefire.Connected:=false;

  databasefire.DatabaseName:=reg.ReadString('rutabase');
  databasefire.Params.Values['User_Name']:='SYSDBA';
  databasefire.Params.Values['Password']:='nmpnet';
  databasefire.DefaultTransaction:=transactionprod;
  databasefire.Connected:=true;
 // qbusqueda.Database:=databasefire;
//  datosbusqueda.DataSet:=qbusqueda;
//  qbusqueda.Transaction:=transactionprod;

end;

procedure TdmFacturador.Cerrarconexion();
var
reg: tregistry;

begin


  databasefire.Connected:=false;


end;

function TdmFacturador.cobertura(codigo, alfabeta: string):Double;
begin

end;





function TdmFacturador.getConexion: TIBDatabase;
begin
  getConexion:=databasefire;
end;




function TdmFacturador.getPuntoVenta: String;
VAR
   reg: tregistry;
   ret:String;
begin
 Reg := TRegistry.Create;
 Reg.RootKey := HKEY_CURRENT_USER;
 Reg.OpenKey(regKey,true);
 ret:=REG.ReadString('PV');
 getPuntoVenta:=ret;
end;


function TdmFacturador.getSucursal: String;
VAR
   reg: tregistry;
   ret:String;
begin
 Reg := TRegistry.Create;
 Reg.RootKey := HKEY_CURRENT_USER;
 Reg.OpenKey(regKey,true);
 ret:=REG.ReadString('sucursal');
 getSucursal:=ret;
end;
end.
