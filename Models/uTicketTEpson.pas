﻿unit uTicketTEpson;

interface
    uses uBaseTicket,uFiscalEpson,udTicket,sysUtils,Vcl.DBGrids,uFormaDePago,FiscalPrinterLib_TLB,math,uUtils,dialogs,forms;
    type
    TTicketTEpson= class(TBaseTicket)
    private
    procedure ReimpresionTK;





    public
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
    respuesta_final_buffer_salida: integer;
    dnfh:string;
    valorivaep: integer;
    texto: string;
    ofecupon: string;
    fatal:integer;
    numeroc:string;
    tieneImpresoParteTicket:boolean;
    Gfacturador: TDBGrid;
    formaDePago:TFormaDePago;


    error:LongInt;


      constructor Create(unTicket:TTicket;gridFacturador:TDBGrid);
      destructor Destroy;override;
      procedure ImprimirTicket(var imprimio: Boolean;var reimpresion:boolean); override;
        procedure establecerNombreVendedor;
    procedure EstablecerDireccionFiscalEnTicket;
    procedure cargarItemsEnTicket;
    procedure EstablecerFormaPagoEnTicket;
    procedure RealizarPago(const imp: string; const tipoPago: Integer; const comandos: string);
    procedure aplicarDescuentoGral;
    procedure finalizarTicket;
    procedure iniciarTicketNoFiscal;
    procedure imprimirItemsTalonOS;
    procedure imprimirItemsVale;
    procedure establecerEncabezadoVale;
    procedure establecerEncabezadoTicketVale;
    procedure establecerPieTicketVale;
    procedure imprimirCorteDeTicket;
    procedure crearTicketVale;


      {procedure imprimirFormaDePagoEnTicket; }
    end;


implementation


constructor TTicketTEpson.Create(unTicket:TTicket;gridFacturador:TDBGrid);
begin
     inherited; // Llama al constructor de la clase padre
     ticket:= unTicket;
     fiscalEpson.configurarImpresor(ticket);
     gFacturador:= gridFacturador;
end;


destructor TTicketTEpson.Destroy;
begin
  inherited;
end;







//----------------------------ENCABEZADO TICKET VALE-----------------------------//
procedure TTicketTEpson.establecerEncabezadoTicketVale;
begin
  comando := '';
  texto := strpcopy(comando, 'Emision VR' + ticket.fiscla_pv + ': ' +
    ticket.fiscla_pv + (TUtils.rightpad(inttostr(nro_comprob), '0', 8)));
  error := fiscalEpson.ImprimirTextoLibre(comando);

  Gfacturador.DataSource.DataSet.First;
  texto := strpcopy(comando, 'Vendedor: ' + (ticket.nom_vendedor));
  error := fiscalEpson.ImprimirTextoLibre(comando);
  texto := strpcopy(comando, 'Obra Social: ' + ticket.codigo_OS + '-' +
    ticket.nombre_os);
  error := fiscalEpson.ImprimirTextoLibre(comando);
  texto := strpcopy(comando, 'Afiliado: ' + ticket.afiliado_apellido + ' ' +
    ticket.afiliado_nombre);
  error := fiscalEpson.ImprimirTextoLibre(comando);
  texto := strpcopy(comando, 'Fecha: ' + (datetostr(now)));
  Application.ProcessMessages;

end;



//----------------------------ENCABEZADO TICKET VALE-----------------------------//


//----------------------------ENCABEZADO VALE --------------------------------//

