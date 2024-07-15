﻿unit Uimpresor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, registry,
  Vcl.Grids, Vcl.ValEdit, Vcl.StdCtrls, Vcl.Buttons, Vcl.DBGrids, Vcl.FileCtrl,  uDetalleTicket,
  Data.DB, Datasnap.DBClient,  uPagoChequeService, uUtils,Xml.xmldom, Xml.XMLIntf,uTicketService,
  msxmldom, xml.xmldoc, udticket, Vcl.OleCtrls, FiscalPrinterLib_TLB, system.Win.ComObj, math,
  Vcl.Menus, Vcl.AppEvnts,uBaseTicket,uTicketTEpson,uTicketBEpson,uTicketAEpson,ufBuscarTK,

  // Formas de pago
    uFPagoCte,uPagoCtaCteService,uPagoEfectivo,uPagoefectivoService,uFormaPagoService,uBaseFormaPago,uPagoCheque,
    uPagoTarjeta,uPagoTarjetaService


  ; //uadicionales;
const

  RegKey ='Software\Autofarma\impresor\';

type
  Tfimpresor = class(TForm)
    pg: TPageControl;
    Principal: TTabSheet;
    Configuracion: TTabSheet;
    flist: TFileListBox;
    mticket: TMemo;
    binsertar: TBitBtn;
    Bguardar: TBitBtn;
    Btestear: TBitBtn;
    dsource: TDataSource;
    Blimpiartodo: TBitBtn;
    HASAR: THASAR;
    bimprimir: TBitBtn;
    cdsdetalle: TClientDataSet;
    cdsdetalleCOD_ALFABETA: TStringField;
    cdsdetalleNRO_TROQUEL: TStringField;
    cdsdetalleVALE: TStringField;
    cdsdetalleCOD_BARRASPRI: TStringField;
    cdsdetalleNOM_LARGO: TStringField;
    cdsdetalleCOD_IVA: TStringField;
    cdsdetallePRECIO: TCurrencyField;
    cdsdetalleCANTIDAD: TIntegerField;
    cdsdetallePRECIO_TOTAL: TCurrencyField;
    cdsdetallePRECIO_TOTALDESC: TCurrencyField;
    cdsdetalleDESCUENTOS: TCurrencyField;
    cdsdetallePORCENTAJEOS: TFloatField;
    cdsdetallePORCENTAJECO1: TFloatField;
    cdsdetallePORCENTAJECO2: TFloatField;
    cdsdetalleDESCUENTOSOS: TCurrencyField;
    cdsdetalleDESCUENTOCO1: TCurrencyField;
    cdsdetalleDESCUENTOCO2: TCurrencyField;
    cdsdetalleCOD_LABORATORIO: TStringField;
    cdsdetallecan_stk: TIntegerField;
    cdsdetalletamano: TIntegerField;
    cdsdetalleModificado: TBooleanField;
    cdsdetalleGENTILEZA: TIntegerField;
    cdsdetalleRUBRO: TStringField;
    cdsdetalleIMPORTEGENT: TFloatField;
    cdsdetalleCODAUTORIZACION: TStringField;
    cdsdetalleporcentaje: TFloatField;
    cdsdetalleItem: TIntegerField;
    cdsdetalleimportetotal: TAggregateField;
    cdsdetalledescuentos_total: TAggregateField;
    cdsdetallenetoxcobrar: TAggregateField;
    cdsdetalleDESCUENTOTOTALOS: TAggregateField;
    cdsdetalleDESCUENTOTOTALCO1: TAggregateField;
    cdsdetalleDESCUENTOTOTALCO2: TAggregateField;
    cdsdetalleTOTALGENTILEZA: TAggregateField;
    contador: TTimer;
    Gfacturador: TDBGrid;
    Label1: TLabel;
    cdsdetallecan_vale: TStringField;
    Bimprimire: TBitBtn;
    VLparametros: TValueListEditor;
    Button2: TButton;
    Button3: TButton;
    btnReimprimir: TBitBtn;
    procedure BguardarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure binsertarClick(Sender: TObject);
    procedure BlimpiartodoClick(Sender: TObject);
    procedure bimprimirClick(Sender: TObject);
    function ComenzarFiscal:Boolean;
    procedure contadorTimer(Sender: TObject);
    procedure Insertarcomprobante;
    procedure limpiarunidadticket;
    procedure comprobarcliente;
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BimprimireClick(Sender: TObject);

    procedure copiadigital;
    procedure Button1Click(Sender: TObject);
    procedure btnReimprimirClick(Sender: TObject);
  private
   Ticket:TTicket;
      imp_efectivo: string;
    imp_tarjeta: string;
    imp_cc: string;
    imp_co1: string;
    imp_co2: string;
    imp_ch: string;
    imp_os: string;
    imp_gentilezas: string;
    nro_comprob: integer;
    nro_comprobdigital: integer;
    impresion: string;
    ticketImprimir:TBaseTicket;
    reimpresion:boolean;
     nIntentos:integer;
    ultTipComprob:string;
    archivo: string;
    ticketService:TTicketService;
    procedure crearComprobanteImpresion;

    procedure registrarPago(pagoService: TFormaPagoService; unCompPago: TBaseFormaPago);

    procedure registrarFormaDePagoTicket;
    procedure cargarGridDetalleTicket;



  public
    procedure SetTicket(unTicket:TTicket);
    procedure mostrarVentanaPrimerPlano;
  end;

var
  fimpresor: Tfimpresor;
  path: string;
  nro_comprob: integer;
  imprimi: boolean;



implementation

{$R *.dfm}

uses UdmFacturador;

procedure Tfimpresor.mostrarVentanaPrimerPlano;
var
  hwndApp: THandle;
