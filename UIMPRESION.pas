unit UIMPRESION;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.OleCtrls, System.Win.ComObj,
  FiscalPrinterLib_TLB,  udticket,  System.Types, math,
  Vcl.Buttons, Xml.xmldom, Xml.XMLIntf,
  msxmldom, xml.xmldoc;

const
  UM_ACTIVATED = WM_USER + 1;

type
   TFIMPRESION = class(TForm)
    mimpresion: TMemo;
    HASAR: THASAR;
    Bcancelar: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure mimpresionKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
    imp_efectivo: string;
    imp_tarjeta: string;
    imp_cc: string;
    imp_co1: string;
    imp_co2: string;
    imp_ch: string;
    imp_os: string;
    nro_comprob: integer;
    nro_comprobdigital: integer;
  public
  vendedor: string;
  pv: string;
  producto: string;
  preciounitario: double;
  total: double;
  cantidad: integer;
  Ticket:TTicket;



  procedure setEfectivo(importe:String);
  procedure setTarjeta(importe:String);
  procedure setos(importe:String);
  procedure setcc(importe:String);
  procedure setch(importe:String);
  procedure setco1(importe:String);
  procedure setco2(importe:String);
  procedure Insertarcomprobante;
  procedure Insertarcomprobantevale;
  procedure SetTicket(unTicket:TTicket);
  procedure ImprimirTicketA(var  Imprimio:boolean);
  procedure ImprimirTicketB(var  Imprimio:boolean);
  procedure ImprimirTicketT(var  Imprimio:boolean);
  procedure copiadigital;

  function ComenzarFiscal:Boolean;
  procedure UMActivated(var Message: TMessage); message UM_ACTIVATED;


  end;

var
  FIMPRESION: TFIMPRESION;
  inserciontk: string;
  insercionvr: string;
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


function TFIMPRESION.ComenzarFiscal: Boolean;
var
 i: integeR;
begin
  Try
    Hasar.Comenzar;
    ComenzarFiscal:=True;
    i:=0;
    nro_comprobdigital:=(strtoint(Hasar.respuesta[3]))+1;
    copiadigital;
     {nro_comprobdigital:=(strtoint(Hasar.respuesta[3]))+1;
      mimpresion.Lines.add('***COMPROBANTE FISCAL HOMOLOGADO***');
      mimpresion.Lines.add('');
      mimpresion.Lines.add('');
      mimpresion.Lines.Add('Nro. Comprobante:'+'................'+(rightpad(inttostr(nro_comprobdigital), '0', 8)));
      mimpresion.Lines.add('Nro. Afiliado: '+ TICKET.afiliado_numero);
      mimpresion.Lines.add('Nombre Cliente: '+ ticket.DESCRIPCIONCLIENTE);
      mimpresion.Lines.add('Nro. receta: '+ ticket.numero_receta);
      mimpresion.Lines.add('CUIT Cliente: '+ ticket.CUIT);
      mimpresion.Lines.add('Nombre Vendedor: '+ ticket.nom_vendedor);
      mimpresion.Lines.Add('Productos: ');
      mimpresion.Lines.Add(cadLongitudFija ('ITEM', 8, false, ' ')+cadLongitudFija ('NOMBRE',  40, false, ' ')+cadLongitudFija ('CANTIDAD', 10, false, ' ')+cadLongitudFija ('IMPORTE',  12, false, ' '));
      mimpresion.Lines.Add('--------------------------------------------------------------------------------');

      ffacturador.Gfacturador.DataSource.DataSet.First;
      while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
      begin
      i:=i+1;
      mimpresion.Lines.Add(cadLongitudFija (inttostr(I),  8, false, ' ')+cadLongitudFija (ffacturador.Gfacturador.Fields[1].AsString, 40, false, ' ')+cadLongitudFija (INTTOSTR(ffacturador.Gfacturador.Fields[3].Asinteger), 10, false, ' ')+cadLongitudFija ('$'+FLOATTOSTR(ffacturador.Gfacturador.Fields[2].asfloat*ffacturador.Gfacturador.Fields[3].Asinteger), 12, false, ' '));
      cantidad:=cantidad+(ffacturador.Gfacturador.Fields[3].Asinteger);
      ffacturador.Gfacturador.DataSource.DataSet.Next;
      end;

      mimpresion.Lines.Add('');
      mimpresion.Lines.Add('TOTAL UNIDADES: '+inttostr(cantidad));
      mimpresion.Lines.Add('');
      mimpresion.Lines.Add('TOTAL EFECTIVO: '+'$ '+IMP_EFECTIVO);
      mimpresion.Lines.Add('');
      mimpresion.Lines.Add('TOTAL TARJETA: '+'$ '+IMP_TARJETA);
      mimpresion.Lines.Add('');
      mimpresion.Lines.Add('TOTAL CUENTA CORRIENTE: '+'$ '+IMP_CC+ '  CODIGO CUENTA: '+ TICKET.codigocc);
      mimpresion.Lines.Add('');
      mimpresion.Lines.Add('TOTAL CHEQUE: '+'$ '+IMP_CH);
      mimpresion.Lines.Add('');
      mimpresion.Lines.Add('TOTAL OS: '+ticket.codigo_OS+' $ '+IMP_OS);
      mimpresion.Lines.Add('');
      mimpresion.Lines.Add('TOTAL CO1: '+ticket.codigo_Co1+' $ '+IMP_CO1);
      mimpresion.Lines.Add('');
      mimpresion.Lines.Add('TOTAL CO2: '+'$ '+IMP_CO2);
      mimpresion.Lines.Add('');
      mimpresion.Lines.add('***COMPROBANTE FISCAL HOMOLOGADO***');
      try
      begin
      mimpresion.Lines.SaveToFile(ticket.errores+ticket.fiscla_pv+(rightpad(inttostr(nro_comprobdigital), '0', 8))+'.txt');
      end;
      except

      end; }


  Except

  on E: EOleException  do
    Begin
    ComenzarFiscal:=false;
    End;
  End;
end;

procedure TFIMPRESION.copiadigital;
var
  archivoXML: TXMLDocument;

  Nodo,NDatosGenerales,NMensajeFacturacion,NCabecera,NDatosFinales,terminal,software,
  validador,prestador,prescriptor, beneficiario, financiador, credencial, CoberturaEspecial, Preautorizacion,
  Fechareceta,Dispensa, Formulario, TipoTratamiento, Diagnostico, Institucion, Retira, detallereceta, item
  : IXMLNode;
  I:Integer;
begin
    archivoXML := TXMLDocument.Create(Application);








end;

procedure TFIMPRESION.FormShow(Sender: TObject);
var
ESTADOFISCAL: string;
z: integer;
comprobanteimpreso: STRING;
RESPONSABLEIVA: TiposDeResponsabilidades;
valoriva: double;
direccioncliente: olevariant;
impresion_ok:boolean;


begin
COMPROBANTEIMPRESO:='';
   with HASAR do
   begin
        Puerto := strtoint(ticket.puerto_com);
        Transporte := PUERTO_SERIE;
        PrecioBase := False;
        DescripcionesLargas := True;
        Reintentos := 3;
        TiempoDeEspera := 2000;
   end;
   dmfacturador.qdire.Close;
   dmfacturador.qdire.SQL.Clear;
   dmfacturador.qdire.SQL.Add('select des_direccion from sumasucursal where nro_sucursal=:sucursal');
   dmfacturador.qdire.ParamByName('sucursal').AsString:=ticket.sucursal;
   dmfacturador.qdire.Open;
   ticket.direccionsucursal:=dmfacturador.qdire.FieldByName('des_direccion').AsString;

   // --------- ticket factura a------------------------//

   if ticket.tip_comprobante='A' then
   BEGIN
          ImprimirTicketA(impresion_ok);
   END;

   // --------- ticket factura B------------------------//

   if ticket.tip_comprobante='B' then
   BEGIN
         ImprimirTicketB(impresion_ok);
   END;

// --------- ticket comun------------------------//
   if ticket.tip_comprobante='T' then
   begin
       ImprimirTicketT(impresion_ok);
  end;

//if impresion_ok=false then

if impresion_ok then
BEGIN

  inserciontk:='';
  INSERTARCOMPROBANTE;

  if not (inserciontk='ok') then
   begin
    mimpresion.Lines.SaveToFile(ticket.errores+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8))+'.txt');
   end;
  if TICKET.llevavale='SI' then
  begin
  insertarcomprobantevale;
  end;
  modalresult:=mrcancel;
  PostMessage(Handle, UM_ACTIVATED, 0, 0);
  ticket.estadoticket:=1;
