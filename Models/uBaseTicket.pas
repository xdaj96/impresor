unit uBaseTicket;

interface
  uses
   Xml.xmldom, Xml.XMLIntf,udTicket, Vcl.DBGrids,uUtils,uFormaDePago,Dialogs,   System.SysUtils, System.IOUtils,
  msxmldom, xml.xmldoc,FiscalPrinterLib_TLB,windows,math,Forms,uFiscalEpson,uRegistryHelper;

 type
  TBaseTicket = class
  private
    error : LongInt;
  str : Array[0..200] of Char;
  mayor : LongInt;
  menor : LongInt;
  mychar: char;
   procedure imprimirDatosAfiliadoValidacion;
   procedure imprimirCodBarrasValidacionOnline;
   procedure imprimirBarrasSeguimientoComprobante;

   function llevaValidacionConCodBarras(cod_os: string): boolean;

  protected
  ticket: TTicket;
  GFacturador: TDBGRID;
  formaDePago:TFormaDePago;
  fiscalEpson: TFiscalEpson;
  reg:TRegistryHelper;

  procedure imprimirCodBarrasSeguimientoOValidacion;

  public
      ultimoTKImpreso:integer;
      nro_comprobdigital:Integer;
      imprimi: boolean;
      ImprimiParteTK:boolean;
      nro_comprob:Integer;

      function puedeImprimir:Boolean;
      procedure EstablecerEncabezadoTalonOS;
      procedure ImprimirTicket(var imprimio: Boolean; var reimpresion:boolean); virtual; abstract;
      procedure copiaDigital;
      procedure imprimirFormaDePagoEnTicket;
      procedure GuardarXML(const XML: TXMLDocument);
      procedure setTKFiscal(nro_tk:string);
      procedure imprimirZ;
      constructor Create(unTicket: TTicket;gridFacturador: TDBGRID);
      procedure verificarPapel;
      function estadoFiscal:boolean;
      destructor Destroy; override;
  end;
implementation
  //--------------------  PROMO -----------------------------------------------------------------------//
          {      if ticket.Oespecial='S' then
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

   //-----------------------------------------------------------------------------//
//----------------------Direccion fiscal----------------------------------------//

constructor TBaseTicket.Create(unTicket: TTicket;gridFacturador: TDBGRID);
begin
  ticket:= unTicket;
  GFacturador:= gridFacturador;
   fiscalEpson:= TFiscalEpson.Create;
  {Establecer metodo de pago}
  formaDePago:= TFormaDePago.Create;
  formaDePago.cargarFormaPago(ticket);
  reg:= TRegistryHelper.Create;
  ultimoTKImpreso:=0;
    ImprimiParteTK :=false;

end;

destructor TBaseTicket.destroy;
begin
  fiscalEpson.Desconectar;
  fiscalEpson.Free;

end;

procedure TBaseTicket.imprimirZ;
begin
        fiscalEpson.imprimirZ;

end;


procedure TBaseTicket.setTKFiscal(nro_tk: string);
begin
  ticket.numero_ticketfiscal:= strToInt(nro_tk);

end;

function TBaseTicket.estadoFiscal;
begin

  error := fiscalEpson.CerrarComprobante();
  error := fiscalEpson.Conectar();
  error := fiscalEpson.Desconectar();
  Result:= error =0;
end;

procedure TBaseTicket.verificarPapel;
begin
  if not fiscalEpson.tienePapel or not fiscalEpson.tieneLaTapaCerrada then
  begin
    fiscalEpson.Desconectar;
    raise Exception.Create('El fiscal no tiene papel o esta la tapa abierta');
  end;
end;



function TBaseTicket.puedeImprimir:Boolean;
begin
  Result:= fiscalEpson.tienePapel and fiscalEpson.tieneLaTapaCerrada
end;

procedure TBaseTicket.copiadigital;
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

       Nodo.text :=ticket.fiscla_pv+(TUtils.rightpad(inttostr(nro_comprobdigital), '0', 8));
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
       Nodo.Text := formaDePago.ImpEfectivo;
       Nodo := NCabecera.AddChild( 'pago_tarjeta' );
       Nodo.Text := formaDePago.imptarjeta;
       Nodo := NCabecera.AddChild( 'pago_cc' );
       Nodo.Text := formaDePago.impcc;
       Nodo := NCabecera.AddChild( 'pago_ch' );
       Nodo.Text := formaDePago.impCheque;
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


       GuardarXML(archivoXML);
      end;
    except
      on E:Exception do
      begin

      end;


    end;



end;

procedure TBaseTicket.GuardarXML(const XML: TXMLDocument);
var
  Directorio: string;
  fileName:string;
begin
  // Directorio donde se guardará el archivo XML
  Directorio := 'C:\zetadigital';
  fileName:=ticket.fiscla_pv+(TUtils.rightpad(inttostr(nro_comprobdigital), '0', 8))+'.xml';
  // Verificar si el directorio existe, si no, crearlo

  try
    // Intentar guardar el archivo XML en el servidor
    XML.SaveToFile(ticket.errores+filename);

  except
    on E: Exception do
    begin
      // En caso de error al guardar, intentar guardar en el directorio predeterminado
      try
        if not TDirectory.Exists(Directorio) then
            TDirectory.CreateDirectory(Directorio);


        XML.SaveToFile(Directorio+'\'+fileName); // Guardar en el directorio predeterminado

      except

      end;
    end;
  end;
end;

//----------------------------ENCABEZADO TALON OS-----------------------------//
procedure TBaseTicket.EstablecerEncabezadoTalonOS;
begin
  fiscalEpson.borrarEncabezadoYCola;
  {Encabezado talon obra social}
  fiscalEpson.EscribirEnEncabezado('Vendedor: ' + ticket.nom_vendedor);
  fiscalEpson.EscribirEnEncabezado('Obra Social: ' + ticket.codigo_OS + '-' +   ticket.nombre_os);
  fiscalEpson.EscribirEnEncabezado('Coseguro 1: ' + ticket.codigo_Co1 + '-' +  ticket.nombre_co1);
  fiscalEpson.EscribirEnEncabezado('Coseguro 2: ' + ticket.codigo_Cos2 + '-' + ticket.nombre_cos2);
  fiscalEpson.EscribirEnEncabezado('Afiliado: ' + ticket.afiliado_apellido + ' ' + ticket.afiliado_nombre);
  fiscalEpson.EscribirEnEncabezado('Nro afiliado: ' + ticket.afiliado_numero);
  fiscalEpson.EscribirEnEncabezado('Mat. Med: ' + ticket.medico_nro_matricula);
  fiscalEpson.EscribirEnEncabezado('Receta: ' + ticket.numero_receta);
  fiscalEpson.EscribirEnEncabezado('Numero de ref: ' + ticket.valnroreferencia);

  {Pie talon obra social}

  imprimirFormaDePagoEnTicket;

end;




//----------------------------ENCABEZADO TALON OS-----------------------------//

procedure TBaseTicket.imprimirFormaDePagoEnTicket;
begin

  fiscalEpson.escribirEnCola('REC: ' + FLOATTOSTR(ticket.importebruto) + '     OS: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpOS), -2)));
  fiscalEpson.escribirEnCola('CO1: ' + formaDePago.ImpCO1 + ' CO2: ' + formaDePago.ImpCO2 + ' AFI: ' + FLOATTOSTR(roundto(formaDePago.calcularTotalPorAfiliado, -2)));
   fiscalEpson.escribirEnCola('EF: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpEfectivo), -2)) + ' CH: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpCheque), -2)) + ' CC: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpCC), -2)) + ' TJ: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpTarjeta), -2)));