begin
  // Reemplaza 'NombreDeTuAplicacion' con el título de la ventana de tu aplicación
  hwndApp := FindWindow(nil, 'impresor');


  if IsWindow(hwndApp) then
  begin
    // Muestra la ventana si está minimizada
    ShowWindow(hwndApp, SW_RESTORE);

    // Pone la ventana al primer plano
    SetWindowPos(hwndApp, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  end
  else
  begin
    ShowMessage('La aplicación no se encontró.');
  end;
end;

procedure Tfimpresor.cargarGridDetalleTicket;
var
  itemTicket: TDetalleFactura;
begin
  for itemTicket in ticket.detalleFac do
  begin
    //ITEMVAL:=DETALLEVAL.ChildNodes[v];
    cdsdetalle.Append;
    //cdsdetallenroitem.AsString:=itemval.ChildNodes['NroItem'].Text;

    //--------- DATOS DEL PRODUCTO-----------------------------//
    cdsdetalleitem.Asstring := itemTicket.NroItem;
    cdsdetallenro_troquel.Asstring := itemTicket.NroTroquel;
    cdsdetallenom_largo.Asstring := itemTicket.NomLargo;
    cdsdetalleprecio.Asstring := itemTicket.Precio;
    cdsdetallecantidad.Asstring := itemTicket.Cantidad;
    cdsdetallecod_alfabeta.Asstring := itemTicket.CodAlfabeta;
    cdsdetallecod_barraspri.Asstring := itemTicket.CodBarrasPri;
    cdsdetallecod_laboratorio.Asstring := itemTicket.CodLaboratorio;
    cdsdetallecan_stk.Asstring := itemTicket.CanStk;
    cdsdetalletamano.Asstring := itemTicket.Tamano;
    cdsdetallerubro.Asstring := itemTicket.Rubro;

    //--------- DATOS DEL PRODUCTO-----------------------------//

    cdsdetallecod_iva.Asstring := itemTicket.CodIVA;

    //--------- PORCENTAJES -----------------------------------//
    cdsdetalleporcentaje.Asstring := itemTicket.Porcentaje;
    cdsdetalleporcentajeos.Asstring := itemTicket.PorcentajeOS;
    cdsdetalleporcentajeco1.Asstring := itemTicket.PorcentajeCO1;
    cdsdetalleporcentajeco2.Asstring := itemTicket.PorcentajeCO2;
    cdsdetallegentileza.Asstring := itemTicket.Gentileza;

    //--------- PORCENTAJES -----------------------------------//

    //--------- VALES -----------------------------------//
    cdsdetallevale.Asstring := itemTicket.Vale;
    cdsdetallecan_vale.Asstring := itemTicket.CanVale;
    //--------- VALES -----------------------------------//


    //--------- DESCUENTOS -----------------------------------//
    cdsdetalledescuentos.Asstring := itemTicket.Descuentos;
    cdsdetalledescuentosos.Asstring := itemTicket.DescuentosOS;
    cdsdetalledescuentoco1.Asstring := itemTicket.DescuentoCO1;
    cdsdetalledescuentoco2.Asstring := itemTicket.DescuentoCO2;

   //--------- DESCUENTOS -----------------------------------//

    //--------- IMPORTES -----------------------------------//
    cdsdetalleimportegent.Asstring := itemTicket.ImporteGent;
    cdsdetallemodificado.Asstring := itemTicket.Modificado;
    cdsdetalleprecio_totaldesc.Asstring := itemTicket.PrecioTotalDesc;
    cdsdetalleprecio_total.Asstring := itemTicket.PrecioTotal;

    //--------- IMPORTES -----------------------------------//


    cdsdetallecodautorizacion.Asstring := itemTicket.CodAutorizacion;


  end;
end;






procedure Tfimpresor.crearComprobanteImpresion;
begin
  if ticketImprimir = nil then
  begin
  if ticket.tip_comprobante = 'A' then
    ticketImprimir := TTicketAEpson.Create(ticket, GFacturador);
  {Ticket Factura B}
  if ticket.tip_comprobante = 'B' then
    ticketImprimir := TTicketBEpson.Create(ticket, GFacturador);
  {Ticket T}
  if ticket.tip_comprobante = 'T' then
    ticketImprimir := TTicketTEpson.Create(ticket, GFacturador);
  end;

end;



function LeftPad(S: string; Ch: Char; Len: Integer): string;
var
  RestLen: Integer;
begin
  Result  := S;
  RestLen := Len - Length(s);
  if RestLen < 1 then Exit;
  Result := S + StringOfChar(Ch, RestLen);
end;

function RightPad(S: string; Ch: Char; Len: Integer): string;
var
  RestLen: Integer;

begin
  Result  := S;
  RestLen := Len - Length(s);
  if RestLen < 1 then Exit;
  Result := StringOfChar(Ch, RestLen) + S;
end;
function SepararCadena(const Cadena: string; const Delim: Char): TStringList;
begin
  Result:= TStringList.Create;
  Result.Delimiter:= Delim;
  Result.DelimitedText:= Cadena;
end;

function cadLongitudFija (cadena : string; longitud : Integer;
    posicionIzquierda : boolean; valorRelleno : string) : string;
var
  i: integer;
begin
  if length(cadena) > longitud then
    cadena := copy(cadena, 1, longitud)
  else
  begin
    for i := 1 to longitud - Length(cadena) do
      if posicionIzquierda then
        cadena := valorRelleno + cadena
      else
        cadena := cadena + valorRelleno;
  end;
  Result := cadena;
end;
function conectarUnidad(letraUnidad : string; rutaUnidad : string;
    contrasenaUsuario : string; nombreUsuario : string;
    mostrarError : Boolean;
  reconectarAlIniciar : Boolean): DWORD;
var
  nRes: TNetResource;
  errCode: DWORD;
  dwFlags: DWORD;
begin
  FillChar(NRes, SizeOf(NRes), #0);
  nRes.dwType := RESOURCETYPE_DISK;
  nRes.lpLocalName  := PChar(letraUnidad);
  nRes.lpRemoteName := PChar(rutaUnidad);
  if reconectarAlIniciar then
    dwFlags := CONNECT_UPDATE_PROFILE and CONNECT_INTERACTIVE
  else
    dwFlags := CONNECT_INTERACTIVE;

  if (contrasenaUsuario = '') and (nombreUsuario = '') then
    errCode := WNetAddConnection3(fimpresor.Handle, nRes,
        nil, nil, dwFlags)
  else
    errCode := WNetAddConnection3(fimpresor.Handle, nRes,
        pchar(contrasenaUsuario), pchar(nombreUsuario), dwFlags);

  if (errCode <> NO_ERROR) and (mostrarError) then
  begin
    Application.MessageBox(PChar('No se ha podido conectar la unidad [' +
        letraUnidad + ']' + #13#10 +
        SysErrorMessage(GetLastError)), 'Error al conectar unidad de red',
        MB_ICONERROR + MB_OK);
  end;
  Result := errCode;
end;
function desconectarUnidad (letraUnidad : string; mostrarError : Boolean;
    forzarDesconexion : Boolean; guardar : Boolean): DWORD;
var
  dwFlags: DWORD;
  errCode: DWORD;
begin
  if guardar then
    dwFlags := CONNECT_UPDATE_PROFILE
  else
    dwFlags := 0;
  errCode := WNetCancelConnection2(PChar(letraUnidad), dwFlags, forzarDesconexion);
  if (errCode <> NO_ERROR) and (mostrarError) then
  begin
    Application.MessageBox(PChar('Error al desconectar unidad de red:'
        + #13#10 + SysErrorMessage(GetLastError)),
        'Error al desconectar',  MB_ICONERROR + MB_OK);
  end;
  Result := errCode;
end;

//----------------------------------------------------------------------------//
// Pagos del ticket
//----------------------------------------------------------------------------//

procedure Tfimpresor.registrarFormaDePagoTicket;
var
  pagoService: TFormaPagoService;
  unCompPago: TBaseFormaPago;
begin
  //INSERTAR VTTBPAGOCHEQUE          --VR LLEVA TODOS LOS MEDIOS DE PAGO
  if TICKET.cheque <> 0 then
  begin
      pagoService := TpagoChequeService.Create;
      unCompPago:= TPagoCheque.Create;
      registrarPago(pagoService,unCompPago);
  end;
  //INSTERTAR VTTPAGOCTACTE
  if TICKET.ctacte <> 0 then
  begin
     pagoService:= TFormaPagoCtaCteService.Create;
     unCompPago:=TFPagoCte.Create;
     registrarPago(pagoService,unCompPago);
  end;
  //INSERTAR VTTPAGOEFECTIVO
  if TICKET.efectivO <> 0 then
  begin
    pagoService:= TPagoEfectivoService.Create;
    unCompPago:=TPagoEfectivo.Create;
    registrarPago(pagoService,unCompPago);
  end;


 //INSERTAR VTTBPAGOTARJETA
 if TICKET.tarjeta<>0 then
 begin
    pagoService:= TPagoTarjetaService.Create;
    unCompPago:=TPagoTarjeta.Create;
    registrarPago(pagoService,unCompPago);
  end;

end;




// Manejador de las formas de pago
procedure Tfimpresor.registrarPago(pagoService: TFormaPagoService; unCompPago: TBaseFormaPago);
begin

  unCompPago.NroSucursal    := ticket.sucursal;
  unCompPago.TipComprobante := TICKET.comprobante;
  unCompPago.NroComprob:= ticket.fiscla_pv + (rightpad(inttostr(nro_comprob), '0', 8));

  // El pago se realiza en efectivo
  if unCompPago is TPagoEfectivo then
     TPagoEfectivo(unCompPago).imp_efectivo:= TICKET.efectivo;

  // El pago se realiza en cuenta corriente
  if unCompPago is TFPagoCTE then
  begin
    TFPagoCTE(unCompPago).CodCtaCte:= ticket.codigocc;
    TFPagoCTE(unCompPago).CodSubCta:= ticket.codigosubcc;
    TFPagoCTE(unCompPago).ImpCtaCte:= TICKET.ctacte;
    TFPagoCTE(unCompPago).ImpSubCtaCte:=  TICKET.ctacte;
  end;

  // El pago se realiza con cheque
  if unCompPago is TPagoCheque then
  begin
      TPagoCheque(unCompPago).cod_banco := ticket.codigocheque;
      TPagoCheque(unCompPago).nro_cheque := ticket.numerocheque;
      TPagoCheque(unCompPago).importe := TICKET.cheque;
  end;

  // El pago se realiza con tarjeta
  if unCompPago is TPagoTarjeta then
  begin
      TPagoTarjeta(unCompPago).codigo := ticket.codigotarjeta;
      TPagoTarjeta(unCompPago).importe := TICKET.tarjeta;
  end;



  pagoService.registrarFormaPago(unCompPago);
  pagoService.Free;
  unCompPago.Free;
end;



//------------------PAGOS DEL TICKET--------------------------------------------


procedure Tfimpresor.ApplicationEvents1Minimize(Sender: TObject);
begin
 // Hide;
  // mostramos el TrayIcon
 // TrayIcon1.Visible:=True;
end;

procedure Tfimpresor.BguardarClick(Sender: TObject);
var
 reg: tregistry;

begin

   Reg := TRegistry.Create(KEY_WRITE);
  Reg.RootKey := HKEY_CURRENT_USER;

  Reg.OpenKey(regKey,true);
  Reg.WriteString('rutabase', vlparametros.Values['Ruta base de datos']);
  Reg.WriteString('rutabasecfg', vlparametros.Values['Ruta base de configuracion']);
  Reg.WriteString('sucursal', vlparametros.Values['Numero de sucursal']);
  Reg.WriteString('pv', vlparametros.Values['Numero de comprobante']);
  Reg.WriteString('pf', vlparametros.Values['Numero de Pv']);
  Reg.WriteString('com', vlparametros.Values['Puerto COM fiscal']);
  Reg.WriteString('URL', vlparametros.Values['Url Webapps']);
  Reg.WriteString('Reportes', vlparametros.Values['Ruta reportes']);
  Reg.WriteString('impresion', vlparametros.Values['Ruta impresion']);
  Reg.WriteString('Recargo', vlparametros.Values['Recargo']);
  REG.WriteString('P-441F',vlparametros.Values['P-441F']);
  REG.WriteString('caja',vlparametros.Values['Modulo de caja']);
  REG.WriteString('Fiscal',vlparametros.Values['Marca del Fiscal']);
  Reg.WriteString('error', vlparametros.Values['Ruta errores']);
  Reg.WriteString('talon', vlparametros.Values['Copia Talon']);
  Reg.WriteString('vale', vlparametros.Values['Vale duplicado']);
  Reg.WriteString('conformidad_afiliado',VLparametros.Values['Conformidad afiliado']);
  Reg.WriteString('talonvonline',VLparametros.Values['Talon valida online']);


  Reg.Free;
  showmessage('Datos actualizados');
end;


procedure Tfimpresor.binsertarClick(Sender: TObject);
var
archivoxmlval: txmldocument;
encabezadoval,rtaval,nrorefval,detalleval,
flag: integer;
I: INTEGER;
v: integer;
J: integer;
f: integer;
itemsval:TTicketItemval;
leido: boolean;
unaTasaIVA:TTasaIVA;
 importeGravado, importeNeto:double;
   importeNetodesc, importeGravadodesc: double;
   key: word;

   reg: tregistry;
   pathimpresion: wchar;
   patherror: wchar;

//   form3: tfadicionales;
begin

//  Reg := TRegistry.Create(KEY_WRITE);
//  Reg.RootKey := HKEY_CURRENT_USER;
 contador.Enabled:=false;
 btnReimprimir.Enabled:= false;
 sleep(100);
for I := 0 to flist.Items.Count -1 do
    begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey(regKey,true);
    dmFacturador.AbrirConexion();
    ITEMsVAL:=TTicketItemval.Create;

                blimpiartodo.Click;
                archivo:=flist.Items[i];
                archivoxmlval:= TXMLDocument.Create(Application);

                ticketService:= TTicketService.Create(archivoxmlval,ticket);
                ticket:= ticketService.obtenerTicket(path+archivo);
                ticketService.Free;


                mticket.Lines.Add(datetostr(TICKET.fechafiscal)+'-----------------------------'+'Nro COMPROB: '+TICKET.comprobante+' '+TICKET.nrocomprobantenf);
                mticket.Lines.Add('VENDEDOR: '+TICKET.cod_vendedor);
                mticket.Lines.Add('Cliente: '+TICKET.cod_cliente+'----------------------'+'CTA. CTE: '+TICKET.codigocc);
                mticket.Lines.Add('CODIGO OS: '+ticket.codigo_OS);
                mticket.Lines.Add('Afiliado os: '+ticket.afiliado_numero);
                mticket.Lines.Add('Matricula: '+ticket.medico_nro_matricula);
                mticket.Lines.Add('Importe neto a cobrar: '+floattostr(ticket.importeneto));
                mticket.Lines.Add('Importe total: '+floattostr(ticket.importebruto));
                mticket.Lines.Add('Pago efectivo: '+floattostr(ticket.efectivo));
                mticket.Lines.Add('Pago tarjeta: '+floattostr(ticket.tarjeta));
                mticket.Lines.Add('Pago ctacte: '+floattostr(ticket.ctacte));
                mticket.Lines.Add('Pago cheque: '+floattostr(ticket.cheque));
                mticket.Lines.Add('Pago a cargo os: '+floattostr(ticket.importecargoos));
                mticket.Lines.Add('Pago a cargo co1: '+floattostr(ticket.importecargoco1));
                mticket.Lines.Add('Codigo de validacion: '+ticket.valnroreferencia);

                if cdsdetalle.Active=false then
                    begin
                      cdsdetalle.CreateDataSet;
                      cdsdetalle.Active:=true;
                    end;
               cargarGridDetalleTicket;


 gfacturador.DataSource.DataSet.First;

  importeGravado := 0;
  IMPORTENETO := 0;
  importeNetodesc := 0;
  importeGravadodesc := 0;

  Gfacturador.DataSource.DataSet.First;
  Ticket.TotalesIVA.Clear;
  while not Gfacturador.DataSource.DataSet.Eof do
  Begin
    unaTasaIVA := nil;
    Ticket.TotalesIVA.TryGetValue(Gfacturador.DataSource.DataSet.FieldByName
      ('cod_iva').AsString, unaTasaIVA);
    if (unaTasaIVA = nil) then
    Begin
      unaTasaIVA := TTasaIVA.Create;
    End;

    unaTasaIVA.codigoIVA := Gfacturador.DataSource.DataSet.FieldByName
      ('cod_iva').AsString;
    importeGravado := ((Gfacturador.DataSource.DataSet.FieldByName('precio')
      .Asfloat * Gfacturador.DataSource.DataSet.FieldByName('cantidad').Asfloat)
      - Gfacturador.DataSource.DataSet.FieldByName('descuentos').Asfloat);

    if (unaTasaIVA.getPorcentajeIVA > 0) then
    Begin
      IMPORTENETO := importeGravado / (1 + unaTasaIVA.getPorcentajeIVA / 100);
    End
    else
    Begin
      IMPORTENETO := importeGravado;
    End;
    unaTasaIVA.netogravado := unaTasaIVA.netogravado + IMPORTENETO;

    if Gfacturador.DataSource.DataSet.FieldByName('importegent').Asfloat > 0
    then
    begin
      importeGravadodesc := 0;
    end;
    if Gfacturador.DataSource.DataSet.FieldByName('importegent').Asfloat = 0
    then
    begin
      importeGravadodesc := Gfacturador.DataSource.DataSet.FieldByName
        ('descuentos').Asfloat;
    end;

    Ticket.TotalesIVA.AddOrSetValue(Gfacturador.DataSource.DataSet.FieldByName
      ('cod_iva').AsString, unaTasaIVA);
    if (unaTasaIVA.getPorcentajeIVA > 0) then
    Begin
      importeNetodesc := importeGravadodesc /
        (1 + unaTasaIVA.getPorcentajeIVA / 100);
    End
    else
    Begin
      importeNetodesc := importeGravadodesc;
    End;
    unaTasaIVA.netogravadodesc := unaTasaIVA.netogravadodesc + importeNetodesc;

    // sumaitem:=gfacturador.Fields[3].Asinteger+sumaitem;
    Gfacturador.DataSource.DataSet.Next;

  End;

   //-------------------------tablas ivas-------------------------------//
  dmfacturador.qtablaiva.Close;
  dmfacturador.qtablaiva.SQL.Text:=concat('select cod_iva, por_iva from prmaiva');
  dmfacturador.qtablaiva.Open;
  dmfacturador.qtablaiva.First;
  while not dmfacturador.qtablaiva.Eof do
  begin
  if dmfacturador.qtablaiva.Fields[0].Text='A' THEN
  BEGIN
    TICKET.IVAA:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
  if dmfacturador.qtablaiva.Fields[0].Text='B' THEN
  BEGIN
    TICKET.IVAB:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
    if dmfacturador.qtablaiva.Fields[0].Text='C' THEN
  BEGIN
    TICKET.IVAC:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
    if dmfacturador.qtablaiva.Fields[0].Text='D' THEN
  BEGIN
    TICKET.IVAD:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
      if dmfacturador.qtablaiva.Fields[0].Text='E' THEN
  BEGIN
    TICKET.IVAE:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
      if dmfacturador.qtablaiva.Fields[0].Text='F' THEN
  BEGIN
    TICKET.IVAF:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
      if dmfacturador.qtablaiva.Fields[0].Text='s' THEN
  BEGIN
    TICKET.IVAs:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
  dmfacturador.qtablaiva.Next;
  end;

  //-------------------------tablas ivas-------------------------------//
   if TUtils.contienePalabra('_reimpresion',archivo)  then
   begin
      reimpresion:=true;
   end
   else
   begin
      reimpresion:= False;
   end;



  if ticket.fiscal='H' then
  BEGIN
    BIMPRIMIR.Click;
  END;
  if TICKET.fiscal='E' then
  begin
    bimprimire.Click;
  end;

     delete(ticket.comprobante,length(ticket.comprobante)-0,1);
     ticket.comprobante:=ticket.comprobante+REG.ReadString('PV');
     ticket.fiscla_pv:=Reg.ReadString('pf');
     ticket.nrorefadicional:=ticket.valnroreferencia;
     if ticket.cod_cliente<>'' then
     begin
     comprobarcliente;
     end;
     if ticket.codigo_Co1=ticket.codigo_Cos2 then
     begin
       ticket.codigo_Cos2:='';
       ticket.nombre_cos2:='';

     end;
     try
      try
        if not TUtils.contienePalabra('_reimpresion',archivo)  then
        begin

          Insertarcomprobante;
        end;

       except
       on E:Exception do
       begin
         ShowMessage(e.Message);
       end;
      end;
     finally
        begin
         //CopyFile(pchar(path+archivo), pchar(path+'\copia\'+ticket.nroticketadicional+'.xml'), false);
         if not TUtils.contienePalabra('_reimpresion',archivo)  then
        begin
            CopyFile(pchar(path+archivo), pchar(ticket.errores+ticket.nroticketadicional+'.xml'), false);
        end;
         deletefile(path+archivo);
         flist.Update;
         //blimpiartodo.Click;
         dmFacturador.CerrarConexion();

      end;


     end;










 end;
  blimpiartodo.Click;
   flist.Update;
   btnReimprimir.Enabled:= true;
   contador.Enabled:=true;
end;


procedure Tfimpresor.bimprimirClick(Sender: TObject);
var
ESTADOFISCAL: string;
z: integer;
RESPONSABLEIVA: TiposDeResponsabilidades;
valoriva: double;
direccioncliente: olevariant;
descripcioncortada: string;
descripcion: string;
efectivoredondeado: double;
afiliado: double;

reg: tregistry;
begin
  dmfacturador.qtablaiva.Close;
  dmfacturador.qtablaiva.SQL.Text:=concat('select cod_iva, por_iva from prmaiva');
  dmfacturador.qtablaiva.Open;
  dmfacturador.qtablaiva.First;
  while not dmfacturador.qtablaiva.Eof do
  begin
  if dmfacturador.qtablaiva.Fields[0].Text='A' THEN
  BEGIN
    TICKET.IVAA:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
  if dmfacturador.qtablaiva.Fields[0].Text='B' THEN
  BEGIN
    TICKET.IVAB:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
    if dmfacturador.qtablaiva.Fields[0].Text='C' THEN
  BEGIN
    TICKET.IVAC:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
    if dmfacturador.qtablaiva.Fields[0].Text='D' THEN
  BEGIN
    TICKET.IVAD:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
      if dmfacturador.qtablaiva.Fields[0].Text='E' THEN
  BEGIN
    TICKET.IVAE:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
      if dmfacturador.qtablaiva.Fields[0].Text='F' THEN
  BEGIN
    TICKET.IVAF:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
      if dmfacturador.qtablaiva.Fields[0].Text='s' THEN
  BEGIN
    TICKET.IVAs:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
  dmfacturador.qtablaiva.Next;
  end;
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey(regKey,true);
  ticket.p441f:=Reg.ReadString('P-441F');
//  ticket.coeficientetarjeta:=1;
  impresion:='';
//------------------------------TICKET COMUN inicio - -------------------------------------------//
if ticket.tip_comprobante='T' then
BEGIN


   if not (ComenzarFiscal) then
   Begin
      ShowMessage('No se pudo conectar al fiscal');

      exit;
   End;

   hasar.BorrarFantasiaEncabezadoCola(true,true,true);
   hasar.CancelarComprobanteFiscal;

   hasar.TratarDeCancelarTodo;
   if hasar.DescripcionEstadoControlador='No hay ningún comprobante abierto' then
    beGIN
       hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
       hasar.Encabezado[2]:=ticket.direccionsucursal;
       hasar.Encabezado[8]:='-------------------------------------------';
       HASAR.AbrirComprobanteFiscal(TICKET_C);
       Gfacturador.DataSource.DataSet.First;
        while not Gfacturador.DataSource.DataSet.Eof do
          begin
                if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[11].FieldName).asstring='0') then
                begin
                hasar.ImprimirTextofiscal(ticket.codigo_OS +': '+Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[14].FieldName).asstring+' ('+(formatfloat('#####', Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[11].FieldName).asfloat))+'%)');
                end;
                if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[12].FieldName).asstring='0') then
                begin
                hasar.ImprimirTextofiscal(ticket.codigo_Co1+': '+Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[20].FieldName).asstring+' ('+Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[12].FieldName).asstring+'%)');
                end;
                 if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[10].FieldName).asstring='B' then
                begin
                  valoriva:=TICKET.IVAB;
                end;
                if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[10].FieldName).asstring='A' then
                begin
                  valoriva:=TICKET.IVAA;
                end;
                descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);

                if (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring)<>'0' then
                BEGIN
                descripcion:='('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring)+')'+descripcion;
                END;



                descripcioncortada:=copy(descripcion, 0, 20);
                HASAR.ImprimirItem(
               (descripcioncortada),
               (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asfloat),
               ((gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat)*ticket.coeficientetarjeta),
                valoriva, 0);

             Gfacturador.DataSource.DataSet.Next;

          end;


        Gfacturador.DataSource.DataSet.First;
        while not Gfacturador.DataSource.DataSet.Eof do
          begin
          if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[22].FieldName).asfloat<>0 then
               begin
                  descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
                  if (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring)<>'' then
                  BEGIN
                  descripcion:='('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring)+')'+descripcion;
                  END;



                 descripcioncortada:=copy(descripcion, 0, 20);
                 hasar.DescuentoGeneral(descripcioncortada,(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[24].FieldName).asfloat),true);
               end;
            Gfacturador.DataSource.DataSet.Next;
          end;





        if ticket.efectivo=0 then
        begin
          ticket.efectivo:=0;
        end;
        if ticket.tarjeta=0 then
         begin
           ticket.tarjeta:=0;
         end;
        if ticket.ctacte=0 then
         begin
           ticket.ctacte:=0;
         end;
        if ticket.importecargoos=0 then
         begin
           ticket.importecargoos:=0;
         end;
         if ticket.importecargoco1=0 then
         begin
           ticket.importecargoco1:=0;
         end;
         if ticket.cheque=0 then
         begin
           ticket.cheque:=0;
         end;


        afiliado:= ticket.efectivo+ ticket.tarjeta+ticket.ctacte+ticket.cheque;
        if ticket.efectivo<>0 then
        begin
        hasar.ImprimirPago('Efectivo: ',ticket.efectivo);
        end;

        if ticket.tarjeta<>0 then
        begin
        hasar.ImprimirPago('Tarjeta '+ticket.codigotarjeta+': ',ticket.tarjeta);
        end;
        if ticket.ctacte<>0 then
        begin
        hasar.ImprimirPago('CC '+ticket.codigocc+' '+ticket.nombrecc+':',ticket.ctacte);
        end;
        if ticket.cheque<>0 then
        begin
        hasar.ImprimirPago('Cheque: ',ticket.cheque);
        end;
        if ticket.importecargoos<>0 then
        begin
        hasar.ImprimirPago(ticket.nombre_os ,ticket.importecargoos);
        end;
        if ticket.importecargoco1<>0 then
        begin
        hasar.ImprimirPago(ticket.nombre_co1 ,ticket.importecargoco1);
        end;


        hasar.Encabezado[11]:='Numero de ref: '+ticket.valnroreferencia;
        if not (ticket.puntos_farmavalor='') or (ticket.puntos_farmavalor='0') then
        begin
        hasar.Encabezado[14]:='Puntos Farmavalor: '+ticket.puntos_farmavalor;
        hasar.Encabezado[15]:='Los puntos se actualizan cada 24 hs';
        end;
        hasar.BorrarFantasiaEncabezadoCola(false,true,false);

        HASAR.CerrarComprobanteFiscal;
        nro_comprob:=strtoint(Hasar.respuesta[3]);
        ticket.fechafiscal:=hasar.FechaHoraFiscal;
        ticket.numero_ticketfiscal:=nro_comprob;

        if ticket.p441f='N' then
        BEGIN

            if (ticket.codigo_OS<>'') or (ticket.codigo_Co1<>'') then
            begin

              hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
              hasar.Encabezado[2]:='Obra Social: '+ticket.codigo_OS+'-'+ticket.nombre_os;
              hasar.Encabezado[3]:='Coseguro 1: '+ticket.codigo_Co1+'-'+ticket.nombre_co1;
              hasar.Encabezado[4]:='Afiliado: '+ticket.afiliado_apellido+' '+ticket.afiliado_nombre;
              hasar.Encabezado[5]:='Nro afiliado: '+ticket.afiliado_numero;
              hasar.Encabezado[6]:='Mat. Med: '+ticket.medico_nro_matricula;
              hasar.Encabezado[7]:='Receta: '+ticket.numero_receta;
              hasar.Encabezado[8]:='    Numero de ref: '+ticket.valnroreferencia;
              hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto((ticket.importecargoos),-2));
              hasar.Encabezado[12]:='CO1: '+floattostr(ticket.importecargoco1)+' '+ 'AFI: '+floattostr(roundto(afiliado,-2));
              hasar.Encabezado[13]:='EF: '+floattostr(roundto((ticket.efectivo),-2))+' CH: '+floattostr(roundto((ticket.cheque),-2))+' CC: '+floattostr(roundto((ticket.ctacte),-2))+' TJ: '+floattostr(roundto((ticket.tarjeta),-2));



            end;
            if ticket.codigo_os<>'' then
            begin
              z:=z+1
            end;
              if ticket.codigo_Co1<>'' then
            begin
              z:=z+1
            end;
            hasar.DNFHFarmacias(z);
            hasar.finalizar;

        END;
                    if TICKET.p441f='S' then
            begin
             if ticket.codigo_OS<>'' then
              begin
              HASAR.Comenzar;
              hasar.BorrarFantasiaEncabezadoCola(true,true,true);
              hasar.CancelarComprobanteFiscal;
              hasar.TratarDeCancelarTodo;
              hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
              hasar.Encabezado[2]:='Obra Social: '+ticket.codigo_OS+'-'+ticket.nombre_os;
              hasar.Encabezado[3]:='Coseguro 1: '+ticket.codigo_Co1+'-'+ticket.nombre_co1;
              hasar.Encabezado[4]:='Afiliado: '+ticket.afiliado_nombre+' '+ticket.afiliado_apellido;
              hasar.Encabezado[5]:='Nro afiliado: '+ticket.afiliado_numero;
              hasar.Encabezado[6]:='Mat. Med: '+ticket.medico_nro_matricula;
              hasar.Encabezado[7]:='Receta: '+ticket.numero_receta;
              hasar.Encabezado[9]:='Numero de ref: '+ticket.valnroreferencia;
              hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto((ticket.importecargoos),-2));
              hasar.Encabezado[12]:='CO1: '+floattostr(ticket.importecargoco1)+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(afiliado,-2));
              hasar.Encabezado[13]:='EF: '+floattostr(roundto((ticket.efectivo),-2))+' CH: '+floattostr(roundto((ticket.cheque),-2))+' CC: '+floattostr(roundto((ticket.ctacte),-2))+' TJ: '+floattostr(roundto((ticket.tarjeta),-2));
              HASAR.AbrirComprobanteNoFiscal;
              hasar.ImprimirTextoNoFiscal('DOCUMENTO NO FISCAL FARMACIAS');
              hasar.ImprimirTextoNoFiscal('NRO TICKET: '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
              hasar.ImprimirTextoNoFiscal('--------------------------------------------------');
             Gfacturador.DataSource.DataSet.First;

              while not Gfacturador.DataSource.DataSet.Eof do
              begin
                    descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
                    descripcioncortada:=copy(descripcion, 0, 20);
                    HASAR.ImprimirTextoNoFiscal((descripcioncortada)+'('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asstring)+')  '+floattostr(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat));
                    HASAR.ImprimirTextoNoFiscal(' ');
                    Gfacturador.DataSource.DataSet.Next;
              end;


              hasar.CerrarComprobanteNoFiscal;

              end;
               if ticket.codigo_Co1<>'' then

                    begin
                    HASAR.Comenzar;
                    hasar.BorrarFantasiaEncabezadoCola(true,true,true);
                    hasar.CancelarComprobanteFiscal;
                    hasar.TratarDeCancelarTodo;
                    hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
                    hasar.Encabezado[2]:='Obra Social: '+ticket.codigo_OS+'-'+ticket.nombre_os;
                    hasar.Encabezado[3]:='Coseguro 1: '+ticket.codigo_Co1+'-'+ticket.nombre_co1;
                    hasar.Encabezado[4]:='Afiliado: '+ticket.afiliado_nombre+' '+ticket.afiliado_apellido;
                    hasar.Encabezado[5]:='Nro afiliado: '+ticket.afiliado_numero;
                    hasar.Encabezado[6]:='Mat. Med: '+ticket.medico_nro_matricula;
                    hasar.Encabezado[7]:='Receta: '+ticket.numero_receta;
                    hasar.Encabezado[9]:='Numero de ref: '+ticket.valnroreferencia;
                    hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto((ticket.importecargoos),-2));
                    hasar.Encabezado[12]:='CO1: '+floattostr(ticket.importecargoco1)+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(afiliado,-2));
                    hasar.Encabezado[13]:='EF: '+floattostr(roundto((ticket.efectivo),-2))+' CH: '+floattostr(roundto((ticket.cheque),-2))+' CC: '+floattostr(roundto((ticket.ctacte),-2))+' TJ: '+floattostr(roundto((ticket.tarjeta),-2));
                    HASAR.AbrirComprobanteNoFiscal;
                    hasar.ImprimirTextoNoFiscal('DOCUMENTO NO FISCAL FARMACIAS');
                    hasar.ImprimirTextoNoFiscal('NRO TICKET: '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
                    hasar.ImprimirTextoNoFiscal('--------------------------------------------------');
                   Gfacturador.DataSource.DataSet.First;

                    while not Gfacturador.DataSource.DataSet.Eof do
                    begin
                          descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
                          descripcioncortada:=copy(descripcion, 0, 20);
                          HASAR.ImprimirTextoNoFiscal((descripcioncortada)+'('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asstring)+')  '+floattostr(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat));
                          HASAR.ImprimirTextoNoFiscal(' ');
                          Gfacturador.DataSource.DataSet.Next;
                    end;


                hasar.CerrarComprobanteNoFiscal;

                    end;

        end;

        if TICKET.llevavale='SI' then
        BEGIN
          HASAR.Comenzar;
          hasar.BorrarFantasiaEncabezadoCola(true,true,true);
          hasar.CancelarComprobanteFiscal;
          hasar.TratarDeCancelarTodo;
          hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;

          if (ticket.nombre_os='') and (ticket.nombre_co1<>'') then
          begin
          hasar.Encabezado[2]:='Cobertura: '+ticket.nombre_co1;
          end;
          if ticket.nombre_os<>'' then
          begin
          hasar.Encabezado[2]:='Cobertura: '+ticket.nombre_os;
          end;
          if (ticket.nombre_os='') and (ticket.nombre_co1='')  then
          begin
          hasar.Encabezado[2]:='Cobertura: ';
          end;
          if (ticket.nombre_os='') and (ticket.nombre_co1<>'') then
          begin
          hasar.Encabezado[3]:='Afiliado: '+ticket.afiliado_nombreco1+' '+ticket.afiliado_apellidoco1;
          hasar.Encabezado[4]:='Nro afiliado: '+ticket.afiliado_numeroco1;
          end;
           if (ticket.nombre_os<>'') then
          begin
          hasar.Encabezado[3]:='Afiliado: '+ticket.afiliado_nombre+' '+ticket.afiliado_apellido;
          hasar.Encabezado[4]:='Nro afiliado: '+ticket.afiliado_numero;
          end;


          hasar.Encabezado[5]:='* * * * * * VALE A RETIRAR * * * * * *';
          hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(ticket.importecargoos,-2));
          hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(afiliado,-2));
          hasar.Encabezado[13]:='EF: '+floattostr(roundto(ticket.efectivo,-2))+' CH: '+floattostr(roundto(ticket.cheque,-2))+' CC: '+floattostr(roundto(ticket.ctacte,-2))+' TJ: '+floattostr(roundto(ticket.tarjeta,-2));
          HASAR.AbrirComprobanteNoFiscal;
          hasar.ImprimirTextoNoFiscal('Emision VR'+ticket.fiscla_pv+': '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
          Gfacturador.DataSource.DataSet.First;

          while not Gfacturador.DataSource.DataSet.Eof do
          begin
               if Gfacturador.Fields[17].AsSTRING='SI' then
               BEGIN
               hasar.ImprimirTextoNoFiscal(Gfacturador.Fields[1].AsSTRING);
               hasar.ImprimirTextoNoFiscal('Unidades Vale:'+Gfacturador.Fields[18].AsSTRING);
               END;
               Gfacturador.DataSource.DataSet.Next;
          end;
          hasar.ImprimirTextoNoFiscal('REF. CPBT. '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));

          hasar.CerrarComprobanteNoFiscal;
          if ticket.numero_ticketfiscal<>0 then
          begin
          impresion:='OK'

          end;
        END;


  end;
