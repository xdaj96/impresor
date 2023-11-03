﻿unit Uimpresor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, registry,
  Vcl.Grids, Vcl.ValEdit, Vcl.StdCtrls, Vcl.Buttons, Vcl.DBGrids, Vcl.FileCtrl,
  Data.DB, Datasnap.DBClient,  Xml.xmldom, Xml.XMLIntf,
  msxmldom, xml.xmldoc, udticket, Vcl.OleCtrls, FiscalPrinterLib_TLB, system.Win.ComObj, math,
  Vcl.Menus, Vcl.AppEvnts,uBaseTicket,uTicketTEpson,uTicketBEpson; //uadicionales;
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
    Button3: TButton;
    Button2: TButton;
    Bimprimire: TBitBtn;
    VLparametros: TValueListEditor;
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
    procedure ImprimirTicketAepson(var  Imprimio:boolean);
    procedure copiadigital;
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


  public
    procedure SetTicket(unTicket:TTicket);

  end;

var
  fimpresor: Tfimpresor;
  path: string;
  nro_comprob: integer;
  imprimi: boolean;



implementation

{$R *.dfm}

uses UdmFacturador;
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
ITEMVAL,BARRASVAL,TROQUELVAL,DESCRIPCIONVAL,RTAPRODUCTO,CANTIDADVAL,PORCENTAJEVAL,IMPORTEUNITARIOVAL,IMPORTEAFIVAL,IMPORTECOBERVAL:ixmlnode;
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
   archivo: string;
   reg: tregistry;
   pathimpresion: wchar;
   patherror: wchar;
//   form3: tfadicionales;
begin

//  Reg := TRegistry.Create(KEY_WRITE);
//  Reg.RootKey := HKEY_CURRENT_USER;

for I := 0 to flist.Items.Count -1 do
    begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey(regKey,true);
    dmFacturador.AbrirConexion();
    contador.Enabled:=false;

                blimpiartodo.Click;
                archivo:=flist.Items[i];
                archivoxmlval:= TXMLDocument.Create(Application);
                archivoxmlval.LoadFromFile (path+archivo);
                archivoxmlval.Active:=true;
                archivoxmlval.DocumentElement.ChildNodes.Count;
                encabezadoval:=archivoxmlval.DocumentElement.ChildNodes[0];
                encabezadoval.ChildNodes.Count;

                ITEMsVAL:=TTicketItemval.Create;
                TICKET.nrocomprobantenf:=encabezadoval.ChildNodes['NROTK'].text;
                ticket.comprobante:=encabezadoval.ChildNodes['tipo_comprobante'].text;
                ticket.tip_comprobante:=encabezadoval.ChildNodes['tipo_comprobantefiscal'].text;
                ticket.cod_vendedor:=encabezadoval.ChildNodes['NRO_VENDEDOR'].Text;
                ticket.nom_vendedor:=encabezadoval.ChildNodes['nombre_vendedor'].Text;
                ticket.direccionsucursal:=encabezadoval.ChildNodes['direccion_sucursal'].Text;
                ticket.fechafiscal:=strtodate(encabezadoval.ChildNodes['fecha_comprobante'].Text);
                ticket.cod_cliente:=encabezadoval.ChildNodes['codigo_cliente'].Text;
                ticket.direccion:=encabezadoval.ChildNodes['direccion_cliente'].Text;
                ticket.CONDICIONIVA:=encabezadoval.ChildNodes['responsableiva'].Text;
                ticket.Cuit:=encabezadoval.ChildNodes['cuit'].Text;
                ticket.DESCRIPCIONCLIENTE:=encabezadoval.ChildNodes['DESCRIPCIONCLIENTE'].Text;
                ticket.codigocc:=encabezadoval.ChildNodes['codigo_cc'].Text;
                ticket.nombrecc:=encabezadoval.ChildNodes['nombre_cc'].Text;
                ticket.codigotarjeta:=encabezadoval.ChildNodes['codigo_tj'].Text;
                ticket.codigocheque:=encabezadoval.ChildNodes['codigo_ch'].Text;
                ticket.numerocheque:=encabezadoval.ChildNodes['numero_ch'].Text;
                ticket.codigo_OS:=encabezadoval.ChildNodes['codigo_os'].Text;
                ticket.nombre_os:=encabezadoval.ChildNodes['nombre_plan'].Text;
                ticket.codigo_co1:=encabezadoval.ChildNodes['codigo_co1'].Text;
                ticket.nombre_co1:=encabezadoval.ChildNodes['nombre_planco1'].Text;
                ticket.codigo_Cos2:=encabezadoval.ChildNodes['codigo_co2'].Text;
                ticket.nombre_cos2:=encabezadoval.ChildNodes['nombre_planco2'].Text;
                ticket.importebruto:=strtofloat(encabezadoval.ChildNodes['importe_total'].Text);
                ticket.importeneto:=strtofloat(encabezadoval.ChildNodes['importe_neto'].Text);
                ticket.importecargoos:=strtofloat(encabezadoval.ChildNodes['importe_os'].Text);
                ticket.importecargoco1:=strtofloat(encabezadoval.ChildNodes['importe_co1'].Text);
    //            ticket.importecargoco2:=strtofloat(encabezadoval.ChildNodes['importe_co2'].Text);
                if (encabezadoval.ChildNodes['importe_co2'].Text)<>'' then
                begin
                ticket.importecargoco2:=strtofloat(encabezadoval.ChildNodes['importe_co2'].Text);
                end;
                if (encabezadoval.ChildNodes['importe_co2'].Text)='' then
                begin
                 ticket.importecargoco2:=0;
                end;

                ticket.importetotaldescuento:=strtofloat(encabezadoval.ChildNodes['imp_afectado'].Text);
                ticket.importegentileza:=strtofloat(encabezadoval.ChildNodes['imp_gentilezas'].Text);
                ticket.coeficientetarjeta:=strtofloat(encabezadoval.ChildNodes['coeficiente_tarjeta'].Text);
                if encabezadoval.ChildNodes['pago_efectivo'].Text='' then
                begin
                 ticket.efectivo:=0;
                end;
                if encabezadoval.ChildNodes['pago_efectivo'].Text<>'' then
                begin
                ticket.efectivo:=strtofloat(encabezadoval.ChildNodes['pago_efectivo'].Text);
                end;
                if encabezadoval.ChildNodes['pago_tarjeta'].Text='' then
                begin
                ticket.tarjeta:=0;
                end;
                if encabezadoval.ChildNodes['pago_tarjeta'].Text<>''  then
                begin
                ticket.tarjeta:=strtofloat(encabezadoval.ChildNodes['pago_tarjeta'].Text);
                end;
                if encabezadoval.ChildNodes['pago_cc'].Text='' then
                begin
                ticket.ctacte:=0;
                end;
                if encabezadoval.ChildNodes['pago_cc'].Text<>'' then
                begin
                ticket.ctacte:=strtofloat(encabezadoval.ChildNodes['pago_cc'].Text);
                end;
                if encabezadoval.ChildNodes['pago_ch'].Text='' then
                begin
                ticket.cheque:=0;
                end;
                if encabezadoval.ChildNodes['pago_ch'].Text<>'' then
                begin
                ticket.cheque:=strtofloat(encabezadoval.ChildNodes['pago_ch'].Text);
                end;


                ticket.afiliado_numero:=encabezadoval.ChildNodes['afiliado_os'].Text;
                ticket.afiliado_apellido:=encabezadoval.ChildNodes['afiliado_apellido'].Text;
                ticket.afiliado_nombre:=encabezadoval.ChildNodes['afiliado_nombre'].Text;
                ticket.numero_receta:=encabezadoval.ChildNodes['receta'].Text;
                ticket.medico_nro_matricula:=encabezadoval.ChildNodes['matricula_medico'].Text;
                ticket.medico_codigo_provincia:=encabezadoval.ChildNodes['codigo_provincia'].Text;
                ticket.medico_tipo_matricula:=encabezadoval.ChildNodes['tipo_matricula'].Text;
                ticket.afiliado_numeroco1:=encabezadoval.ChildNodes['afiliado_co1'].Text;
                ticket.medico_nro_matriculaco1:=encabezadoval.ChildNodes['matricula_medicoco1'].Text;
                ticket.valnroreferencia:=encabezadoval.ChildNodes['codigo_Validacion'].Text;
                ticket.nro_caja:=encabezadoval.ChildNodes['Nro_caja'].Text;
                ticket.fechacaja:=strtodate(encabezadoval.ChildNodes['fecha_operativa'].Text);
                ticket.fec_operativa:=strtodate(encabezadoval.ChildNodes['fecha_operativa'].Text);
                ticket.codigo_tratamiento:= encabezadoval.ChildNodes['tratamiento'].Text;
                ticket.info_adicional:= encabezadoval.ChildNodes['datos_adicionales'].Text;
                TICKET.codigoos_prestador:=encabezadoval.ChildNodes['codigo_prestador'].Text;
                TICKET.codigo_validador:=encabezadoval.ChildNodes['codigo_validador'].Text;
                ticket.cuitsucursal:=encabezadoval.ChildNodes['cuit_sucursal'].Text;
                ticket.codigoos_validador:=encabezadoval.ChildNodes['codigoos_validador'].Text;
                ticket.puntos_farmavalor:=encabezadoval.ChildNodes['punto_farmavalor'].Text;

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

                detalleval:=archivoxmlval.DocumentElement.ChildNodes[1];
                if cdsdetalle.Active=false then
                    begin
                      cdsdetalle.CreateDataSet;
                      cdsdetalle.Active:=true;
                    end;
                    for v := 0 to DETALLEVAL.ChildNodes.Count -1 do
                        BEGIN
                          ITEMVAL:=DETALLEVAL.ChildNodes[v];
                          cdsdetalle.Append;
                          //cdsdetallenroitem.AsString:=itemval.ChildNodes['NroItem'].Text;
                          cdsdetallenro_troquel.Asstring:=itemval.ChildNodes['nro_troquel'].Text;
                          cdsdetallenom_largo.Asstring:=itemval.ChildNodes['nom_largo'].Text;
                          cdsdetalleprecio.Asstring:=itemval.ChildNodes['precio'].Text;
                          cdsdetallecantidad.Asstring:=itemval.ChildNodes['cantidad'].Text;
                          cdsdetalledescuentos.Asstring:=itemval.ChildNodes['descuentos'].Text;
                          cdsdetalleprecio_totaldesc.Asstring:=itemval.ChildNodes['precio_totaldesc'].Text;
                          cdsdetalleprecio_total.Asstring:=itemval.ChildNodes['precio_total'].Text;
                          cdsdetalleporcentaje.Asstring:=itemval.ChildNodes['porcentaje'].Text;
                          cdsdetallecod_alfabeta.Asstring:=itemval.ChildNodes['cod_alfabeta'].Text;
                          cdsdetallecod_barraspri.Asstring:=itemval.ChildNodes['cod_barraspri'].Text;
                          cdsdetallecod_iva.Asstring:=itemval.ChildNodes['cod_iva'].Text;
                          cdsdetalleporcentajeos.Asstring:=itemval.ChildNodes['porcentajeos'].Text;
                          cdsdetalleporcentajeco1.Asstring:=itemval.ChildNodes['porcentajeco1'].Text;
                          cdsdetalleporcentajeco2.Asstring:=itemval.ChildNodes['porcentajeco2'].Text;
                          cdsdetalledescuentosos.Asstring:=itemval.ChildNodes['descuentosos'].Text;
                          cdsdetallecod_laboratorio.Asstring:=itemval.ChildNodes['cod_laboratorio'].Text;
                          cdsdetallecan_stk.Asstring:=itemval.ChildNodes['can_stk'].Text;
                          cdsdetallevale.Asstring:=itemval.ChildNodes['vale'].Text;
                          cdsdetallecan_vale.Asstring:=itemval.ChildNodes['can_vale'].Text;
                          cdsdetalletamano.Asstring:=itemval.ChildNodes['tamano'].Text;
                          cdsdetalledescuentoco1.Asstring:=itemval.ChildNodes['descuentoco1'].Text;
                          cdsdetallemodificado.Asstring:=itemval.ChildNodes['modificado'].Text;
                          cdsdetallegentileza.Asstring:=itemval.ChildNodes['gentileza'].Text;
                          cdsdetallerubro.Asstring:=itemval.ChildNodes['rubro'].Text;
                          cdsdetalleimportegent.Asstring:=itemval.ChildNodes['importegent'].Text;
                          cdsdetallecodautorizacion.Asstring:=itemval.ChildNodes['cod_autorizacion'].Text;
                          cdsdetalleitem.Asstring:=itemval.ChildNodes['NroItem'].Text;
                          cdsdetalledescuentoco2.Asstring:=itemval.ChildNodes['descuentoco2'].Text;
                          if cdsdetallecan_vale.asstring<>'0' then
                          begin
                          TICKET.valecantidad:=cdsdetallecan_vale.AsString;
                          ticket.llevavale:='SI';
                          end;

                        end;
               ticket.itemstotales:=DETALLEVAL.ChildNodes.Count;

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


  if ticket.fiscal='H' then
  BEGIN
    BIMPRIMIR.Click;
  END;
  if TICKET.fiscal='E' then
  begin
    bimprimire.Click;
  end;
  if imprimi<>false then
  begin
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

     Insertarcomprobante;