END ELSE
BEGIN
  showmessage('IMPOSIBLE IMPRIMIR COMPROBANTE REVISE IMPRESORA');
  modalresult:=mrcancel;
  PostMessage(Handle, UM_ACTIVATED, 0, 0);
  ticket.estadoticket:=0;
END;

end;


procedure TFIMPRESION.setEfectivo(importe: String);
begin
  imp_efectivo:=importe;
end;

procedure TFIMPRESION.setTarjeta(importe: String);
begin
   imp_tarjeta:=importe;
end;
procedure TFIMPRESION.setos(importe: String);
begin
  imp_os:=importe;
end;
procedure TFIMPRESION.setcc(importe: String);
begin
  imp_cc:=importe;
end;
procedure TFIMPRESION.setch(importe: String);
begin
  imp_ch:=importe;
end;
procedure TFIMPRESION.setco1(importe: String);
begin
  imp_co1:=importe;
end;
procedure TFIMPRESION.setco2(importe: String);
begin
  imp_co2:=importe;
end;





procedure TFIMPRESION.ImprimirTicketA(var  Imprimio:boolean);
var
ESTADOFISCAL: string;
z: integer;
RESPONSABLEIVA: TiposDeResponsabilidades;
valoriva: double;
direccioncliente: olevariant;
descripcion: string;
descripcioncortada: string;
begin
  if not (ComenzarFiscal) then
   Begin
      ShowMessage('No se pudo conectar al fiscal');
      imprimio:=false;
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

       hasar.DatosCliente(ticket.DESCRIPCIONCLIENTE, ticket.CUIT, TIPO_CUIT, RESPONSABLEIVA, direccioncliente);

       Hasar.AbrirComprobanteFiscal(TICKET_FACTURA_A);

       ffacturador.Gfacturador.DataSource.DataSet.First;
        while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
          begin
                if not (ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[11].FieldName).asstring='0') then
                begin
                hasar.ImprimirTextofiscal(ticket.codigo_OS +': '+ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[14].FieldName).asstring+' ('+ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[11].FieldName).asstring+'%)');
                end;
                if not (ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[12].FieldName).asstring='0') then
                begin
                hasar.ImprimirTextofiscal(ticket.codigo_Co1+': '+ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[20].FieldName).asstring+' ('+ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[12].FieldName).asstring+'%)');
                end;
                if ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[10].FieldName).asstring='B' then
                begin
                  valoriva:=21;
                end;
                if ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[10].FieldName).asstring='A' then
                begin
                  valoriva:=0;
                end;
                descripcion:=(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[1].FieldName).asstring);
                descripcioncortada:=copy(descripcion, 0, 20);
                HASAR.ImprimirItem(
               (descripcioncortada),
               (ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[3].FieldName).asfloat),
               ((ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[2].FieldName).asfloat)*ticket.coeficientetarjeta),
                valoriva, 0);


               ffacturador.Gfacturador.DataSource.DataSet.Next;
          end;
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
        if imp_efectivo<>'0' then
        begin
        hasar.ImprimirPago('Efectivo: ',strtofloat(imp_efectivo));
        end;
        if imp_tarjeta<>'0' then
        begin
        hasar.ImprimirPago('Tarjeta: ',strtofloat(imp_tarjeta));
        end;
        if imp_cc<>'0' then
        begin
        hasar.ImprimirPago('CC '+ticket.codigocc+' '+ticket.nombrecc+':',strtofloat(imp_cc));
        end;
        if imp_ch<>'0' then
        begin
        hasar.ImprimirPago('Cheque: ',strtofloat(imp_ch));
        end;
        if imp_os<>'0' then
        begin
        hasar.ImprimirPago(ticket.nombre_os ,strtofloat(imp_os));
        end;
        if imp_co1<>'0' then
        begin
        hasar.ImprimirPago(ticket.nombre_co1 ,strtofloat(imp_co1));
        end;
        if imp_co2<>'0' then
        begin
        hasar.ImprimirPago(ticket.nombre_cos2 ,strtofloat(imp_co2));
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
          FFACTURADOR.Gfacturador.DataSource.DataSet.First;
          while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
          begin

               hasar.ImprimirTextoNoFiscal((ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[1].FieldName).asstring)+' ('+(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[3].FieldName).asstring)+') '+
               (ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[2].FieldName).asstring));
               ffacturador.Gfacturador.DataSource.DataSet.Next;
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
          FFACTURADOR.Gfacturador.DataSource.DataSet.First;
          while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
          begin

               hasar.ImprimirTextoNoFiscal((ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[1].FieldName).asstring)+' ('+(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[3].FieldName).asstring)+') '+
               (ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[2].FieldName).asstring));
               ffacturador.Gfacturador.DataSource.DataSet.Next;
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
          FFACTURADOR.Gfacturador.DataSource.DataSet.First;
          while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
          begin
               if ffacturador.Gfacturador.Fields[17].AsSTRING='SI' then
               BEGIN
               hasar.ImprimirTextoNoFiscal(ffacturador.Gfacturador.Fields[1].AsSTRING);
               hasar.ImprimirTextoNoFiscal('Unidades Vale:'+ffacturador.Gfacturador.Fields[18].AsSTRING);
               END;
               ffacturador.Gfacturador.DataSource.DataSet.Next;
          end;
          hasar.ImprimirTextoNoFiscal('REF. CPBT. '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));

          hasar.CerrarComprobanteNoFiscal;

        END;

        hasar.finalizar;
   Imprimio:=true;

    end;
end;