END;
//------------------------------TICKET COMUN FINAL -----------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------TICKET FACTURA A INICIO-------------------------------------------//

if ticket.tip_comprobante='A' then
BEGIN
if not (ComenzarFiscal) then
   Begin
      ShowMessage('No se pudo conectar al fiscal');

      exit;
   End;

   hasar.BorrarFantasiaEncabezadoCola(true,true,true);
   hasar.CancelarComprobanteFiscal;
   hasar.TratarDeCancelarTodo;
   if hasar.DescripcionEstadoControlador='No hay ningún comprobante abierto' then
    beGIN
    IF Ticket.CONDICIONIVA = 'RESPONSABLE MONOTRIBUTO' THEN
        RESPONSABLEIVA := MONOTRIBUTO
       ELSE IF Ticket.CONDICIONIVA = 'RESPONSABLE INSCRIPTO' THEN
        RESPONSABLEIVA := RESPONSABLE_INSCRIPTO
       ELSE IF Ticket.CONDICIONIVA = 'RESPONSABLE NO INSCRIPTO' THEN
        RESPONSABLEIVA := RESPONSABLE_NO_INSCRIPTO
       ELSE IF Ticket.CONDICIONIVA = 'EXENTO' THEN
        RESPONSABLEIVA := RESPONSABLE_EXENTO
       ELSE IF Ticket.CONDICIONIVA = 'CONSUMIDOR FINAL' THEN
        RESPONSABLEIVA := CONSUMIDOR_FINAL;




       hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
       hasar.Encabezado[2]:=ticket.direccionsucursal;
       direccioncliente:=ticket.direccion;
       hasar.encabezado[9]:='Direccion cliente: '+ticket.direccion;
       hasar.DatosCliente(ticket.DESCRIPCIONCLIENTE, ticket.CUIT, TIPO_CUIT, RESPONSABLEIVA, direccioncliente);

       Hasar.AbrirComprobanteFiscal(TICKET_FACTURA_A);

       Gfacturador.DataSource.DataSet.First;
        while not Gfacturador.DataSource.DataSet.Eof do
          begin
                if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[11].FieldName).asstring='0') then
                begin
                hasar.ImprimirTextofiscal(ticket.codigo_OS +': '+Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[14].FieldName).asstring+' ('+Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[11].FieldName).asstring+'%)');
                end;
                if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[12].FieldName).asstring='0') then
                begin
                hasar.ImprimirTextofiscal(ticket.codigo_Co1+': '+Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[20].FieldName).asstring+' ('+Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[12].FieldName).asstring+'%)');
                end;
                if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[10].FieldName).asstring='B' then
                begin
                  valoriva:=ticket.IVAB;
                end;
                if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[10].FieldName).asstring='A' then
                begin
                  valoriva:=ticket.ivaa;
                end;
                descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
                descripcioncortada:=copy(descripcion, 0, 20);
                HASAR.ImprimirItem(
               (descripcioncortada),
               (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asfloat),
               ((gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat)*ticket.coeficientetarjeta),
                valoriva, 0);


         Gfacturador.DataSource.DataSet.Next;
          end;
          //--------------------------descuento general----------------------------------//
        Gfacturador.DataSource.DataSet.First;
        while not Gfacturador.DataSource.DataSet.Eof do
          begin
          if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[22].FieldName).asfloat<>0 then
               begin
                  descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
                  if (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring)<>'' then
                  BEGIN
                  descripcion:='('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring)+')'+descripcion;
                  END;



                 descripcioncortada:=copy(descripcion, 0, 20);
                 hasar.DescuentoGeneral(descripcioncortada,(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[24].FieldName).asfloat),true);
               end;
            Gfacturador.DataSource.DataSet.Next;
          end;

//----------------------------descuento general---------------------------------//


        if ticket.efectivo=0 then
        begin
          ticket.efectivo:=0;
        end;
        if ticket.tarjeta=0 then
         begin
           ticket.tarjeta:=0;
         end;
        if ticket.ctacte=0 then
         begin
           ticket.ctacte:=0;
         end;
        if ticket.importecargoos=0 then
         begin
           ticket.importecargoos:=0;
         end;
         if ticket.importecargoco1=0 then
         begin
           ticket.importecargoco1:=0;
         end;
         if ticket.cheque=0 then
         begin
           ticket.cheque:=0;
         end;


        afiliado:= ticket.efectivo+ ticket.tarjeta+ticket.ctacte+ticket.cheque;
        if ticket.efectivo<>0 then
        begin
        hasar.ImprimirPago('Efectivo: ',ticket.efectivo);
        end;

        if ticket.tarjeta<>0 then
        begin
        hasar.ImprimirPago('Tarjeta '+ticket.codigotarjeta+': ',ticket.tarjeta);
        end;
        if ticket.ctacte<>0 then
        begin
        hasar.ImprimirPago('CC '+ticket.codigocc+' '+ticket.nombrecc+':',ticket.ctacte);
        end;
        if ticket.cheque<>0 then
        begin
        hasar.ImprimirPago('Cheque: ',ticket.cheque);
        end;
        if ticket.importecargoos<>0 then
        begin
        hasar.ImprimirPago(ticket.nombre_os ,ticket.importecargoos);
        end;
        if ticket.importecargoco1<>0 then
        begin
        hasar.ImprimirPago(ticket.nombre_co1 ,ticket.importecargoco1);
        end;


        hasar.Encabezado[11]:='Numero de ref: '+ticket.valnroreferencia;

        hasar.BorrarFantasiaEncabezadoCola(false,true,false);

        HASAR.CerrarComprobanteFiscal;
        nro_comprob:=strtoint(Hasar.respuesta[3]);
        ticket.fechafiscal:=hasar.FechaHoraFiscal;
        if ticket.codigo_OS<>'' then
        begin
          HASAR.Comenzar;
          hasar.BorrarFantasiaEncabezadoCola(true,true,true);
          hasar.CancelarComprobanteFiscal;
          hasar.TratarDeCancelarTodo;
          hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
          hasar.Encabezado[2]:='Obra Social: '+ticket.nombre_os;
          hasar.Encabezado[3]:='Coseguro 1: '+ticket.nombre_co1;
          hasar.Encabezado[4]:='Coseguro 2: '+ticket.nombre_cos2;
          hasar.Encabezado[5]:='Afiliado: '+ticket.afiliado_nombre+' '+ticket.afiliado_apellido;
          hasar.Encabezado[6]:='Nro afiliado: '+ticket.afiliado_numero;
          hasar.Encabezado[7]:='Mat. Med: '+ticket.medico_nro_matricula;
          hasar.Encabezado[8]:='Receta: '+ticket.numero_receta;
          hasar.Encabezado[9]:='Numero de ref: '+ticket.valnroreferencia;
          hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+imp_os;
          hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+imp_efectivo;
          hasar.Encabezado[13]:='EF: '+IMP_EFECTIVO+' CH: '+imp_ch+' CC: '+imp_cc+' TJ: '+imp_TARJETA;
          HASAR.AbrirComprobanteNoFiscal;
          hasar.ImprimirTextoNoFiscal('Ticket Nro: '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
          hasar.ImprimirTextoNoFiscal('Productos:');
          Gfacturador.DataSource.DataSet.First;
          while not Gfacturador.DataSource.DataSet.Eof do
          begin

               hasar.ImprimirTextoNoFiscal((gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring)+' ('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asstring)+') '+
               (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asstring));
               Gfacturador.DataSource.DataSet.Next;
          end;


          hasar.CerrarComprobanteNoFiscal;


        end;
          if ticket.codigo_Co1<>'' then
        begin
                    HASAR.Comenzar;
          hasar.BorrarFantasiaEncabezadoCola(true,true,true);
          hasar.CancelarComprobanteFiscal;
          hasar.TratarDeCancelarTodo;
          hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
          hasar.Encabezado[2]:='Obra Social: '+ticket.nombre_os;
          hasar.Encabezado[3]:='Coseguro 1: '+ticket.nombre_co1;
          hasar.Encabezado[4]:='Coseguro 2: '+ticket.nombre_cos2;
          hasar.Encabezado[5]:='Afiliado: '+ticket.afiliado_nombre;
          hasar.Encabezado[6]:='Nro afiliado: '+ticket.afiliado_numero;
          hasar.Encabezado[7]:='Mat. Med: '+ticket.medico_nro_matricula;
          hasar.Encabezado[8]:='Receta: '+ticket.numero_receta;
          hasar.Encabezado[9]:='Numero de ref: '+ticket.valnroreferencia;
          hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+imp_os;
          hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+imp_efectivo;
          hasar.Encabezado[13]:='EF: '+IMP_EFECTIVO+' CH: '+imp_ch+' CC: '+imp_cc+' TJ: '+imp_TARJETA;
          HASAR.AbrirComprobanteNoFiscal;
          hasar.ImprimirTextoNoFiscal('Ticket Nro: '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
          hasar.ImprimirTextoNoFiscal('Productos:');
          Gfacturador.DataSource.DataSet.First;
          while not Gfacturador.DataSource.DataSet.Eof do
          begin

               hasar.ImprimirTextoNoFiscal((gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring)+' ('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asstring)+') '+
               (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asstring));
               Gfacturador.DataSource.DataSet.Next;
          end;


          hasar.CerrarComprobanteNoFiscal;

        end;

        if TICKET.llevavale='SI' then
        BEGIN
          HASAR.Comenzar;
          hasar.BorrarFantasiaEncabezadoCola(true,true,true);
          hasar.CancelarComprobanteFiscal;
          hasar.TratarDeCancelarTodo;
          hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
          hasar.Encabezado[2]:='Obra Social: '+ticket.nombre_os;
          hasar.Encabezado[3]:='Coseguro 1: '+ticket.nombre_co1;
          hasar.Encabezado[4]:='Coseguro 2: '+ticket.nombre_cos2;
          hasar.Encabezado[9]:='Numero de ref: '+ticket.valnroreferencia;
          hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+imp_os;
          hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+imp_efectivo;
          hasar.Encabezado[13]:='EF: '+IMP_EFECTIVO+' CH: '+imp_ch+' CC: '+imp_cc+' TJ: '+imp_TARJETA;
          HASAR.AbrirComprobanteNoFiscal;
          hasar.ImprimirTextoNoFiscal('VALE A RETIRAR');
          hasar.ImprimirTextoNoFiscal('Emision VR'+ticket.fiscla_pv+': '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
          hasar.ImprimirTextoNoFiscal('Productos:');
          Gfacturador.DataSource.DataSet.First;
          while not Gfacturador.DataSource.DataSet.Eof do
          begin
               if Gfacturador.Fields[17].AsSTRING='SI' then
               BEGIN
               hasar.ImprimirTextoNoFiscal(Gfacturador.Fields[1].AsSTRING);
               hasar.ImprimirTextoNoFiscal('Unidades Vale:'+Gfacturador.Fields[18].AsSTRING);
               END;
               Gfacturador.DataSource.DataSet.Next;
          end;
          hasar.ImprimirTextoNoFiscal('REF. CPBT. '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));

          hasar.CerrarComprobanteNoFiscal;

        END;

        hasar.finalizar;
          if ticket.numero_ticketfiscal<>0 then
          begin
          impresion:='OK'

          end;

    end;
END;
//------------------------------TICKET FACTURA A FINAL -----------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------TICKET FACTURA B INICIO-------------------------------------------//

if ticket.tip_comprobante='B' then
begin
   Hasar.PrecioBase:=False;
     if not (ComenzarFiscal) then
   Begin
      ShowMessage('No se pudo conectar al fiscal');

      exit;
   End;


   hasar.BorrarFantasiaEncabezadoCola(true,true,true);
   hasar.CancelarComprobanteFiscal;
   hasar.TratarDeCancelarTodo;
   direccioncliente:=ticket.direccion;
   if hasar.DescripcionEstadoControlador='No hay ningún comprobante abierto' then
    beGIN
    IF Ticket.CONDICIONIVA = 'RESPONSABLE MONOTRIBUTO' THEN
        RESPONSABLEIVA := MONOTRIBUTO
       ELSE IF Ticket.CONDICIONIVA = 'RESPONSABLE NO INSCRIPTO' THEN
        RESPONSABLEIVA := RESPONSABLE_NO_INSCRIPTO
       ELSE IF Ticket.CONDICIONIVA = 'EXENTO' THEN
        RESPONSABLEIVA := RESPONSABLE_EXENTO
       ELSE IF Ticket.CONDICIONIVA = 'CONSUMIDOR FINAL' THEN
        RESPONSABLEIVA := CONSUMIDOR_FINAL;




       hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
       hasar.Encabezado[2]:=ticket.direccionsucursal;
       hasar.encabezado[9]:='Direccion cliente: '+ticket.direccion;
       IF Ticket.CONDICIONIVA = 'EXENTO' THEN
       begin
       hasar.DatosCliente(ticket.DESCRIPCIONCLIENTE, ticket.CUIT, TIPO_CUIT, RESPONSABLEIVA,direccioncliente);
       end;
       IF Ticket.CONDICIONIVA = 'CONSUMIDOR FINAL' THEN
       begin
       if ticket.dni='' then
       begin
         ticket.dni:='1';
       end;
       hasar.DatosCliente(ticket.DESCRIPCIONCLIENTE, ticket.DNI, TIPO_DNI, RESPONSABLEIVA,direccioncliente);
       end;
       IF Ticket.CONDICIONIVA = 'RESPONSABLE NO INSCRIPTO' THEN
       begin
       hasar.DatosCliente(ticket.DESCRIPCIONCLIENTE, ticket.CUIT, TIPO_CUIT, RESPONSABLEIVA,direccioncliente);
       end;
            IF Ticket.CONDICIONIVA = 'RESPONSABLE MONOTRIBUTO' THEN
       begin
       hasar.DatosCliente(ticket.DESCRIPCIONCLIENTE, ticket.CUIT, TIPO_CUIT, RESPONSABLEIVA,direccioncliente);
       end;

       Hasar.AbrirComprobanteFiscal(TICKET_FACTURA_B);
       Gfacturador.DataSource.DataSet.First;
        while not Gfacturador.DataSource.DataSet.Eof do
          begin
                if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[11].FieldName).asstring='0') then
                begin
                hasar.ImprimirTextofiscal(ticket.codigo_OS +': '+Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[14].FieldName).asstring+' ('+Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[11].FieldName).asstring+'%)');
                end;
                if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[12].FieldName).asstring='0') then
                begin
                hasar.ImprimirTextofiscal(ticket.codigo_Co1+': '+Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[20].FieldName).asstring+' ('+Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[12].FieldName).asstring+'%)');
                end;
                 if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[10].FieldName).asstring='B' then
                begin
                  valoriva:=ticket.IVAB;
                end;
                if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[10].FieldName).asstring='A' then
                begin
                  valoriva:=ticket.IVAA;
                end;
                descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);

                if (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring)<>'0' then
                BEGIN
                descripcion:='('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring)+')'+descripcion;
                END;


                descripcioncortada:=copy(descripcion, 0, 20);



                HASAR.ImprimirItem(
               (descripcioncortada),
               (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asfloat),
               ((gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat)*ticket.coeficientetarjeta),
                valoriva, 0);


               Gfacturador.DataSource.DataSet.Next;
          end;

//--------------------------descuento general----------------------------------//
        Gfacturador.DataSource.DataSet.First;
        while not Gfacturador.DataSource.DataSet.Eof do
          begin
          if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[22].FieldName).asfloat<>0 then
               begin
                  descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
                  if (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring)<>'' then
                  BEGIN
                  descripcion:='('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring)+')'+descripcion;
                  END;



                 descripcioncortada:=copy(descripcion, 0, 20);
                 hasar.DescuentoGeneral(descripcioncortada,(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[24].FieldName).asfloat),true);
               end;
            Gfacturador.DataSource.DataSet.Next;
          end;