end;



//------------------------------------------------------------------------------//

{Metodo que imprime el codigo de barras para validacion online}
procedure TBaseTicket.imprimirCodBarrasValidacionOnline;
var
cod_ref:string;
begin




  fiscalEpson.EscribirTextoLibre('Codigo Validacion online:');
  cod_ref:= TUtils.RightPad(ticket.valnroreferencia,'0',13);
  fiscalEpson.imprimirCodigoDeBarras(cod_ref);

end;

{Metodo que imprime el codigo de barras para validacion online}
procedure TBaseTicket.imprimirDatosAfiliadoValidacion;
begin
  FiscalEpson.escribirTextoLibre('********** CONFORMIDAD DEL AFILIADO **********');
  FiscalEpson.escribirTextoLibre('FIRMA:........................................');
  FiscalEpson.escribirTextoLibre('ACLARACION:...................................');
  FiscalEpson.escribirTextoLibre('DOCUMENTO:....................................');
  FiscalEpson.escribirTextoLibre('DOMICILIO:....................................');
  FiscalEpson.escribirTextoLibre('TELEFONO:.....................................');
end;

{Metodo que valida si el ticket es con co}
procedure TBaseticket.imprimirCodBarrasSeguimientoOValidacion;
begin

  if  (llevaValidacionConCodBarras(ticket.codigo_OS)) and not(TUtils.esCampoVacio(ticket.valnroreferencia)) then
  begin

     imprimirCodBarrasValidacionOnline;
     imprimirDatosAfiliadoValidacion;
  end
  else
      begin

        imprimirBarrasSeguimientoComprobante
      end;


end;


procedure TBaseTicket.imprimirBarrasSeguimientoComprobante;
var
  barra_seguimiento:string;
  nro_suc_pv:string;
  cant_caracteres:Integer;
begin
cant_caracteres:=13;
 nro_suc_pv:= TUtils.rightpad(ticket.sucursal,'0',3) + TUtils.rightpad(ticket.fiscla_pv,'0',2);

 barra_seguimiento:= nro_suc_pv +(TUtils.rightpad(inttostr(nro_comprob), '0', cant_caracteres - length(nro_suc_pv)));
 fiscalEpson.EscribirTextoLibre('Numero de seguimiento:');
 //fiscalEpson.EscribirTextoLibre(barra_seguimiento);

 fiscalEpson.imprimirCodigoDeBarras(barra_seguimiento);

end;






//------------------------------------------------------------------------------//

{
  Función: llevaValidacionConCodBarras
  Descripcion: Verifica si el codigo del plan de la obra social
               lleva impresa la validacion por codigo de barras
  @param string cod_os : el codigo de plan a verificar
}
function TBaseTicket.llevaValidacionConCodBarras(cod_os: string): boolean;
var
  cod_os_habilitadas: array of string;
  i: Integer;
  codBarrasHabilitado: Boolean;
begin
  // Inicializamos la variable codBarrasHabilitado en false
  codBarrasHabilitado := False;

  // Cod. de planes OS que llevan validacion por codigo de barras
  cod_os_habilitadas := ['WIF', 'WIA', 'WIB','WIG','WIH','WII'];

  // Recorremos el array de códigos habilitados para verificar si cod_os está en la lista
  for i := 0 to High(cod_os_habilitadas) do
  begin
    if cod_os_habilitadas[i] = cod_os then
    begin
      codBarrasHabilitado := True;
      break; // Si encontramos el código, salimos del bucle
    end;
  end;

  // Devolvemos el valor de codBarrasHabilitado
  Result := codBarrasHabilitado;
end;


end.