procedure TTicketTEpson.establecerEncabezadoVale;
begin
   comando:='';
   texto := strpcopy(comando, 'Vendedor: ' + ticket.nom_vendedor);
   error := fiscalEpson.establecerencabezado(1, @comando[0]);

   if (ticket.nombre_os = '') and (ticket.nombre_co1 <> '') then
   begin
     comando := '';
     texto := strpcopy(comando, 'Obra Social: ' + ticket.codigo_OS + '-' +
       ticket.nombre_os);
     error := fiscalEpson.establecerencabezado(2, @comando[0]);
   end;

   if (ticket.nombre_os = '') and (ticket.nombre_co1 <> '') then
   begin
     comando := '';
     texto := strpcopy(comando, 'Afiliado: ' + ticket.afiliado_apellido + ' ' +
       ticket.afiliado_nombre);
     error := fiscalEpson.establecerencabezado(4, @comando[0]);

   end;
   if (ticket.nombre_os <> '') then
   begin
     comando := '';
     texto := strpcopy(comando, 'Afiliado: ' + ticket.afiliado_apellido + ' ' +
       ticket.afiliado_nombre);
     error := fiscalEpson.establecerencabezado(4, @comando[0]);
     comando := '';
     texto := strpcopy(comando, 'Nro afiliado: ' + ticket.afiliado_numero);
     error := fiscalEpson.establecerencabezado(5, @comando[0]);

   end;
   comando := '';
   texto := strpcopy(comando, 'REC: ' + FLOATTOSTR(ticket.importebruto) +
     '     OS: ' + FLOATTOSTR(roundto(strtofloat(formaDepago.impOS), -2)));
   error := fiscalEpson.establecercola(1, @comando[0]);
   comando := '';
   texto := strpcopy(comando, 'CO1: ' + formaDepago.impco1 + ' CO2: ' + formaDepago.impco2 + ' AFI: '
     + FLOATTOSTR(roundto(formaDepago.calcularTotalPorAfiliado, -2)));
   error := fiscalEpson.establecercola(2, @comando[0]);
   comando := '';
   texto := strpcopy(comando,
     'EF: ' + FLOATTOSTR(roundto(strtofloat(formaDepago.IMPEFECTIVO), -2)) + ' CH: ' +
     FLOATTOSTR(roundto(strtofloat(formaDepago.impCheque), -2)) + ' CC: ' +
     FLOATTOSTR(roundto(strtofloat(formaDepago.impCC), -2)) + ' TJ: ' +
     FLOATTOSTR(roundto(strtofloat(formaDepago.impTarjeta), -2)));
   error := fiscalEpson.establecercola(3, @comando[0]);
   comando := '';

   error := fiscalEpson.abrircomprobante(21);

   texto := strpcopy(comando,'--------------------------------------------------');
   error := fiscalEpson.ImprimirTextoLibre(comando);
   comando := '';
   texto := strpcopy(comando, 'Emision VR' + ticket.fiscla_pv + ': ' +
     ticket.fiscla_pv + (TUtils.rightpad(inttostr(nro_comprob), '0', 8)));
   error := fiscalEpson.ImprimirTextoLibre(comando);
   Application.ProcessMessages;


end;



//----------------------------ENCABEZADO VALE --------------------------------//

procedure TTicketTEpson.establecerPieTicketVale;
begin
  comando:='';
  texto:=strpcopy(comando,'REF. CPBT. '+ticket.fiscla_pv+(TUtils.rightpad(inttostr(nro_comprob), '0', 8))) ;
  error :=fiscalEpson.ImprimirTextoLibre(comando);
 Application.ProcessMessages;

end;


procedure TTicketTEpson.imprimirCorteDeTicket;
begin
     comando:='';
     texto:=strpcopy(comando,'-----CORTAR-------------CORTAR------------CORTAR------------CORTAR------------️') ;
     error :=fiscalEpson.ImprimirTextoLibre(comando);
     Application.ProcessMessages;

end;

//----------------------------TICKET NO FISCAL-----------------------------//

procedure TTicketTEpson.iniciarTicketNoFiscal;
begin
  error := fiscalEpson.abrircomprobante(21);
  comando:='';
  texto:=strpcopy(comando,'DOCUMENTO NO FISCAL FARMACIAS') ;
  error :=fiscalEpson.ImprimirTextoLibre(comando);
  comando:='';
  texto:=strpcopy(comando,'NRO TICKET: '+ticket.fiscla_pv+(TUtils.rightpad(inttostr(nro_comprob), '0', 8))) ;
  error :=fiscalEpson.ImprimirTextoLibre(comando);
  comando:='';
  texto:=strpcopy(comando,'--------------------------------------------------') ;
  error :=fiscalEpson.ImprimirTextoLibre(comando);
  Application.ProcessMessages;