//----------------------------descuento general---------------------------------//


        if ticket.efectivo=0 then
        begin
          ticket.efectivo:=0;
        end;
        if ticket.tarjeta=0 then
         begin
           ticket.tarjeta:=0;
         end;
        if ticket.ctacte=0 then
         begin
           ticket.ctacte:=0;
         end;
        if ticket.importecargoos=0 then
         begin
           ticket.importecargoos:=0;
         end;
         if ticket.importecargoco1=0 then
         begin
           ticket.importecargoco1:=0;
         end;
         if ticket.cheque=0 then
         begin
           ticket.cheque:=0;
         end;


        afiliado:= ticket.efectivo+ ticket.tarjeta+ticket.ctacte+ticket.cheque;
        if ticket.efectivo<>0 then
        begin
        hasar.ImprimirPago('Efectivo: ',ticket.efectivo);
        end;

        if ticket.tarjeta<>0 then
        begin
        hasar.ImprimirPago('Tarjeta '+ticket.codigotarjeta+': ',ticket.tarjeta);
        end;
        if ticket.ctacte<>0 then
        begin
        hasar.ImprimirPago('CC '+ticket.codigocc+' '+ticket.nombrecc+':',ticket.ctacte);
        end;
        if ticket.cheque<>0 then
        begin
        hasar.ImprimirPago('Cheque: ',ticket.cheque);
        end;
        if ticket.importecargoos<>0 then
        begin
        hasar.ImprimirPago(ticket.nombre_os ,ticket.importecargoos);
        end;
        if ticket.importecargoco1<>0 then
        begin
        hasar.ImprimirPago(ticket.nombre_co1 ,ticket.importecargoco1);
        end;


        hasar.Encabezado[11]:='Numero de ref: '+ticket.valnroreferencia;

        hasar.BorrarFantasiaEncabezadoCola(false,true,false);

        HASAR.CerrarComprobanteFiscal;
        nro_comprob:=strtoint(Hasar.respuesta[3]);
        ticket.fechafiscal:=hasar.FechaHoraFiscal;

        if ticket.p441f='N' then
        BEGIN
            if (ticket.codigo_OS<>'') or (ticket.codigo_Co1<>'')   then
            begin
              hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
              hasar.Encabezado[2]:='Obra Social: '+ticket.codigo_OS+'-'+ticket.nombre_os;
              hasar.Encabezado[3]:='Coseguro 1: '+ticket.codigo_Co1+'-'+ticket.nombre_co1;
              hasar.Encabezado[4]:='Coseguro 2: '+ticket.nombre_cos2;
              hasar.Encabezado[5]:='Afiliado: '+ticket.afiliado_nombre+' '+ticket.afiliado_apellido;
              hasar.Encabezado[6]:='Nro afiliado: '+ticket.afiliado_numero;
              hasar.Encabezado[7]:='Mat. Med: '+ticket.medico_nro_matricula;
              hasar.Encabezado[8]:='Receta: '+ticket.numero_receta;
              hasar.Encabezado[9]:='Numero de ref: '+ticket.valnroreferencia;
              hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto((ticket.importecargoos),-2));
              hasar.Encabezado[12]:='CO1: '+floattostr(ticket.importecargoco1)+' '+ 'AFI: '+floattostr(roundto(afiliado,-2));
              hasar.Encabezado[13]:='EF: '+floattostr(roundto((ticket.efectivo),-2))+' CH: '+floattostr(roundto((ticket.cheque),-2))+' CC: '+floattostr(roundto((ticket.ctacte),-2))+' TJ: '+floattostr(roundto((ticket.tarjeta),-2));



            end;


            if ticket.codigo_OS<>'' then
            begin
              z:=z+1
            end;
              if ticket.codigo_Co1<>'' then
            begin
              z:=z+1
            end;
            hasar.DNFHFarmacias(z);
        END;

        if TICKET.p441f='S' then
            begin
             if ticket.codigo_OS<>'' then
              begin
              HASAR.Comenzar;
              hasar.BorrarFantasiaEncabezadoCola(true,true,true);
              hasar.CancelarComprobanteFiscal;
              hasar.TratarDeCancelarTodo;
              hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
              hasar.Encabezado[2]:='Obra Social: '+ticket.codigo_OS+'-'+ticket.nombre_os;
              hasar.Encabezado[3]:='Coseguro 1: '+ticket.codigo_Co1+'-'+ticket.nombre_co1;
              hasar.Encabezado[4]:='Afiliado: '+ticket.afiliado_nombre+' '+ticket.afiliado_apellido;
              hasar.Encabezado[5]:='Nro afiliado: '+ticket.afiliado_numero;
              hasar.Encabezado[6]:='Mat. Med: '+ticket.medico_nro_matricula;
              hasar.Encabezado[7]:='Receta: '+ticket.numero_receta;
              hasar.Encabezado[9]:='Numero de ref: '+ticket.valnroreferencia;
              hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto((ticket.importecargoos),-2));
              hasar.Encabezado[12]:='CO1: '+floattostr(ticket.importecargoco1)+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(afiliado,-2));
              hasar.Encabezado[13]:='EF: '+floattostr(roundto((ticket.efectivo),-2))+' CH: '+floattostr(roundto((ticket.cheque),-2))+' CC: '+floattostr(roundto((ticket.ctacte),-2))+' TJ: '+floattostr(roundto((ticket.tarjeta),-2));
              HASAR.AbrirComprobanteNoFiscal;
              hasar.ImprimirTextoNoFiscal('DOCUMENTO NO FISCAL FARMACIAS');
              hasar.ImprimirTextoNoFiscal('NRO TICKET: '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
              hasar.ImprimirTextoNoFiscal('--------------------------------------------------');
             Gfacturador.DataSource.DataSet.First;

              while not Gfacturador.DataSource.DataSet.Eof do
              begin
                    descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
                    descripcioncortada:=copy(descripcion, 0, 20);
                    HASAR.ImprimirTextoNoFiscal((descripcioncortada)+'('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asstring)+')  '+floattostr(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat));
                    HASAR.ImprimirTextoNoFiscal(' ');
                    Gfacturador.DataSource.DataSet.Next;
              end;


              hasar.CerrarComprobanteNoFiscal;

              end;
               if ticket.codigo_Co1<>'' then

                    begin
                    HASAR.Comenzar;
                    hasar.BorrarFantasiaEncabezadoCola(true,true,true);
                    hasar.CancelarComprobanteFiscal;
                    hasar.TratarDeCancelarTodo;
                    hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
                    hasar.Encabezado[2]:='Obra Social: '+ticket.codigo_OS+'-'+ticket.nombre_os;
                    hasar.Encabezado[3]:='Coseguro 1: '+ticket.codigo_Co1+'-'+ticket.nombre_co1;
                    hasar.Encabezado[4]:='Afiliado: '+ticket.afiliado_nombre+' '+ticket.afiliado_apellido;
                    hasar.Encabezado[5]:='Nro afiliado: '+ticket.afiliado_numero;
                    hasar.Encabezado[6]:='Mat. Med: '+ticket.medico_nro_matricula;
                    hasar.Encabezado[7]:='Receta: '+ticket.numero_receta;
                    hasar.Encabezado[9]:='Numero de ref: '+ticket.valnroreferencia;
                    hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto((ticket.importecargoos),-2));
                    hasar.Encabezado[12]:='CO1: '+floattostr(ticket.importecargoco1)+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(afiliado,-2));
                    hasar.Encabezado[13]:='EF: '+floattostr(roundto((ticket.efectivo),-2))+' CH: '+floattostr(roundto((ticket.cheque),-2))+' CC: '+floattostr(roundto((ticket.ctacte),-2))+' TJ: '+floattostr(roundto((ticket.tarjeta),-2));
                    HASAR.AbrirComprobanteNoFiscal;
                    hasar.ImprimirTextoNoFiscal('DOCUMENTO NO FISCAL FARMACIAS');
                    hasar.ImprimirTextoNoFiscal('NRO TICKET: '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
                    hasar.ImprimirTextoNoFiscal('--------------------------------------------------');
                   Gfacturador.DataSource.DataSet.First;

                    while not Gfacturador.DataSource.DataSet.Eof do
                    begin
                          descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
                          descripcioncortada:=copy(descripcion, 0, 20);
                          HASAR.ImprimirTextoNoFiscal((descripcioncortada)+'('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asstring)+')  '+floattostr(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat));
                          HASAR.ImprimirTextoNoFiscal(' ');
                          Gfacturador.DataSource.DataSet.Next;
                    end;


                hasar.CerrarComprobanteNoFiscal;

                end;

        end;




       if TICKET.llevavale='SI' then
        BEGIN
          HASAR.Comenzar;
          hasar.BorrarFantasiaEncabezadoCola(true,true,true);
          hasar.CancelarComprobanteFiscal;
          hasar.TratarDeCancelarTodo;
          hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;

          if (ticket.nombre_os='') and (ticket.nombre_co1<>'') then
          begin
          hasar.Encabezado[2]:='Cobertura: '+ticket.nombre_co1;
          end;
          if ticket.nombre_os<>'' then
          begin
          hasar.Encabezado[2]:='Cobertura: '+ticket.nombre_os;
          end;
          if (ticket.nombre_os='') and (ticket.nombre_co1='')  then
          begin
          hasar.Encabezado[2]:='Cobertura: ';
          end;
          if (ticket.nombre_os='') and (ticket.nombre_co1<>'') then
          begin
          hasar.Encabezado[3]:='Afiliado: '+ticket.afiliado_nombreco1+' '+ticket.afiliado_apellidoco1;
          hasar.Encabezado[4]:='Nro afiliado: '+ticket.afiliado_numeroco1;
          end;
           if (ticket.nombre_os<>'') then
          begin
          hasar.Encabezado[3]:='Afiliado: '+ticket.afiliado_nombre+' '+ticket.afiliado_apellido;
          hasar.Encabezado[4]:='Nro afiliado: '+ticket.afiliado_numero;
          end;


          hasar.Encabezado[5]:='* * * * * * VALE A RETIRAR * * * * * *';
          hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(ticket.importecargoos,-2));
          hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(afiliado,-2));
          hasar.Encabezado[13]:='EF: '+floattostr(roundto(ticket.efectivo,-2))+' CH: '+floattostr(roundto(ticket.cheque,-2))+' CC: '+floattostr(roundto(ticket.ctacte,-2))+' TJ: '+floattostr(roundto(ticket.tarjeta,-2));
          HASAR.AbrirComprobanteNoFiscal;
          hasar.ImprimirTextoNoFiscal('Emision VR'+ticket.fiscla_pv+': '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
          Gfacturador.DataSource.DataSet.First;

          while not Gfacturador.DataSource.DataSet.Eof do
          begin
               if Gfacturador.Fields[17].AsSTRING='SI' then
               BEGIN
               hasar.ImprimirTextoNoFiscal(Gfacturador.Fields[1].AsSTRING);
               hasar.ImprimirTextoNoFiscal('Unidades Vale:'+Gfacturador.Fields[18].AsSTRING);
               END;
               Gfacturador.DataSource.DataSet.Next;
          end;
          hasar.ImprimirTextoNoFiscal('REF. CPBT. '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));


          hasar.CerrarComprobanteNoFiscal;

        END;

        hasar.finalizar;
          if ticket.numero_ticketfiscal<>0 then
          begin
          impresion:='OK'

          end;
//------------------------------TICKET FACTURA B INICIO-------------------------------------------//
    end;

end;
end;







procedure Tfimpresor.BimprimireClick(Sender: TObject);
var
impresion_ok: boolean;
nro_tk:string;
begin

try
    impresion_ok:= False;
  crearComprobanteImpresion;

  if  TUtils.contienePalabra('_reimpresion',archivo)  then
  begin
      ticketImprimir.imprimiParteTK:=true;
      nro_tk:=StringReplace(archivo, Ticket.fiscla_pv, '', [rfReplaceAll, rfIgnoreCase]);
      nro_tk:=StringReplace(nro_tk,'_reimpresion.xml', '', [rfReplaceAll, rfIgnoreCase]);
      ticketImprimir.setTKFiscal(nro_tk);
      ticketImprimir.nro_comprob:= strToInt(nro_tk);
      ticketImprimir.nro_comprobdigital:= strToInt(nro_tk);

  end;


ticketImprimir.ImprimirTicket(impresion_ok,reimpresion);



 nro_comprob:= ticketImprimir.nro_comprob;
nro_comprobdigital:= ticketImprimir.nro_comprobdigital;

imprimi:= ticketImprimir.imprimi;
ticketImprimir.Free;
ticketImprimir:= nil;

except
  on E: Exception do
  begin
    // Capturar y mostrar información sobre la excepción
    fImpresor.WindowState := wsNormal;
    fImpresor.Show;
    reimpresion:=true;
     //mostrarVentanaPrimerPlano;
    mticket.lines.Add(E.Message);
    application.ProcessMessages;
    Sleep(1000);
    bimprimirE.click;
  end;


end;
 end;

procedure Tfimpresor.BlimpiartodoClick(Sender: TObject);
begin
mticket.Clear;
if cdsdetalle.Active=true then
begin
cdsdetalle.EmptyDataSet;
end;


TICKET.llevavale:='NO';
limpiarunidadticket;

end;


procedure Tfimpresor.btnReimprimirClick(Sender: TObject);
var
  fBuscarTK:TfBuscarTK;
begin
    contador.Enabled:= false;
    if ticket.fiscal <> 'E' then
    begin
        ShowMessage('Funcionalidad habilitada solo en fiscales EPSON');
        exit;
    end;

    fBuscarTK:= TfBuscarTK.Create(SELF);
    fBuscarTK.setTicket(ticket);
    fBuscarTK.ShowModal;

    if not (fBuscarTK.rutaTicket = '') then
    begin
     CopyFile(pchar(fBuscarTK.rutaTicket), pchar(ticket.cola+fBuscarTK.archivo+'_reimpresion.xml'), false);

    end;



    contador.Enabled:= true;


end;

procedure Tfimpresor.Button1Click(Sender: TObject);
var
fiscal:TTicketAEpson;
begin
 fiscal:= TTicketAEpson.Create(ticket,gFacturador);
 fiscal.reimpresionTK;
end;

procedure Tfimpresor.Button2Click(Sender: TObject);
var
eSTADOFISCAL: string;
estado:string;
fecha:tdate;
numerob:string;
numeroa:string;
EstafiscalConectado:boolean;
begin
 if ticket.fiscal='H' then
    BEGIN
      button2.Enabled:=false;

      mticket.Lines.Add('Comprobando estado de fiscal hasar');
      mticket.Lines.Add('----------------------------------------------------');
      button2.Enabled:=false;
      hasar.finalizar;
      Hasar.Puerto:= strtoint(ticket.puerto_com);

      Hasar.Comenzar;
      HASAR.CancelarComprobanteFiscal;
      hasar.PedidoDeStatus;


      mticket.Lines.Add('Tratando de cancelar todo');
      estado:=hasar.DescripcionEstadoControlador;

      mticket.Lines.Add(estado);
      fecha:=hasar.FechaHoraFiscal;
      mticket.Lines.Add('Fecha fiscal: '+datetostr(fecha));
      numeroB:=inttostr(hasar.UltimoDocumentoFiscalBC);
      mticket.Lines.Add('Ultimo numero comprobante B: '+ numerob);
      NUMEROA:=INTTOSTR(hasar.UltimoDocumentoFiscalA);
      mticket.Lines.Add('Ultimo numero comprobante A: '+ numeroa);
      hasar.finalizar;
  if estado='No hay ningún comprobante abierto' then
   BEGIN
     BUTTON3.Enabled:=TRUE;
     button2.Enabled:=true;
   END;
     if estado<>'No hay ningún comprobante abierto' then
   BEGIN
     BUTTON3.Enabled:=False;
     button2.Enabled:=true;
   END;
   END;
   if ticket.fiscal='E' then
    begin
        ticketImprimir:= TTicketAEpson.Create(ticket,Gfacturador);
        EstafiscalConectado:= ticketImprimir.estadoFiscal;

        if EstafiscalConectado then
        begin
           BUTTON3.Enabled:=TRUE;
           button2.Enabled:=true;
           mticket.Lines.Add('TODO OK FISCAL EPSON CONECTADO');
        end
        else
        BEGIN
           mticket.Lines.Add('ERROR FISCAL EPSON DESCONECTADO');
           BUTTON3.Enabled:=FALSE;
           button2.Enabled:=FALSE;
        END;

    end;




end;

procedure Tfimpresor.Button3Click(Sender: TObject);

var
fecha: tdate;
numero: string;
com: integer;

dll  : THandle;
  error : LongInt;
  str : Array[0..200] of Char;
  mayor : LongInt;
  menor : LongInt;
  mychar: char;
  comando: Array[0..200] of AnsiChar;
  texto: string;
  numeroc: string;

begin
if ticket.fiscal='H' then
BEGIN
  mticket.Clear;
  button3.Enabled:=false;
  mticket.Lines.add('IMPRESION REPORTE FISCAL Z comenzada....');
  hasar.finalizar;
  Hasar.Puerto:=strtoint(ticket.puerto_com);
  hasar.Comenzar;
  hasar.BorrarFantasiaEncabezadoCola(true,true,true);
  hasar.CancelarComprobanteFiscal;
  hasar.TratarDeCancelarTodo;

  hasar.ReporteZ;
  fecha:=hasar.FechaHoraFiscal;
  numero:=inttostr(hasar.UltimoDocumentoFiscalBC);
  hasar.finalizar;
  mticket.Lines.add('IMPRESION REPORTE FISCAL Z finalizada....');
END;
if ticket.fiscal='E' then
BEGIN
  ticketImprimir:= TTicketAEpson.Create(ticket,Gfacturador);
  ticketImprimir.imprimirZ;
  ticketImprimir.Free;
END;


end;


function Tfimpresor.ComenzarFiscal: Boolean;
begin
Try
with HASAR do
     begin
        Puerto := strtoint(ticket.puerto_com);
        Transporte := PUERTO_SERIE;
        PrecioBase := False;
        DescripcionesLargas := True;
        Reintentos := 3;
        TiempoDeEspera := 2000;
     end;
    Hasar.Comenzar;
    ComenzarFiscal:=True;
 Except

  on E: EOleException  do
    Begin
    ComenzarFiscal:=false;
    End;
  End;
end;

procedure Tfimpresor.comprobarcliente;
begin
dmfacturador.AbrirConexion();
dmfacturador.qcliente.Close;
dmfacturador.qcliente.SQL.Clear;
dmfacturador.qcliente.SQL.Append('select cod_cliente, nom_cliente, pos_iva, nro_cuit, des_direccion, des_telefono, nro_doc  from mkmacliente where cod_cliente=:codigo');
dmfacturador.qcliente.ParamByName('codigo').AsString:=ticket.cod_cliente;
dmfacturador.qcliente.Open;
if dmfacturador.qcliente.RecordCount=0 then
begin
ticket.cod_cliente:='';
ticket.DESCRIPCIONCLIENTE:='';
end;

end;

procedure Tfimpresor.contadorTimer(Sender: TObject);
begin
binsertar.Click;
end;

procedure Tfimpresor.copiadigital;
var
  archivoXML: TXMLDocument;

  Nodo,NDatosGenerales,NMensajeFacturacion,NCabecera,NDatosFinales,terminal,software,
  validador,prestador,prescriptor, beneficiario, financiador, credencial, CoberturaEspecial, Preautorizacion,
  Fechareceta,Dispensa, Formulario, TipoTratamiento, Diagnostico, Institucion, Retira, detallereceta, item
  : IXMLNode;
  I:Integer;
  RESPONSABLEIVA: TiposDeResponsabilidades;