procedure TFIMPRESION.ImprimirTicketB(var  Imprimio:boolean);
var
ESTADOFISCAL: string;
z: integer;
RESPONSABLEIVA: TiposDeResponsabilidades;
valoriva: double;
direccioncliente: olevariant;
descripcion: string;
descripcioncortada: string;
begin
   Hasar.PrecioBase:=False;
     if not (ComenzarFiscal) then
   Begin
      ShowMessage('No se pudo conectar al fiscal');
       imprimio:=false;
      exit;
   End;


   hasar.BorrarFantasiaEncabezadoCola(true,true,true);
   hasar.CancelarComprobanteFiscal;
   hasar.TratarDeCancelarTodo;

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
       IF Ticket.CONDICIONIVA = 'EXENTO' THEN
       begin
       hasar.DatosCliente(ticket.DESCRIPCIONCLIENTE, ticket.CUIT, TIPO_CUIT, RESPONSABLEIVA,' ');
       end;
       IF Ticket.CONDICIONIVA = 'CONSUMIDOR FINAL' THEN
       begin
       if ticket.dni='' then
       begin
         ticket.dni:='1';
       end;
       hasar.DatosCliente(ticket.DESCRIPCIONCLIENTE, ticket.DNI, TIPO_DNI, RESPONSABLEIVA,' ');
       end;
       IF Ticket.CONDICIONIVA = 'RESPONSABLE NO INSCRIPTO' THEN
       begin
       hasar.DatosCliente(ticket.DESCRIPCIONCLIENTE, ticket.CUIT, TIPO_CUIT, RESPONSABLEIVA,' ');
       end;
            IF Ticket.CONDICIONIVA = 'RESPONSABLE MONOTRIBUTO' THEN
       begin
       hasar.DatosCliente(ticket.DESCRIPCIONCLIENTE, ticket.CUIT, TIPO_CUIT, RESPONSABLEIVA,' ');
       end;

       Hasar.AbrirComprobanteFiscal(TICKET_FACTURA_B);
       ffacturador.Gfacturador.DataSource.DataSet.First;
        while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
          begin
                if not (ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[11].FieldName).asstring='0') then
                begin
                hasar.ImprimirTextofiscal(ticket.codigo_OS +': '+ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[14].FieldName).asstring+' ('+ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[11].FieldName).asstring+'%)');
                end;
                if not (ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[12].FieldName).asstring='0') then
                begin
                hasar.ImprimirTextofiscal(ticket.codigo_Co1+': '+ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[20].FieldName).asstring+' ('+ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[12].FieldName).asstring+'%)');
                end;
                 if ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[10].FieldName).asstring='B' then
                begin
                  valoriva:=21;
                end;
                if ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[10].FieldName).asstring='A' then
                begin
                  valoriva:=0;
                end;
                descripcion:=(FFacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[1].FieldName).asstring);

                if (ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[18].FieldName).asstring)<>'' then
                BEGIN
                descripcion:='('+(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[18].FieldName).asstring)+')'+descripcion;
                END;


                descripcioncortada:=copy(descripcion, 0, 20);



                HASAR.ImprimirItem(
               (descripcioncortada),
               (ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[3].FieldName).asfloat),
               ((ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[2].FieldName).asfloat)*ticket.coeficientetarjeta),
                valoriva, 0);


               ffacturador.Gfacturador.DataSource.DataSet.Next;
          end;
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
        if imp_efectivo<>'0' then
        begin
        hasar.ImprimirPago('Efectivo: ',strtofloat(imp_efectivo));
        end;
        if imp_tarjeta<>'0' then
        begin
        hasar.ImprimirPago('Tarjeta: ',strtofloat(imp_tarjeta));
        end;
        if imp_cc<>'0' then
        begin
        hasar.ImprimirPago('CC '+ticket.codigocc+' '+ticket.nombrecc+':',strtofloat(imp_cc));
        end;
        if imp_ch<>'0' then
        begin
        hasar.ImprimirPago('Cheque: ',strtofloat(imp_ch));
        end;
        if imp_os<>'0' then
        begin
        hasar.ImprimirPago(ticket.nombre_os ,strtofloat(imp_os));
        end;
        if imp_co1<>'0' then
        begin
        hasar.ImprimirPago(ticket.nombre_co1 ,strtofloat(imp_co1));
        end;
        if imp_co2<>'0' then
        begin
        hasar.ImprimirPago(ticket.nombre_cos2 ,strtofloat(imp_co2));
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
              hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(imp_os),-2));
              hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(strtofloat(imp_efectivo),-2));
              hasar.Encabezado[13]:='EF: '+floattostr(roundto(strtofloat(IMP_EFECTIVO),-2))+' CH: '+floattostr(roundto(strtofloat(imp_ch),-2))+' CC: '+floattostr(roundto(strtofloat(imp_cc),-2))+' TJ: '+floattostr(roundto(strtofloat(imp_TARJETA),-2));
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
              hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(imp_os),-2));
              hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(strtofloat(imp_efectivo),-2));
              hasar.Encabezado[13]:='EF: '+floattostr(roundto(strtofloat(IMP_EFECTIVO),-2))+' CH: '+floattostr(roundto(strtofloat(imp_ch),-2))+' CC: '+floattostr(roundto(strtofloat(imp_cc),-2))+' TJ: '+floattostr(roundto(strtofloat(imp_TARJETA),-2));
              HASAR.AbrirComprobanteNoFiscal;
              hasar.ImprimirTextoNoFiscal('DOCUMENTO NO FISCAL FARMACIAS');
              hasar.ImprimirTextoNoFiscal('NRO TICKET: '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
              hasar.ImprimirTextoNoFiscal('--------------------------------------------------');
              FFACTURADOR.Gfacturador.DataSource.DataSet.First;

              while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
              begin
                    descripcion:=(FFacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[1].FieldName).asstring);
                    descripcioncortada:=copy(descripcion, 0, 20);
                    HASAR.ImprimirTextoNoFiscal((descripcioncortada)+'('+(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[3].FieldName).asstring)+')  '+floattostr(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[2].FieldName).asfloat));
                    HASAR.ImprimirTextoNoFiscal(' ');
                    ffacturador.Gfacturador.DataSource.DataSet.Next;
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
                hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(imp_os),-2));
                hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(strtofloat(imp_efectivo),-2));
                hasar.Encabezado[13]:='EF: '+floattostr(roundto(strtofloat(IMP_EFECTIVO),-2))+' CH: '+floattostr(roundto(strtofloat(imp_ch),-2))+' CC: '+floattostr(roundto(strtofloat(imp_cc),-2))+' TJ: '+floattostr(roundto(strtofloat(imp_TARJETA),-2));
                HASAR.AbrirComprobanteNoFiscal;
                hasar.ImprimirTextoNoFiscal('DOCUMENTO NO FISCAL FARMACIAS');
                hasar.ImprimirTextoNoFiscal('NRO TICKET: '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
                hasar.ImprimirTextoNoFiscal('------------------------------------------');
                FFACTURADOR.Gfacturador.DataSource.DataSet.First;

                while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
                begin
                      descripcion:=(FFacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[1].FieldName).asstring);
                      descripcioncortada:=copy(descripcion, 0, 20);
                      HASAR.ImprimirTextoNoFiscal((descripcioncortada)+'('+(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[3].FieldName).asstring)+')  '+floattostr(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[2].FieldName).asfloat));
                      HASAR.ImprimirTextoNoFiscal(' ');
                      ffacturador.Gfacturador.DataSource.DataSet.Next;
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
          hasar.Encabezado[2]:='Obra Social: '+ticket.nombre_os;
          hasar.Encabezado[3]:='Coseguro 1: '+ticket.nombre_co1;
          hasar.Encabezado[4]:='Coseguro 2: '+ticket.nombre_cos2;
          hasar.Encabezado[9]:='Numero de ref: '+ticket.valnroreferencia;
          hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(imp_os),-2));
          hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(strtofloat(imp_efectivo),-2));
          hasar.Encabezado[13]:='EF: '+floattostr(roundto(strtofloat(IMP_EFECTIVO),-2))+' CH: '+floattostr(roundto(strtofloat(imp_ch),-2))+' CC: '+floattostr(roundto(strtofloat(imp_cc),-2))+' TJ: '+floattostr(roundto(strtofloat(imp_TARJETA),-2));
          HASAR.AbrirComprobanteNoFiscal;
          hasar.ImprimirTextoNoFiscal('VALE A RETIRAR');
          hasar.ImprimirTextoNoFiscal('Emision VR'+ticket.fiscla_pv+': '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
          hasar.ImprimirTextoNoFiscal('Productos:');
          FFACTURADOR.Gfacturador.DataSource.DataSet.First;
          while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
          begin
               if ffacturador.Gfacturador.Fields[17].AsSTRING='SI' then
               BEGIN
               hasar.ImprimirTextoNoFiscal(ffacturador.Gfacturador.Fields[1].AsSTRING);
               hasar.ImprimirTextoNoFiscal('Unidades Vale:'+ffacturador.Gfacturador.Fields[18].AsSTRING);
               END;
               ffacturador.Gfacturador.DataSource.DataSet.Next;
          end;
          hasar.ImprimirTextoNoFiscal('REF. CPBT. '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));

          hasar.CerrarComprobanteNoFiscal;

        END;

        hasar.finalizar;
     imprimio:=true;
    end;

end;