end;


//----------------------------TICKET NO FISCAL-----------------------------//

procedure TTicketTEpson.imprimirItemsTalonOS;
begin
  Gfacturador.DataSource.DataSet.First;

  while not Gfacturador.DataSource.DataSet.Eof do
  begin
      descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
      descripcioncortada:=copy(descripcion, 0, 20);

      comando:='';
      texto:=strpcopy(comando,(descripcioncortada)+'('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asstring)+')  '+floattostr(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat)) ;
      error :=fiscalEpson.ImprimirTextoLibre(comando);
      comando:='';
      texto:=strpcopy(comando,' ') ;
      error :=fiscalEpson.ImprimirTextoLibre(comando);

      Gfacturador.DataSource.DataSet.Next;
  end;
  Application.ProcessMessages;

end;


//----------------------------Finalizar Ticket-----------------------------//

procedure TTicketTEpson.finalizarTicket;
begin


  {Fin de codigo validacion online}
  FiscalEpson.EscribirEnCola('Numero de ref:' + (ticket.valnroreferencia));


  if not (ticket.puntos_farmavalor = '') or (ticket.puntos_farmavalor = '0') then
  begin
    FiscalEpson.EscribirEnCola('Puntos Farmavalor: ' + (ticket.puntos_farmavalor));
    FiscalEpson.EscribirEnCola('Los puntos se actualizan cada 24 hs');

  end;
  respuesta := '';
  tipcomprob := '';
  texto := strpcopy(tipcomprob, '83');
  error := fiscalEpson.ConsultarNumeroComprobanteActual(@respuesta, 2000);
  numeroc := respuesta;
  imprimi := true;
  if not ((numeroc = '') or (numeroc = 'Ninguno')) then
  begin
    nro_comprob := strtoint(respuesta);
    respuesta := '';
    ticket.fechafiscal := (now);
    ticket.numero_ticketfiscal := nro_comprob;
  end
  else
  begin
    imprimi := False;
  end;
   error:= fiscalEpson.cerrarComprobante();
  Application.ProcessMessages;

 end;

//----------------------------Finalizar Ticket-----------------------------//

//--------------------------COD BARRAS SEGUIMIENTO ----------------------------------//






//------------------------- COD BARRAS SEGUIMIENTO ----------------------------------//





//--------------------------descuento general----------------------------------//

procedure TTicketTEpson.aplicarDescuentoGral;
begin

  Gfacturador.DataSource.DataSet.First;
  while not Gfacturador.DataSource.DataSet.Eof do
  begin
    if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[22].FieldName).asfloat <> 0 then
    begin
      descripcion := (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
      if (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring) <> '' then
      begin
        descripcion := '(' + (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring) + ')' + descripcion;
      end;
      descripcioncortada := copy(descripcion, 0, 20);
      texto := strpcopy(comando, descripcioncortada);
      texto := strpcopy(precioep, floattostr((gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[24].FieldName).asfloat) * ticket.coeficientetarjeta));
      error := fiscalEpson.cargarajuste(400, comando, precioep, valorivaep, alfabetaep);
    end;
    Gfacturador.DataSource.DataSet.Next;
  end;
end;
//--------------------------descuento general----------------------------------//

 //--------------------------FORMA DE PAGO-------------------------------------//

procedure TTicketTEpson.RealizarPago(const imp: string; const tipoPago: Integer; const comandos: string);
begin
  if imp <> '0' then
  begin
    monto := '';
    texto := StrPCopy(monto, imp);
    texto := StrPCopy(comando, comandos);
    error := fiscalEpson.CargarPago(200, tipoPago, 0, monto, '', comando, '','');
  end;