begin
    archivoXML := TXMLDocument.Create(Application);

    try
      begin



      // Activamos el archivo XML

       archivoxml.xml.Clear;
       archivoxml.Active:=true;
       archivoXML.Version:='1.0';
       archivoXML.Encoding:='ISO-8859-1';
       NMensajeFacturacion := archivoXML.AddChild('COMPROBANTE');
       NCabecera := NMensajeFacturacion.AddChild( 'Encabezado' );
       Nodo := NCabecera.AddChild( 'NROTK' );

       Nodo.text :=ticket.fiscla_pv+(rightpad(inttostr(nro_comprobdigital), '0', 8));
       Nodo := NCabecera.AddChild( 'tipo_comprobante' );
       Nodo.Text := TICKEt.comprobante;
       Nodo := NCabecera.AddChild( 'tipo_comprobantefiscal' );
       Nodo.Text := ticket.tip_comprobante;
       Nodo := NCabecera.AddChild( 'NRO_VENDEDOR' );
       Nodo.Text := TICKEt.cod_vendedor;
       Nodo := NCabecera.AddChild( 'nombre_vendedor' );
       Nodo.Text := TICKEt.nom_vendedor;
       Nodo := NCabecera.AddChild( 'direccion_sucursal' );
       Nodo.Text := ticket.direccionsucursal;
       Nodo := NCabecera.AddChild( 'fecha_comprobante' );
       Nodo.Text := datetostr(now);
       Nodo := NCabecera.AddChild( 'codigo_cliente' );
       Nodo.Text := TICKEt.cod_cliente;
       Nodo := NCabecera.AddChild( 'direccion_cliente' );
       Nodo.Text := ticket.direccion;
       Nodo := NCabecera.AddChild( 'responsableiva' );
       Nodo.Text :=  ticket.CONDICIONIVA ;
       Nodo := NCabecera.AddChild( 'DESCRIPCIONCLIENTE' );
       Nodo.Text :=  ticket.DESCRIPCIONCLIENTE;
       Nodo := NCabecera.AddChild( 'cuit' );
       Nodo.Text := ticket.CUIT ;
       Nodo := NCabecera.AddChild( 'codigo_cc' );
       Nodo.Text := ticket.codigocc;
       Nodo := NCabecera.AddChild( 'nombre_cc' );
       Nodo.Text := ticket.nombrecc;
       Nodo := NCabecera.AddChild( 'codigo_tj' );
       Nodo.Text := TICKEt.codigotarjeta;
       Nodo := NCabecera.AddChild( 'codigo_ch' );
       Nodo.Text := ticket.codigocheque;
       Nodo := NCabecera.AddChild( 'numero_ch' );
       Nodo.Text := ticket.numerocheque;
       Nodo := NCabecera.AddChild( 'codigo_os' );
       Nodo.Text := TICKEt.codigo_OS;
       Nodo := NCabecera.AddChild( 'nombre_plan' );
       Nodo.Text := TICKEt.nombre_os;
       Nodo := NCabecera.AddChild( 'codigo_co1' );
       Nodo.Text := TICKEt.codigo_Co1;
       Nodo := NCabecera.AddChild( 'nombre_planco1' );
       Nodo.Text := TICKEt.nombre_co1;
       Nodo := NCabecera.AddChild( 'codigo_co2' );
       Nodo.Text := TICKEt.codigo_Cos2;
       Nodo := NCabecera.AddChild( 'importe_total' );
       Nodo.Text := floattostr(TICKet.importebruto);
       Nodo := NCabecera.AddChild( 'importe_neto' );
       Nodo.Text := floattostr(TICKEt.importeneto);
       Nodo := NCabecera.AddChild( 'importe_os' );
       Nodo.Text := floattostr(TICKEt.importecargoos);
       Nodo := NCabecera.AddChild( 'importe_co1' );
       Nodo.Text := floattostr(TICKEt.importecargoco1);
       Nodo := NCabecera.AddChild( 'imp_afectado' );
       Nodo.Text := floattostr(ticket.importetotaldescuento);
       Nodo := NCabecera.AddChild( 'imp_gentilezas' );
       Nodo.Text := floattostr(ticket.importegentileza);
       Nodo := NCabecera.AddChild( 'coeficiente_tarjeta' );
       Nodo.Text :=floattostr(ticket.coeficientetarjeta);
       Nodo := NCabecera.AddChild( 'pago_efectivo' );
       Nodo.Text := imp_efectivo;
       Nodo := NCabecera.AddChild( 'pago_tarjeta' );
       Nodo.Text := imp_tarjeta;
       Nodo := NCabecera.AddChild( 'pago_cc' );
       Nodo.Text := imp_cc;
       Nodo := NCabecera.AddChild( 'pago_ch' );
       Nodo.Text := imp_ch;
       Nodo := NCabecera.AddChild( 'afiliado_os' );
       Nodo.Text := ticket.afiliado_numero;
       Nodo := NCabecera.AddChild( 'matricula_medico' );
       Nodo.Text := ticket.medico_nro_matricula;
       Nodo := NCabecera.AddChild( 'codigo_provincia' );
       Nodo.Text := ticket.medico_codigo_provincia;
       Nodo := NCabecera.AddChild( 'tipo_matricula' );
       Nodo.Text := ticket.medico_tipo_matricula;
       Nodo := NCabecera.AddChild( 'afiliado_co1' );
       Nodo.Text := ticket.afiliado_numeroco1;
       Nodo := NCabecera.AddChild( 'matricula_medicoco1' );
       Nodo.Text := ticket.medico_tipo_matricula+ticket.medico_nro_matricula;
       Nodo := NCabecera.AddChild( 'afiliado_apellido' );
       Nodo.Text := ticket.afiliado_apellido;
       Nodo := NCabecera.AddChild( 'afiliado_nombre' );
       Nodo.Text := ticket.afiliado_nombre;
       Nodo := NCabecera.AddChild( 'receta' );
       Nodo.Text := ticket.numero_receta;
       Nodo := NCabecera.AddChild( 'tratamiento' );
       Nodo.Text := ticket.codigo_tratamiento;
       Nodo := NCabecera.AddChild( 'codigo_Validacion' );
       Nodo.Text := ticket.valnroreferencia;
       Nodo := NCabecera.AddChild( 'Nro_caja' );
       Nodo.Text := ticket.nro_caja;
       Nodo := NCabecera.AddChild( 'fecha_operativa' );
       Nodo.Text := datetostr(ticket.fec_operativa);
       Nodo := NCabecera.AddChild( 'datos_adicionales' );
       Nodo.Text := ticket.info_adicional;
       Nodo := NCabecera.AddChild( 'codigo_prestador' );
       Nodo.Text := ticket.codigoos_prestador;
       Nodo := NCabecera.AddChild( 'codigo_validador' );
       Nodo.Text := TICKET.codigo_validador;
       nodo:= NCabecera.AddChild( 'cuit_sucursal' );
       nodo.Text:=StringReplace(ticket.cuitsucursal, '-', '', [rfReplaceAll]);
       Nodo := NCabecera.AddChild( 'codigoos_validador' );
       Nodo.Text :=ticket.codigoos_validador;

       detallereceta := NMensajeFacturacion.AddChild( 'DetalleReceta' );
       Gfacturador.DataSource.DataSet.First;
       while not Gfacturador.DataSource.DataSet.Eof do
        begin
        i:=i+1;
        item := detallereceta.AddChild('Item');
        Nodo := item.AddChild( 'NroItem' ); //26
        Nodo.Text := inttostr(i);
        Nodo := item.AddChild( 'nro_troquel' );//
        Nodo.Text := (Gfacturador.Fields[0].Asstring);
        Nodo := item.AddChild( 'nom_largo' );//
        Nodo.Text := (Gfacturador.Fields[1].asstring);
        Nodo := item.AddChild( 'precio' );//
        Nodo.Text := (Gfacturador.Fields[2].asstring);
        Nodo := item.AddChild( 'cantidad' );//
        Nodo.Text := (Gfacturador.Fields[3].asstring);
        Nodo := item.AddChild( 'descuentos' );//
        Nodo.Text := (Gfacturador.Fields[4].asstring);
        Nodo := item.AddChild( 'precio_totaldesc' );//
        Nodo.Text := (Gfacturador.Fields[5].asstring);
        Nodo := item.AddChild( 'precio_total' );//
        Nodo.Text := (Gfacturador.Fields[6].asstring);
        Nodo := item.AddChild( 'porcentaje' );
        Nodo.Text := (Gfacturador.Fields[7].asstring);
        Nodo := item.AddChild( 'cod_alfabeta' );
        Nodo.Text := (Gfacturador.Fields[8].asstring);
        Nodo := item.AddChild( 'cod_barraspri' );
        Nodo.Text := (Gfacturador.Fields[9].asstring);
        Nodo := item.AddChild( 'cod_iva' );
        Nodo.Text := (Gfacturador.Fields[10].asstring);
        Nodo := item.AddChild( 'porcentajeos' );
        Nodo.Text := (Gfacturador.Fields[11].asstring);
        Nodo := item.AddChild( 'porcentajeco1' );
        Nodo.Text := (Gfacturador.Fields[12].asstring);
        Nodo := item.AddChild( 'porcentajeco2' );
        Nodo.Text := (Gfacturador.Fields[13].asstring);
        Nodo := item.AddChild( 'descuentosos' );
        Nodo.Text := (Gfacturador.Fields[14].asstring);
        Nodo := item.AddChild( 'cod_laboratorio' );
        Nodo.Text := (Gfacturador.Fields[15].asstring);
        Nodo := item.AddChild( 'can_stk' );
        Nodo.Text := (Gfacturador.Fields[16].asstring);
        Nodo := item.AddChild( 'vale' );
        Nodo.Text := (Gfacturador.Fields[17].asstring);
        Nodo := item.AddChild( 'can_vale' );
        Nodo.Text := (Gfacturador.Fields[18].asstring);
        Nodo := item.AddChild( 'tamano' );
        Nodo.Text := (Gfacturador.Fields[19].asstring);
        Nodo := item.AddChild( 'descuentoco1' );
        Nodo.Text := (Gfacturador.Fields[20].asstring);
        Nodo := item.AddChild( 'modificado' );
        Nodo.Text := (Gfacturador.Fields[21].asstring);
        Nodo := item.AddChild( 'gentileza' );
        Nodo.Text := (Gfacturador.Fields[22].asstring);
        Nodo := item.AddChild( 'rubro' );
        Nodo.Text := (Gfacturador.Fields[23].asstring);
        Nodo := item.AddChild( 'importegent' );
        Nodo.Text := (Gfacturador.Fields[24].asstring);
        Nodo := item.AddChild( 'codautorizacion' );
        Nodo.Text := (Gfacturador.Fields[25].asstring);
        Gfacturador.DataSource.DataSet.Next;
        end;


      archivoXML.SaveToFile(ticket.errores+ticket.fiscla_pv+(rightpad(inttostr(nro_comprobdigital), '0', 8))+'.xml');
      end;
    finally


    end;




end;
procedure Tfimpresor.FormShow(Sender: TObject);
var
reg: tregistry;
  ip: STRING;
  ip2: tstringLIST;
  ip3: STRING;

begin
 nIntentos:= 0; // Intentos de impresion si son 3 borra el archivo y lo pasa a errores
 // Ticket:=TTicket.Create;
//  pINICIO.ActivePageIndex:=0;
Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey(regKey,true);
  Ticket:=TTicket.Create;
  vlparametros.Values['Ruta base de datos']:=reg.ReadString('rutabase');
  vlparametros.Values['Ruta base de configuracion']:=reg.ReadString('rutabasecfg');
  vlparametros.Values['Numero de sucursal']:=reg.ReadString('sucursal');
  vlparametros.Values['Numero de Comprobante']:=Reg.ReadString('pv');
  vlparametros.Values['Numero de Pv']:=Reg.ReadString('pf');
  vlparametros.Values['Puerto COM fiscal']:=Reg.ReadString('com');
  vlparametros.Values['Ruta reportes']:=Reg.ReadString('Reportes');
  vlparametros.Values['P-441F']:=Reg.ReadString('P-441F');
  vlparametros.Values['Modulo de caja']:=Reg.ReadString('caja');
  vlparametros.Values['Ruta impresion']:=Reg.ReadString('impresion');
  vlparametros.Values['Marca del Fiscal']:=Reg.ReadString('Fiscal');
  vlparametros.Values['Ruta errores']:=Reg.ReadString('error');
  vlparametros.Values['Copia Talon']:=Reg.ReadString('talon');
  vlparametros.Values['Vale duplicado']:=Reg.ReadString('vale');
  vlparametros.Values['Conformidad afiliado']:=Reg.ReadString('conformidad_afiliado');
  vlparametros.Values['Talon valida online']:=Reg.ReadString('talonvonline');



  ticket.cola:=Reg.ReadString('impresion');
if directoryExists((reg.ReadString('impresion'))) then
begin

  flist.ApplyFilePath(reg.ReadString('impresion'));