//     CopyFile(pchar(path+archivo), pchar(path+'\copia\'+ticket.nroticketadicional+'.xml'), false);
     CopyFile(pchar(path+archivo), pchar(ticket.errores+ticket.nroticketadicional+'.xml'), false);

     deletefile(path+archivo);
     blimpiartodo.Click;


     dmFacturador.CerrarConexion();
  end







 end;
  // blimpiartodo.Click;
   flist.Update;

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
begin
if ticket.tip_comprobante='A' then
           BEGIN
              ImprimirTicketAepson(impresion_ok);
           END;
if ticket.tip_comprobante='B' then
           BEGIN
              ticketImprimir:= TTicketBEpson.Create(ticket,GFacturador);
              ticketImprimir.ImprimirTicket(impresion_ok);
               nro_comprob:= ticketImprimir.nro_comprob;
              nro_comprobdigital:= ticketImprimir.nro_comprobdigital;
              imprimi:= ticketImprimir.imprimi;

           END;
if ticket.tip_comprobante='T' then
           begin

              ticketImprimir:= TTicketTEpson.Create(ticket,GFacturador);
              ticketImprimir.ImprimirTicket(impresion_ok);
              nro_comprob:= ticketImprimir.nro_comprob;
              nro_comprobdigital:= ticketImprimir.nro_comprobdigital;

              imprimi:= ticketImprimir.imprimi;
           end
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


procedure Tfimpresor.Button2Click(Sender: TObject);
TYPE
  TConsultarVersionDll = function ( descripcion : PChar; descripcion_largo_maximo: LongInt; var mayor : LongInt; var menor : LongInt) : LongInt; StdCall;

  TConfigurarVelocidad = function ( velocidad: LongInt ) : LongInt; StdCall;

  TConfigurarPuerto = function ( velocidad: String ) : LongInt; StdCall;

  TConectar = function () : LongInt; StdCall;

  TImprimirCierreX = function () : LongInt; StdCall;

  TImprimirCierreZ = function () : LongInt; StdCall;

  TDesconectar = function () : LongInt; StdCall;

  tEstablecerEncabezado= function( numero_encabezado: integer;  descripcion: PansiChar ): LongInt; StdCall;

  tAbrirComprobante= function( id_tipo_documento: integer)  : LongInt; StdCall;

  tCerrarComprobante= function()  : LongInt; StdCall;

  tEnviarComando=function ( commando:PansiChar  )  : LongInt; StdCall;

  tConsultarEncabezado=function( numero_encabezado: integer;  respuesta: string ;respuesta_largo_maximo:integer): LongInt; StdCall;

  tEstablecerCola=function( numero_cola: integer;  descripcion: PansiChar ): LongInt; StdCall;

  tCargarTextoExtra=function(descripcion :PansiChar ): LongInt; StdCall;

  TImprimirItem=function(id_modificador : integer; descripcion :Pansichar; cantidad :Pansichar; precio : Pansichar; id_tasa_iva : Integer; ii_id: integer; ii_valor: Pansichar; id_codigo : integer; codigo: Pansichar; codigo_unidad_matrix: Pansichar; código_unidad_medida: integer ):LongInt; StdCall;

  TCargarPago=function(id_modificador: Integer;  codigo_forma_pago:Integer; cantidad_cuotas:Integer; monto : Pansichar;descripción_cupones:Pansichar;descripcion:Pansichar;descripcion_extra1:Pansichar;descripcion_extra2:Pansichar): LongInt; StdCall;

  TConsultarNumeroComprobanteUltimo=function(tipo_de_comprobante: pansichar; respuesta: pansichar; respuesta_largo_maximo: Longint):Longint; StdCall;

  TObtenerRespuesta=function(buffer_salida:pansichar; largo_buffer_salida: integer;largo_final_buffer_salida: integer): LongInt; StdCall;

  TConsultarNumeroComprobanteActual=function( respuesta : pansichar; respuesta_largo_maximo : integer): LongInt; Stdcall;

  TConsultarFechaHora=function(respuesta: pansichar; respuesta_largo_maximo : integer): LongInt; Stdcall;

  TCargarAjuste=function ( id_modificador: integer ; descripcion: pansichar; monto : pansichar ;id_tasa_iva: integer; codigo_interno:pansichar ):Longint; Stdcall;

  TObtenerRespuestaExtendida=function ( numero_campo: longint;buffer_salida: pansichar;largo_buffer_salida : longint; largo_final_buffer_salida: longint ): LongInt; Stdcall;

  TImprimirTextoLibre=function(descripcion : Pansichar ):Longint; Stdcall;

  TCargarDatosCliente=function(nombre_o_razon_social1: pansichar; nombre_o_razon_social2: pansichar; domicilio1: pansichar; domicilio2: pansichar; domicilio3: pansichar; id_tipo_documento: Longint	; numero_documento: pansichar; id_responsabilidad_iva: Longint):Longint; stdcall;

  TCargarComprobanteAsociado=function( descripcion: pansichar ): Longint; Stdcall;

var

  dll  : THandle;
  error : LongInt;
  str : Array[0..200] of Char;
  mayor : LongInt;
  menor : LongInt;
  mychar: char;

  ConfigurarVelocidad: TConfigurarVelocidad;
  ConfigurarPuerto: TConfigurarPuerto;
  Conectar: TConectar;
  ImprimirCierreX: TImprimirCierreX;
  ImprimirCierreZ: TImprimirCierreZ;
  Desconectar: TDesconectar;
  ConsultarVersionDll: TConsultarVersionDll;
  establecerencabezado: testablecerencabezado;
  ConsultarEncabezado: tConsultarEncabezado;
  abrircomprobante: tabrircomprobante;
  CerrarComprobante: tCerrarComprobante;
  EnviarComando: tEnviarComando;
  EstablecerCola: tEstablecerCola;
  CargarTextoExtra: tCargarTextoExtra;
  ImprimirItem: tImprimirItem;
  CargarPago: TCargarPago;
  ConsultarNumeroComprobanteUltimo: TConsultarNumeroComprobanteUltimo;
  ObtenerRespuesta: TObtenerRespuesta;
  ConsultarNumeroComprobanteActual: TConsultarNumeroComprobanteActual;
  ConsultarFechaHora : TConsultarFechaHora;
  ObtenerRespuestaExtendida: tObtenerRespuestaExtendida;
  Cargarajuste: Tcargarajuste;
  ImprimirTextoLibre: TImprimirTextoLibre;
  CargarDatosCliente: TCargarDatosCliente;
  CargarComprobanteAsociado: TCargarComprobanteAsociado;