end;

procedure TTicketTEpson.EstablecerFormaPagoEnTicket;
begin
        formaDePago:= TFormaDePago.Create;
        formaDePago.cargarFormaPago(ticket);

        afiliado:= formaDePago.calcularTotalPorAfiliado;

        if formaDePago.PagaConEfectivo then
          RealizarPago(formaDePago.ImpEfectivo, 8, '');

        if formaDePago.pagaConTarjeta  then
          RealizarPago(formaDePago.ImpTarjeta, 20, 'Tarjeta ' + ticket.codigotarjeta + ':');

        if formaDePago.pagaConCC  then
          RealizarPago(formaDePago.ImpCC, 6, 'CC ' + ticket.codigocc + ' ' + ticket.nombrecc);

        if formaDePago.pagaConCheque  then
          RealizarPago(formaDePago.ImpCheque, 3, '');

        if formaDePago.pagaConOS  then
          RealizarPago(formaDePago.ImpOS, 99, ticket.nombre_os);

        if formaDePago.pagaConCO1 then
          RealizarPago(formaDePago.impCO1, 99, ticket.nombre_co1);

        if formaDePago.pagaConCO2 then
          RealizarPago(formaDePago.ImpCO2, 99, ticket.nombre_cos2);



end;

 //--------------------------FORMA DE PAGO-------------------------------------//
 //-------------------------------------------------------------------------------//
//-----------------------------CARGA DE ITEMS------------------------------------//
procedure TTicketTEpson.imprimirItemsVale;
begin
  Gfacturador.DataSource.DataSet.First;

  while not Gfacturador.DataSource.DataSet.Eof do
  begin
    if Gfacturador.Fields[17].asstring = 'SI' then
    BEGIN
      comando := '';
      texto := strpcopy(comando,AnsiString(Gfacturador.Fields[1].AsString));
      error := fiscalEpson.ImprimirTextoLibre(comando);
      comando := '';
      texto := strpcopy(comando, 'Unidades Vale:' +
        (Gfacturador.Fields[18].asstring));
      error := fiscalEpson.ImprimirTextoLibre(comando);

    END;
    Gfacturador.DataSource.DataSet.Next;
  end;
  Application.ProcessMessages;

end;




 //-------------------------------------------------------------------------------//
//-----------------------------CARGA DE ITEMS------------------------------------//

 //-------------------------------------------------------------------------------//
//-----------------------------CARGA DE ITEMS------------------------------------//
procedure TTicketTEpson.cargarItemsEnTicket;
begin

  Gfacturador.DataSource.DataSet.First;
  while not Gfacturador.DataSource.DataSet.Eof do
  begin
    if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[11].FieldName).asstring = '0') then
    begin
      comando := '';
      texto := strpcopy(comando, ticket.codigo_OS + ': ' + (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[14].FieldName).asstring + ' (' + (formatfloat('#####', Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[11].FieldName).asfloat)) + '%)'));
      error := fiscalEpson.CargarTextoExtra(comando);
    end;
    if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[12].FieldName).asstring = '0') then
    begin
      comando := '';
      texto := strpcopy(comando, ticket.codigo_Co1 + ': ' + (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[20].FieldName).asstring + ' (' + (formatfloat('#####', Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[12].FieldName).asfloat)) + '%)'));
      error := fiscalEpson.CargarTextoExtra(comando);
    end;
    if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[13].FieldName).asstring = '0') then
    begin
      comando := '';
      texto := strpcopy(comando, ticket.codigo_CoS2 + ': ' + (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[27].FieldName).asstring + ' (' + (formatfloat('#####', Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[13].FieldName).asfloat)) + '%)'));
      error := fiscalEpson.CargarTextoExtra(comando);
    end;
    if not ((TICKET.sucursal = '202') or (TICKET.sucursal = '203') or (TICKET.sucursal = '221')) then
    begin
      if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[10].FieldName).asstring = 'B' then
      begin
        valorivaep := 5;
      end;
    end;
    if ((TICKET.sucursal = '202') or (TICKET.sucursal = '203') or (TICKET.sucursal = '221')) then
    begin
      if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[10].FieldName).asstring = 'B' then
      begin
        valorivaep := 1;
      end;
    end;
    if gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[10].FieldName).asstring = 'A' then
    begin
      valorivaep := 1;
    end;
    descripcion := (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
    if (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring) <> '0' then
    begin
      descripcion := '(' + (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[18].FieldName).asstring) + ')' + descripcion;
    end;
    descripcioncortada := copy(descripcion, 0, 20);
    comando := '';
    texto := strpcopy(comando, descripcioncortada);
    texto := strpcopy(cantidadep, (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asstring));
    texto := strpcopy(precioep, floattostr((gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat) * ticket.coeficientetarjeta));
    texto := strpcopy(alfabetaep, (gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[0].FieldName).asstring));
    error := fiscalEpson.ImprimirItem(200, comando, cantidadep, precioep, valorivaep, 0, (''), 1, alfabetaep, (''), 7);
    Gfacturador.DataSource.DataSet.Next;
  end;
  Application.ProcessMessages;