procedure TFIMPRESION.ImprimirTicketT;
var
ESTADOFISCAL: string;
z: integer;
RESPONSABLEIVA: TiposDeResponsabilidades;
valoriva: double;
direccioncliente: olevariant;
descripcioncortada: string;
descripcion: string;
efectivoredondeado: double;
begin
   if not (ComenzarFiscal) then
   Begin
      ShowMessage('No se pudo conectar al fiscal');
      imprimio:=false;
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
       ffacturador.Gfacturador.DataSource.DataSet.First;
        while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
          begin
                if not (ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[11].FieldName).asstring='0') then
                begin
                hasar.ImprimirTextofiscal(ticket.codigo_OS +': '+ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[14].FieldName).asstring+' ('+ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[11].FieldName).asstring+'%)');
                end;
                if not (ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[12].FieldName).asstring='0') then
                begin
                hasar.ImprimirTextofiscal(ticket.codigo_Co1+': '+ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[20].FieldName).asstring+' ('+ffacturador.Gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[12].FieldName).asstring+'%)');
                end;
                 if ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[10].FieldName).asstring='B' then
                begin
                  valoriva:=21;
                end;
                if ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[10].FieldName).asstring='A' then
                begin
                  valoriva:=0;
                end;
                descripcion:=(FFacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[1].FieldName).asstring);

                if (ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[18].FieldName).asstring)<>'' then
                BEGIN
                descripcion:='('+(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[18].FieldName).asstring)+')'+descripcion;
                END;



                descripcioncortada:=copy(descripcion, 0, 20);
                HASAR.ImprimirItem(
               (descripcioncortada),
               (ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[3].FieldName).asfloat),
               ((ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[2].FieldName).asfloat)*ticket.coeficientetarjeta),
                valoriva, 0);


               ffacturador.Gfacturador.DataSource.DataSet.Next;
          end;

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


        if imp_efectivo<>'0' then
        begin
        hasar.ImprimirPago('Efectivo: ',strtofloat(imp_efectivo));
        end;

        if imp_tarjeta<>'0' then
        begin
        hasar.ImprimirPago('Tarjeta: ',strtofloat(imp_tarjeta));
        end;
        if imp_cc<>'0' then
        begin
        hasar.ImprimirPago('CC '+ticket.codigocc+' '+ticket.nombrecc+':',strtofloat(imp_cc));
        end;
        if imp_ch<>'0' then
        begin
        hasar.ImprimirPago('Cheque: ',strtofloat(imp_ch));
        end;
        if imp_os<>'0' then
        begin
        hasar.ImprimirPago(ticket.nombre_os ,strtofloat(imp_os));
        end;
        if imp_co1<>'0' then
        begin
        hasar.ImprimirPago(ticket.nombre_co1 ,strtofloat(imp_co1));
        end;
        if imp_co2<>'0' then
        begin
        hasar.ImprimirPago(ticket.nombre_cos2 ,strtofloat(imp_co2));
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


        if ticket.p441f='N' then
        BEGIN

            if (ticket.codigo_OS<>'') or (ticket.codigo_Co1<>'') then
            begin

              hasar.Encabezado[1]:='Vendedor: '+ticket.nom_vendedor;
              hasar.Encabezado[2]:='Obra Social: '+ticket.codigo_OS+'-'+ticket.nombre_os;
              hasar.Encabezado[3]:='Coseguro 1: '+ticket.codigo_Co1+'-'+ticket.nombre_co1;
              hasar.Encabezado[4]:='Afiliado: '+ticket.afiliado_nombre+' '+ticket.afiliado_apellido;
              hasar.Encabezado[5]:='Nro afiliado: '+ticket.afiliado_numero;
              hasar.Encabezado[6]:='Mat. Med: '+ticket.medico_nro_matricula;
              hasar.Encabezado[7]:='Receta: '+ticket.numero_receta;
              hasar.Encabezado[8]:='    Numero de ref: '+ticket.valnroreferencia;
              hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(imp_os),-2));
              hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(strtofloat(imp_efectivo),-2));
              hasar.Encabezado[13]:='EF: '+floattostr(roundto(strtofloat(IMP_EFECTIVO),-2))+' CH: '+floattostr(roundto(strtofloat(imp_ch),-2))+' CC: '+floattostr(roundto(strtofloat(imp_cc),-2))+' TJ: '+floattostr(roundto(strtofloat(imp_TARJETA),-2));



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
              hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(imp_os),-2));
              hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(strtofloat(imp_efectivo),-2));
              hasar.Encabezado[13]:='EF: '+floattostr(roundto(strtofloat(IMP_EFECTIVO),-2))+' CH: '+floattostr(roundto(strtofloat(imp_ch),-2))+' CC: '+floattostr(roundto(strtofloat(imp_cc),-2))+' TJ: '+floattostr(roundto(strtofloat(imp_TARJETA),-2));
              HASAR.AbrirComprobanteNoFiscal;
              hasar.ImprimirTextoNoFiscal('DOCUMENTO NO FISCAL FARMACIAS');
              hasar.ImprimirTextoNoFiscal('NRO TICKET: '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
              hasar.ImprimirTextoNoFiscal('--------------------------------------------------');
              FFACTURADOR.Gfacturador.DataSource.DataSet.First;

              while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
              begin
                    descripcion:=(FFacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[1].FieldName).asstring);
                    descripcioncortada:=copy(descripcion, 0, 20);
                    HASAR.ImprimirTextoNoFiscal((descripcioncortada)+'('+(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[3].FieldName).asstring)+')  '+floattostr(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[2].FieldName).asfloat));
                    HASAR.ImprimirTextoNoFiscal(' ');
                    ffacturador.Gfacturador.DataSource.DataSet.Next;
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
                hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(imp_os),-2));
                hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(strtofloat(imp_efectivo),-2));
                hasar.Encabezado[13]:='EF: '+floattostr(roundto(strtofloat(IMP_EFECTIVO),-2))+' CH: '+floattostr(roundto(strtofloat(imp_ch),-2))+' CC: '+floattostr(roundto(strtofloat(imp_cc),-2))+' TJ: '+floattostr(roundto(strtofloat(imp_TARJETA),-2));
                HASAR.AbrirComprobanteNoFiscal;
                hasar.ImprimirTextoNoFiscal('DOCUMENTO NO FISCAL FARMACIAS');
                hasar.ImprimirTextoNoFiscal('NRO TICKET: '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
                hasar.ImprimirTextoNoFiscal('------------------------------------------');
                FFACTURADOR.Gfacturador.DataSource.DataSet.First;

                while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
                begin
                      descripcion:=(FFacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[1].FieldName).asstring);
                      descripcioncortada:=copy(descripcion, 0, 20);
                      HASAR.ImprimirTextoNoFiscal((descripcioncortada)+'('+(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[3].FieldName).asstring)+')  '+floattostr(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[2].FieldName).asfloat));
                      HASAR.ImprimirTextoNoFiscal(' ');
                      ffacturador.Gfacturador.DataSource.DataSet.Next;
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
          hasar.Encabezado[2]:='Obra Social: '+ticket.nombre_os;
          hasar.Encabezado[3]:='Coseguro 1: '+ticket.nombre_co1;
          hasar.Encabezado[4]:='Coseguro 2: '+ticket.nombre_cos2;
          hasar.Encabezado[9]:='Numero de ref: '+ticket.valnroreferencia;
          hasar.Encabezado[11]:='REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(imp_os),-2));
          hasar.Encabezado[12]:='CO1: '+imp_co1+' CO2: '+imp_co2+' AFI: '+floattostr(roundto(strtofloat(imp_efectivo),-2));
          hasar.Encabezado[13]:='EF: '+floattostr(roundto(strtofloat(IMP_EFECTIVO),-2))+' CH: '+floattostr(roundto(strtofloat(imp_ch),-2))+' CC: '+floattostr(roundto(strtofloat(imp_cc),-2))+' TJ: '+floattostr(roundto(strtofloat(imp_TARJETA),-2));
          HASAR.AbrirComprobanteNoFiscal;
          hasar.ImprimirTextoNoFiscal('VALE A RETIRAR');
          hasar.ImprimirTextoNoFiscal('Emision VR'+ticket.fiscla_pv+': '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));
          hasar.ImprimirTextoNoFiscal('Productos:');
          FFACTURADOR.Gfacturador.DataSource.DataSet.First;

          while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
          begin
               if ffacturador.Gfacturador.Fields[17].AsSTRING='SI' then
               BEGIN
               hasar.ImprimirTextoNoFiscal(ffacturador.Gfacturador.Fields[1].AsSTRING);
               hasar.ImprimirTextoNoFiscal('Unidades Vale:'+ffacturador.Gfacturador.Fields[18].AsSTRING);
               END;
               ffacturador.Gfacturador.DataSource.DataSet.Next;
          end;
          hasar.ImprimirTextoNoFiscal('REF. CPBT. '+ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8)));

          hasar.CerrarComprobanteNoFiscal;

        END;


 { mimpresion.Lines.add('***COMPROBANTE FISCAL HOMOLOGADO***');
  mimpresion.Lines.add('');
  mimpresion.Lines.add('');
  mimpresion.Lines.Add('N°:'+  (rightpad(inttostr(nro_comprob), '0', 8)));
  mimpresion.Lines.add('');
  mimpresion.Lines.add('');
  ffacturador.Gfacturador.DataSource.DataSet.First;
      while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
      begin
      mimpresion.Lines.add('('+(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[3].FieldName).asstring)+')'+' x '+(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[2].FieldName).asstring));
      mimpresion.Lines.add((ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[1].FieldName).asstring)+'     '+(ffacturador.gfacturador.DataSource.DataSet.FieldByName(ffacturador.Gfacturador.Columns[6].FieldName).asstring));
      ffacturador.Gfacturador.DataSource.DataSet.Next;
      mimpresion.Lines.add('');
      end;

  mimpresion.Lines.add('cod os: '+ticket.codigo_OS);
  mimpresion.Lines.add('cod co1: '+ticket.codigo_Co1);
  mimpresion.Lines.add('cod co2: '+ticket.codigo_Cos2);
  mimpresion.Lines.add('');
  mimpresion.Lines.add('');
  mimpresion.Lines.add('');
  mimpresion.Lines.add('***COMPROBANTE FISCAL HOMOLOGADO***');  }
  imprimio:=true;
  end;