eSTADOFISCAL: string;
estado:string;
fecha:tdate;
numerob:string;
numeroa:string;
z: integer;
RESPONSABLEIVA: TiposDeResponsabilidades;
valoriva: double;
direccioncliente: olevariant;
descripcioncortada: string;
descripcion: string;
efectivoredondeado: double;
afiliado: double;
prueba: Array[0..200] of AnsiChar;
comando: Array[0..200] of AnsiChar;
cantidadep: Array[0..200] of AnsiChar;
precioep: Array[0..200] of AnsiChar;
alfabetaep: Array[0..200] of AnsiChar;
monto: Array[0..200] of AnsiChar;
tipcomprob : Array[0..200] of AnsiChar;
respuesta:  Array[0..10000] of AnsiChar;
numero: array [0..10000] of longint;
fechahora: array [0..300] of Ansichar;
cliente: Array[0..200] of AnsiChar;
domicilio: Array[0..200] of AnsiChar;
cuitcliente: Array[0..200] of AnsiChar;
dnicliente: Array[0..200] of AnsiChar;
tipdoc: array[0..200] of longint;
respuesta_final_buffer_salida: integer;
dnfh:string;
valorivaep: integer;
texto: string;
CODIGOIVA: string;
ofecupon: string;


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
       dll := 0;
    // instanciar dll - recordar que se require "uses Windows"

       dll := LoadLibrary('C:\EpsonFiscalInterface.dll');

    // check error
        if dll = 0 then
        begin
          ShowMessage('Error al instanciar DLL');
          Exit;
        end;

        // obtener las referencias a funciones:  "ConsultarVersionDll"
        @ConsultarVersionDll := GetProcAddress(dll, 'ConsultarVersionDll');
        if not Assigned(ConsultarVersionDll) then
        begin
          ShowMessage('Error al asignar funcion: ConsultarVersionDll');
          Exit;
        end;


        // obtener las referencias a funciones:  "ConfigurarVelocidad"
        @ConfigurarVelocidad := GetProcAddress(dll, 'ConfigurarVelocidad');
        if not Assigned(ConfigurarVelocidad) then
        begin
          ShowMessage('Error al asignar funcion: ConfigurarVelocidad');
          Exit;
        end;

        // obtener las referencias a funciones:  "ConfigurarPuerto"
        @ConfigurarPuerto := GetProcAddress(dll, 'ConfigurarPuerto');
        if not Assigned(ConfigurarPuerto) then
        begin
          ShowMessage('Error al asignar funcion: ConfigurarPuerto');
          Exit;
        end;

        // obtener las referencias a funciones:  "Conectar"
        @Conectar := GetProcAddress(dll, 'Conectar');
        if not Assigned(Conectar) then
        begin
          ShowMessage('Error al asignar funcion: Conectar');
          Exit;
        end;

        // obtener las referencias a funciones:  "ImprimirCierreX"
        @ImprimirCierreX := GetProcAddress(dll, 'ImprimirCierreX');
        if not Assigned(ImprimirCierreX) then
        begin
          ShowMessage('Error al asignar funcion: ImprimirCierreX');
          Exit;
        end;

        // obtener las referencias a funciones:  "ImprimirCierreZ"
        @ImprimirCierreZ := GetProcAddress(dll, 'ImprimirCierreZ');
        if not Assigned(ImprimirCierreZ) then
        begin
          ShowMessage('Error al asignar funcion: ImprimirCierreZ');
          Exit;
        end;

        @AbrirComprobante := GetProcAddress(dll, 'AbrirComprobante');
        if not Assigned(AbrirComprobante) then
        begin
          ShowMessage('Error al asignar funcion: AbrirComprobante');
          Exit;
        end;
         @CerrarComprobante := GetProcAddress(dll, 'CerrarComprobante');
        if not Assigned(AbrirComprobante) then
        begin
          ShowMessage('Error al asignar funcion: CerrarComprobante');
          Exit;
        end;
           @Establecerencabezado := GetProcAddress(dll, 'EstablecerEncabezado');
        if not Assigned(AbrirComprobante) then
        begin
          ShowMessage('Error al asignar funcion: CerrarComprobante');
          Exit;
        end;
            @ConsultarEncabezado:= GetProcAddress(dll, 'EstablecerEncabezado');
        if not Assigned(AbrirComprobante) then
        begin
          ShowMessage('Error al asignar funcion: CerrarComprobante');
          Exit;
        end;
             @EnviarComando := GetProcAddress(dll, 'EnviarComando');
        if not Assigned(EnviarComando) then
        begin
          ShowMessage('Error al asignar funcion: EnviarComando');
          Exit;
        end;

        // obtener las referencias a funciones:  "Desconectar"
        @Desconectar := GetProcAddress(dll, 'Desconectar');
        if not Assigned(Desconectar) then
        begin
          ShowMessage('Error al asignar funcion: Desconectar');
          Exit;
        end;
          @EstablecerCola := GetProcAddress(dll, 'EstablecerCola');
        if not Assigned(EstablecerCola) then
        begin
          ShowMessage('Error al asignar funcion: EstablecerCola');
          Exit;
        end;
            @CargarTextoExtra := GetProcAddress(dll, 'CargarTextoExtra');
        if not Assigned(CargarTextoExtra) then
        begin
          ShowMessage('Error al asignar funcion: CargarTextoExtra');
          Exit;
        end;
           @ImprimirItem := GetProcAddress(dll, 'ImprimirItem');
        if not Assigned(ImprimirItem) then
        begin
          ShowMessage('Error al asignar funcion: ImprimirItem');
          Exit;
        end;
             @CargarPago := GetProcAddress(dll, 'CargarPago');
        if not Assigned(CargarPago) then
        begin
          ShowMessage('Error al asignar funcion: CargarPago');
          Exit;
        end;

               @ConsultarNumeroComprobanteActual := GetProcAddress(dll, 'ConsultarNumeroComprobanteActual');
        if not Assigned(ConsultarNumeroComprobanteActual) then
        begin
          ShowMessage('Error al asignar funcion: ConsultarNumeroComprobanteActual');
          Exit;
        end;
                 @Consultarfechahora := GetProcAddress(dll, 'Consultarfechahora');
        if not Assigned(ConsultarNumeroComprobanteActual) then
        begin
          ShowMessage('Error al asignar funcion: Consultarfechahora');
          Exit;
        end;

                   @ObtenerRespuestaExtendida:= GetProcAddress(dll, 'ObtenerRespuestaExtendida');
        if not Assigned(ObtenerRespuestaExtendida) then
        begin
          ShowMessage('Error al asignar funcion: ObtenerRespuestaExtendida');
          Exit;
        end;
                     @CargarAjuste:= GetProcAddress(dll, 'CargarAjuste');
        if not Assigned(Cargarajuste) then
        begin
          ShowMessage('Error al asignar funcion: CargarAjuste');
          Exit;
        end;

                  @ImprimirTextoLibre:= GetProcAddress(dll, 'ImprimirTextoLibre');
          if not Assigned(ImprimirTextoLibre) then
        begin
          ShowMessage('Error al asignar funcion: ImprimirTextoLibre');
          Exit;
        end;

        mayor := 0;
        menor := 0;
        mychar:=' ';
        error := ConsultarVersionDll( @str[0], 100, mayor, menor );
        error := ConfigurarVelocidad( 9600 );
        error := ConfigurarPuerto( ticket.puerto_com );
        error := CerrarComprobante();
        error := Conectar();



        error := Desconectar();

        FreeLibrary(dll);


        if error= 0 then
        begin
           BUTTON3.Enabled:=TRUE;

           button2.Enabled:=true;
           mticket.Lines.Add('TODO OK FISCAL EPSON CONECTADO');
        end;
        if error<>0 then
        BEGIN
           mticket.Lines.Add('ERROR FISCAL EPSON DESCONECTADO');
           BUTTON3.Enabled:=FALSE;
           button2.Enabled:=FALSE;
        END;

    end;




end;

procedure Tfimpresor.Button3Click(Sender: TObject);
TYPE
  TConsultarVersionDll = function ( descripcion : PChar; descripcion_largo_maximo: LongInt; var mayor : LongInt; var menor : LongInt) : LongInt; StdCall;

  TConfigurarVelocidad = function ( velocidad: LongInt ) : LongInt; StdCall;

  TConfigurarPuerto = function ( velocidad: String ) : LongInt; StdCall;

  TConectar = function () : LongInt; StdCall;

  TImprimirCierreX = function () : LongInt; StdCall;

  TImprimirCierreZ = function () : LongInt; StdCall;

  TDesconectar = function () : LongInt; StdCall;

  tEstablecerEncabezado= function( numero_encabezado: integer;  descripcion: PansiChar ): LongInt; StdCall;

  tAbrirComprobante= function( id_tipo_documento: integer)  : LongInt; StdCall;

  tCerrarComprobante= function()  : LongInt; StdCall;

  tEnviarComando=function ( commando:PansiChar  )  : LongInt; StdCall;

  tConsultarEncabezado=function( numero_encabezado: integer;  respuesta: string ;respuesta_largo_maximo:integer): LongInt; StdCall;

  tEstablecerCola=function( numero_cola: integer;  descripcion: PansiChar ): LongInt; StdCall;

  tCargarTextoExtra=function(descripcion :PansiChar ): LongInt; StdCall;

  TImprimirItem=function(id_modificador : integer; descripcion :Pansichar; cantidad :Pansichar; precio : Pansichar; id_tasa_iva : Integer; ii_id: integer; ii_valor: Pansichar; id_codigo : integer; codigo: Pansichar; codigo_unidad_matrix: Pansichar; código_unidad_medida: integer ):LongInt; StdCall;

  TCargarPago=function(id_modificador: Integer;  codigo_forma_pago:Integer; cantidad_cuotas:Integer; monto : Pansichar;descripción_cupones:Pansichar;descripcion:Pansichar;descripcion_extra1:Pansichar;descripcion_extra2:Pansichar): LongInt; StdCall;

  TConsultarNumeroComprobanteUltimo=function(tipo_de_comprobante: pansichar; respuesta: pansichar; respuesta_largo_maximo: Longint):Longint; StdCall;

  TObtenerRespuesta=function(buffer_salida:pansichar; largo_buffer_salida: integer;largo_final_buffer_salida: integer): LongInt; StdCall;

  TConsultarNumeroComprobanteActual=function( respuesta : pansichar; respuesta_largo_maximo : integer): LongInt; Stdcall;

  TConsultarFechaHora=function(respuesta: pansichar; respuesta_largo_maximo : integer): LongInt; Stdcall;

  TCargarAjuste=function ( id_modificador: integer ; descripcion: pansichar; monto : pansichar ;id_tasa_iva: integer; codigo_interno:pansichar ):Longint; Stdcall;

  TObtenerRespuestaExtendida=function ( numero_campo: longint;buffer_salida: pansichar;largo_buffer_salida : longint; largo_final_buffer_salida: longint ): LongInt; Stdcall;

  TImprimirTextoLibre=function(descripcion : Pansichar ):Longint; Stdcall;

  TCargarDatosCliente=function(nombre_o_razon_social1: pansichar; nombre_o_razon_social2: pansichar; domicilio1: pansichar; domicilio2: pansichar; domicilio3: pansichar; id_tipo_documento: Longint	; numero_documento: pansichar; id_responsabilidad_iva: Longint):Longint; stdcall;

  TCargarComprobanteAsociado=function( descripcion: pansichar ): Longint; Stdcall;