end
else
begin
    ip:= reg.ReadString('rutabasecfg');

      ip2:=separarcadena(ip,'\');
      ip3:=ip2[2];
   desconectarUnidad('f:', false, true, true);
   conectarUnidad('f:', '\\'+IP3+'\'+'net','','',false, False);
   flist.ApplyFilePath(reg.ReadString('impresion'));
end;


  path:=reg.ReadString('impresion');
  ticket.puerto_com:=Reg.ReadString('com');
  ticket.sucursal:=reg.ReadString('sucursal');
  ticket.comprobante:=Reg.ReadString('pv');
  ticket.fiscla_pv:=Reg.ReadString('pf');
  ticket.modulocaja:=Reg.ReadString('caja');
  ticket.fiscal:=Reg.ReadString('Fiscal');
  ticket.errores:=Reg.ReadString('error');
  ticket.talon:=Reg.ReadString('talon');
  ticket.vale:=Reg.ReadString('vale');
  contador.Enabled:=true;



end;


procedure Tfimpresor.SetTicket(unTicket: TTicket);
begin
ticket:=unTicket;
end;





 //----------------------------talon obras sociales-------------------------------------//







//finalizacion ticket-------------------------------------------------------------//



procedure Tfimpresor.Insertarcomprobante;
var
i: integer;
iva: double;
 condIva:String;
 //importeTotal
  baseImponible, importeIva, unaTasa:Double;
 unaTasaIVA:TTasaIVA;

 stockparcial: integer;
 conteo:integer;

begin
  ticket.nroticketadicional:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));



 //INSERTAR VTMACOMPROBANTE  VR
        if dmfacturador.ticomprobante.InTransaction then
             begin
              dmfacturador.ticomprobante.Rollback;
              end;
            dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

            dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
            dmfacturador.icomprobante.Close;
            dmfacturador.icomprobante.SQL.Clear;

            dmfacturador.icomprobante.Close;
            dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO VTMACOMPROBEMITIDO                                 ',
                                                         ' (NRO_SUCURSAL,                                              ',
                                                         ' TIP_COMPROBANTE,                                          ',
                                                         ' NRO_COMPROBANTE,                                        ',
                                                         ' NRO_CAJA,                                             ',
                                                         ' COD_VENDEDOR,                                       ',
                                                         ' NRO_TRANSACCION,                                  ',
                                                         ' COD_CLIENTE,                                    ',
                                                         ' NOM_CLIENTE,                                  ',
                                                         ' COD_PROVEEDOR,                              ',
                                                         ' FEC_COMPROBANTE,                          ',
                                                         ' DES_LEYENDA,                            ',
                                                         ' FEC_PROXVENC_RECETA,                  ',
                                                         ' MAR_TRATAMIENTO,                    ',
                                                         ' CAN_REIMPRESO,                    ',
                                                         ' MAR_ANULADO,                    ',
                                                         ' NRO_SUC_CANCELADO,            ',
                                                         ' TIP_COMPROB_CANCELADO,      ',
                                                         ' NRO_COMPROB_CANCELADO,    ',
                                                         ' FEC_COMPROB_CANCELADO,  ',
                                                          'DES_PARTICULARIDAD,   ',
                                                          'MAR_ODONTOLOGO,                                                ',
                                                          'NRO_PBM,                                                      ',
                                                          'NOM_MEDICO,                                                  ',
                                                          'CAN_ITEMS,                                                  ',
                                                          'IMP_FINANC,                                                ',
                                                          'IMP_NETO,                                                 ',
                                                          'IMP_BRUTO,                                                ',
                                                         ' IMP_INTERES,                                             ',
                                                         ' IMP_GENTILEZA_FARM,                                      ',
                                                         ' MAR_PASOXCAJA,                                           ',
                                                         ' MAR_IMPRE_SUBDIA,                                      ',
                                                         ' MAR_IMPRESO_FISCAL,                                  ',
                                                         ' CAN_REIMPRESO_AUD,                                 ',
                                                         ' IMP_VALES,                                       ',
                                                         ' IMP_SALDO,                                     ',
                                                         ' FEC_REF,                                     ',
                                                         ' FEC_OPERATIVA,                             ',
                                                         ' MAR_RESERVADO,                           ',
                                                         ' IMP_APAGAR,                            ',
                                                         ' IMP_PERCEPCION,                      ',
                                                         ' MAR_ORIGEN,                        ',
                                                         ' COD_CLINICA,                     ',
                                                         ' NOM_CLINICA,                   ',
                                                         ' COD_AUTORIZACION,            ',
                                                         ' POR_GENTILEZA_FARM,        ',
                                                         ' POR_IVA)                 ',
                                                         ' VALUES (               ',
                                                         ' :sucursal,           ',
                                                         ' :tkcomprobante,                                      ',
                                                         ' :nrocomprobante,                                    ',
                                                         ' :caja,                                          ',
                                                         ' :vendedor,                                    ',
                                                         ' :transaccion,                               ',
                                                         ' :cod_cliente,                             ',
                                                         ' :nom_cliente,                           ',
                                                         ' NULL,                                 ',
                                                         ' :fec_comprobante,                   ',
                                                         ' '''',                               ',
                                                         ' :fec_receta,                    ',
                                                         ' :mar_tratamiento,             ',
                                                         ' 0,                          ',
                                                         ' ''N'',                      ',
                                                         ' :sucursal,              ',
                                                         ' NULL,                 ',
                                                         ' NULL,                 ',
                                                         ' NULL,                                   ',
                                                         ' '''',                                    ',
                                                         ' ''N'',                                  ',
                                                         ' -1,                                  ',
                                                         ' :MEDICO,                            ',
                                                         ' :CANTIDADINTEMS,                   ',
                                                         ' 0,                                ',
                                                         ' :IMP_NETO,                        ',
                                                         ' :IMP_BRUTO,                      ',
                                                         ' 0,                              ',
                                                         ' :imp_gentileza,                             ',
                                                         ' :PASOXCAJA,                   ',
                                                         ' NULL,                         ',
                                                         ' ''S'',                         ',
                                                         ' 0,                          ',
                                                         ' 0,                         ',
                                                         ' :SALDOCC,                  ',
                                                         ' :FEC_REF,                 ',
                                                         ' :FEC_OPERATIVA,          ',
                                                         ' NULL,                   ',
                                                         ' NULL,                  ',
                                                         ' 0,                    ',
                                                         ' ''F'',                 ',
                                                         ' NULL,               ',
                                                         ' NULL,               ',
                                                         ' :CODAUTORIZACION,  ',
                                                         ' NULL, ',
                                                         ' NULL)');



        dmfacturador.icomprobante.ParamByName('SUCURSAL').AsString:=ticket.sucursal;
        dmfacturador.icomprobante.ParamByName('TKCOMPROBANTE').ASSTRING:=ticket.comprobante;
        dmfacturador.icomprobante.ParamByName('NROCOMPROBANTE').ASSTRING:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
        if TICKET.nro_caja='999' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('CAJA').ASSTRING:='999';
        END;
        if TICKET.nro_caja<>'999' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('CAJA').ASSTRING:=TICKET.nro_caja;
        END;
        dmfacturador.icomprobante.ParamByName('VENDEDOR').ASSTRING:=ticket.cod_vendedor;
        dmfacturador.icomprobante.ParamByName('TRANSACCION').AsString:=inttostr(nro_comprob);
        dmfacturador.icomprobante.ParamByName('COD_CLIENTE').AsString:=ticket.cod_cliente;
        dmfacturador.icomprobante.ParamByName('nom_cliente').AsString:=ticket.DESCRIPCIONCLIENTE;
        dmfacturador.icomprobante.ParamByName('fec_comprobante').AsDateTime:=ticket.fechafiscal;
        dmfacturador.icomprobante.ParamByName('fec_receta').asdate:=ticket.fecha_receta;
        if TICKET.codigo_tratamiento='' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('mar_tratamiento').AsString:='N';
        END;
         if TICKET.codigo_tratamiento<>'' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('mar_tratamiento').AsString:=TICKET.codigo_tratamiento;
        END;
        dmfacturador.icomprobante.ParamByName('sucursal').AsString:=ticket.sucursal;
        dmfacturador.icomprobante.ParamByName('MEDICO').AsString:=ticket.medico_apellido+ticket.medico_nombre;
        dmfacturador.icomprobante.ParamByName('CANTIDADINTEMS').Asinteger:=ticket.itemstotales;
        dmfacturador.icomprobante.ParamByName('IMP_NETO').AsFloat:=ticket.importeneto*ticket.coeficientetarjeta;
        dmfacturador.icomprobante.ParamByName('IMP_BRUTO').AsFloat:=ticket.importebruto*ticket.coeficientetarjeta;
        dmfacturador.icomprobante.ParamByName('IMP_gentileza').AsFloat:=ticket.importegentileza;
         if TICKET.nro_caja='999' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('PASOXCAJA').ASSTRING:='N';
        END;
        if TICKET.nro_caja<>'999' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('PASOXCAJA').ASSTRING:='S';
        END;

        dmfacturador.icomprobante.ParamByName('SALDOCC').ASFLOAT:=TICKEt.saldocc;
        dmfacturador.icomprobante.ParamByName('FEC_REF').ASdate:=TICKEt.fechacaja;
        if TICKET.nro_caja='999' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('FEC_OPERATIVA').asstring:='';
        END;
        if TICKET.nro_caja<>'999' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('FEC_OPERATIVA').AsDate:=ticket.fec_operativa;
        END;
        if Length(ticket.valnroreferencia)>13 then
        begin
        conteo:=Length(ticket.valnroreferencia);
        Delete( ticket.valnroreferencia, 1, 8 );
        dmfacturador.icomprobante.ParamByName('CODAUTORIZACION').AsString:='0';
        end
        else
        begin
        dmfacturador.icomprobante.ParamByName('CODAUTORIZACION').AsString:='0';
        end;

        dmfacturador.icomprobante.ExecSQL;
        dmfacturador.ticomprobante.Commit;






 //INSTERTAR VTMADETALLECOMPROB -----------------------------------------// VR


  if dmfacturador.ticomprobante.InTransaction then
      begin
       dmfacturador.ticomprobante.Rollback;
      end;
            dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

            dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
            dmfacturador.icomprobante.Close;
            dmfacturador.icomprobante.SQL.Clear;


            dmfacturador.icomprobante.Close;
            dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO VTMADETALLECOMPROB ',
                                                        '(NRO_SUCURSAL,                  ',
                                                        'TIP_COMPROBANTE,                 ',
                                                        'NRO_COMPROBANTE,                  ',
                                                        'NRO_ITEM,                          ',
                                                        'COD_ALFABETA,                       ',
                                                        'NOM_PRODUCTO,                        ',
                                                        'CAN_CANTIDAD,                         ',
                                                        'IMP_UNITARIO,                          ',
                                                        'IMP_IVADESC,                            ',
                                                        'IMP_IVA_NETO,                            ',
                                                        'IMP_IVATASA,                              ',
                                                        'IMP_PRODNETO,                              ',
                                                        'IMP_GENTILEZA_FARM,                         ',
                                                        'MAR_MODIF,                                   ',
                                                        'MAR_MOTVENTA,                                 ',
                                                        'CAN_VALE,                                      ',
                                                        'TIP_VALE,                                       ',
                                                        'COD_PROD_REC,                                   ',
                                                        'COD_AUTORIZACION)                               ',
                                                        '                                                ',
                                                        'VALUES (:nro_sucursal,                          ',
                                                        ':TIP_COMPROBANTE,                                        ',
                                                        ':nro_comprobante,                               ',
                                                        ':nro_item,                                      ',
                                                        ':cod_alfabeta,                                  ',
                                                        ':nom_producto,                                  ',
                                                        ':cantidad,                                      ',
                                                        ':imp_unitario,                                  ',
                                                        ':IMP_IVADESC,                                   ',
                                                        ':IMP_IVANETO,                                   ',
                                                        ':IMP_IVATASA,                                   ',
                                                        ':IMP_PRODNETO,                                  ',
                                                        ':IMP_GENTILEZA,                                 ',
                                                        ':modificado,                                          ',
                                                        'NULL,                                           ',
                                                        ':cantvale,                                      ',
                                                        'NULL,                                           ',
                                                        'NULL,                                           ',
                                                        ''''');');


i:=0;

Gfacturador.DataSource.DataSet.first;
while not Gfacturador.DataSource.DataSet.Eof do
    begin
    i:=i+1;
     dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').asstring:=TICKET.comprobante;
     dmfacturador.icomprobante.ParamByName('nro_sucursal').asstring:=ticket.sucursal;
     dmfacturador.icomprobante.parambyname('nro_comprobante').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
     dmfacturador.icomprobante.ParamByName('nro_item').Asinteger:=i;
     dmfacturador.icomprobante.parambyname('cod_alfabeta').Asinteger:=Gfacturador.Fields[8].AsInteger;
     dmfacturador.icomprobante.parambyname('nom_producto').asstring:=Gfacturador.Fields[1].AsString;
     dmfacturador.icomprobante.parambyname('cantidad').asinteger:=Gfacturador.Fields[3].Asinteger;
     dmfacturador.icomprobante.parambyname('imp_unitario').asfloat:=Gfacturador.Fields[2].asfloat*ticket.coeficientetarjeta;
     dmfacturador.icomprobante.parambyname('cantvale').asInteger:= Gfacturador.Fields[18].AsInteger;
     //----------cuando tiene obra social o coseguro cambia el campo del iva--------------------///
  if not ((ticket.codigo_OS<>'') or (ticket.codigo_Co1<>'') or (ticket.codigo_Cos2<>''))  then
  begin
    if Gfacturador.fields[10].AsString='B' then
    begin
    iva:=(ticket.IVAB/100)+1;
     dmfacturador.icomprobante.parambyname('imp_ivaneto').AsFloat:=Gfacturador.Fields[6].asfloat*ticket.coeficientetarjeta-(Gfacturador.Fields[6].asfloat*ticket.coeficientetarjeta/iva);
     dmfacturador.icomprobante.parambyname('imp_ivadesc').AsFloat:=0;
    end;
    if Gfacturador.fields[10].AsString<>'B' then
    begin
    iva:=0;
     dmfacturador.icomprobante.parambyname('imp_ivaneto').AsFloat:=Gfacturador.Fields[6].asfloat*iva;
     dmfacturador.icomprobante.parambyname('imp_ivadesc').AsFloat:=0;
    end;

  end;


    if (ticket.codigo_OS<>'') or (ticket.codigo_Co1<>'') or (ticket.codigo_Cos2<>'')  then
  begin
    if Gfacturador.fields[10].AsString='B' then
    begin
    iva:=(ticket.IVAB/100)+1;
     dmfacturador.icomprobante.parambyname('imp_ivadesc').AsFloat:=Gfacturador.Fields[6].asfloat-(Gfacturador.Fields[6].asfloat/iva);
     dmfacturador.icomprobante.parambyname('imp_ivaneto').AsFloat:=0;
    end;
    if Gfacturador.fields[10].AsString<>'B' then
    begin
    iva:=0;
     dmfacturador.icomprobante.parambyname('imp_ivadesc').AsFloat:=Gfacturador.Fields[6].asfloat*iva;
     dmfacturador.icomprobante.parambyname('imp_ivaneto').AsFloat:=0;
    end;
//----------cuando tiene obra social o coseguro cambia el campo del iva--------------------///
  end;
    dmfacturador.icomprobante.parambyname('imp_ivatasa').AsFloat:=0;
    dmfacturador.icomprobante.parambyname('imp_prodneto').AsFloat:=(Gfacturador.Fields[6].asfloat*ticket.coeficientetarjeta)-Gfacturador.Fields[4].asfloat;
    dmfacturador.icomprobante.parambyname('imp_GENTILEZA').AsFloat:=Gfacturador.Fields[24].asfloat;
    if Gfacturador.Fields[21].asstring='True' then
    BEGIN
    dmfacturador.icomprobante.ParamByName('modificado').AsString:='S';
    END;
    if Gfacturador.Fields[21].asstring='' then
    BEGIN
    dmfacturador.icomprobante.ParamByName('modificado').AsString:='N';
    END;
    dmfacturador.icomprobante.ExecSQL;
    Gfacturador.DataSource.DataSet.Next;
    end;

    dmFacturador.ticomprobante.Commit;




 //INSERTAR VTMAPORCENTAJESIVA   ----VR LLEVA PERO TODOS LOS VALORES EN 0

if dmfacturador.ticomprobante.InTransaction  then
dmfacturador.ticomprobante.Rollback;

dmfacturador.ticomprobante.StartTransaction;
dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
dmfacturador.icomprobante.Close;
dmfacturador.icomprobante.SQL.Clear;


dmfacturador.icomprobante.Close;
dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO VTMAPORCENTAJESIVA                        ',
                                            '(NRO_SUCURSAL,                                       ',
                                            'TIP_COMPROBANTE,                                     ',
                                            'NRO_COMPROBANTE,                                     ',
                                            'NRO_ITEM,                                           ',
                                            'POR_PORCENTAJE,                                     ',
                                            'POR_SOBRETASA,                                     ',
                                            'IMP_NETOGRAV,                                      ',
                                            'IMP_IVA,                                         ',
                                            'IMP_IVASOBRETASA,                              ',
                                            'IMP_NETOGRAV_DESC,                           ',
                                            'IMP_IVA_DESC,                              ',
                                            'IMP_IVASOBRETASA_DESC)                   ',
                                            '                                       ',
                                            'VALUES (:nro_sucursal,                   ',
                                            ':tip_comprobante,  ',
                                            ':nro_comprobante,                ',
                                            ':nro_item,                     ',
                                            ':por_porcentaje,             ',
                                            ':por_sobretasa,            ',
                                            ':imp_netograv,            ',
                                            ':imp_iva,                ',
                                            ':imp_ivasobretasa,     ',
                                            ':imp_netograv_desc,   ',
                                            ':imp_iva_desc,      ',
                                            'NULL);');

i:=0;

for condIVA in ticket.TotalesIVA.Keys do
Begin
  i:=i+1;
  ticket.TotalesIVA.TryGetValue(condIVa, unaTasaIVA);
  dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').asstring:=TICKET.comprobante;
  dmfacturador.icomprobante.ParamByName('nro_sucursal').asstring:=ticket.sucursal;
  dmfacturador.icomprobante.parambyname('nro_comprobante').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
  dmfacturador.icomprobante.ParamByName('nro_item').Asinteger:=i;

  //Obtener la tasa de iva de la tabla PRMAIVA con la condicion condIVA
  if condIVA ='A' then unaTasa:=ticket.IVAA
  else if condIVA='B' then unaTasa:=ticket.IVAB
  else if condIVA='D' then unaTasa:=ticket.IVAD
  else if condIVA='E' then unaTasa:=ticket.IVAE
  else if condIVA='s' then unaTasa:=ticket.IVAs;


  //Si es S poner el monto sobretrasa sino 0
  iva:=unaTasa/100;
  baseImponible:=unaTasaIVA.importeTotal /(1+iva);
  importeIVA:=baseImponible*iva;

  dmfacturador.icomprobante.parambyname('por_sobretasa').asstring:='0';
  dmfacturador.icomprobante.parambyname('por_porcentaje').AsFloat:=unaTasa;


  dmfacturador.icomprobante.parambyname('imp_netograv').asfloat:=unaTasaIVA.netogravado*ticket.coeficientetarjeta;
  dmfacturador.icomprobante.parambyname('imp_netograv_desc').AsFloat:=unaTasaIVA.netogravadodesc;


  dmfacturador.icomprobante.parambyname('imp_iva').asfloat:= (unaTasaIVA.netogravado*ticket.coeficientetarjeta)*iva;

  dmfacturador.icomprobante.parambyname('imp_iva_desc').AsFloat:=unaTasaIVA.netogravadodesc*iva;

  dmfacturador.icomprobante.parambyname('imp_ivasobretasa').AsFloat:=0;
  dmfacturador.icomprobante.Open;
  dmfacturador.ticomprobante.Commit;
  End;

  // Registramos las formas de pago
  registrarFormaDePagoTicket;








 //INSERTAR VTMADESCCOMPROB     ------VR LLEVA PERO SIN IMPORTES


 if TICKET.codigo_OS<>'' THEN
 begin
        i:=0;

        Gfacturador.DataSource.DataSet.first;
        while not Gfacturador.DataSource.DataSet.Eof do
          begin
          I:=I+1;
           if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat(' INSERT INTO VTMADESCCOMPROB (NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_PLANOS, NRO_ITEM, POR_DESCUENTO, IMP_DESCUENTO, IMP_GENTILEZA, POR_GENTILEZA)',
                                                     ' VALUES (:NRO_SUCURSAL, :TIP_COMPROBANTE, :NRO_COMPROBANTE, :COD_PLANOS, :ITEM, :POR_DESCUENTO, :IMP_DESCUENTO, 0, NULL)');

          dmfacturador.icomprobante.ParamByName('NRO_SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_OS;
          dmfacturador.icomprobante.ParamByName('ITEM').AsFloat:=I;
          dmfacturador.icomprobante.ParamByName('POR_DESCUENTO').AsFloat:=Gfacturador.Fields[11].AsInteger;
          dmfacturador.icomprobante.ParamByName('IMP_DESCUENTO').AsFloat:=((Gfacturador.Fields[11].AsInteger*ticket.coeficientetarjeta)*(Gfacturador.Fields[2].Asfloat))/100;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          Gfacturador.DataSource.DataSet.Next;
          end;
 end;

  if TICKET.codigo_Co1<>'' THEN
 begin
        i:=0;

        Gfacturador.DataSource.DataSet.first;
        while not Gfacturador.DataSource.DataSet.Eof do
          begin
          I:=I+1;
           if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat(' INSERT INTO VTMADESCCOMPROB (NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_PLANOS, NRO_ITEM, POR_DESCUENTO, IMP_DESCUENTO, IMP_GENTILEZA, POR_GENTILEZA)',
                                                     ' VALUES (:NRO_SUCURSAL, :TIP_COMPROBANTE, :NRO_COMPROBANTE, :COD_PLANOS, :ITEM, :POR_DESCUENTO, :IMP_DESCUENTO, 0, NULL)');

          dmfacturador.icomprobante.ParamByName('NRO_SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_Co1;
          dmfacturador.icomprobante.ParamByName('ITEM').AsFloat:=I;
          dmfacturador.icomprobante.ParamByName('POR_DESCUENTO').AsFloat:=Gfacturador.Fields[12].AsInteger;
          dmfacturador.icomprobante.ParamByName('IMP_DESCUENTO').AsFloat:=((Gfacturador.Fields[12].AsInteger)*(Gfacturador.Fields[6].Asfloat))/100;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          Gfacturador.DataSource.DataSet.Next;
          end;
 end;
 if TICKET.codigo_Cos2<>'' THEN
 begin
        i:=0;

        Gfacturador.DataSource.DataSet.first;
         while not Gfacturador.DataSource.DataSet.Eof do
          begin
          I:=I+1;
           if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat(' INSERT INTO VTMADESCCOMPROB (NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_PLANOS, NRO_ITEM, POR_DESCUENTO, IMP_DESCUENTO, IMP_GENTILEZA, POR_GENTILEZA)',
                                                     ' VALUES (:NRO_SUCURSAL, :TIP_COMPROBANTE, :NRO_COMPROBANTE, :COD_PLANOS, :ITEM, :POR_DESCUENTO, :IMP_DESCUENTO, 0, NULL)');

          dmfacturador.icomprobante.ParamByName('NRO_SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_Cos2;
          dmfacturador.icomprobante.ParamByName('ITEM').AsFloat:=I;
          dmfacturador.icomprobante.ParamByName('POR_DESCUENTO').AsFloat:=Gfacturador.Fields[13].AsInteger;
          dmfacturador.icomprobante.ParamByName('IMP_DESCUENTO').AsFloat:=((Gfacturador.Fields[13].AsInteger)*(Gfacturador.Fields[6].Asfloat))/100;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          Gfacturador.DataSource.DataSet.Next;
          end;
 end;


 //INSERTAR VTMADETALLEAFILOS  ---vr lleva     sin importes tambien


if TICKET.codigo_os<>'' THEN
 begin
          if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO VTMADETALLEAFILOS ',
                                                     ' (NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_PLANOS, NRO_AFILIADO, NRO_MATRICULA, NOM_MEDICO, NRO_RECETA, FEC_RECETA, ',
                                                     ' IMP_ABONAOS, IMP_GENTILEZA, IMP_PRESTADOR, IMP_TOTALAFEC, NOM_AFILIADO, MAR_INHIBIDO, FECHADENACIMIENTO, NRODEDOCUMENTO, COD_ESPECIALIDAD, ',
                                                     ' COD_CLINICA, COD_DIAGNOSTICO, ESPECIALIDAD, DIAGNOSTICO, CLINICA, POR_IVA, SEXO, PARENTESCO, TIPOTRATAMIENTO, TIPOMATRICULA, TIPORECETARIO, COD_AUTORIZACION, MAR_MEDICOINHIBIDO, NUMEROCLINICA)',
                                                     ' VALUES (:nro_sucursal, :tip_comprobante, :nro_comprobante, :cod_planos, :nro_afiliado , :nro_matricula, :nom_medico, ',
                                                     ' :nro_receta, :fec_recet, :imp_abonaos, 0, 0, :imp_totalfec, :nom_afiliado, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); ');




          dmfacturador.icomprobante.ParamByName('NRO_SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_os;
          dmfacturador.icomprobante.ParamByName('nro_afiliado').asstring:=ticket.afiliado_numero;
          dmfacturador.icomprobante.ParamByName('nro_matricula').asstring:=ticket.medico_tipo_matricula+ticket.medico_nro_matricula;
          dmfacturador.icomprobante.ParamByName('nom_medico').asstring:=ticket.medico_nombre+' '+ticket.medico_apellido;
          dmfacturador.icomprobante.ParamByName('nro_receta').asstring:=ticket.numero_receta;
          dmfacturador.icomprobante.ParamByName('fec_recet').Asdate:=ticket.fecha_receta;
          dmfacturador.icomprobante.ParamByName('imp_abonaos').Ascurrency:=roundto(strtofloat(formatfloat('0.00',(ticket.importecargoos))),-2);
          dmfacturador.icomprobante.ParamByName('imp_totalfec').Ascurrency:=roundto(strtofloat(formatfloat('0.00',(ticket.importebruto))),-2);
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;

 end;

 if TICKET.codigo_Co1<>'' THEN
 begin
          if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO VTMADETALLEAFILOS ',
                                                     ' (NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_PLANOS, NRO_AFILIADO, NRO_MATRICULA, NOM_MEDICO, NRO_RECETA, FEC_RECETA, ',
                                                     ' IMP_ABONAOS, IMP_GENTILEZA, IMP_PRESTADOR, IMP_TOTALAFEC, NOM_AFILIADO, MAR_INHIBIDO, FECHADENACIMIENTO, NRODEDOCUMENTO, COD_ESPECIALIDAD, ',
                                                     ' COD_CLINICA, COD_DIAGNOSTICO, ESPECIALIDAD, DIAGNOSTICO, CLINICA, POR_IVA, SEXO, PARENTESCO, TIPOTRATAMIENTO, TIPOMATRICULA, TIPORECETARIO, COD_AUTORIZACION, MAR_MEDICOINHIBIDO, NUMEROCLINICA)',
                                                     ' VALUES (:nro_sucursal, :tip_comprobante, :nro_comprobante, :cod_planos, :nro_afiliado , :nro_matricula, :nom_medico, ',
                                                     ' :nro_receta, :fec_recet, :imp_abonaos, 0, 0, :imp_totalfec, :nom_afiliado, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); ');




          dmfacturador.icomprobante.ParamByName('NRO_SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_Co1;
          dmfacturador.icomprobante.ParamByName('nro_afiliado').asstring:=ticket.afiliado_numero;
          dmfacturador.icomprobante.ParamByName('nro_matricula').asstring:=ticket.medico_tipo_matriculaco1+ticket.medico_nro_matriculaco1;
          dmfacturador.icomprobante.ParamByName('nom_medico').asstring:=ticket.medico_nombre+' '+ticket.medico_apellido;
          dmfacturador.icomprobante.ParamByName('nro_receta').asstring:=ticket.numero_receta;
          dmfacturador.icomprobante.ParamByName('fec_recet').Asdate:=ticket.fecha_recetaco1;
          dmfacturador.icomprobante.ParamByName('imp_abonaos').Ascurrency:=roundto(strtofloat(formatfloat('0.00',(ticket.importecargoco1))),-2);
          dmfacturador.icomprobante.ParamByName('imp_totalfec').Ascurrency:=roundto(strtofloat(formatfloat('0.00',(ticket.importecargoco1))),-2);
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;

 end;
  if TICKET.codigo_cos2<>'' THEN
 begin
          if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO VTMADETALLEAFILOS ',
                                                     ' (NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_PLANOS, NRO_AFILIADO, NRO_MATRICULA, NOM_MEDICO, NRO_RECETA, FEC_RECETA, ',
                                                     ' IMP_ABONAOS, IMP_GENTILEZA, IMP_PRESTADOR, IMP_TOTALAFEC, NOM_AFILIADO, MAR_INHIBIDO, FECHADENACIMIENTO, NRODEDOCUMENTO, COD_ESPECIALIDAD, ',
                                                     ' COD_CLINICA, COD_DIAGNOSTICO, ESPECIALIDAD, DIAGNOSTICO, CLINICA, POR_IVA, SEXO, PARENTESCO, TIPOTRATAMIENTO, TIPOMATRICULA, TIPORECETARIO, COD_AUTORIZACION, MAR_MEDICOINHIBIDO, NUMEROCLINICA)',
                                                     ' VALUES (:nro_sucursal, :tip_comprobante, :nro_comprobante, :cod_planos, :nro_afiliado , :nro_matricula, :nom_medico, ',
                                                     ' :nro_receta, :fec_recet, :imp_abonaos, 0, 0, :imp_totalfec, :nom_afiliado, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); ');






          dmfacturador.icomprobante.ParamByName('NRO_SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_Cos2;
          dmfacturador.icomprobante.ParamByName('nro_afiliado').asstring:=ticket.afiliado_numero;
          dmfacturador.icomprobante.ParamByName('nro_matricula').asstring:=ticket.medico_nro_matricula;
          dmfacturador.icomprobante.ParamByName('nom_medico').asstring:=ticket.medico_nombre+' '+ticket.medico_apellido;
          dmfacturador.icomprobante.ParamByName('nro_receta').asstring:=ticket.numero_receta;
          dmfacturador.icomprobante.ParamByName('fec_recet').Asdate:=ticket.fecha_recetaco1;
          dmfacturador.icomprobante.ParamByName('imp_abonaos').Ascurrency:=roundto(strtofloat(formatfloat('0.00',(ticket.importecargoco1))),-2);
          dmfacturador.icomprobante.ParamByName('imp_totalfec').Ascurrency:=roundto(strtofloat(formatfloat('0.00',(ticket.importecargoco1))),-2);
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;

 end;



 //INSERTAR OSMAMOVOBRASOCIAL     --vr no lleva

  if TICKET.codigo_os<>'' THEN
 begin
          if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO OSMAMOVOBRASOCIAL                         ',
                                                     '(NRO_SUCURSAL,                                       ',
                                                     ' TIP_COMPROB,                                       ',
                                                     ' NRO_COMPROB,                                      ',
                                                     ' COD_PLANOS,                                      ',
                                                     ' COD_PLANOSORIG,                                 ',
                                                     ' NOM_OBRASOCIAL,                                ',
                                                     ' FEC_COMPROB,                                  ',
                                                     ' FEC_RECETA,                                  ',
                                                     ' IMP_TICKET,                                 ',
                                                     ' IMP_AFECTADO,                              ',
                                                     ' IMP_CARGOOS,                              ',
                                                     ' IMP_GENTILEZA,                           ',
                                                     ' IMP_PRESTADOR,                          ',
                                                     ' NRO_AFILIADO,                          ',
                                                     ' COD_ESTADO,                           ',
                                                     ' NOM_AFILIADO,                        ',
                                                     ' NRO_MATRICULA,                      ',
                                                     ' NRO_RECETA,                        ',
                                                     ' MAR_TRATAMIENTO,                  ',
                                                     ' NRO_LIQUIDACION,                 ',
                                                     ' IDE_PRESENTACION,               ',
                                                     ' DES_PARTICULARIDAD,            ',
                                                     ' COD_CLINICA,                  ',
                                                     ' NOM_CLINICA,                 ',
                                                     ' INFOADICIONAL)              ',
                                                     '                            ',
                                                     ' VALUES (:sucursal,        ',
                                                     ' :tipo_comprobante,       ',
                                                     ' :nro_Comprobante,                 ',
                                                     ' :cod_planos,                     ',
                                                     '  NULL,                          ',
                                                     ' :nom_obrasocial,               ',
                                                     ' :fec_comprobante,             ',
                                                     ' :fec_receta,                 ',
                                                     ' :imp_ticket,                ',
                                                     ' :imp_afectado,             ',
                                                     ' :imp_cargoos,             ',
                                                     ' 0,                       ',
                                                     ' 0,                      ',
                                                     ' :nro_afiliado,         ',
                                                     ' ''C'',                  ',
                                                     ' :nom_afiliado,       ',
                                                     ' :nro_matricula,     ',
                                                     ' :nro_receta,       ',
                                                     ' :tip_tratamiento, ',
                                                     ' NULL,        ',
                                                     ' NULL,      ',
                                                     ' '''',       ',
                                                     ' NULL,   ',
                                                     ' NULL, ',
                                                     ' '''');');





          dmfacturador.icomprobante.ParamByName('SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIPO_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_os;
          dmfacturador.icomprobante.ParamByName('nom_obrasocial').AsString:=TICKET.nombre_os;
          dmfacturador.icomprobante.ParamByName('fec_comprobante').AsDatetime:=ticket.fechafiscal;
          dmfacturador.icomprobante.ParamByName('fec_receta').Asdate:=ticket.fecha_receta;
          dmfacturador.icomprobante.ParamByName('imp_ticket').Asfloat:=ticket.importebruto;
          dmfacturador.icomprobante.ParamByName('imp_afectado').Asfloat:=ticket.importetotaldescuento;
          dmfacturador.icomprobante.ParamByName('imp_cargoos').Asfloat:=ticket.importecargoos;
          dmfacturador.icomprobante.ParamByName('nro_afiliado').asstring:=ticket.afiliado_numero;

          if (ticket.afiliado_nombre<>'') and (ticket.afiliado_apellido<>'') then
          begin

          dmfacturador.icomprobante.ParamByName('nom_afiliado').asstring:=ticket.afiliado_apellido+' '+ticket.afiliado_nombre;

          end;
          if (ticket.afiliado_nombre='') or (ticket.afiliado_apellido='') then
          begin
          dmfacturador.icomprobante.ParamByName('nom_afiliado').asstring:=ticket.afiliado_apellido;
          end;
          dmfacturador.icomprobante.ParamByName('nro_matricula').asstring:=ticket.medico_tipo_matricula+ticket.medico_nro_matricula;
          dmfacturador.icomprobante.ParamByName('nro_receta').asstring:=ticket.numero_receta;
          dmfacturador.icomprobante.ParamByName('tip_tratamiento').Asstring:=ticket.codigo_tratamiento;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;

 end;


if TICKET.codigo_Co1<>'' THEN
 begin
          if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO OSMAMOVOBRASOCIAL                         ',
                                                     '(NRO_SUCURSAL,                                       ',
                                                     ' TIP_COMPROB,                                       ',
                                                     ' NRO_COMPROB,                                      ',
                                                     ' COD_PLANOS,                                      ',
                                                     ' COD_PLANOSORIG,                                 ',
                                                     ' NOM_OBRASOCIAL,                                ',
                                                     ' FEC_COMPROB,                                  ',
                                                     ' FEC_RECETA,                                  ',
                                                     ' IMP_TICKET,                                 ',
                                                     ' IMP_AFECTADO,                              ',
                                                     ' IMP_CARGOOS,                              ',
                                                     ' IMP_GENTILEZA,                           ',
                                                     ' IMP_PRESTADOR,                          ',
                                                     ' NRO_AFILIADO,                          ',
                                                     ' COD_ESTADO,                           ',
                                                     ' NOM_AFILIADO,                        ',
                                                     ' NRO_MATRICULA,                      ',
                                                     ' NRO_RECETA,                        ',
                                                     ' MAR_TRATAMIENTO,                  ',
                                                     ' NRO_LIQUIDACION,                 ',
                                                     ' IDE_PRESENTACION,               ',
                                                     ' DES_PARTICULARIDAD,            ',
                                                     ' COD_CLINICA,                  ',
                                                     ' NOM_CLINICA,                 ',
                                                     ' INFOADICIONAL)              ',
                                                     '                            ',
                                                     ' VALUES (:sucursal,        ',
                                                     ' :tipo_comprobante,       ',
                                                     ' :nro_Comprobante,                 ',
                                                     ' :cod_planos,                     ',
                                                     '  NULL,                          ',
                                                     ' :nom_obrasocial,               ',
                                                     ' :fec_comprobante,             ',
                                                     ' :fec_receta,                 ',
                                                     ' :imp_ticket,                ',
                                                     ' :imp_afectado,             ',
                                                     ' :imp_cargoos,             ',
                                                     ' 0,                       ',
                                                     ' 0,                      ',
                                                     ' :nro_afiliado,         ',
                                                     ' ''C'',                  ',
                                                     ' :nom_afiliado,       ',
                                                     ' :nro_matricula,     ',
                                                     ' :nro_receta,       ',
                                                     ' :tip_tratamiento, ',
                                                     ' NULL,        ',
                                                     ' NULL,      ',
                                                     ' '''',       ',
                                                     ' NULL,   ',
                                                     ' NULL, ',
                                                     ' '''');');





          dmfacturador.icomprobante.ParamByName('SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIPO_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_Co1;
          dmfacturador.icomprobante.ParamByName('nom_obrasocial').AsString:=TICKET.nombre_co1;
          dmfacturador.icomprobante.ParamByName('fec_comprobante').AsDatetime:=ticket.fechafiscal;
          dmfacturador.icomprobante.ParamByName('fec_receta').Asdate:=ticket.fecha_recetaco1;
          dmfacturador.icomprobante.ParamByName('imp_ticket').Asfloat:=ticket.importebruto;
          dmfacturador.icomprobante.ParamByName('imp_afectado').Asfloat:=ticket.importetotaldescuento;
          dmfacturador.icomprobante.ParamByName('imp_cargoos').Asfloat:=ticket.importecargoco1;
          dmfacturador.icomprobante.ParamByName('nro_afiliado').asstring:=ticket.afiliado_numeroco1;
          if (ticket.afiliado_nombreco1<>'') and (ticket.afiliado_apellidoco1<>'') then
          begin
          dmfacturador.icomprobante.ParamByName('nom_afiliado').asstring:=ticket.afiliado_nombreco1+' '+ticket.afiliado_apellidoco1;
          end;
          if (ticket.afiliado_nombreco1='') and (ticket.afiliado_apellidoco1='') then
          begin
          dmfacturador.icomprobante.ParamByName('nom_afiliado').asstring:=ticket.afiliado_apellidoco1;
          end;

          dmfacturador.icomprobante.ParamByName('nro_matricula').asstring:=ticket.medico_tipo_matricula+ticket.medico_nro_matriculaco1;
          dmfacturador.icomprobante.ParamByName('nro_receta').asstring:=ticket.numero_recetaco1;
          dmfacturador.icomprobante.ParamByName('tip_tratamiento').Asstring:='N';
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;

 end;

 if TICKET.codigo_Cos2<>'' THEN
 begin
          if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO OSMAMOVOBRASOCIAL                         ',
                                                     '(NRO_SUCURSAL,                                       ',
                                                     ' TIP_COMPROB,                                       ',
                                                     ' NRO_COMPROB,                                      ',
                                                     ' COD_PLANOS,                                      ',
                                                     ' COD_PLANOSORIG,                                 ',
                                                     ' NOM_OBRASOCIAL,                                ',
                                                     ' FEC_COMPROB,                                  ',
                                                     ' FEC_RECETA,                                  ',
                                                     ' IMP_TICKET,                                 ',
                                                     ' IMP_AFECTADO,                              ',
                                                     ' IMP_CARGOOS,                              ',
                                                     ' IMP_GENTILEZA,                           ',
                                                     ' IMP_PRESTADOR,                          ',
                                                     ' NRO_AFILIADO,                          ',
                                                     ' COD_ESTADO,                           ',
                                                     ' NOM_AFILIADO,                        ',
                                                     ' NRO_MATRICULA,                      ',
                                                     ' NRO_RECETA,                        ',
                                                     ' MAR_TRATAMIENTO,                  ',
                                                     ' NRO_LIQUIDACION,                 ',
                                                     ' IDE_PRESENTACION,               ',
                                                     ' DES_PARTICULARIDAD,            ',
                                                     ' COD_CLINICA,                  ',
                                                     ' NOM_CLINICA,                 ',
                                                     ' INFOADICIONAL)              ',
                                                     '                            ',
                                                     ' VALUES (:sucursal,        ',
                                                     ' :tipo_comprobante,       ',
                                                     ' :nro_Comprobante,                 ',
                                                     ' :cod_planos,                     ',
                                                     '  NULL,                          ',
                                                     ' :nom_obrasocial,               ',
                                                     ' :fec_comprobante,             ',
                                                     ' :fec_receta,                 ',
                                                     ' :imp_ticket,                ',
                                                     ' :imp_afectado,             ',
                                                     ' :imp_cargoos,             ',
                                                     ' 0,                       ',
                                                     ' 0,                      ',
                                                     ' :nro_afiliado,         ',
                                                     ' ''C'',                  ',
                                                     ' :nom_afiliado,       ',
                                                     ' :nro_matricula,     ',
                                                     ' :nro_receta,       ',
                                                     ' :tip_tratamiento, ',
                                                     ' NULL,        ',
                                                     ' NULL,      ',
                                                     ' '''',       ',
                                                     ' NULL,   ',
                                                     ' NULL, ',
                                                     ' '''');');





          dmfacturador.icomprobante.ParamByName('SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIPO_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_Cos2;
          dmfacturador.icomprobante.ParamByName('nom_obrasocial').AsString:=TICKET.nombre_cos2;
          dmfacturador.icomprobante.ParamByName('fec_comprobante').AsDatetime:=ticket.fechafiscal;
          dmfacturador.icomprobante.ParamByName('fec_receta').Asdate:=ticket.fecha_recetaco1;
          dmfacturador.icomprobante.ParamByName('imp_ticket').Asfloat:=ticket.importebruto;
          dmfacturador.icomprobante.ParamByName('imp_afectado').Asfloat:=ticket.importetotaldescuento;
          dmfacturador.icomprobante.ParamByName('imp_cargoos').Asfloat:=ticket.importecargoco2;
          dmfacturador.icomprobante.ParamByName('nro_afiliado').asstring:=ticket.afiliado_numero;
          dmfacturador.icomprobante.ParamByName('nom_afiliado').asstring:=ticket.afiliado_nombre+' '+ticket.afiliado_apellido;
          dmfacturador.icomprobante.ParamByName('nro_matricula').asstring:=ticket.medico_nro_matricula;
          dmfacturador.icomprobante.ParamByName('nro_receta').asstring:=ticket.numero_receta;
          dmfacturador.icomprobante.ParamByName('tip_tratamiento').Asstring:=ticket.codigo_tratamiento;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;

 end;

 //INSTERTAR OSMADETALLEMOV     --vr no lleva


 if TICKET.codigo_os<>'' THEN
 begin
          if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO OSMADETALLEMOV                     ',
                                                     ' (COD_PLANOS,                                 ',
                                                     ' NRO_SUCURSAL,                               ',
                                                     ' TIP_COMPROB,                               ',
                                                     ' NRO_COMPROB,                              ',
                                                     ' NRO_ITEM,                                ',
                                                     ' COD_ALFABETA,                           ',
                                                     ' COD_LABORATORIO,                       ',
                                                     ' NOM_LARGO,                            ',
                                                     ' CAN_VENDIDA,                         ',
                                                     ' IMP_UNITARIO,                       ',
                                                     ' POR_DESCUENTO,                     ',
                                                     ' IMP_DESCUENTO,                    ',
                                                     ' MAR_MOTVENTA,                    ',
                                                     ' NRO_TROQUEL,                    ',
                                                     ' COD_VALIDACION)                ',
                                                     '                               ',
                                                     ' VALUES (:cod_planos,         ',
                                                     ' :nro_sucursal,              ',
                                                     ' :tip_comprobante,          ',
                                                     ' :nro_comprobante,         ',
                                                     ' :nro_item,               ',
                                                     ' :cod_alfabeta,          ',
                                                     ' :cod_laboratorio,      ',
                                                     ' :nom_largo,           ',
                                                     ' :can_vendida,        ',
                                                     ' :imp_unitario,      ',
                                                     ' :por_descuento,    ',
                                                     ' :imp_descuento,   ',
                                                     ' ''3'',            ',
                                                     ' :nro_troquel,  ',
                                                     ' :cod_validacion);');



i:=0;
Gfacturador.DataSource.DataSet.first;
while not Gfacturador.DataSource.DataSet.Eof do
    begin
          i:=i+1;
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_os;
          dmfacturador.icomprobante.ParamByName('nro_SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('nro_item').Asinteger:=i;
          dmfacturador.icomprobante.ParamByName('cod_alfabeta').Asinteger:=Gfacturador.Fields[8].AsInteger;
          dmfacturador.icomprobante.ParamByName('cod_laboratorio').AsString:=Gfacturador.Fields[15].Asstring;
          dmfacturador.icomprobante.ParamByName('nom_largo').AsString:=Gfacturador.Fields[1].Asstring;//
          dmfacturador.icomprobante.ParamByName('can_vendida').AsString:=Gfacturador.Fields[3].Asstring;
          dmfacturador.icomprobante.ParamByName('imp_unitario').Asfloat:=Gfacturador.Fields[2].Asfloat;
          dmfacturador.icomprobante.ParamByName('por_descuento').Asfloat:=Gfacturador.Fields[11].Asfloat;

          dmfacturador.icomprobante.ParamByName('imp_descuento').asfloat:=roundto((Gfacturador.Fields[14].asfloat)/(Gfacturador.Fields[3].asfloat),-2);//roundto((Gfacturador.Fields[2].Asfloat*Gfacturador.Fields[11].Asfloat)/100,-2);
          dmfacturador.icomprobante.ParamByName('nro_troquel').Asinteger:=Gfacturador.Fields[0].Asinteger;
          dmfacturador.icomprobante.ParamByName('cod_validacion').AsString:='0';
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          Gfacturador.DataSource.DataSet.Next;
    end;

 end;

 if TICKET.codigo_co1<>'' THEN
 begin
          if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO OSMADETALLEMOV                     ',
                                                     ' (COD_PLANOS,                                 ',
                                                     ' NRO_SUCURSAL,                               ',
                                                     ' TIP_COMPROB,                               ',
                                                     ' NRO_COMPROB,                              ',
                                                     ' NRO_ITEM,                                ',
                                                     ' COD_ALFABETA,                           ',
                                                     ' COD_LABORATORIO,                       ',
                                                     ' NOM_LARGO,                            ',
                                                     ' CAN_VENDIDA,                         ',
                                                     ' IMP_UNITARIO,                       ',
                                                     ' POR_DESCUENTO,                     ',
                                                     ' IMP_DESCUENTO,                    ',
                                                     ' MAR_MOTVENTA,                    ',
                                                     ' NRO_TROQUEL,                    ',
                                                     ' COD_VALIDACION)                ',
                                                     '                               ',
                                                     ' VALUES (:cod_planos,         ',
                                                     ' :nro_sucursal,              ',
                                                     ' :tip_comprobante,          ',
                                                     ' :nro_comprobante,         ',
                                                     ' :nro_item,               ',
                                                     ' :cod_alfabeta,          ',
                                                     ' :cod_laboratorio,      ',
                                                     ' :nom_largo,           ',
                                                     ' :can_vendida,        ',
                                                     ' :imp_unitario,      ',
                                                     ' :por_descuento,    ',
                                                     ' :imp_descuento,   ',
                                                     ' ''3'',            ',
                                                     ' :nro_troquel,  ',
                                                     ' :cod_validacion);');



i:=0;
Gfacturador.DataSource.DataSet.first;
while not Gfacturador.DataSource.DataSet.Eof do
    begin
          i:=i+1;
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_co1;
          dmfacturador.icomprobante.ParamByName('nro_SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('nro_item').Asinteger:=i;
          dmfacturador.icomprobante.ParamByName('cod_alfabeta').Asinteger:=Gfacturador.Fields[8].AsInteger;
          dmfacturador.icomprobante.ParamByName('cod_laboratorio').AsString:=Gfacturador.Fields[15].Asstring;
          dmfacturador.icomprobante.ParamByName('nom_largo').AsString:=Gfacturador.Fields[1].Asstring;//
          dmfacturador.icomprobante.ParamByName('can_vendida').AsString:=Gfacturador.Fields[3].Asstring;
          dmfacturador.icomprobante.ParamByName('imp_unitario').Asfloat:=Gfacturador.Fields[2].Asfloat;
          dmfacturador.icomprobante.ParamByName('por_descuento').Asfloat:=Gfacturador.Fields[12].Asfloat;
          dmfacturador.icomprobante.ParamByName('imp_descuento').Asfloat:=roundto((Gfacturador.Fields[20].asfloat)/(Gfacturador.Fields[3].asfloat),-2);//Gfacturador.Fields[20].Asfloat;//(Gfacturador.Fields[2].Asfloat*Gfacturador.Fields[12].Asfloat)/100);
          dmfacturador.icomprobante.ParamByName('nro_troquel').Asinteger:=Gfacturador.Fields[0].Asinteger;
          dmfacturador.icomprobante.ParamByName('cod_validacion').AsString:='0';
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          Gfacturador.DataSource.DataSet.Next;
    end;

 end;


if TICKET.codigo_cos2<>'' THEN
 begin
          if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO OSMADETALLEMOV                     ',
                                                     ' (COD_PLANOS,                                 ',
                                                     ' NRO_SUCURSAL,                               ',
                                                     ' TIP_COMPROB,                               ',
                                                     ' NRO_COMPROB,                              ',
                                                     ' NRO_ITEM,                                ',
                                                     ' COD_ALFABETA,                           ',
                                                     ' COD_LABORATORIO,                       ',
                                                     ' NOM_LARGO,                            ',
                                                     ' CAN_VENDIDA,                         ',
                                                     ' IMP_UNITARIO,                       ',
                                                     ' POR_DESCUENTO,                     ',
                                                     ' IMP_DESCUENTO,                    ',
                                                     ' MAR_MOTVENTA,                    ',
                                                     ' NRO_TROQUEL,                    ',
                                                     ' COD_VALIDACION)                ',
                                                     '                               ',
                                                     ' VALUES (:cod_planos,         ',
                                                     ' :nro_sucursal,              ',
                                                     ' :tip_comprobante,          ',
                                                     ' :nro_comprobante,         ',
                                                     ' :nro_item,               ',
                                                     ' :cod_alfabeta,          ',
                                                     ' :cod_laboratorio,      ',
                                                     ' :nom_largo,           ',
                                                     ' :can_vendida,        ',
                                                     ' :imp_unitario,      ',
                                                     ' :por_descuento,    ',
                                                     ' :imp_descuento,   ',
                                                     ' ''3'',            ',
                                                     ' :nro_troquel,  ',
                                                     ' :cod_validacion);');



i:=0;
Gfacturador.DataSource.DataSet.first;
while not Gfacturador.DataSource.DataSet.Eof do
    begin
          i:=i+1;
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_cos2;
          dmfacturador.icomprobante.ParamByName('nro_SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('nro_item').Asinteger:=i;
          dmfacturador.icomprobante.ParamByName('cod_alfabeta').Asinteger:=Gfacturador.Fields[8].AsInteger;
          dmfacturador.icomprobante.ParamByName('cod_laboratorio').AsString:=Gfacturador.Fields[15].Asstring;
          dmfacturador.icomprobante.ParamByName('nom_largo').AsString:=Gfacturador.Fields[1].Asstring;//
          dmfacturador.icomprobante.ParamByName('can_vendida').AsString:=Gfacturador.Fields[3].Asstring;
          dmfacturador.icomprobante.ParamByName('imp_unitario').Asfloat:=Gfacturador.Fields[2].Asfloat;
          dmfacturador.icomprobante.ParamByName('por_descuento').Asinteger:=Gfacturador.Fields[13].Asinteger;
          dmfacturador.icomprobante.ParamByName('imp_descuento').Asfloat:=(Gfacturador.Fields[2].Asfloat*Gfacturador.Fields[13].Asfloat)/100;
          dmfacturador.icomprobante.ParamByName('nro_troquel').Asinteger:=Gfacturador.Fields[0].Asinteger;
          dmfacturador.icomprobante.ParamByName('cod_validacion').AsString:='0';
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          Gfacturador.DataSource.DataSet.Next;
    end;

 end;

 //stock.. --vr no lleva

if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat('update prmastock set can_stk=:can_stk where cod_alfabeta=:cod_alfabeta and nro_sucursal=:nro_sucursal');

Gfacturador.DataSource.DataSet.first;
stockparcial:=0;
while not Gfacturador.DataSource.DataSet.Eof do
    begin
    dmfacturador.qbusquedastock.Close;
    dmfacturador.qbusquedastock.SQL.Text:=concat('select can_stk from prmastock where cod_Alfabeta=:codigo and nro_sucursal=:sucursal');
    dmfacturador.qbusquedastock.ParamByName('codigo').asinteger:=Gfacturador.Fields[8].AsInteger;
    dmfacturador.qbusquedastock.ParamByName('sucursal').asstring:=ticket.sucursal;
    dmfacturador.qbusquedastock.Open;
    if dmfacturador.qbusquedastock.RecordCount>0 then
    begin

    stockparcial:=dmfacturador.qbusquedastock.FieldByName('can_stk').AsInteger;


    end;
    if dmfacturador.qbusquedastock.RecordCount=0 then
    begin

    dmfacturador.qinsertlineastock.Close;
    dmfacturador.qinsertlineastock.SQL.Text:=concat(' INSERT INTO PRMASTOCK (NRO_SUCURSAL, COD_ALFABETA, CAN_STKMIN, CAN_STKMAX, CAN_STK) ',
                                                 ' VALUES (:sucursal, :alfabeta, 0, 1000, 0)');
    dmfacturador.qinsertlineastock.ParamByName('alfabeta').asinteger:=Gfacturador.Fields[8].AsInteger;
    dmfacturador.qinsertlineastock.ParamByName('sucursal').asstring:=ticket.sucursal;
    dmfacturador.qinsertlineastock.Open;

    stockparcial:=0;


    end;



    dmfacturador.icomprobante.ParamByName('cod_alfabeta').asinteger:=Gfacturador.Fields[8].AsInteger;
    dmfacturador.icomprobante.ParamByName('can_stk').asinteger:=stockparcial-Gfacturador.Fields[3].AsInteger;;
    dmfacturador.icomprobante.parambyname('nro_sucursal').asstring:=ticket.sucursal;
    dmfacturador.icomprobante.Open;
    dmfacturador.ticomprobante.Commit;
    Gfacturador.DataSource.DataSet.Next;
    end;



//------------------------------------------RANCKING PRODUCTOS---------------------------------//
//----------------------------------------------------------------------------------------------//




Gfacturador.DataSource.DataSet.first;
while not Gfacturador.DataSource.DataSet.Eof do
    begin

          if dmfacturador.tranking.InTransaction  then
          dmfacturador.tranking.Rollback;

          dmfacturador.tranking.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.qranking.Transaction:=dmFacturador.tranking;
          dmfacturador.qranking.SQL.Clear;
          dmfacturador.qranking.Close;
          dmfacturador.qranking.SQL.Text:=concat('select can_stkinicial, can_venta_diaria, can_compra_diaria, can_movdia from cotbrankproducto b where b.dat_fecha_hora=:fecha and cod_alfabeta=:alfabeta');
          dmfacturador.qranking.ParamByName('alfabeta').asinteger:=Gfacturador.Fields[8].AsInteger;
          dmfacturador.qranking.ParamByName('fecha').AsDate:=ticket.fechafiscal;
          dmfacturador.qranking.Open;
    if dmfacturador.qranking.RecordCount>0 then
    begin
    if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;
          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.SQL.Clear;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat(' UPDATE COTBRANKPRODUCTO SET           ',
                                                     ' CAN_STKINICIAL = :stock_inicial,     ',
                                                     ' CAN_VENTA_DIARIA = :venta_diaria,   ',
                                                     ' CAN_COMPRA_DIARIA = :compra_diaria, ',
                                                     ' CAN_MOVDIA = :movdia               ',
                                                     '                                     ',
                                                     ' WHERE (NRO_SUCURSAL = :sucursal) AND ',
                                                     ' (COD_ALFABETA = :alfabeta) AND ',
                                                     '(DAT_FECHA_HORA = :fecha) ');

        dmfacturador.icomprobante.parambyname('Sucursal').asstring:=ticket.sucursal;
        dmfacturador.icomprobante.ParamByName('alfabeta').asinteger:=Gfacturador.Fields[8].AsInteger;
        dmfacturador.icomprobante.ParamByName('fecha').AsDate:=ticket.fechafiscal;
        dmfacturador.icomprobante.parambyname('stock_inicial').asinteger:=Gfacturador.Fields[16].AsInteger;;
        dmfacturador.icomprobante.ParamByName('venta_diaria').asinteger:=dmfacturador.qranking.FieldByName('can_venta_diaria').AsInteger+Gfacturador.Fields[3].AsINTEGER;;
        dmfacturador.icomprobante.ParamByName('compra_diaria').Asinteger:=dmfacturador.qranking.FieldByName('can_compra_diaria').AsInteger;
        dmfacturador.icomprobante.ParamByName('movdia').Asinteger:=dmfacturador.qranking.FieldByName('can_movdia').AsInteger;
        dmfacturador.icomprobante.Open;
        dmfacturador.ticomprobante.Commit;
    end;
    if dmfacturador.qranking.RecordCount=0 then

    begin

         if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.SQL.Clear;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat(' INSERT                                 ',
                                                     ' INTO COTBRANKPRODUCTO (NRO_SUCURSAL,   ',
                                                     '  COD_ALFABETA,              ',
                                                     '  DAT_FECHA_HORA,           ',
                                                     '  CAN_STKINICIAL,          ',
                                                     '  CAN_VENTA_DIARIA,                            ',
                                                     '  CAN_COMPRA_DIARIA,                          ',
                                                     '  CAN_MOVDIA,                                ',
                                                     '  IMP_VENTA,                                ',
                                                     '  IMP_NETOVENTA,                           ',
                                                     '  IMP_COSTOVENTA,                         ',
                                                     '  IMP_COSTOCOMPRA,                       ',
                                                     '  IMP_OSD,                              ',
                                                     '  IMP_RETENCION_OSD,                    ',
                                                     '  CAN_UNID_OSD,                        ',
                                                     '  IMP_OSM,                            ',
                                                     '  IMP_RETENCION_OSM,                 ',
                                                     '  CAN_UNID_OSM,                     ',
                                                     '  IMP_COB_EFECTIVO,                ',
                                                     '  IMP_COB_CHEQUE,                 ',
                                                     '  IMP_COB_TARJ,                  ',
                                                     '  IMP_RETENCION_TARJ,           ',
                                                     '  IMP_CTACTE,                  ',
                                                     '  IMP_DSC_CTACTE,             ',
                                                     '  IMP_GENTILEZA,             ',
                                                     '  IMP_DSC_AFIL_OSD,         ',
                                                     '  IMP_DSC_AFIL_OSM)        ',
                                                     '                          ',
                                                     ' VALUES (:sucursal,                      ',
                                                     ' :cod_Alfabeta,                         ',
                                                     ' :fechahora,                           ',
                                                     ' :stockinicial,                       ',
                                                     ' :CANTIDAD,                          ',
                                                     ' 0,                                 ',
                                                     ' 0,                                ',
                                                     ' :importeventa,                    ',
                                                     ' :importeneto,                    ',
                                                     ' :importecostoventa,             ',
                                                     ' :importecostocompra,           ',
                                                     ' :importeosd,                  ',
                                                     ' :importeRETENCIONOSD,        ',
                                                     ' :CAN_UNID_OSD,              ',
                                                     ' :IMP_OSM,                   ',
                                                     ' :CAN_UNID_OSM,              ',
                                                     ' :importeRETENCIONOSM,           ',
                                                     ' :IMP_COB_EFECTIVO,        ',
                                                     ' :IMP_COB_CHEQUE,         ',
                                                     ' :IMP_COB_TARJ,          ',
                                                     ' :IMP_RETENCION_TARJ,   ',
                                                     ' :IMP_CTACTE,          ',
                                                     ' :IMP_DSC_CTACTE,     ',
                                                     ' :IMP_GENTILEZA,     ',
                                                     ' :IMP_DSC_AFIL_OSD, ',
                                                     ' :IMP_DSC_AFIL_OSM)');


                  dmfacturador.icomprobante.parambyname('Sucursal').asstring:=ticket.sucursal;
                  dmfacturador.icomprobante.ParamByName('cod_alfabeta').asinteger:=Gfacturador.Fields[8].AsInteger;
                  dmfacturador.icomprobante.ParamByName('fechahora').AsDate:=ticket.fechafiscal;
                  dmfacturador.icomprobante.ParamByName('stockinicial').asinteger:=Gfacturador.Fields[16].AsInteger;
                  dmfacturador.icomprobante.ParamByName('CANTIDAD').asinteger:=Gfacturador.Fields[3].AsINTEGER;
                  dmfacturador.icomprobante.ParamByName('importeventa').asFLOAT:=Gfacturador.Fields[2].asfloat;
                  dmfacturador.icomprobante.ParamByName('importeneto').AsFloat:=Gfacturador.Fields[2].asfloat;
                  dmfacturador.icomprobante.ParamByName('importecostoventa').AsFloat:=Gfacturador.Fields[2].asfloat;
                  dmfacturador.icomprobante.ParamByName('importecostocompra').AsFloat:=Gfacturador.Fields[2].asfloat;
                  dmfacturador.icomprobante.ParamByName('importeRETENCIONOSD').AsFloat:=0;
                  dmfacturador.icomprobante.ParamByName('importeRETENCIONOSM').AsFloat:=0;
                  dmfacturador.icomprobante.ParamByName('importeosd').AsFloat:=TICKET.importecargoos*ticket.coeficientetarjeta;
                  dmfacturador.icomprobante.ParamByName('CAN_UNID_OSD').AsFloat:=0;
                  dmfacturador.icomprobante.ParamByName('IMP_COB_EFECTIVO').AsFLOAT:=ticket.efectivo;
                  dmfacturador.icomprobante.ParamByName('IMP_COB_CHEQUE').AsFLOAT:=ticket.cheque;
                  dmfacturador.icomprobante.ParamByName('IMP_COB_TARJ').AsFLOAT:=ticket.tarjeta;
                  dmfacturador.icomprobante.ParamByName('IMP_RETENCION_TARJ').AsFloat:=0;
                  dmfacturador.icomprobante.ParamByName('IMP_CTACTE').AsFLOAT:=ticket.ctacte;
                  dmfacturador.icomprobante.ParamByName('IMP_DSC_CTACTE').AsFloat:=0;
                  dmfacturador.icomprobante.ParamByName('IMP_GENTILEZA').AsFloat:=0;
                  dmfacturador.icomprobante.ParamByName('IMP_DSC_CTACTE').AsFloat:=0;
                  dmfacturador.icomprobante.ParamByName('IMP_GENTILEZA').AsFloat:=0;
                  dmfacturador.icomprobante.ParamByName('IMP_DSC_AFIL_OSD').AsFloat:=0;
                  dmfacturador.icomprobante.ParamByName('IMP_DSC_AFIL_OSM').AsFloat:=0;
                  dmfacturador.icomprobante.Open;
                  dmfacturador.ticomprobante.Commit;





           end;

    Gfacturador.DataSource.DataSet.Next;
    end;




//----------------------------------------------------insertar pago comprobante modulo de caja-------------------//
if TICKET.modulocaja='S' then
BEGIN
if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;


          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO CJMAPAGOCOMPROB ',
                                                     ' (nro_caja, NRO_SUCURSAL,  TIP_COMPROBANTE, NRO_COMPROBANTE, COD_ESTADO) ',
                                                     ' VALUES (null ,:sucursal,  :tipo_comprobante, :nro_comprobante, ''PP'')');

      //    dmfacturador.icomprobante.ParamByName('caja').AsString:=ticket.nro_caja;
          dmfacturador.icomprobante.ParamByName('sucursal').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('tipo_comprobante').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobante').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;

if dmfacturador.ticomprobante.InTransaction  then
          dmfacturador.ticomprobante.Rollback;

          dmfacturador.ticomprobante.StartTransaction;
          dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

          dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Clear;

          dmfacturador.icomprobante.Close;
          dmfacturador.icomprobante.SQL.Text:=concat(' UPDATE cjmapagocomprob ',
                                                     ' set nro_caja=null      ',
                                                     ' WHERE nro_comprobante = :comprobante ',
                                                     ' and tip_comprobante= :tipo_comprobante ');

          dmfacturador.icomprobante.ParamByName('tipo_comprobante').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('comprobante').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;


END;


end;








procedure Tfimpresor.limpiarunidadticket;
begin
    if ticket.detalleFac<> nil then
    begin
      ticket.detalleFac.Clear;
    end;
    if ticket.items<>nil then
      begin
    ticket.items.Clear;
      end;
    if ticket.itemsval<>nil then
    begin
     ticket.itemsval.Clear;
    end;
     if ticket.itemsonline<>nil then
    begin
     ticket.itemsonline.Clear;
    end;
    if ticket.totalesiva<>nil then
      begin
      ticket.totalesiva.Clear;
    end;

      ticket.afiliado_numero:='';
      ticket.afiliado_nombre:='';
      ticket.afiliado_apellido:='';

      ticket.medico_apellido:='';
      ticket.medico_nombre:='';
      ticket.medico_tipo_matricula:='';
      ticket.medico_nro_matricula:='';
      ticket.medico_codigo_provincia:='';

      ticket.fechacaja:=-693594;
      ticket.fechaactual:='';
      ticket.hora:=-693594;
      ticket.fecha_receta:=now;
      ticket.fecha_recetaco1:=now;
      ticket.numero_receta:='';
      ticket.cod_afiliadoplanos:='';

      ticket.codigo_OS:='';
      ticket.nombre_os:='';
      ticket.codigo_Co1:='';
      ticket.nombre_co1:='';
      ticket.codigo_Cos2:='';
      ticket.nombre_cos2:='';
      ticket.codigo_validador:='';
      ticket.codigoos_validador:='';
      ticket.codigoos_prestador:='';
      ticket.codigo_tratamiento:='';
      ticket.valnroreferencia:='';
      ticket.valdescripcionrespuesta:='';
      ticket.valmsjrespuesta:='';
      ticket.valnro_item:='';
      ticket.valcodigorespuesta:='9999';
      ticket.valimporte_unitarioval:='';
      ticket.valcod_troquel:='';
      ticket.CodAccion:='';
      ticket.path_validador:='';

      ticket.cod_vendedor:='';
      ticket.nom_vendedor:='';
      ticket.itemstotales:=0;
      ticket.importebruto:=0;
      ticket.importeneto:=0;
      ticket.saldocc:=0;
      ticket.alfabetastock:='';
      ticket.nombrestock:='';
      ticket.estadoticket:=0;
      ticket.importetotal_iva:=0;
      ticket.importetotalsin_iva:=0;
      ticket.importetotaldescuento:=0;
      ticket.importecargoos:=0;
      ticket.importecargoco1:=0;
      ticket.importecargoco2:=0;
      ticket.codigocheque:='';
      ticket.numerocheque:='';
      ticket.codigotarjeta:='';
      ticket.cod_cliente:='';

      ticket.codigocc:='';
      ticket.codigosubcc:='';
      ticket.valecantidad:='';
      ticket.llevavale:='';


      ticket.cuitproveedor:='';
      ticket.facturaproveedor:='';



      ticket.nrocomprobantenf:='';
      ticket.marstock:='';
      ticket.puntos_farmavalor:='';
      ticket.monodroga:='';



//      ticket.fec_operativa:=0;
//      ticket.nombre_terminal:='';
//      ticket.fiscla_pv:='';
//      ticket.puerto_com:='';
      ticket.fechafiscal:=-693594;
//      ticket.sucursal:='';
//      ticket.comprobante:='';
//      ticket.tip_comprobante:='';

      ticket.CUIT:='';
      ticket.CONDICIONIVA:='';
      ticket.DESCRIPCIONCLIENTE:='';
      ticket.codigocliente:='';
      ticket.direccion:='';
      ticket.telefono:='';
 //     ticket.url:='';
      ticket.dni:='';

end;


end.