end;

procedure Tfimpresion.Insertarcomprobante;
var
i: integer;
iva: double;
 condIva:String;
 //importeTotal
  baseImponible, importeIva, unaTasa:Double;
 unaTasaIVA:TTasaIVA;
 form: tfprogreso;

begin
  form:=tfprogreso.Create(self);
  form.Show;
  application.ProcessMessages;

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
                                                         ' 0,                             ',
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
                                                         ' :CODAUTORIZACION, ',
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
        dmfacturador.icomprobante.ParamByName('COD_CLIENTE').AsString:=ticket.codigocliente;
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
        dmfacturador.icomprobante.ParamByName('IMP_NETO').AsFloat:=ticket.importeneto;
        dmfacturador.icomprobante.ParamByName('IMP_BRUTO').AsFloat:=ticket.importebruto;
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
        dmfacturador.icomprobante.ParamByName('CODAUTORIZACION').AsString:=ticket.valnroreferencia;
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
                                                        '0,                                              ',
                                                        '''N'',                                          ',
                                                        'NULL,                                           ',
                                                        '0,                                              ',
                                                        'NULL,                                           ',
                                                        'NULL,                                           ',
                                                        ''''');');


i:=0;

ffacturador.Gfacturador.DataSource.DataSet.first;
while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
    begin
    i:=i+1;
     dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').asstring:=TICKET.comprobante;
     dmfacturador.icomprobante.ParamByName('nro_sucursal').asstring:=ticket.sucursal;
     dmfacturador.icomprobante.parambyname('nro_comprobante').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
     dmfacturador.icomprobante.ParamByName('nro_item').Asinteger:=i;
     dmfacturador.icomprobante.parambyname('cod_alfabeta').Asinteger:=ffacturador.Gfacturador.Fields[8].AsInteger;
     dmfacturador.icomprobante.parambyname('nom_producto').asstring:=ffacturador.Gfacturador.Fields[1].AsString;
     dmfacturador.icomprobante.parambyname('cantidad').asinteger:=ffacturador.Gfacturador.Fields[3].Asinteger;
     dmfacturador.icomprobante.parambyname('imp_unitario').asfloat:=ffacturador.Gfacturador.Fields[2].asfloat;

     //----------cuando tiene obra social o coseguro cambia el campo del iva--------------------///
  if not ((ticket.codigo_OS<>'') or (ticket.codigo_Co1<>'') or (ticket.codigo_Cos2<>''))  then
  begin
    if ffacturador.Gfacturador.fields[10].AsString='B' then
    begin
    iva:=1.21;
     dmfacturador.icomprobante.parambyname('imp_ivaneto').AsFloat:=ffacturador.Gfacturador.Fields[6].asfloat-(ffacturador.Gfacturador.Fields[6].asfloat/iva);
     dmfacturador.icomprobante.parambyname('imp_ivadesc').AsFloat:=0;
    end;
    if ffacturador.Gfacturador.fields[10].AsString<>'B' then
    begin
    iva:=0;
     dmfacturador.icomprobante.parambyname('imp_ivaneto').AsFloat:=ffacturador.Gfacturador.Fields[6].asfloat*iva;
     dmfacturador.icomprobante.parambyname('imp_ivadesc').AsFloat:=0;
    end;

  end;


    if (ticket.codigo_OS<>'') or (ticket.codigo_Co1<>'') or (ticket.codigo_Cos2<>'')  then
  begin
    if ffacturador.Gfacturador.fields[10].AsString='B' then
    begin
    iva:=1.21;
     dmfacturador.icomprobante.parambyname('imp_ivadesc').AsFloat:=ffacturador.Gfacturador.Fields[6].asfloat-(ffacturador.Gfacturador.Fields[6].asfloat/iva);
     dmfacturador.icomprobante.parambyname('imp_ivaneto').AsFloat:=0;
    end;
    if ffacturador.Gfacturador.fields[10].AsString<>'B' then
    begin
    iva:=0;
     dmfacturador.icomprobante.parambyname('imp_ivadesc').AsFloat:=ffacturador.Gfacturador.Fields[6].asfloat*iva;
     dmfacturador.icomprobante.parambyname('imp_ivaneto').AsFloat:=0;
    end;
//----------cuando tiene obra social o coseguro cambia el campo del iva--------------------///
  end;
    dmfacturador.icomprobante.parambyname('imp_ivatasa').AsFloat:=0;
    dmfacturador.icomprobante.parambyname('imp_prodneto').AsFloat:=ffacturador.Gfacturador.Fields[6].asfloat-ffacturador.Gfacturador.Fields[4].asfloat;
    dmfacturador.icomprobante.Open;
    dmFacturador.ticomprobante.Commit;
    ffacturador.Gfacturador.DataSource.DataSet.Next;
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
  if condIVA ='A' then unaTasa:=0
  else if condIVA='B' then unaTasa:=21
  else if condIVA='D' then unaTasa:=27
  else if condIVA='E' then unaTasa:=0
  else if condIVA='s' then unaTasa:=10.5;


  //Si es S poner el monto sobretrasa sino 0
  iva:=unaTasa/100;
  baseImponible:=unaTasaIVA.importeTotal /(1+iva);
  importeIVA:=baseImponible*iva;

  dmfacturador.icomprobante.parambyname('por_sobretasa').asstring:='0';
  dmfacturador.icomprobante.parambyname('por_porcentaje').AsFloat:=unaTasa;


  dmfacturador.icomprobante.parambyname('imp_netograv').asfloat:=unaTasaIVA.netogravado;
  dmfacturador.icomprobante.parambyname('imp_netograv_desc').AsFloat:=unaTasaIVA.netogravadodesc;


  dmfacturador.icomprobante.parambyname('imp_iva').asfloat:= unaTasaIVA.netogravado*iva;

  dmfacturador.icomprobante.parambyname('imp_iva_desc').AsFloat:=unaTasaIVA.netogravadodesc*iva;

  dmfacturador.icomprobante.parambyname('imp_ivasobretasa').AsFloat:=0;
  dmfacturador.icomprobante.Open;
  dmfacturador.ticomprobante.Commit;
  End;




 //INSERTAR VTTBPAGOCHEQUE          --VR LLEVA TODOS LOS MEDIOS DE PAGO

if strtofloat(imp_CH)<>0 then
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
    dmfacturador.icomprobante.ParamByName('importe_cheque').AsFloat:=strtofloat(imp_ch);
    dmfacturador.icomprobante.Open;
    dmfacturador.ticomprobante.Commit;

end;

//INSTERTAR VTTPAGOCTACTE

if strtofloat(imp_CC)<>0 then
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
        dmfacturador.icomprobante.ParamByName('imp_ctacte').AsFloat:=strtofloat(imp_cc);
        dmfacturador.icomprobante.ParamByName('imp_sctacte').AsFloat:=strtofloat(imp_cc);
        dmfacturador.icomprobante.Open;
        dmfacturador.ticomprobante.Commit;

end;