var
fecha: tdate;
numero: string;
com: integer;ImprimirCierreX: TImprimirCierreX;
ImprimirCierreZ: TImprimirCierreZ;
  ConfigurarVelocidad: TConfigurarVelocidad;
  ConfigurarPuerto: TConfigurarPuerto;
  Conectar: TConectar;
  Desconectar: TDesconectar;
  ConsultarVersionDll: TConsultarVersionDll;
  establecerencabezado: testablecerencabezado;
  ConsultarEncabezado: tConsultarEncabezado;
  abrircomprobante: tabrircomprobante;
  CerrarComprobante: tCerrarComprobante;
  EnviarComando: tEnviarComando;
  EstablecerCola: tEstablecerCola;
  CargarTextoExtra: tCargarTextoExtra;
  ImprimirItem: tImprimirItem;
  CargarPago: TCargarPago;
  ConsultarNumeroComprobanteUltimo: TConsultarNumeroComprobanteUltimo;
  ObtenerRespuesta: TObtenerRespuesta;
  ConsultarNumeroComprobanteActual: TConsultarNumeroComprobanteActual;
  ConsultarFechaHora : TConsultarFechaHora;
  ObtenerRespuestaExtendida: tObtenerRespuestaExtendida;
  Cargarajuste: Tcargarajuste;
  ImprimirTextoLibre: TImprimirTextoLibre;
  CargarDatosCliente: TCargarDatosCliente;
  CargarComprobanteAsociado: TCargarComprobanteAsociado;
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
dll := 0;
    // instanciar dll - recordar que se require "uses Windows"

      dll := LoadLibrary('C:\EpsonFiscalInterface.dll');

  // check error
 if dll = 0 then
  begin
    ShowMessage('Error al instanciar DLL');
    Exit;
  end;

  // obtener las referencias a funciones:  "ConsultarVersionDll"
  @ConsultarVersionDll := GetProcAddress(dll, 'ConsultarVersionDll');
  if not Assigned(ConsultarVersionDll) then
  begin
    ShowMessage('Error al asignar funcion: ConsultarVersionDll');
    Exit;
  end;


  // obtener las referencias a funciones:  "ConfigurarVelocidad"
  @ConfigurarVelocidad := GetProcAddress(dll, 'ConfigurarVelocidad');
  if not Assigned(ConfigurarVelocidad) then
  begin
    ShowMessage('Error al asignar funcion: ConfigurarVelocidad');
    Exit;
  end;

  // obtener las referencias a funciones:  "ConfigurarPuerto"
  @ConfigurarPuerto := GetProcAddress(dll, 'ConfigurarPuerto');
  if not Assigned(ConfigurarPuerto) then
  begin
    ShowMessage('Error al asignar funcion: ConfigurarPuerto');
    Exit;
  end;

  // obtener las referencias a funciones:  "Conectar"
  @Conectar := GetProcAddress(dll, 'Conectar');
  if not Assigned(Conectar) then
  begin
    ShowMessage('Error al asignar funcion: Conectar');
    Exit;
  end;

  // obtener las referencias a funciones:  "ImprimirCierreX"
  @ImprimirCierreX := GetProcAddress(dll, 'ImprimirCierreX');
  if not Assigned(ImprimirCierreX) then
  begin
    ShowMessage('Error al asignar funcion: ImprimirCierreX');
    Exit;
  end;

  // obtener las referencias a funciones:  "ImprimirCierreZ"
  @ImprimirCierreZ := GetProcAddress(dll, 'ImprimirCierreZ');
  if not Assigned(ImprimirCierreZ) then
  begin
    ShowMessage('Error al asignar funcion: ImprimirCierreZ');
    Exit;
  end;

  @AbrirComprobante := GetProcAddress(dll, 'AbrirComprobante');
  if not Assigned(AbrirComprobante) then
  begin
    ShowMessage('Error al asignar funcion: AbrirComprobante');
    Exit;
  end;
   @CerrarComprobante := GetProcAddress(dll, 'CerrarComprobante');
  if not Assigned(AbrirComprobante) then
  begin
    ShowMessage('Error al asignar funcion: CerrarComprobante');
    Exit;
  end;
     @Establecerencabezado := GetProcAddress(dll, 'EstablecerEncabezado');
  if not Assigned(AbrirComprobante) then
  begin
    ShowMessage('Error al asignar funcion: CerrarComprobante');
    Exit;
  end;
      @ConsultarEncabezado:= GetProcAddress(dll, 'EstablecerEncabezado');
  if not Assigned(AbrirComprobante) then
  begin
    ShowMessage('Error al asignar funcion: CerrarComprobante');
    Exit;
  end;
       @EnviarComando := GetProcAddress(dll, 'EnviarComando');
  if not Assigned(EnviarComando) then
  begin
    ShowMessage('Error al asignar funcion: EnviarComando');
    Exit;
  end;

  // obtener las referencias a funciones:  "Desconectar"
  @Desconectar := GetProcAddress(dll, 'Desconectar');
  if not Assigned(Desconectar) then
  begin
    ShowMessage('Error al asignar funcion: Desconectar');
    Exit;
  end;
    @EstablecerCola := GetProcAddress(dll, 'EstablecerCola');
  if not Assigned(EstablecerCola) then
  begin
    ShowMessage('Error al asignar funcion: EstablecerCola');
    Exit;
  end;
      @CargarTextoExtra := GetProcAddress(dll, 'CargarTextoExtra');
  if not Assigned(CargarTextoExtra) then
  begin
    ShowMessage('Error al asignar funcion: CargarTextoExtra');
    Exit;
  end;
     @ImprimirItem := GetProcAddress(dll, 'ImprimirItem');
  if not Assigned(ImprimirItem) then
  begin
    ShowMessage('Error al asignar funcion: ImprimirItem');
    Exit;
  end;
       @CargarPago := GetProcAddress(dll, 'CargarPago');
  if not Assigned(CargarPago) then
  begin
    ShowMessage('Error al asignar funcion: CargarPago');
    Exit;
  end;

         @ConsultarNumeroComprobanteActual := GetProcAddress(dll, 'ConsultarNumeroComprobanteActual');
  if not Assigned(ConsultarNumeroComprobanteActual) then
  begin
    ShowMessage('Error al asignar funcion: ConsultarNumeroComprobanteActual');
    Exit;
  end;
           @Consultarfechahora := GetProcAddress(dll, 'Consultarfechahora');
  if not Assigned(ConsultarNumeroComprobanteActual) then
  begin
    ShowMessage('Error al asignar funcion: Consultarfechahora');
    Exit;
  end;

             @ObtenerRespuestaExtendida:= GetProcAddress(dll, 'ObtenerRespuestaExtendida');
  if not Assigned(ObtenerRespuestaExtendida) then
  begin
    ShowMessage('Error al asignar funcion: ObtenerRespuestaExtendida');
    Exit;
  end;
               @CargarAjuste:= GetProcAddress(dll, 'CargarAjuste');
  if not Assigned(Cargarajuste) then
  begin
    ShowMessage('Error al asignar funcion: CargarAjuste');
    Exit;
  end;

            @ImprimirTextoLibre:= GetProcAddress(dll, 'ImprimirTextoLibre');
    if not Assigned(ImprimirTextoLibre) then
  begin
    ShowMessage('Error al asignar funcion: ImprimirTextoLibre');
    Exit;
  end;


        mayor := 0;
        menor := 0;
        mychar:=' ';
        error := ConsultarVersionDll( str, 100, mayor, menor );
        error := ConfigurarVelocidad( 9600 );
        error := ConfigurarPuerto( ticket.puerto_com );
        error := CerrarComprobante();
        error := Conectar();
        comando:='';
        texto:=strpcopy(comando,'0801|0C00') ;
        error :=enviarcomando(@comando[0]);


        error := Desconectar();
        FreeLibrary(dll);


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


procedure Tfimpresor.ImprimirTicketAepson(var Imprimio: boolean);
type
  TConsultarVersionDll = function ( descripcion : PChar; descripcion_largo_maximo: LongInt; var mayor : LongInt; var menor : LongInt) : LongInt; StdCall;

  TConfigurarVelocidad = function ( velocidad: LongInt ) : LongInt; StdCall;

  TConfigurarPuerto = function ( velocidad: String ) : LongInt; StdCall;

  TConectar = function () : LongInt; StdCall;

  TImprimirCierreX = function () : LongInt; StdCall;

  TImprimirCierreZ = function () : LongInt; StdCall;

  TDesconectar = function () : LongInt; StdCall;

  tEstablecerEncabezado= function( numero_encabezado: integer;  descripcion: PansiChar ): LongInt; StdCall;

  tAbrirComprobante= function( id_tipo_documento: integer)  : LongInt; StdCall;

  tCerrarComprobante= function()  : LongInt; StdCall;

  tEnviarComando=function ( commando:PansiChar  )  : LongInt; StdCall;

  tConsultarEncabezado=function( numero_encabezado: integer;  respuesta: string ;respuesta_largo_maximo:integer): LongInt; StdCall;

  tEstablecerCola=function( numero_cola: integer;  descripcion: PansiChar ): LongInt; StdCall;

  tCargarTextoExtra=function(descripcion :PansiChar ): LongInt; StdCall;

  TImprimirItem=function(id_modificador : integer; descripcion :Pansichar; cantidad :Pansichar; precio : Pansichar; id_tasa_iva : Integer; ii_id: integer; ii_valor: Pansichar; id_codigo : integer; codigo: Pansichar; codigo_unidad_matrix: Pansichar; código_unidad_medida: integer ):LongInt; StdCall;

  TCargarPago=function(id_modificador: Integer;  codigo_forma_pago:Integer; cantidad_cuotas:Integer; monto : Pansichar;descripción_cupones:Pansichar;descripcion:Pansichar;descripcion_extra1:Pansichar;descripcion_extra2:Pansichar): LongInt; StdCall;

  TConsultarNumeroComprobanteUltimo=function(tipo_de_comprobante: pansichar; respuesta: pansichar; respuesta_largo_maximo: Longint):Longint; StdCall;

  TObtenerRespuesta=function(buffer_salida:pansichar; largo_buffer_salida: integer;largo_final_buffer_salida: integer): LongInt; StdCall;

  TConsultarNumeroComprobanteActual=function( respuesta : pansichar; respuesta_largo_maximo : integer): LongInt; Stdcall;

  TConsultarFechaHora=function(respuesta: pansichar; respuesta_largo_maximo : integer): LongInt; Stdcall;

  TCargarAjuste=function ( id_modificador: integer ; descripcion: pansichar; monto : pansichar ;id_tasa_iva: integer; codigo_interno:pansichar ):Longint; Stdcall;

  TObtenerRespuestaExtendida=function ( numero_campo: longint;buffer_salida: pansichar;largo_buffer_salida : longint; largo_final_buffer_salida: longint ): LongInt; Stdcall;

  TImprimirTextoLibre=function(descripcion : Pansichar ):Longint; Stdcall;

  TCargarDatosCliente=function(nombre_o_razon_social1: pansichar; nombre_o_razon_social2: pansichar; domicilio1: pansichar; domicilio2: pansichar; domicilio3: pansichar; id_tipo_documento: Longint	; numero_documento: pansichar; id_responsabilidad_iva: Longint):Longint; stdcall;

  TCargarComprobanteAsociado=function( descripcion: pansichar ): Longint; Stdcall;