end;


procedure TTicketTEpson.crearTicketVale;
begin
    {Ticket correspondiente a farmacia}
    establecerEncabezadoVale;
    imprimirItemsVale;
    establecerPieTicketVale;
    imprimirCorteDeTicket;

    {Ticket correspondiente a afiliado}
    establecerEncabezadoTicketVale;
    imprimirItemsVale;
    establecerPieTicketVale;
    comando:='';
    error := fiscalEpson.CerrarComprobante();
   Application.ProcessMessages;

end;



procedure TTicketTEpson.ReimpresionTK;
begin
  // ------------------------------------------------------------------------------------//
  comando := '';
  texto := strpcopy(comando, '08F0|0001|083|' + inttostr(ticket.numero_ticketfiscal));
  error := fiscalEpson.enviarcomando(comando);
  comando := '';
  texto := strpcopy(comando, '08F6|0000');
  error := fiscalEpson.enviarcomando(comando);
end;


//-----------------------------------------------------------------------------//
//----------------------Direccion fiscal----------------------------------------//

procedure TTicketTEpson.EstablecerDireccionFiscalEnTicket;
begin
  //Setea el nombre del vendedor en el ticket

  comando := '';
  texto := strpcopy(comando, '050E|0000|' + (ticket.direccionsucursal));
  error := fiscalEpson.enviarcomando(@comando[0]);
end;

//-----------------------------------------------------------------------------//
//----------------------nombre vendedor----------------------------------------//
procedure TTicketTEpson.establecerNombreVendedor;
begin

  comando := '';
  texto := strpcopy(comando, 'Vendedor: ' + (ticket.nom_vendedor));
  error := fiscalEpson.establecerencabezado(1, @comando[0]);
end;



procedure TTicketTEpson.ImprimirTicket(var imprimio: Boolean; var reimpresion:boolean);
var
  respuesta_estado:LongInt;