//INSERTAR VTTPAGOEFECTIVO

 if strtofloat(imp_efectivo)<>0 then
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
        dmfacturador.icomprobante.ParamByName('imp_EFECTIVO').AsFloat:=strtofloat(imp_efectivo);
        dmfacturador.icomprobante.Open;
        dmfacturador.ticomprobante.Commit;

        end;





 //INSERTAR VTTBPAGOTARJETA


 if strtofloat(imp_tarjeta)<>0 then
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
        dmfacturador.icomprobante.ParamByName('imp_tarjeta').AsFloat:=strtofloat(imp_tarjeta);
        dmfacturador.icomprobante.Open;
        dmfacturador.ticomprobante.Commit;

        end;




 //INSERTAR VTMADESCCOMPROB     ------VR LLEVA PERO SIN IMPORTES


 if TICKET.codigo_OS<>'' THEN
 begin
        i:=0;

        ffacturador.Gfacturador.DataSource.DataSet.first;
        while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
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
          dmfacturador.icomprobante.ParamByName('POR_DESCUENTO').AsFloat:=ffacturador.Gfacturador.Fields[11].AsInteger;
          dmfacturador.icomprobante.ParamByName('IMP_DESCUENTO').AsFloat:=((ffacturador.Gfacturador.Fields[11].AsInteger)*(ffacturador.Gfacturador.Fields[6].Asfloat))/100;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          ffacturador.Gfacturador.DataSource.DataSet.Next;
          end;
 end;

  if TICKET.codigo_Co1<>'' THEN
 begin
        i:=0;

        ffacturador.Gfacturador.DataSource.DataSet.first;
        while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
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
          dmfacturador.icomprobante.ParamByName('POR_DESCUENTO').AsFloat:=ffacturador.Gfacturador.Fields[12].AsInteger;
          dmfacturador.icomprobante.ParamByName('IMP_DESCUENTO').AsFloat:=((ffacturador.Gfacturador.Fields[12].AsInteger)*(ffacturador.Gfacturador.Fields[6].Asfloat))/100;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          ffacturador.Gfacturador.DataSource.DataSet.Next;
          end;
 end;
 if TICKET.codigo_Cos2<>'' THEN
 begin
        i:=0;

        ffacturador.Gfacturador.DataSource.DataSet.first;
         while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
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
          dmfacturador.icomprobante.ParamByName('POR_DESCUENTO').AsFloat:=ffacturador.Gfacturador.Fields[13].AsInteger;
          dmfacturador.icomprobante.ParamByName('IMP_DESCUENTO').AsFloat:=((ffacturador.Gfacturador.Fields[13].AsInteger)*(ffacturador.Gfacturador.Fields[6].Asfloat))/100;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          ffacturador.Gfacturador.DataSource.DataSet.Next;
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
          dmfacturador.icomprobante.ParamByName('imp_abonaos').Ascurrency:=roundto(strtofloat(formatfloat('0.00',(ffacturador.descuentoos.field.value))),-2);
          dmfacturador.icomprobante.ParamByName('imp_totalfec').Ascurrency:=roundto(strtofloat(formatfloat('0.00',(ffacturador.importetotal.Field.Value))),-2);
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
          dmfacturador.icomprobante.ParamByName('imp_abonaos').Ascurrency:=roundto(strtofloat(formatfloat('0.00',(ffacturador.descuentoco1.field.value))),-2);
          dmfacturador.icomprobante.ParamByName('imp_totalfec').Ascurrency:=roundto(strtofloat(formatfloat('0.00',(ffacturador.descuentoco1.field.value))),-2);
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
          dmfacturador.icomprobante.ParamByName('imp_abonaos').Ascurrency:=roundto(strtofloat(formatfloat('0.00',(ffacturador.descuentoco2.field.value))),-2);
          dmfacturador.icomprobante.ParamByName('imp_totalfec').Ascurrency:=roundto(strtofloat(formatfloat('0.00',(ffacturador.descuentoco2.field.value))),-2);
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
          dmfacturador.icomprobante.ParamByName('nom_afiliado').asstring:=ticket.afiliado_nombre+' '+ticket.afiliado_apellido;
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
ffacturador.Gfacturador.DataSource.DataSet.first;
while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
    begin
          i:=i+1;
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_os;
          dmfacturador.icomprobante.ParamByName('nro_SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('nro_item').Asinteger:=i;
          dmfacturador.icomprobante.ParamByName('cod_alfabeta').Asinteger:=ffacturador.Gfacturador.Fields[8].AsInteger;
          dmfacturador.icomprobante.ParamByName('cod_laboratorio').AsString:=ffacturador.Gfacturador.Fields[15].Asstring;
          dmfacturador.icomprobante.ParamByName('nom_largo').AsString:=ffacturador.Gfacturador.Fields[1].Asstring;//
          dmfacturador.icomprobante.ParamByName('can_vendida').AsString:=ffacturador.Gfacturador.Fields[3].Asstring;
          dmfacturador.icomprobante.ParamByName('imp_unitario').Asfloat:=ffacturador.Gfacturador.Fields[2].Asfloat;
          dmfacturador.icomprobante.ParamByName('por_descuento').Asinteger:=ffacturador.Gfacturador.Fields[11].Asinteger;
          dmfacturador.icomprobante.ParamByName('imp_descuento').Asfloat:=(ffacturador.Gfacturador.Fields[2].Asfloat*ffacturador.Gfacturador.Fields[11].Asfloat)/100;
          dmfacturador.icomprobante.ParamByName('nro_troquel').Asinteger:=ffacturador.Gfacturador.Fields[0].Asinteger;
          dmfacturador.icomprobante.ParamByName('cod_validacion').AsString:=ticket.valnroreferencia;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          ffacturador.Gfacturador.DataSource.DataSet.Next;
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
ffacturador.Gfacturador.DataSource.DataSet.first;
while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
    begin
          i:=i+1;
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_co1;
          dmfacturador.icomprobante.ParamByName('nro_SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('nro_item').Asinteger:=i;
          dmfacturador.icomprobante.ParamByName('cod_alfabeta').Asinteger:=ffacturador.Gfacturador.Fields[8].AsInteger;
          dmfacturador.icomprobante.ParamByName('cod_laboratorio').AsString:=ffacturador.Gfacturador.Fields[15].Asstring;
          dmfacturador.icomprobante.ParamByName('nom_largo').AsString:=ffacturador.Gfacturador.Fields[1].Asstring;//
          dmfacturador.icomprobante.ParamByName('can_vendida').AsString:=ffacturador.Gfacturador.Fields[3].Asstring;
          dmfacturador.icomprobante.ParamByName('imp_unitario').Asfloat:=ffacturador.Gfacturador.Fields[2].Asfloat;
          dmfacturador.icomprobante.ParamByName('por_descuento').Asinteger:=ffacturador.Gfacturador.Fields[12].Asinteger;
          dmfacturador.icomprobante.ParamByName('imp_descuento').Asfloat:=(ffacturador.Gfacturador.Fields[2].Asfloat*ffacturador.Gfacturador.Fields[12].Asfloat)/100;
          dmfacturador.icomprobante.ParamByName('nro_troquel').Asinteger:=ffacturador.Gfacturador.Fields[0].Asinteger;
          dmfacturador.icomprobante.ParamByName('cod_validacion').AsString:=ticket.valnroreferencia;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          ffacturador.Gfacturador.DataSource.DataSet.Next;
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
ffacturador.Gfacturador.DataSource.DataSet.first;
while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
    begin
          i:=i+1;
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_cos2;
          dmfacturador.icomprobante.ParamByName('nro_SUCURSAL').AsString:=ticket.sucursal;
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=TICKET.comprobante;
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('nro_item').Asinteger:=i;
          dmfacturador.icomprobante.ParamByName('cod_alfabeta').Asinteger:=ffacturador.Gfacturador.Fields[8].AsInteger;
          dmfacturador.icomprobante.ParamByName('cod_laboratorio').AsString:=ffacturador.Gfacturador.Fields[15].Asstring;
          dmfacturador.icomprobante.ParamByName('nom_largo').AsString:=ffacturador.Gfacturador.Fields[1].Asstring;//
          dmfacturador.icomprobante.ParamByName('can_vendida').AsString:=ffacturador.Gfacturador.Fields[3].Asstring;
          dmfacturador.icomprobante.ParamByName('imp_unitario').Asfloat:=ffacturador.Gfacturador.Fields[2].Asfloat;
          dmfacturador.icomprobante.ParamByName('por_descuento').Asinteger:=ffacturador.Gfacturador.Fields[13].Asinteger;
          dmfacturador.icomprobante.ParamByName('imp_descuento').Asfloat:=(ffacturador.Gfacturador.Fields[2].Asfloat*ffacturador.Gfacturador.Fields[13].Asfloat)/100;
          dmfacturador.icomprobante.ParamByName('nro_troquel').Asinteger:=ffacturador.Gfacturador.Fields[0].Asinteger;
          dmfacturador.icomprobante.ParamByName('cod_validacion').AsString:=ticket.valnroreferencia;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          ffacturador.Gfacturador.DataSource.DataSet.Next;
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

ffacturador.Gfacturador.DataSource.DataSet.first;
while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
    begin
    dmfacturador.icomprobante.ParamByName('cod_alfabeta').asinteger:=ffacturador.Gfacturador.Fields[8].AsInteger;
    dmfacturador.icomprobante.ParamByName('can_stk').asinteger:=ffacturador.Gfacturador.Fields[16].AsInteger-ffacturador.Gfacturador.Fields[3].AsInteger;;
    dmfacturador.icomprobante.parambyname('nro_sucursal').asstring:=ticket.sucursal;
    dmfacturador.icomprobante.Open;
    dmfacturador.ticomprobante.Commit;
    ffacturador.Gfacturador.DataSource.DataSet.Next;
    end;


 form.Close;
 inserciontk:='ok';
end;

// ticket.estadoticket:=1;


 procedure Tfimpresion.SetTicket(unTicket: TTicket);
begin
  ticket:=unTicket;
end;



procedure TFIMPRESION.UMActivated(var Message: TMessage);
begin
 ModalResult := mrCancel;
end;


//--------------------------insercion del vale cuando lo tiene----------------------------------//
procedure Tfimpresion.Insertarcomprobantevale;
var
i: integer;
iva: double;
 condIva:String;
 //importeTotal,
 unaTasaIVA:TTasaIVA;
  baseImponible, importeIva, unaTasa:Double;

begin


 //INSERTAR VTMACOMPROBANTE

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
                                                         ' 0,                             ',
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
                                                         ' :CODAUTORIZACION, ',
                                                         ' NULL, ',
                                                         ' NULL)');



        dmfacturador.icomprobante.ParamByName('SUCURSAL').AsString:=ticket.sucursal;
        dmfacturador.icomprobante.ParamByName('TKCOMPROBANTE').ASSTRING:='VR'+dmFacturador.getPuntoVenta();
        dmfacturador.icomprobante.ParamByName('NROCOMPROBANTE').ASSTRING:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
        if TICKET.nro_caja='999' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('CAJA').ASSTRING:='';
        END;
        if TICKET.nro_caja<>'999' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('CAJA').ASSTRING:=TICKET.nro_caja;
        END;
        dmfacturador.icomprobante.ParamByName('VENDEDOR').ASSTRING:=ticket.cod_vendedor;
        dmfacturador.icomprobante.ParamByName('TRANSACCION').AsString:=inttostr(nro_comprob);
        dmfacturador.icomprobante.ParamByName('COD_CLIENTE').AsString:=ticket.codigocliente;
        dmfacturador.icomprobante.ParamByName('nom_cliente').AsString:=ticket.DESCRIPCIONCLIENTE;
        dmfacturador.icomprobante.ParamByName('fec_comprobante').AsDatetime:=ticket.fechafiscal;
        dmfacturador.icomprobante.ParamByName('fec_receta').Asdate:=ticket.fecha_receta;
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
        dmfacturador.icomprobante.ParamByName('IMP_NETO').AsFloat:=0;
        dmfacturador.icomprobante.ParamByName('IMP_BRUTO').AsFloat:=0;
         if TICKET.nro_caja='999' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('PASOXCAJA').ASSTRING:='N';
        END;
        if TICKET.nro_caja<>'999' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('PASOXCAJA').ASSTRING:='S';
        END;

        dmfacturador.icomprobante.ParamByName('SALDOCC').ASFLOAT:=0;
        dmfacturador.icomprobante.ParamByName('FEC_REF').ASdate:=TICKEt.fechacaja;
        if TICKET.nro_caja='999' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('FEC_OPERATIVA').asstring:='';
        END;
        if TICKET.nro_caja<>'999' then
        BEGIN
        dmfacturador.icomprobante.ParamByName('FEC_OPERATIVA').AsDate:=ticket.fec_operativa;
        END;
        dmfacturador.icomprobante.ParamByName('CODAUTORIZACION').AsString:=ticket.valnroreferencia;
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
                                                        '0,                                              ',
                                                        '''N'',                                          ',
                                                        'NULL,                                           ',
                                                        '0,                                              ',
                                                        'NULL,                                           ',
                                                        'NULL,                                           ',
                                                        ''''');');