var
  dll  : THandle;
  error : LongInt;
  str : Array[0..200] of Char;
  mayor : LongInt;
  menor : LongInt;
  mychar: char;

  ConfigurarVelocidad: TConfigurarVelocidad;
  ConfigurarPuerto: TConfigurarPuerto;
  Conectar: TConectar;
  ImprimirCierreX: TImprimirCierreX;
  ImprimirCierreZ: TImprimirCierreZ;
  Desconectar: TDesconectar;
  ConsultarVersionDll: TConsultarVersionDll;
  establecerencabezado: testablecerencabezado;
  ConsultarEncabezado: tConsultarEncabezado;
  abrircomprobante: tabrircomprobante;
  CerrarComprobante: tCerrarComprobante;
  EnviarComando: tEnviarComando;
  EstablecerCola: tEstablecerCola;
  CargarTextoExtra: tCargarTextoExtra;
  ImprimirItem: tImprimirItem;
  CargarPago: TCargarPago;
  ConsultarNumeroComprobanteUltimo: TConsultarNumeroComprobanteUltimo;
  ObtenerRespuesta: TObtenerRespuesta;
  ConsultarNumeroComprobanteActual: TConsultarNumeroComprobanteActual;
  ConsultarFechaHora : TConsultarFechaHora;
  ObtenerRespuestaExtendida: tObtenerRespuestaExtendida;
  Cargarajuste: Tcargarajuste;
  ImprimirTextoLibre: TImprimirTextoLibre;
  CargarDatosCliente: TCargarDatosCliente;
  CargarComprobanteAsociado: TCargarComprobanteAsociado;

eSTADOFISCAL: string;
z: integer;
RESPONSABLEIVA: TiposDeResponsabilidades;
valoriva: double;
direccioncliente: olevariant;
descripcioncortada: string;
descripcion: string;
efectivoredondeado: double;
afiliado: double;
prueba: Array[0..200] of AnsiChar;
comando: Array[0..200] of AnsiChar;
cantidadep: Array[0..200] of AnsiChar;
precioep: Array[0..200] of AnsiChar;
alfabetaep: Array[0..200] of AnsiChar;
monto: Array[0..200] of AnsiChar;
tipcomprob : Array[0..200] of AnsiChar;
respuesta:  Array[0..10000] of AnsiChar;
numero: array [0..10000] of longint;
fechahora: array [0..300] of Ansichar;
cliente: Array[0..200] of AnsiChar;
domicilio: Array[0..200] of AnsiChar;
cuitcliente: Array[0..200] of AnsiChar;
dnicliente: Array[0..200] of AnsiChar;
tipdoc: array[0..200] of longint;
respuesta_final_buffer_salida: integer;
dnfh:string;
valorivaep: integer;
texto: string;
CODIGOIVA: string;
ofecupon: string;
numeroc: string;
begin
//  copiadigital;
  dll := 0;

  // instanciar dll - recordar que se require "uses Windows"

  dll := LoadLibrary('C:\dll\EpsonFiscalInterface.dll');

  // check error
  if dll = 0 then
  begin
    ShowMessage('Error al instanciar DLL');
    Exit;
  end;

  // obtener las referencias a funciones:  "ConsultarVersionDll"
  @ConsultarVersionDll := GetProcAddress(dll, 'ConsultarVersionDll');
  if not Assigned(ConsultarVersionDll) then
  begin
    ShowMessage('Error al asignar funcion: ConsultarVersionDll');
    Exit;
  end;


  // obtener las referencias a funciones:  "ConfigurarVelocidad"
  @ConfigurarVelocidad := GetProcAddress(dll, 'ConfigurarVelocidad');
  if not Assigned(ConfigurarVelocidad) then
  begin
    ShowMessage('Error al asignar funcion: ConfigurarVelocidad');
    Exit;
  end;

  // obtener las referencias a funciones:  "ConfigurarPuerto"
  @ConfigurarPuerto := GetProcAddress(dll, 'ConfigurarPuerto');
  if not Assigned(ConfigurarPuerto) then
  begin
    ShowMessage('Error al asignar funcion: ConfigurarPuerto');
    Exit;
  end;

  // obtener las referencias a funciones:  "Conectar"
  @Conectar := GetProcAddress(dll, 'Conectar');
  if not Assigned(Conectar) then
  begin
    ShowMessage('Error al asignar funcion: Conectar');
    Exit;
  end;

  // obtener las referencias a funciones:  "ImprimirCierreX"
  @ImprimirCierreX := GetProcAddress(dll, 'ImprimirCierreX');
  if not Assigned(ImprimirCierreX) then
  begin
    ShowMessage('Error al asignar funcion: ImprimirCierreX');
    Exit;
  end;

  // obtener las referencias a funciones:  "ImprimirCierreZ"
  @ImprimirCierreZ := GetProcAddress(dll, 'ImprimirCierreZ');
  if not Assigned(ImprimirCierreZ) then
  begin
    ShowMessage('Error al asignar funcion: ImprimirCierreZ');
    Exit;
  end;

  @AbrirComprobante := GetProcAddress(dll, 'AbrirComprobante');
  if not Assigned(AbrirComprobante) then
  begin
    ShowMessage('Error al asignar funcion: AbrirComprobante');
    Exit;
  end;
   @CerrarComprobante := GetProcAddress(dll, 'CerrarComprobante');
  if not Assigned(AbrirComprobante) then
  begin
    ShowMessage('Error al asignar funcion: CerrarComprobante');
    Exit;
  end;
     @Establecerencabezado := GetProcAddress(dll, 'EstablecerEncabezado');
  if not Assigned(AbrirComprobante) then
  begin
    ShowMessage('Error al asignar funcion: CerrarComprobante');
    Exit;
  end;
      @ConsultarEncabezado:= GetProcAddress(dll, 'EstablecerEncabezado');
  if not Assigned(AbrirComprobante) then
  begin
    ShowMessage('Error al asignar funcion: CerrarComprobante');
    Exit;
  end;
       @EnviarComando := GetProcAddress(dll, 'EnviarComando');
  if not Assigned(EnviarComando) then
  begin
    ShowMessage('Error al asignar funcion: EnviarComando');
    Exit;
  end;

  // obtener las referencias a funciones:  "Desconectar"
  @Desconectar := GetProcAddress(dll, 'Desconectar');
  if not Assigned(Desconectar) then
  begin
    ShowMessage('Error al asignar funcion: Desconectar');
    Exit;
  end;
    @EstablecerCola := GetProcAddress(dll, 'EstablecerCola');
  if not Assigned(EstablecerCola) then
  begin
    ShowMessage('Error al asignar funcion: EstablecerCola');
    Exit;
  end;
      @CargarTextoExtra := GetProcAddress(dll, 'CargarTextoExtra');
  if not Assigned(CargarTextoExtra) then
  begin
    ShowMessage('Error al asignar funcion: CargarTextoExtra');
    Exit;
  end;
     @ImprimirItem := GetProcAddress(dll, 'ImprimirItem');
  if not Assigned(ImprimirItem) then
  begin
    ShowMessage('Error al asignar funcion: ImprimirItem');
    Exit;
  end;
       @CargarPago := GetProcAddress(dll, 'CargarPago');
  if not Assigned(CargarPago) then
  begin
    ShowMessage('Error al asignar funcion: CargarPago');
    Exit;
  end;

         @ConsultarNumeroComprobanteActual := GetProcAddress(dll, 'ConsultarNumeroComprobanteActual');
  if not Assigned(ConsultarNumeroComprobanteActual) then
  begin
    ShowMessage('Error al asignar funcion: ConsultarNumeroComprobanteActual');
    Exit;
  end;
           @Consultarfechahora := GetProcAddress(dll, 'Consultarfechahora');
  if not Assigned(ConsultarNumeroComprobanteActual) then
  begin
    ShowMessage('Error al asignar funcion: Consultarfechahora');
    Exit;
  end;

             @ObtenerRespuestaExtendida:= GetProcAddress(dll, 'ObtenerRespuestaExtendida');
  if not Assigned(ObtenerRespuestaExtendida) then
  begin
    ShowMessage('Error al asignar funcion: ObtenerRespuestaExtendida');
    Exit;
  end;
               @CargarAjuste:= GetProcAddress(dll, 'CargarAjuste');
  if not Assigned(Cargarajuste) then
  begin
    ShowMessage('Error al asignar funcion: CargarAjuste');
    Exit;
  end;

            @ImprimirTextoLibre:= GetProcAddress(dll, 'ImprimirTextoLibre');
    if not Assigned(ImprimirTextoLibre) then
  begin
    ShowMessage('Error al asignar funcion: ImprimirTextoLibre');
    Exit;
  end;
       @CargarDatosCliente:= GetProcAddress(dll, 'CargarDatosCliente');
    if not Assigned(CargarDatosCliente) then
  begin
    ShowMessage('Error al asignar funcion: CargarDatosCliente');
    Exit;
  end;
  @ConsultarNumeroComprobanteUltimo:= GetProcAddress(dll, 'ConsultarNumeroComprobanteUltimo');
    if not Assigned(ConsultarNumeroComprobanteUltimo) then
  begin
    ShowMessage('Error al asignar funcion: ConsultarNumerocomprobanteultimo');
    Exit;
  end;









  mayor := 0;
  menor := 0;
  mychar:=' ';
  error := ConsultarVersionDll( str, 100, mayor, menor );
  error := ConfigurarVelocidad( 9600 );
  error := ConfigurarPuerto( ticket.puerto_com );
  error := CerrarComprobante();
  error := Conectar();
  error:= ConsultarNumeroComprobanteUltimo('81',@respuesta,2000);
 if not ((respuesta='') or (respuesta='Ninguno') ) then
      begin

         nro_comprobdigital:=strtoint(respuesta)+1;
         copiadigital;
      //---------------------------borrado encabezados y cola-----------------------//
        comando:='';

        error :=establecerencabezado (1, @comando[0]);
        error :=establecerencabezado (2, @comando[0]);
        error :=establecerencabezado (3, @comando[0]);
        error :=establecerencabezado (4, @comando[0]);
        error :=establecerencabezado (5, @comando[0]);
        error :=establecerencabezado (6, @comando[0]);
        error :=establecerencabezado (7, @comando[0]);
        error :=establecerencabezado (8, @comando[0]);
        error :=establecerencabezado (9, @comando[0]);
        error :=establecerencabezado (10, @comando[0]);

        error :=EstablecerCola (1, @comando[0]);
        error :=EstablecerCola (2, @comando[0]);
        error :=EstablecerCola (3, @comando[0]);
        error :=EstablecerCola (4, @comando[0]);
        error :=EstablecerCola (5, @comando[0]);
        error :=EstablecerCola (6, @comando[0]);
        error :=EstablecerCola (7, @comando[0]);
        error :=EstablecerCola (8, @comando[0]);
        error :=EstablecerCola (9, @comando[0]);
        error :=EstablecerCola (10, @comando[0]);
      //-----------------------------------------------------------------------------//
      //----------------------cliente y vendedor----------------------------------------//

         direccioncliente:=ticket.direccion;
          if direccioncliente='' then
           begin
             ticket.direccion:=ticket.DESCRIPCIONCLIENTE;
           end;

         IF Ticket.CONDICIONIVA = 'RESPONSABLE MONOTRIBUTO' THEN
         CODIGOIVA := 'M'
         ELSE IF Ticket.CONDICIONIVA = 'RESPONSABLE NO INSCRIPTO' THEN
          CODIGOIVA := 'N'
         ELSE IF Ticket.CONDICIONIVA = 'EXENTO' THEN
          CODIGOIVA := 'E'
         ELSE IF Ticket.CONDICIONIVA = 'RESPONSABLE INSCRIPTO' THEN
          CODIGOIVA := 'I'
         ELSE IF Ticket.CONDICIONIVA = 'CONSUMIDOR FINAL' THEN
          CODIGOIVA:= 'F';
         {  I = Responsable Inscripto
            N = No Responsable
            M = Monotributista
            E = Exento
            U = No Categorizado
            F = Consumidor Final
            T = Monotributista Social
            P = Monotributo Trabajador Independiente Promovido }




        dnicliente:='';
         if ticket.dni='' then
           begin
             ticket.dni:='1';

           end;
          if ticket.dni<>'' then
           begin

            ticket.dni:=trim(ticket.dni);

           end;


         ticket.CUIT:=trim(ticket.CUIT);
         IF Ticket.CONDICIONIVA <> 'CONSUMIDOR FINAL' THEN
         begin
          comando:='';
          texto:=strpcopy(comando,'0B01|0000|'+TICKET.DESCRIPCIONCLIENTE+'||'+TICKET.direccion+'|||T|'+ticket.CUIT+'|'+CODIGOIVA+'||||') ;
          error :=enviarcomando(@comando[0]);

 //
         end;
         IF Ticket.CONDICIONIVA = 'CONSUMIDOR FINAL' THEN
         begin
          comando:='';
          texto:=strpcopy(comando,'0B01|0000|'+TICKET.DESCRIPCIONCLIENTE+'||'+TICKET.direccion+'|||D|'+ticket.dni+'|'+CODIGOIVA+'||||') ;
          error :=enviarcomando(@comando[0]);
  //
         end;

