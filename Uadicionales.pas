unit Uadicionales;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,
  Vcl.ExtCtrls, Vcl.StdCtrls,UDTicket, udmfacturador;

type
  Tfadicionales = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Lsegundos: TLabel;
    mmsjvalida: TMemo;
    Tvalidacion: TTimer;
    XMLVAL: TXMLDocument;
    procedure FormShow(Sender: TObject);
    procedure TvalidacionTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mmsjvalidaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
        Ticket:TTicket;
  public
    { Public declarations }
    procedure SetTicket(unTicket:TTicket);
  end;

var
  fadicionales: Tfadicionales;
  NUMEROVALIDA: INTEGER;
  x: integer;
  ceros: string;

implementation

{$R *.dfm}

Function FillSpaces(cVar:String;nLen:Integer):String;
 begin
 Result:=StringOfChar('0',nLen - Length(cVar))+cVar;
 end;

procedure Tfadicionales.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=vk_return then
begin
  if (mmsjvalida.Color=clmaroon) or (mmsjvalida.Color=clgreen) OR (mmsjvalida.Color=clBLUE) then
  begin
  ModalResult := mrCancel;
  end;
end;
end;
procedure Tfadicionales.FormShow(Sender: TObject);
var

  archivoXML: TXMLDocument;

  Nodo,NDatosGenerales,NMensajeFacturacion,NCabecera,NDatosFinales,terminal,software,
  validador,prestador,prescriptor, beneficiario, financiador, credencial, CoberturaEspecial, Preautorizacion,
  Fechareceta,Dispensa, Formulario, TipoTratamiento, Diagnostico, Institucion, Retira, detallereceta, item, comprobante
  : IXMLNode;
  I:Integer;
  detalleTicket: TTicketItem;
  impcoberturaredondeado: double;
  impunitarioredondeado: double;
  IDCOMPROBANTEVALIDACIONES: INTEGER;
  rutaarchivo: string;
  rutadestino: string;