i:=0;

ffacturador.Gfacturador.DataSource.DataSet.first;
while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
    begin
    i:=i+1;
     dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').asstring:='VR'+dmFacturador.getPuntoVenta();
     dmfacturador.icomprobante.ParamByName('nro_sucursal').asstring:=ticket.sucursal;
     dmfacturador.icomprobante.parambyname('nro_comprobante').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
     dmfacturador.icomprobante.ParamByName('nro_item').Asinteger:=i;
     dmfacturador.icomprobante.parambyname('cod_alfabeta').Asinteger:=ffacturador.Gfacturador.Fields[8].AsInteger;
     dmfacturador.icomprobante.parambyname('nom_producto').asstring:=ffacturador.Gfacturador.Fields[1].AsString;
     dmfacturador.icomprobante.parambyname('cantidad').asinteger:=ffacturador.Gfacturador.Fields[3].Asinteger;
     dmfacturador.icomprobante.parambyname('imp_unitario').asfloat:=0;

     //----------cuando tiene obra social o coseguro cambia el campo del iva--------------------///
  if not ((ticket.codigo_OS<>'') or (ticket.codigo_Co1<>'') or (ticket.codigo_Cos2<>''))  then
  begin
    if ffacturador.Gfacturador.fields[10].AsString='B' then
    begin
    iva:=1.21;
     dmfacturador.icomprobante.parambyname('imp_ivaneto').AsFloat:=0;
     dmfacturador.icomprobante.parambyname('imp_ivadesc').AsFloat:=0;
    end;
    if ffacturador.Gfacturador.fields[10].AsString<>'B' then
    begin
    iva:=0;
     dmfacturador.icomprobante.parambyname('imp_ivaneto').AsFloat:=0;
     dmfacturador.icomprobante.parambyname('imp_ivadesc').AsFloat:=0;
    end;

  end;


    if (ticket.codigo_OS<>'') or (ticket.codigo_Co1<>'') or (ticket.codigo_Cos2<>'')  then
  begin
    if ffacturador.Gfacturador.fields[10].AsString='B' then
    begin
    iva:=1.21;
     dmfacturador.icomprobante.parambyname('imp_ivadesc').AsFloat:=0;
     dmfacturador.icomprobante.parambyname('imp_ivaneto').AsFloat:=0;
    end;
    if ffacturador.Gfacturador.fields[10].AsString<>'B' then
    begin
    iva:=0;
     dmfacturador.icomprobante.parambyname('imp_ivadesc').AsFloat:=0;
     dmfacturador.icomprobante.parambyname('imp_ivaneto').AsFloat:=0;
    end;
//----------cuando tiene obra social o coseguro cambia el campo del iva--------------------///
  end;
    dmfacturador.icomprobante.parambyname('imp_ivatasa').AsFloat:=0;
    dmfacturador.icomprobante.parambyname('imp_prodneto').AsFloat:=0;
    dmfacturador.icomprobante.Open;
    dmFacturador.ticomprobante.Commit;
    ffacturador.Gfacturador.DataSource.DataSet.Next;
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
  dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').asstring:='VR'+dmFacturador.getPuntoVenta();
  dmfacturador.icomprobante.ParamByName('nro_sucursal').asstring:=ticket.sucursal;
  dmfacturador.icomprobante.parambyname('nro_comprobante').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
  dmfacturador.icomprobante.ParamByName('nro_item').Asinteger:=i;

  //Obtener la tasa de iva de la tabla PRMAIVA con la condicion condIVA
  if condIVA ='A' then unaTasa:=0
  else if condIVA=  'B' then unaTasa:=21
  else if condIVA='D' then unaTasa:=27
  else if condIVA=  'E' then unaTasa:=0
  else if condIVA=  's' then unaTasa:=10.5;


  //Si es S poner el monto sobretrasa sino 0
  iva:=unaTasa/100;
  baseImponible:=unaTasaIVA.importeTotal/(1+iva);
  importeIVA:=baseImponible*iva;

  dmfacturador.icomprobante.parambyname('por_sobretasa').asstring:='0';
  dmfacturador.icomprobante.parambyname('por_porcentaje').AsFloat:=0;

  if not ((ticket.codigo_OS<>'') or (ticket.codigo_Co1<>'') or (ticket.codigo_Cos2<>''))  then
  Begin
    //NO TENGO OBRA SOCIAL
    dmfacturador.icomprobante.parambyname('imp_netograv').asfloat:=0;
    dmfacturador.icomprobante.parambyname('imp_netograv_desc').AsFloat:=0;
    dmfacturador.icomprobante.parambyname('imp_iva').asfloat:=0;
    dmfacturador.icomprobante.parambyname('imp_iva_desc').AsFloat:=0;
  End
  else
  begin //TIENE OBRA SOCIAL
      dmfacturador.icomprobante.parambyname('imp_netograv_desc').asfloat:=0;
      dmfacturador.icomprobante.parambyname('imp_netograv').AsFloat:=0;
      dmfacturador.icomprobante.parambyname('imp_iva_desc').asfloat:=0;
      dmfacturador.icomprobante.parambyname('imp_iva').AsFloat:=0;
  end;
  dmfacturador.icomprobante.parambyname('imp_ivasobretasa').AsFloat:=0;
  dmfacturador.icomprobante.Open;
  dmfacturador.ticomprobante.Commit;
  End;




 //INSERTAR VTTBPAGOCHEQUE          --VR LLEVA TODOS LOS MEDIOS DE PAGO