//  error:=CargarComprobanteAsociado('');

//-----------------------------------------------------------------------------//
//----------------------Direccion fiscal----------------------------------------//
  comando:='';
  texto:=strpcopy(comando,'050E|0000|'+(ticket.direccionsucursal)) ;

  error :=enviarcomando(@comando[0]);

 comando:='';



//-------------------------------------------------------------------------------//
//-----------------------------CARGA DE ITEMS------------------------------------//
Gfacturador.DataSource.DataSet.First;
while not Gfacturador.DataSource.DataSet.Eof do
          begin
                if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[11].FieldName).asstring='0') then
                begin
                comando:='';
                texto:=strpcopy(comando,ticket.codigo_OS +': '+(Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[14].FieldName).asstring+' ('+(formatfloat('#####', Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[11].FieldName).asfloat))+'%)')) ;
                error:= CargarTextoExtra( comando )
                end;
                if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[12].FieldName).asstring='0') then
                begin
                comando:='';
                texto:=strpcopy(comando,ticket.codigo_Co1 +': '+(Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[20].FieldName).asstring+' ('+(formatfloat('#####', Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[12].FieldName).asfloat))+'%)')) ;
                error:= CargarTextoExtra( comando )
                end;
                if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[13].FieldName).asstring='0') then
                begin
                comando:='';
                texto:=strpcopy(comando,ticket.codigo_CoS2 +': '+(Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[27].FieldName).asstring+' ('+(formatfloat('#####', Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[13].FieldName).asfloat))+'%)')) ;
                error:= CargarTextoExtra( comando )
                end;
                if NOT ((TICKET.sucursal='202') OR (TICKET.sucursal='203') OR (TICKET.sucursal='221')) then
                BEGIN
                  if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[10].FieldName).asstring='B' then
                  begin
                    valorivaep:=5;
                  end;
                END;
                if ((TICKET.sucursal='202') OR (TICKET.sucursal='203') OR (TICKET.sucursal='221')) then
                BEGIN
                  if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[10].FieldName).asstring='B' then
                  begin
                    valorivaep:=1;
                  end;
                END;
                if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[10].FieldName).asstring='A' then
                begin
                  valorivaep:=1;
                end;

                descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);

                if (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring)<>'0' then
                BEGIN
                descripcion:='('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring)+')'+descripcion;
                END;

           descripcioncortada:=copy(descripcion, 0, 20);
           comando:='';
           texto:=strpcopy(comando,descripcioncortada) ;

           texto:=strpcopy(cantidadep,(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asstring)) ;


           if valorivaep=5 then
             begin
             texto:=strpcopy(precioep,floattostr(((gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat)*ticket.coeficientetarjeta)/1.21)) ;

             end;


           if valorivaep=1 then
           begin
           texto:=strpcopy(precioep,floattostr(((gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat)*ticket.coeficientetarjeta))) ;
           end;

           texto:=strpcopy(alfabetaep,(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[0].FieldName).asstring)) ;

           error:=ImprimirItem(200,comando,cantidadep,precioep,valorivaep,0,(''),1,alfabetaep,(''),7);

           Gfacturador.DataSource.DataSet.Next;
          end;
//-----------------------------CARGA DE ITEMS------------------------------------//
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
                 texto:=strpcopy(comando,descripcioncortada) ;
                 texto:=strpcopy(precioep,floattostr((gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[24].FieldName).asfloat)*ticket.coeficientetarjeta)) ;

                 error:= cargarajuste(400, comando, precioep, valorivaep, alfabetaep);

                end;
            Gfacturador.DataSource.DataSet.Next;

          end;

//----------------------------descuento general---------------------------------//



//----------------------------PAGOS-----------------------------------------------//


imp_efectivo:=floattostr(ticket.efectivo);
imp_tarjeta:=floattostr(ticket.tarjeta);
imp_cc:=floattostr(ticket.ctacte);
imp_os:=floattostr(ticket.importecargoos);
imp_co1:=floattostr(ticket.importecargoco1);
imp_co2:=floattostr(ticket.importecargoco2);
imp_ch:=floattostr(ticket.cheque);

      if imp_efectivo='' then
        begin
          imp_efectivo:='0';
        end;
        if imp_tarjeta='' then
         begin
           imp_tarjeta:='0';
         end;
        if imp_cc='' then
         begin
           imp_cc:='0';
         end;
        if imp_os='' then
         begin
           imp_os:='0';
         end;
         if imp_co1='' then
         begin
           imp_co1:='0';
         end;
         if imp_co2='' then
         begin
           imp_co2:='0';
         end;
         if imp_ch='' then
         begin
           imp_ch:='0';
         end;
         if imp_cc='' then
         begin
           imp_cc:='0';
         end;

        afiliado:= strtofloat(imp_efectivo)+ strtofloat(imp_tarjeta)+strtofloat(imp_cc)+strtofloat(imp_ch);
        if imp_efectivo<>'0' then
        begin
        monto:='';
        texto:=strpcopy(monto,imp_efectivo) ;
        comando:='';
        texto:=strpcopy(comando,'') ;
        error:= CargarPago(200,8,0,monto,'',comando,'','');
        end;

        if imp_tarjeta<>'0' then
        begin

        monto:='';
        texto:=strpcopy(monto,imp_tarjeta) ;
        comando:='';
        texto:=strpcopy(comando,'Tarjeta '+ticket.codigotarjeta+': ') ;
        error:= CargarPago(200,20,0,monto,'',comando,'','');
        end;

        if imp_cc<>'0' then
        begin

        monto:='';
        texto:=strpcopy(monto,imp_cc) ;
        comando:='';
        texto:=strpcopy(comando,'CC '+ticket.codigocc+' '+ticket.nombrecc) ;
        error:= CargarPago(200,6,0,monto,'',comando,'','');


        end;
        if imp_ch<>'0' then
        begin

         monto:='';
        texto:=strpcopy(monto,imp_ch) ;
        comando:='';
        texto:=strpcopy(comando,'') ;
        error:= CargarPago(200,3,0,monto,'',comando,'','');



        end;
        if imp_os<>'0' then
        begin

        monto:='';
        texto:=strpcopy(monto,imp_os) ;
        comando:='';
        texto:=strpcopy(comando,ticket.nombre_os) ;
        error:= CargarPago(200,99,0,monto,'',comando,'','');


        end;
        if imp_co1<>'0' then
        begin

        monto:='';
        texto:=strpcopy(monto,imp_co1) ;
        comando:='';
        texto:=strpcopy(comando,ticket.nombre_co1) ;
        error:= CargarPago(200,99,0,monto,'',comando,'','');



        end;
        if imp_co2<>'0' then
        begin

         monto:='';
        texto:=strpcopy(monto,imp_co2) ;
        comando:='';
        texto:=strpcopy(comando,ticket.nombre_cos2) ;
        error:= CargarPago(200,99,0,monto,'',comando,'','');
        end;
//----------------------------PAGOS-----------------------------------------------//
//finalizacion ticket-------------------------------------------------------------//
          comando:='';
          texto:=strpcopy(comando,'Numero de ref:' +(ticket.valnroreferencia)) ;
          error :=establecercola (1, @comando[0]);
          if not (ticket.puntos_farmavalor='') or (ticket.puntos_farmavalor='0') then
          begin
          comando:='';
          texto:=strpcopy(comando,'Puntos Farmavalor: '+(ticket.puntos_farmavalor)) ;
          error :=establecercola (2, @comando[0]);
          comando:='';
          texto:=strpcopy(comando,'Los puntos se actualizan cada 24 hs') ;
          error :=establecercola (3, @comando[0]);
          end;
//--------------------  PROMO -----------------------------------------------------------------------//
      {  if ticket.Oespecial='S' then
        BEGIN
          TRY

             if ticket.sumafarmacia<2000 then
              begin
                   if ticket.sumafarmacia>1000 then
                      begin
                      generarcuponoferta('126');
                      ofecupon:='%5:  '
                      end;
              end;
              if ticket.sumafarmacia>2000 then
              begin
                 generarcuponoferta('127');
                 ofecupon:='%10:  '
              end;
              if cupon<>'' then
              begin

              texto:=strpcopy(comando,'Cupon oferta perfu '+ofecupon+cupon) ;
              error :=establecercola (4, @comando[0]);
              end;
          EXCEPT

          END;
        END; }