begin

  // error  := ObtenerEstadoImpresora();
  // error := strtoint((IntToHex(error,8)));

  { fatal:=error;
    if fatal=0 then
    begin
    try }





  fiscalEpson.Conectar;
  error := fiscalEpson.ConsultarNumeroComprobanteUltimo('83', @respuesta, 2000);

  if not((respuesta = '') or (respuesta = 'Ninguno')) then
  begin
    verificarPapel;
      if not ImprimiParteTK then
      begin
       nro_comprobdigital := strtoint(respuesta);
       nro_comprobdigital := nro_comprobdigital +1;
       copiadigital;
       // ---------------------------borrado encabezados y cola-----------------------//
       fiscalEpson.borrarEncabezadoYCola;
       comando := '';
       establecerNombreVendedor;
       EstablecerDireccionFiscalEnTicket;
     // -----------------------------------------------------------------------------//
     // --------------------------apertura de comprobante C---------------------------//
      error := fiscalEpson.abrircomprobante(2);
      // -----------------------------CARGA DE ITEMS------------------------------------//
      cargarItemsEnTicket;
      // -----------------------------CARGA DE ITEMS------------------------------------//

      // ----------------------------descuento general---------------------------------//
      aplicarDescuentoGral;
      // ----------------------------descuento general---------------------------------//

      // ----------------------------PAGOS-----------------------------------------------//
       EstablecerFormaPagoEnTicket;
      // ----------------------------PAGOS-----------------------------------------------//
      // ----------------------------CERRAR TK-----------------------------------------------//
        finalizarTicket;
      // ----------------------------CERRAR TK-----------------------------------------------//
       ImprimiParteTK:= true;
     end;

    // -------------------borrado encabezado y cola------------------------------------------//
    fiscalEpson.borrarEncabezadoYCola;

    verificarPapel;

    if ImprimiParteTK and reimpresion then
       ReimpresionTK;

    ReimpresionTK; {Respaldo de caja o de obra social}




    // ----------------------------talon obras sociales-------------------------------------//

    if (ticket.codigo_OS <> '') or (ticket.codigo_Co1 <> '') or
      (ticket.codigo_Cos2 <> '') then
    begin

      error := fiscalEpson.cerrarComprobante();
      verificarPapel;
      EstablecerEncabezadoTalonOS;

      iniciarTicketNoFiscal;

      imprimirItemsTalonOS;

      imprimirCodBarrasSeguimientoOValidacion;

      error := fiscalEpson.cerrarComprobante();
      z := 0;
      if ticket.talon = 'S' then      {LLEVA COPIA DE TALON}
      BEGIN
        if ticket.codigo_OS <> '' then
        begin

          error := fiscalEpson.cerrarComprobante();
          verificarPapel;
          EstablecerEncabezadoTalonOS;

          iniciarTicketNoFiscal;
          imprimirItemsTalonOS;
           imprimirCodBarrasSeguimientoOValidacion;
          error := fiscalEpson.cerrarComprobante();
        end;
      END;

      if ticket.codigo_Co1 <> '' then
      begin
        z := z + 1
      end;
      comando := '';
      if z >= 1 then
      begin
        error := fiscalEpson.cerrarComprobante();
        verificarPapel;
        EstablecerEncabezadoTalonOS;

        iniciarTicketNoFiscal;
        imprimirItemsTalonOS;
        error := fiscalEpson.cerrarComprobante();

      end;

    end;

    // -------------------borrado encabezado y cola------------------------------------------//
    fiscalEpson.borrarEncabezadoYCola;
    // ------------------------------------------------------------------------------------//

    if ticket.llevavale = 'SI' then
    BEGIN
      verificarPapel;
      error := fiscalEpson.cerrarComprobante();

      crearTicketVale;
      if ticket.vale = 'S' then
      BEGIN

        crearTicketVale;

      END;

    END;

    Application.ProcessMessages;


        // Aquí puedes manejar el valor de error y respuesta_estado según sea necesario
        // Por ejemplo, mostrarlos en un MessageBox

    imprimi:=true;
    fiscalEpson.Desconectar;
  end;
end;

       {
procedure TTicketTEpson.imprimirFormaDePagoEnTicket;
begin

  fiscalEpson.escribirEnCola('REC: ' + FLOATTOSTR(ticket.importebruto) + '     OS: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpOS), -2)));
  fiscalEpson.escribirEnCola('CO1: ' + formaDePago.ImpCO1 + ' CO2: ' + formaDePago.ImpCO2 + ' AFI: ' + FLOATTOSTR(roundto(formaDePago.calcularTotalPorAfiliado, -2)));
   fiscalEpson.escribirEnCola('EF: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpEfectivo), -2)) + ' CH: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpCheque), -2)) + ' CC: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpCC), -2)) + ' TJ: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpTarjeta), -2)));

end;
             }


end.