begin
 dmfacturador.qNROVALIDACION.close;
 dmfacturador.qNROVALIDACION.SQL.Text:=concat('select MAX(idcomprobante), MAX(IDCOMPROBANTEVALIDACIONES) from osmacomprobvalidaciones');
 dmfacturador.qNROVALIDACION.Open;
 NUMEROVALIDA:=strtoint(dmfacturador.qNROVALIDACION.Fields[1].Text)+1;
 IDCOMPROBANTEVALIDACIONES:=strtoint(dmfacturador.qNROVALIDACION.Fields[0].Text)+1;
 x:=0;
 ceros:='';
 archivoXML := TXMLDocument.Create(Application);

    try
     archivoxml.xml.Clear;
     archivoxml.Active:=true;
     archivoXML.Version:='1.0';
     archivoXML.Encoding:='ISO-8859-1';
     NMensajeFacturacion := archivoXML.AddChild('MensajeADESFA');
     NMensajeFacturacion.Attributes['version'] := '3.1.0';

     NCabecera := NMensajeFacturacion.AddChild( 'EncabezadoMensaje' );
     Nodo := NCabecera.AddChild( 'TipoMsj' );
     Nodo.text := '200';
     Nodo := NCabecera.AddChild( 'CodAccion' );
     Nodo.Text := '290220';
     Nodo := NCabecera.AddChild( 'IdMsj' );
     Nodo.Text := inttostr(NUMEROVALIDA);

     NDatosGenerales := NCabecera.AddChild( 'InicioTrx' );
     Nodo := NDatosGenerales.AddChild( 'Fecha' );
     Nodo.Text :=  FormatDateTime('yyyymmdd',date);
     Nodo := NDatosGenerales.AddChild( 'Hora' );
     Nodo.Text :=  FormatDateTime('hhmmss',time);

     software := NCabecera.AddChild( 'Software' );
     nodo:= software.AddChild('CodigoADESFA');
     nodo:= software.AddChild('Nombre');
     nodo.Text:='aPlus';
     nodo:=software.AddChild('Version');
     nodo.Text:='';

     validador := NCabecera.AddChild( 'Validador' );
     nodo:=validador.AddChild('CodigoADESFA');
     nodo.Text:='';
     nodo:= validador.AddChild('Nombre');
     nodo.Text:=TICKET.codigo_validador;

     prestador := NCabecera.AddChild( 'Prestador' );
     nodo:=prestador.AddChild('CodigoADESFA');
     nodo.Text:='';
     nodo:= prestador.AddChild('Cuit');
     nodo.Text:=StringReplace(ticket.cuitsucursal, '-', '', [rfReplaceAll]);; //cuit
     nodo:=prestador.AddChild('Sucursal');
     nodo.Text:=ticket.sucursal;
     nodo:=prestador.AddChild('RazonSocial');
     nodo.Text:='';
     nodo:=prestador.AddChild('Codigo');
     nodo.Text:=TICKET.codigoos_prestador;
     nodo:=prestador.AddChild('Vendedor');
     nodo.Text:=TICKEt.cod_vendedor;

     detallereceta := NMensajeFacturacion.AddChild( 'DatosAdicionales' );
     item := detallereceta.AddChild('Receta');
     Nodo := item.AddChild('NroOrden');
     Nodo.Text := '1';
     Nodo := item.AddChild('NroReferencia');
     Nodo.Text := ticket.nrorefadicional;    //---
     comprobante := item.AddChild('Comprobante');
     Nodo := comprobante.AddChild('Fecha');
     Nodo.Text :=  FormatDateTime('yyyymmdd',date);
     Nodo := comprobante.AddChild('Hora');
     Nodo.Text :=  FormatDateTime('hhmmss',time);
     Nodo := comprobante.AddChild('ID');
     Nodo.Text := ticket.nroticketadicional;   //--
     Nodo := comprobante.AddChild('ImporteNeto');
     Nodo.Text := floattostr(ticket.importeneto);
     financiador := item.AddChild('Financiador');
     Nodo := financiador.AddChild('CodigoADESFA');
     Nodo.Text :='';
     Nodo := financiador.AddChild('Codigo');
     Nodo.Text :=ticket.codigoos_validador;
     Nodo := financiador.AddChild('Cuit');
     Nodo.Text :='';
     Nodo := financiador.AddChild('Sucursal');
     Nodo.Text :='';
     Nodo := item.AddChild('Trazabilidad');

     archivoxml.Active:=true;
     archivoXML.Version:='1.0';
     archivoXML.Encoding:='ISO-8859-1';


     archivoXML.SaveToFile('z:\imed\ida\'+ FillSpaces(inttostr(NUMEROVALIDA), 8)+'.XML');

    finally
    archivoxml.Active:=false;
    archivoXML.Free;
    end;
mmsjvalida.Lines.Add(inttostr(NUMEROVALIDA)+'.XML'+' VALIDANDO........');


if DMFACTURADOR.IBTransactionVAL.InTransaction then
begin
DMFACTURADOR.IBTransactionVAL.Rollback;
end;
 dmfacturador.IBTransactionVAL.StartTransaction;
 dmfacturador.qNROVALIDACION.close;
 dmfacturador.qNROVALIDACION.SQL.Text:=concat('INSERT INTO OSMACOMPROBVALIDACIONES (IDCOMPROBANTEVALIDACIONES, COD_ESTADO, IDCOMPROBANTE, FECHA, COD_VALIDADOR, COD_PLANOS)',
                                              'VALUES (:ID, 0, :NUMEROARCHIVO, CURRENT_DATE, :CODIGOVAL, :CODIGOPLAN);');


 dmfacturador.qNROVALIDACION.ParamByName('id').Asinteger:=NUMEROVALIDA;
 dmfacturador.qNROVALIDACION.ParamByName('numeroarchivo').AsInteger:=IDCOMPROBANTEVALIDACIONES;
 dmfacturador.qNROVALIDACION.ParamByName('codigoval').Asstring:=ticket.codigo_validador;
 dmfacturador.qNROVALIDACION.ParamByName('codigoplan').Asstring:=ticket.codigo_OS;
 dmfacturador.qNROVALIDACION.Open;
 dmfacturador.IBTransactionVAL.Commit;
 tvalidacion.Enabled:=True;


end;

procedure Tfadicionales.mmsjvalidaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
BEGIN


if key=vk_return then
begin
  if (mmsjvalida.Color=clmaroon) or (mmsjvalida.Color=clgreen) OR (mmsjvalida.Color=clBLUE) then
  begin
  ModalResult := mrCancel;
  end;


end;
end;

procedure TFadicionales.SetTicket(unTicket: TTicket);
begin
  ticket:=unTicket;
end;


procedure Tfadicionales.TvalidacionTimer(Sender: TObject);

var
archivoxmlval: txmldocument;
encabezadoval,rtaval,nrorefval,detalleval,
ITEMVAL,BARRASVAL,TROQUELVAL,DESCRIPCIONVAL,RTAPRODUCTO,CANTIDADVAL,PORCENTAJEVAL,IMPORTEUNITARIOVAL,IMPORTEAFIVAL,IMPORTECOBERVAL:ixmlnode;
flag: integer;
I: INTEGER;
itemsval:TTicketItemval;
leido: boolean;

begin

ticket.valcodigorespuesta:='999';
ticket.valdescripcionrespuesta:='';
ticket.valmsjrespuesta:='';
ticket.valnroreferencia:='';
ticket.itemsval:=Tlist.Create;
leido:=false;


       if x<80 then
        begin
         x:=x+1;
        archivoxmlval:= TXMLDocument.Create(Application);
        if flag=0 then
           begin

         If FileExists ('z:\imed\rta\'+FillSpaces(inttostr(NUMEROVALIDA), 8)+'.XML') Then
                begin
                try
                  //  archivoxmlval.LoadFromFile ('C:\VALIDA\imed\Rta\00040541.XML');
                    archivoxmlval.LoadFromFile ('z:\imed\rta\'+FillSpaces(inttostr(NUMEROVALIDA), 8)+'.XML');
                    archivoxmlval.Active:=true;
                    archivoxmlval.DocumentElement.ChildNodes.Count;
                    leido:=true;
                    encabezadoval:=archivoxmlval.DocumentElement.ChildNodes[0];
                    encabezadoval.ChildNodes.Count;
                    rtaval:=encabezadoval.ChildNodes['Rta'];
                    ticket.valcodigorespuesta:=StringReplace(StringReplace((rtaval.ChildNodes['CodRtaGeneral'].Text), #$A, '', [rfReplaceAll]), ' ', '', [rfReplaceAll]);
                    ticket.valdescripcionrespuesta:=rtaval.ChildNodes['Descripcion'].Text;
                  except
                   begin
                     x:=80;
                     showmessage('XML mal formado');

                   end;
                  end;



 //----------------------modificado el 03/03/2017-------------------------- lectura de validacion universal--------------//




                        if (ticket.valcodigorespuesta)='' then
                        begin
                          flag:=0;
                        end;
                         if ticket.valcodigorespuesta='0' then
                        begin
                          flag:=1;
                        end;
                         if (ticket.valcodigorespuesta<>'0') and ((ticket.valcodigorespuesta)<>'')  then
                        begin
                          flag:=2;
                        end;
                        if ((ticket.valcodigorespuesta<>'0') AND (ticket.valcodigorespuesta<>'00')) then
                        begin
                          mmsjvalida.Lines.Add('_____________________________________________________________');
                          mmsjvalida.Lines.Add('SOLICITUD RECHAZADA CORRIJA LOS DATOS Y VUELVA A INTENTARLO!');
                          mmsjvalida.Lines.Add('_____________________________________________________________');
                          tvalidacion.Enabled:=false;
                          mmsjvalida.Lines.Add((ticket.valcodigorespuesta));
                          mmsjvalida.Lines.Add('_____________________________________________________________');
                          mmsjvalida.Lines.Add(ticket.valdescripcionrespuesta);
                          mmsjvalida.Lines.Add('_____________________________________________________________');
                          mmsjvalida.Lines.Add(ticket.valmsjrespuesta);
                          ticket.valnroreferencia:='';
                          MMSJVALIDA.Color:=clmaroon;
                        end;
                end;


            end;

        lsegundos.Caption:=inttostr(x);


       end;
         if (x=80) and (flag=0) then
             begin
                mmsjvalida.Lines.Add('_____________________________________________________________');
                mmsjvalida.Lines.Add('Tiempo de espera agotado');
                mmsjvalida.Lines.Add('_____________________________________________________________');
                tvalidacion.Enabled:=false;
                MMSJVALIDA.Color:=clmaroon;
             end;

       if (ticket.valcodigorespuesta='0') OR (ticket.valcodigorespuesta='00')  then
         BEGIN

           if (flag=2) or (flag=1) then
            begin
            mmsjvalida.Lines.Add('');
            mmsjvalida.Lines.Add('');
            mmsjvalida.Lines.Add('_____________________________________________________________');
            mmsjvalida.Lines.Add('RESPUESTA RECIBIDA NRO. REF:..................'+ticket.valnroreferencia);
            mmsjvalida.Lines.Add('_____________________________________________________________');
            mmsjvalida.Lines.Add('');
            mmsjvalida.Lines.Add('_____________________________________________________________');
            mmsjvalida.Lines.Add(ticket.valdescripcionrespuesta);
            mmsjvalida.Lines.Add('_____________________________________________________________');
            mmsjvalida.Lines.Add('');
            mmsjvalida.Lines.Add('_____________________________________________________________');
            mmsjvalida.Lines.Add(ticket.valmsjrespuesta);
            mmsjvalida.Lines.Add('_____________________________________________________________');
            MMSJVALIDA.Color:=clgreen;
            x:=80;
            lsegundos.Caption:='';
            tvalidacion.Enabled:=false;

            end;
         END;


    If (FileExists (ticket.path_respuesta+'rta\'+FillSpaces(inttostr(NUMEROVALIDA), 8)+'.xml')) and (leido=true) Then
    begin
 //     copyfile(pchar(ticket.path_respuesta+'rta\'+FillSpaces(inttostr(NUMEROVALIDA), 8)+'.xml'),pchar(ticket.path_respuesta+'bck\rta\'+FillSpaces(inttostr(NUMEROVALIDA), 8)+'.xml'),false);
      deletefile(ticket.path_respuesta+'rta\'+FillSpaces(inttostr(NUMEROVALIDA), 8)+'.xml');
    end;
    if (mmsjvalida.Color=clmaroon) or (mmsjvalida.Color=clgreen) OR (mmsjvalida.Color=clBLUE) then
    begin
    ModalResult := mrCancel;
    end;





end;
end.


