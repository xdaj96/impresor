unit uTicketService;

interface
  uses SysUtils,udticket,Xml.xmldom, Xml.XMLIntf,msxmldom, xml.xmldoc,Data.DB, Datasnap.DBClient,Classes,uDetalleTicket, system.Generics.collections;
  Type
    TTicketService = class
      private
        archivoxmlval:TXMLDocument;
        ticket:TTicket;
      public
        constructor Create(unXML:TXMLDocument;unTicket:TTicket);
        function obtenerTicket(rutaXML:string):TTicket;
    end;


implementation


constructor TTicketService.Create(unXML:TXMLDocument;unTicket:TTicket);
begin
   archivoxmlval:= unXML;
   ticket:= unTicket;
end;

function TTicketService.obtenerTicket(rutaXML:string):TTicket;
var

  encabezadoval,rtaval,nrorefval,detalleval,
ITEMVAL,BARRASVAL,TROQUELVAL,DESCRIPCIONVAL,RTAPRODUCTO,CANTIDADVAL,PORCENTAJEVAL,IMPORTEUNITARIOVAL,IMPORTEAFIVAL,IMPORTECOBERVAL:ixmlnode;
  itemTicket:TDetalleFactura;
  v:integer;
begin

   itemTicket:= TDetalleFactura.Create;
   archivoxmlval.LoadFromFile (rutaXML);
                archivoxmlval.Active:=true;
                archivoxmlval.DocumentElement.ChildNodes.Count;
                encabezadoval:=archivoxmlval.DocumentElement.ChildNodes[0];
                encabezadoval.ChildNodes.Count;


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

                  detalleval:=archivoxmlval.DocumentElement.ChildNodes[1];
                    ticket.detalleFac:= TList<TDetalleFactura>.Create;
                    for v := 0 to DETALLEVAL.ChildNodes.Count -1 do
                    BEGIN
                          ITEMVAL:=DETALLEVAL.ChildNodes[v];
                          itemTicket.AssignFromXmlNode(ITEMVAL);
                          if itemTicket.CanVale <>'0' then
                          begin
                          TICKET.valecantidad:=itemTicket.CanVale;
                          ticket.llevavale:='SI';
                          end;
                          ticket.detalleFac.Add(itemTicket);
                   end;
                ticket.itemstotales:=DETALLEVAL.ChildNodes.Count;


    Result:= ticket;

end;


end.