//--------------------  PROMO -----------------------------------------------------------------------//
         respuesta:='';
         tipcomprob:='';
         texto:=strpcopy(tipcomprob,'81') ;
         error:= ConsultarNumeroComprobanteActual(@respuesta,2000);
         numeroc:=respuesta;
         imprimi:=true;
         if not ((numeroc='') or (numeroc='Ninguno')) then
         begin
         nro_comprob:=strtoint(respuesta);
         respuesta:='';


         ticket.fechafiscal:=(now);
         ticket.numero_ticketfiscal:=nro_comprob;


         error := CerrarComprobante();
         end
         else
         imprimi:=False;
         end;


//-------------------borrado encabezado y cola------------------------------------------//
  comando:='';

  error :=establecerencabezado (1, @comando[0]);
  error :=establecerencabezado (2, @comando[0]);
  error :=establecerencabezado (3, @comando[0]);
  error :=establecerencabezado (4, @comando[0]);
  error :=establecerencabezado (5, @comando[0]);
  error :=establecerencabezado (6, @comando[0]);
  error :=establecerencabezado (7, @comando[0]);
  error :=establecerencabezado (8, @comando[0]);
  error :=establecerencabezado (9, @comando[0]);
  error :=establecerencabezado (10, @comando[0]);

  error :=EstablecerCola (1, @comando[0]);
  error :=EstablecerCola (2, @comando[0]);
  error :=EstablecerCola (3, @comando[0]);
  error :=EstablecerCola (4, @comando[0]);
  error :=EstablecerCola (5, @comando[0]);
  error :=EstablecerCola (6, @comando[0]);
  error :=EstablecerCola (7, @comando[0]);
  error :=EstablecerCola (8, @comando[0]);
  error :=EstablecerCola (9, @comando[0]);
  error :=EstablecerCola (10, @comando[0]);

 //------------------------------------------------------------------------------------//
 comando:='';
 texto:=strpcopy(comando,'08F0|0001|081|'+inttostr(ticket.numero_ticketfiscal)) ;
 error:=enviarcomando(Comando);
 comando:='';
 texto:=strpcopy(comando,'08F6|0000') ;
 error:=enviarcomando(Comando);



 //----------------------------talon obras sociales-------------------------------------//

             if (ticket.codigo_OS<>'') or (ticket.codigo_Co1<>'') or (ticket.codigo_Cos2<>'') then
              begin

              error := CerrarComprobante();


              comando:='';
              texto:=strpcopy(comando,'Vendedor: '+ticket.nom_vendedor) ;
              error :=establecerencabezado (1, @comando[0]);
              comando:='';
              texto:=strpcopy(comando,'Obra Social: '+ticket.codigo_OS+'-'+ticket.nombre_os) ;
              error :=establecerencabezado (2, @comando[0]);
              comando:='';
              texto:=strpcopy(comando,'Coseguro 1: '+ticket.codigo_Co1+'-'+ticket.nombre_co1) ;
              error :=establecerencabezado (3, @comando[0]);
              comando:='';
              texto:=strpcopy(comando,'Afiliado: '+ticket.afiliado_apellido+' '+ticket.afiliado_nombre) ;
              error :=establecerencabezado (4, @comando[0]);
              comando:='';
              texto:=strpcopy(comando,'Nro afiliado: '+ticket.afiliado_numero) ;
              error :=establecerencabezado (5, @comando[0]);
              comando:='';
              texto:=strpcopy(comando,'Mat. Med: '+ticket.medico_nro_matricula) ;
              error :=establecerencabezado (6, @comando[0]);
              comando:='';
              texto:=strpcopy(comando,'Receta: '+ticket.numero_receta) ;
              error :=establecerencabezado (7, @comando[0]);
              comando:='';
              texto:=strpcopy(comando,'Numero de ref: '+ticket.valnroreferencia) ;
              error :=establecerencabezado (9, @comando[0]);
              comando:='';
              texto:=strpcopy(comando,'REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(imp_os),-2)) );
              error :=establecercola (1, @comando[0]);
              comando:='';
              texto:=strpcopy(comando,'CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(afiliado,-2))) ;
              error :=establecercola (2, @comando[0]);
              comando:='';
              texto:=strpcopy(comando,'EF: '+floattostr(roundto(strtofloat(IMP_EFECTIVO),-2))+' CH: '+floattostr(roundto(strtofloat(imp_ch),-2))+' CC: '+floattostr(roundto(strtofloat(imp_cc),-2))+' TJ: '+floattostr(roundto(strtofloat(imp_TARJETA),-2)) );
              error :=establecercola (3, @comando[0]);

              error := abrircomprobante(21);

              comando:='';
              texto:=strpcopy(comando,'DOCUMENTO NO FISCAL FARMACIAS') ;
              error :=ImprimirTextoLibre(comando);
              comando:='';
              texto:=strpcopy(comando,'NRO TICKET: '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8))) ;
              error :=ImprimirTextoLibre(comando);
              comando:='';
              texto:=strpcopy(comando,'--------------------------------------------------') ;
              error :=ImprimirTextoLibre(comando);

              Gfacturador.DataSource.DataSet.First;

              while not Gfacturador.DataSource.DataSet.Eof do
              begin
                    descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
                    descripcioncortada:=copy(descripcion, 0, 20);

                    comando:='';
                    texto:=strpcopy(comando,(descripcioncortada)+'('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asstring)+')  '+floattostr(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat)) ;
                    error :=ImprimirTextoLibre(comando);
                    comando:='';
                    texto:=strpcopy(comando,' ') ;
                    error :=ImprimirTextoLibre(comando);

                    Gfacturador.DataSource.DataSet.Next;
              end;

              error := CerrarComprobante();
              if ticket.codigo_os<>'' then
              begin
                z:=z+1
              end;
                if ticket.codigo_Co1<>'' then
              begin
                z:=z+1
              end;
              comando:='';
              if z>1 then
                begin
                    error := CerrarComprobante();


                    comando:='';
                    texto:=strpcopy(comando,'Vendedor: '+ticket.nom_vendedor) ;
                    error :=establecerencabezado (1, @comando[0]);
                    comando:='';
                    texto:=strpcopy(comando,'Obra Social: '+ticket.codigo_OS+'-'+ticket.nombre_os) ;
                    error :=establecerencabezado (2, @comando[0]);
                    comando:='';
                    texto:=strpcopy(comando,'Coseguro 1: '+ticket.codigo_Co1+'-'+ticket.nombre_co1) ;
                    error :=establecerencabezado (3, @comando[0]);
                    comando:='';
                    texto:=strpcopy(comando,'Afiliado: '+ticket.afiliado_apellido+' '+ticket.afiliado_nombre) ;
                    error :=establecerencabezado (4, @comando[0]);
                    comando:='';
                    texto:=strpcopy(comando,'Nro afiliado: '+ticket.afiliado_numero) ;
                    error :=establecerencabezado (5, @comando[0]);
                    comando:='';
                    texto:=strpcopy(comando,'Mat. Med: '+ticket.medico_nro_matricula) ;
                    error :=establecerencabezado (6, @comando[0]);
                    comando:='';
                    texto:=strpcopy(comando,'Receta: '+ticket.numero_receta) ;
                    error :=establecerencabezado (7, @comando[0]);
                    comando:='';
                    texto:=strpcopy(comando,'Numero de ref: '+ticket.valnroreferencia) ;
                    error :=establecerencabezado (9, @comando[0]);
                    comando:='';
                    texto:=strpcopy(comando,'REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(imp_os),-2)) );
                    error :=establecercola (1, @comando[0]);
                    comando:='';
                    texto:=strpcopy(comando,'CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(afiliado,-2))) ;
                    error :=establecercola (2, @comando[0]);
                    comando:='';
                    texto:=strpcopy(comando,'EF: '+floattostr(roundto(strtofloat(IMP_EFECTIVO),-2))+' CH: '+floattostr(roundto(strtofloat(imp_ch),-2))+' CC: '+floattostr(roundto(strtofloat(imp_cc),-2))+' TJ: '+floattostr(roundto(strtofloat(imp_TARJETA),-2)) );
                    error :=establecercola (3, @comando[0]);

                    error := abrircomprobante(21);

                    comando:='';
                    texto:=strpcopy(comando,'DOCUMENTO NO FISCAL FARMACIAS') ;
                    error :=ImprimirTextoLibre(comando);
                    comando:='';
                    texto:=strpcopy(comando,'NRO TICKET: '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8))) ;
                    error :=ImprimirTextoLibre(comando);
                    comando:='';
                    texto:=strpcopy(comando,'--------------------------------------------------') ;
                    error :=ImprimirTextoLibre(comando);

                    Gfacturador.DataSource.DataSet.First;

                    while not Gfacturador.DataSource.DataSet.Eof do
                    begin
                          descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
                          descripcioncortada:=copy(descripcion, 0, 20);

                          comando:='';
                          texto:=strpcopy(comando,(descripcioncortada)+'('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asstring)+')  '+floattostr(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat)) ;
                          error :=ImprimirTextoLibre(comando);
                          comando:='';
                          texto:=strpcopy(comando,' ') ;
                          error :=ImprimirTextoLibre(comando);

                          Gfacturador.DataSource.DataSet.Next;
                    end;

                    error := CerrarComprobante();



              end;






              end;

  comando:='';

  error :=establecerencabezado (1, @comando[0]);
  error :=establecerencabezado (2, @comando[0]);
  error :=establecerencabezado (3, @comando[0]);
  error :=establecerencabezado (4, @comando[0]);
  error :=establecerencabezado (5, @comando[0]);
  error :=establecerencabezado (6, @comando[0]);
  error :=establecerencabezado (7, @comando[0]);
  error :=establecerencabezado (8, @comando[0]);
  error :=establecerencabezado (9, @comando[0]);
  error :=establecerencabezado (10, @comando[0]);

  error :=EstablecerCola (1, @comando[0]);
  error :=EstablecerCola (2, @comando[0]);
  error :=EstablecerCola (3, @comando[0]);
  error :=EstablecerCola (4, @comando[0]);
  error :=EstablecerCola (5, @comando[0]);
  error :=EstablecerCola (6, @comando[0]);
  error :=EstablecerCola (7, @comando[0]);
  error :=EstablecerCola (8, @comando[0]);
  error :=EstablecerCola (9, @comando[0]);
  error :=EstablecerCola (10, @comando[0]);



 if TICKET.llevavale='SI' then
        BEGIN

          error := CerrarComprobante();



          comando:='';
          texto:=strpcopy(comando,'Vendedor: '+ticket.nom_vendedor) ;
          error :=establecerencabezado (1, @comando[0]);

          if (ticket.nombre_os='') and (ticket.nombre_co1<>'') then
          begin
          comando:='';
          texto:=strpcopy(comando,'Obra Social: '+ticket.codigo_OS+'-'+ticket.nombre_os) ;
          error :=establecerencabezado (2, @comando[0]);
          end;

          if (ticket.nombre_os='') and (ticket.nombre_co1<>'') then
          begin
          comando:='';
          texto:=strpcopy(comando,'Afiliado: '+ticket.afiliado_apellido+' '+ticket.afiliado_nombre) ;
          error :=establecerencabezado (4, @comando[0]);

          end;
          if (ticket.nombre_os<>'') then
          begin
          comando:='';
          texto:=strpcopy(comando,'Afiliado: '+ticket.afiliado_apellido+' '+ticket.afiliado_nombre) ;
          error :=establecerencabezado (4, @comando[0]);
          comando:='';
          texto:=strpcopy(comando,'Nro afiliado: '+ticket.afiliado_numero) ;
          error :=establecerencabezado (5, @comando[0]);

          end;
          comando:='';
          texto:=strpcopy(comando,'REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(imp_os),-2)) );
          error :=establecercola (1, @comando[0]);
          comando:='';
          texto:=strpcopy(comando,'CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(afiliado,-2))) ;
          error :=establecercola (2, @comando[0]);
          comando:='';
          texto:=strpcopy(comando,'EF: '+floattostr(roundto(strtofloat(IMP_EFECTIVO),-2))+' CH: '+floattostr(roundto(strtofloat(imp_ch),-2))+' CC: '+floattostr(roundto(strtofloat(imp_cc),-2))+' TJ: '+floattostr(roundto(strtofloat(imp_TARJETA),-2)) );
          error :=establecercola (3, @comando[0]);
          comando:='';

          error := abrircomprobante(21);

          texto:=strpcopy(comando,'--------------------------------------------------') ;
          error :=ImprimirTextoLibre(comando);
          comando:='';
          texto:=strpcopy(comando,'Emision VR'+ticket.fiscla_pv+': '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8))) ;
          error :=ImprimirTextoLibre(comando);

          Gfacturador.DataSource.DataSet.First;

          while not Gfacturador.DataSource.DataSet.Eof do
          begin
               if Gfacturador.Fields[17].AsSTRING='SI' then
               BEGIN
                comando:='';
                texto:=strpcopy(comando,Gfacturador.Fields[1].AsSTRING) ;
                error :=ImprimirTextoLibre(comando);
                comando:='';
                texto:=strpcopy(comando,'Unidades Vale:'+(Gfacturador.Fields[18].AsSTRING)) ;
                error :=ImprimirTextoLibre(comando);

               END;
               Gfacturador.DataSource.DataSet.Next;
          end;
          comando:='';
          texto:=strpcopy(comando,'REF. CPBT. '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8))) ;
          error :=ImprimirTextoLibre(comando);

           texto:=strpcopy(comando,'-----CORTAR-------------CORTAR------------CORTAR------------CORTAR------------️') ;
          error :=ImprimirTextoLibre(comando);
          comando:='';
          texto:=strpcopy(comando,'Emision VR'+ticket.fiscla_pv+': '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8))) ;
          error :=ImprimirTextoLibre(comando);

          Gfacturador.DataSource.DataSet.First;

          while not Gfacturador.DataSource.DataSet.Eof do
          begin
               if Gfacturador.Fields[17].AsSTRING='SI' then
               BEGIN
                comando:='';
                texto:=strpcopy(comando,Gfacturador.Fields[1].AsSTRING) ;
                error :=ImprimirTextoLibre(comando);
                comando:='';
                texto:=strpcopy(comando,'Unidades Vale:'+(Gfacturador.Fields[18].AsSTRING)) ;
                error :=ImprimirTextoLibre(comando);

               END;
               Gfacturador.DataSource.DataSet.Next;
          end;
          comando:='';
          texto:=strpcopy(comando,'REF. CPBT. '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8))) ;
          error :=ImprimirTextoLibre(comando);
          comando:='';
          texto:=strpcopy(comando,'-----CORTAR-------------CORTAR------------CORTAR------------CORTAR------------') ;
          error :=ImprimirTextoLibre(comando);


        error := CerrarComprobante();

        END;


 //----------------------------talon obras sociales-------------------------------------//
 error := Desconectar();
 FreeLibrary(dll);
          if imprimi<>false then
            begin
            imprimi:=true;
            end;