if strtofloat(imp_CH)<>0 then
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
    dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:='VR'+dmFacturador.getPuntoVenta();
    dmfacturador.icomprobante.ParamByName('nro_comprobante').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
    dmfacturador.icomprobante.ParamByName('cod_banco').AsString:=ticket.codigocheque;
    dmfacturador.icomprobante.ParamByName('nro_cheque').AsString:=ticket.numerocheque;
    dmfacturador.icomprobante.ParamByName('importe_cheque').AsFloat:=strtofloat(imp_ch);
    dmfacturador.icomprobante.Open;
    dmfacturador.ticomprobante.Commit;

end;

//INSTERTAR VTTPAGOCTACTE

if strtofloat(imp_CC)<>0 then
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
        dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:='VR'+dmFacturador.getPuntoVenta();
        dmfacturador.icomprobante.ParamByName('nro_comprob').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
        dmfacturador.icomprobante.ParamByName('COD_CTACTE').AsString:=ticket.codigocc;
        dmfacturador.icomprobante.ParamByName('cod_subcta').AsString:=ticket.codigosubcc;
        dmfacturador.icomprobante.ParamByName('imp_ctacte').AsFloat:=strtofloat(imp_cc);
        dmfacturador.icomprobante.ParamByName('imp_sctacte').AsFloat:=strtofloat(imp_cc);
        dmfacturador.icomprobante.Open;
        dmfacturador.ticomprobante.Commit;

end;

//INSERTAR VTTPAGOEFECTIVO

 if strtofloat(imp_efectivo)<>0 then
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
        dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:='VR'+dmFacturador.getPuntoVenta();
        dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
        dmfacturador.icomprobante.ParamByName('imp_EFECTIVO').AsFloat:=strtofloat(imp_efectivo);
        dmfacturador.icomprobante.Open;
        dmfacturador.ticomprobante.Commit;

        end;





 //INSERTAR VTTBPAGOTARJETA


 if strtofloat(imp_tarjeta)<>0 then
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
        dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:='VR'+dmFacturador.getPuntoVenta();
        dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
        dmfacturador.icomprobante.ParamByName('COD_TARJETA').AsString:=ticket.codigotarjeta;
        dmfacturador.icomprobante.ParamByName('imp_tarjeta').AsFloat:=strtofloat(imp_tarjeta);
        dmfacturador.icomprobante.Open;
        dmfacturador.ticomprobante.Commit;

        end;




 //INSERTAR VTMADESCCOMPROB     ------VR LLEVA PERO SIN IMPORTES


 if TICKET.codigo_OS<>'' THEN
 begin
        i:=0;

        ffacturador.Gfacturador.DataSource.DataSet.first;
        while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
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
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:='VR'+dmFacturador.getPuntoVenta();
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_OS;
          dmfacturador.icomprobante.ParamByName('ITEM').AsFloat:=I;
          dmfacturador.icomprobante.ParamByName('POR_DESCUENTO').AsFloat:=0;
          dmfacturador.icomprobante.ParamByName('IMP_DESCUENTO').AsFloat:=0;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          ffacturador.Gfacturador.DataSource.DataSet.Next;
          end;
 end;

  if TICKET.codigo_Co1<>'' THEN
 begin
        i:=0;

        ffacturador.Gfacturador.DataSource.DataSet.first;
        while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
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
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:='VR'+dmFacturador.getPuntoVenta();
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_Co1;
          dmfacturador.icomprobante.ParamByName('ITEM').AsFloat:=I;
          dmfacturador.icomprobante.ParamByName('POR_DESCUENTO').AsFloat:=0;
          dmfacturador.icomprobante.ParamByName('IMP_DESCUENTO').AsFloat:=0;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          ffacturador.Gfacturador.DataSource.DataSet.Next;
          end;
 end;
 if TICKET.codigo_Cos2<>'' THEN
 begin
        i:=0;

        ffacturador.Gfacturador.DataSource.DataSet.first;
         while not ffacturador.Gfacturador.DataSource.DataSet.Eof do
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
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:='VR'+dmFacturador.getPuntoVenta();
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_Cos2;
          dmfacturador.icomprobante.ParamByName('ITEM').AsFloat:=I;
          dmfacturador.icomprobante.ParamByName('POR_DESCUENTO').AsFloat:=0;
          dmfacturador.icomprobante.ParamByName('IMP_DESCUENTO').AsFloat:=0;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;
          ffacturador.Gfacturador.DataSource.DataSet.Next;
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
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:='VR'+dmFacturador.getPuntoVenta();
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_os;
          dmfacturador.icomprobante.ParamByName('nro_afiliado').asstring:=ticket.afiliado_numero;
          dmfacturador.icomprobante.ParamByName('nro_matricula').asstring:=ticket.medico_tipo_matricula+ticket.medico_nro_matricula;
          dmfacturador.icomprobante.ParamByName('nom_medico').asstring:=ticket.medico_nombre+' '+ticket.medico_apellido;
          dmfacturador.icomprobante.ParamByName('nro_receta').asstring:=ticket.numero_receta;
          dmfacturador.icomprobante.ParamByName('fec_recet').Asdate:=ticket.fecha_receta;
          dmfacturador.icomprobante.ParamByName('imp_abonaos').Ascurrency:=0;
          dmfacturador.icomprobante.ParamByName('imp_totalfec').Ascurrency:=0;
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
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:='VR'+dmFacturador.getPuntoVenta();
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_Co1;
          dmfacturador.icomprobante.ParamByName('nro_afiliado').asstring:=ticket.afiliado_numero;
          dmfacturador.icomprobante.ParamByName('nro_matricula').asstring:=ticket.medico_tipo_matriculaco1+ticket.medico_nro_matriculaco1;
          dmfacturador.icomprobante.ParamByName('nom_medico').asstring:=ticket.medico_nombre+' '+ticket.medico_apellido;
          dmfacturador.icomprobante.ParamByName('nro_receta').asstring:=ticket.numero_receta;
          dmfacturador.icomprobante.ParamByName('fec_recet').Asdate:=ticket.fecha_recetaco1;
          dmfacturador.icomprobante.ParamByName('imp_abonaos').Ascurrency:=0;
          dmfacturador.icomprobante.ParamByName('imp_totalfec').Ascurrency:=0;
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
          dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:='VR'+dmFacturador.getPuntoVenta();
          dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=ticket.fiscla_pv+(rightpad(inttostr(nro_comprob), '0', 8));
          dmfacturador.icomprobante.ParamByName('COD_PLANOS').AsString:=TICKET.codigo_Cos2;
          dmfacturador.icomprobante.ParamByName('nro_afiliado').asstring:=ticket.afiliado_numero;
          dmfacturador.icomprobante.ParamByName('nro_matricula').asstring:=ticket.medico_nro_matricula;
          dmfacturador.icomprobante.ParamByName('nom_medico').asstring:=ticket.medico_nombre+' '+ticket.medico_apellido;
          dmfacturador.icomprobante.ParamByName('nro_receta').asstring:=ticket.numero_receta;
          dmfacturador.icomprobante.ParamByName('fec_recet').Asdate:=ticket.fecha_recetaco1;
          dmfacturador.icomprobante.ParamByName('imp_abonaos').Ascurrency:=0;
          dmfacturador.icomprobante.ParamByName('imp_totalfec').Ascurrency:=0;
          dmfacturador.icomprobante.Open;
          dmfacturador.ticomprobante.Commit;

  end;
 end;
procedure TFIMPRESION.mimpresionKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=vk_escape then
begin
  fimpresion.CloseModal;
end;
end;

end.