//finalizacion ticket-------------------------------------------------------------//



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

        dmfacturador.icomprobante.Open;
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
                                                        '0,                                              ',
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
    dmfacturador.icomprobante.Open;
    dmFacturador.ticomprobante.Commit;
    Gfacturador.DataSource.DataSet.Next;
    end;



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




 //INSERTAR VTTBPAGOCHEQUE          --VR LLEVA TODOS LOS MEDIOS DE PAGO

if TICKET.cheque<>0 then
begin
     if dmfacturador.ticomprobante.InTransaction  then
    dmfacturador.ticomprobante.Rollback;

    dmfacturador.ticomprobante.StartTransaction;
    dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

    dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
    dmfacturador.icomprobante.Close;
    dmfacturador.icomprobante.SQL.Clear;


    dmfacturador.icomprobante.Close;
    dmfacturador.icomprobante.SQL.Text:=concat(' INSERT INTO VTTBPAGOCHEQUE (NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_BANCO, COD_CTA, NRO_CHEQUE, IMP_CHEQUE) VALUES (:sucursal,:tip_comprobante, :nro_comprobante, :cod_banco, '''', :nro_cheque, :importe_cheque);');



    dmfacturador.icomprobante.ParamByName('SUCURSAL').AsString:=ticket.sucursal;
    dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
    dmfacturador.icomprobante.ParamByName('nro_comprobante').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
    dmfacturador.icomprobante.ParamByName('cod_banco').AsString:=ticket.codigocheque;
    dmfacturador.icomprobante.ParamByName('nro_cheque').AsString:=ticket.numerocheque;
    dmfacturador.icomprobante.ParamByName('importe_cheque').AsFloat:=TICKET.cheque;
    dmfacturador.icomprobante.Open;
    dmfacturador.ticomprobante.Commit;

end;

//INSTERTAR VTTPAGOCTACTE

if TICKET.ctacte<>0 then
        begin
         if dmfacturador.ticomprobante.InTransaction  then
        dmfacturador.ticomprobante.Rollback;

        dmfacturador.ticomprobante.StartTransaction;
        dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

        dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
        dmfacturador.icomprobante.Close;
        dmfacturador.icomprobante.SQL.Clear;


        dmfacturador.icomprobante.Close;
        dmfacturador.icomprobante.SQL.Text:=concat(' INSERT INTO VTTBPAGOCTACTE ',
                                                   '(NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_CTACTE, COD_SUBCTA, COD_AUTORIZACTA, IMP_CTACTE, IMP_SALDO, ',
                                                   ' MAR_RESUMIDO, NRO_SUCURSAL_LIQ, NRO_LIQUIDACION, CAN_CUOTAS, CAN_CUOTASPEN, POR_IVA, CODIGOPAGO) ',
                                                   ' VALUES (:NRO_SUCURSAL,:TIP_COMPROBANTE , :NRO_COMPROB, :COD_CTACTE, :COD_SUBCTA, '''', :IMP_CTACTE, :IMP_SCTACTE, ''N'', 0, NULL, 0, 0, NULL, NULL)');


        dmfacturador.icomprobante.ParamByName('NRO_SUCURSAL').AsString:=ticket.sucursal;
        dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
        dmfacturador.icomprobante.ParamByName('nro_comprob').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
        dmfacturador.icomprobante.ParamByName('COD_CTACTE').AsString:=ticket.codigocc;
        dmfacturador.icomprobante.ParamByName('cod_subcta').AsString:=ticket.codigosubcc;
        dmfacturador.icomprobante.ParamByName('imp_ctacte').AsFloat:=TICKET.ctacte;
        dmfacturador.icomprobante.ParamByName('imp_sctacte').AsFloat:=TICKET.ctacte;
        dmfacturador.icomprobante.Open;
        dmfacturador.ticomprobante.Commit;

end;

//INSERTAR VTTPAGOEFECTIVO

 if TICKET.efectivO<>0 then
        begin
         if dmfacturador.ticomprobante.InTransaction  then
        dmfacturador.ticomprobante.Rollback;

        dmfacturador.ticomprobante.StartTransaction;
        dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

        dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
        dmfacturador.icomprobante.Close;
        dmfacturador.icomprobante.SQL.Clear;


        dmfacturador.icomprobante.Close;
        dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO VTTBPAGOEFECTIVO (NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_MONEDA, IMP_EFECTIVO, IMP_COTIZ, POR_IVA)',
                                                   ' VALUES (:NRO_SUCURSAL, :TIP_COMPROBANTE, :NRO_COMPROBANTE, ''$'', :IMP_EFECTIVO, NULL, NULL)');


        dmfacturador.icomprobante.ParamByName('NRO_SUCURSAL').AsString:=ticket.sucursal;
        dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
        dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
        dmfacturador.icomprobante.ParamByName('imp_EFECTIVO').AsFloat:=TICKET.efectivO;
        dmfacturador.icomprobante.Open;
        dmfacturador.ticomprobante.Commit;

        end;





 //INSERTAR VTTBPAGOTARJETA


 if TICKET.tarjeta<>0 then
        begin
         if dmfacturador.ticomprobante.InTransaction  then
        dmfacturador.ticomprobante.Rollback;

        dmfacturador.ticomprobante.StartTransaction;
        dmfacturador.icomprobante.Database:=dmFacturador.getConexion;

        dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
        dmfacturador.icomprobante.Close;
        dmfacturador.icomprobante.SQL.Clear;


        dmfacturador.icomprobante.Close;
        dmfacturador.icomprobante.SQL.Text:=concat(' INSERT INTO VTTBPAGOTARJETA (NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_TARJETA, NRO_TARJETA, COD_MONEDA, NRO_CUPON, ',
                                                   ' IMP_TARJETA, IMP_COTIZ, NRO_CUOTA, NRO_AUTORIZACION, NRO_LIQUIDACION, FEC_VENCIMIENTO, NRO_PIN, POR_IVA, CODIGOPAGO)',
                                                   ' VALUES (:NRO_SUCURSAL, :TIP_COMPROBANTE, :NRO_COMPROBANTE, :COD_TARJETA, ''0'', ''$'', NULL, :IMP_TARJETA, NULL, 0, 0, NULL, CURRENT_DATE , 0, NULL, NULL)');



        dmfacturador.icomprobante.ParamByName('NRO_SUCURSAL').AsString:=ticket.sucursal;
        dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
        dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
        dmfacturador.icomprobante.ParamByName('COD_TARJETA').AsString:=ticket.codigotarjeta;
        dmfacturador.icomprobante.ParamByName('imp_tarjeta').AsFloat:=TICKET.tarjeta;
        dmfacturador.icomprobante.Open;
        dmfacturador.ticomprobante.Commit;

        end;




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