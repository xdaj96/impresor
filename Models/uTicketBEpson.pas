﻿unit uTicketBEpson;

interface

uses uBaseTicket, uFiscalEpson, udTicket, sysUtils, Vcl.DBGrids, uFormaDePago,
  FiscalPrinterLib_TLB, math, uUtils;

type
  TTicketBEpson= class(TBaseTicket)

  private

    fiscalEpson: TFiscalEpson;

    dll: THandle;
    error: LongInt;
    str: Array [0 .. 200] of Char;
    mayor: LongInt;
    menor: LongInt;
    mychar: Char;

    eSTADOFISCAL: string;
    z: integer;
    RESPONSABLEIVA: TiposDeResponsabilidades;
    valoriva: double;
    direccioncliente: olevariant;
    descripcioncortada: string;
    descripcion: string;
    efectivoredondeado: double;
    afiliado: double;
    prueba: Array [0 .. 200] of AnsiChar;
    comando: Array [0 .. 200] of AnsiChar;
    cantidadep: Array [0 .. 200] of AnsiChar;
    precioep: Array [0 .. 200] of AnsiChar;
    alfabetaep: Array [0 .. 200] of AnsiChar;
    monto: Array [0 .. 200] of AnsiChar;
    tipcomprob: Array [0 .. 200] of AnsiChar;
    respuesta: Array [0 .. 10000] of AnsiChar;
    numero: array [0 .. 10000] of LongInt;
    fechahora: array [0 .. 300] of AnsiChar;
    cliente: Array [0 .. 200] of AnsiChar;
    domicilio: Array [0 .. 200] of AnsiChar;
    cuitcliente: Array [0 .. 200] of AnsiChar;
    dnicliente: Array [0 .. 200] of AnsiChar;
    tipdoc: array [0 .. 200] of LongInt;
    respuesta_final_buffer_salida: integer;
    dnfh: string;
    valorivaep: integer;
    texto: string;
    CODIGOIVA: string;
    ofecupon: string;
    numeroc: string;
    nro_comprob:Integer;
    imprimi:boolean;

    procedure EstablecerClienteVendedor;

    procedure establecerNombreVendedor;
    procedure EstablecerDireccionFiscalEnTicket;
    procedure cargarItemsEnTicket;
    procedure EstablecerFormaPagoEnTicket;
    procedure RealizarPago(const imp: string; const tipoPago: Integer; const comandos: string);
    procedure aplicarDescuentoGral;
    procedure finalizarTicket;
    procedure EstablecerEncabezadoTalonOS;
    procedure iniciarTicketNoFiscal;
    procedure imprimirItemsTalonOS;
    procedure imprimirItemsVale;
    procedure establecerEncabezadoVale;
    procedure establecerEncabezadoTicketVale;
    procedure establecerPieTicketVale;
    procedure imprimirCorteDeTicket;
    procedure crearTicketVale;
  public

    constructor Create(unTicket: TTicket; gridFacturador: TDBGRID);
    procedure ImprimirTicket(var imprimio: Boolean); override;
  end;

implementation

constructor TTicketBEpson.Create(unTicket: TTicket; gridFacturador: TDBGRID);
begin

  TBaseTicket.Create(unTicket,gridFacturador);
  fiscalEpson := TFiscalEpson.Create;
  fiscalEpson.configurarImpresor(ticket);

end;

//----------------------------ENCABEZADO TALON OS-----------------------------//
procedure TTicketBEpson.EstablecerEncabezadoTalonOS;
begin
  comando := '';
  texto := strpcopy(comando, 'Vendedor: ' + ticket.nom_vendedor);
  error := fiscalEpson.establecerencabezado(1, @comando[0]);
  comando := '';
  texto := strpcopy(comando, 'Obra Social: ' + ticket.codigo_OS + '-' +
    ticket.nombre_os);
  error := fiscalEpson.establecerencabezado(2, @comando[0]);
  comando := '';
  texto := strpcopy(comando, 'Coseguro 1: ' + ticket.codigo_Co1 + '-' +
    ticket.nombre_co1);
  error := fiscalEpson.establecerencabezado(3, @comando[0]);
  comando := '';
  texto := strpcopy(comando, 'Coseguro 2: ' + ticket.codigo_Cos2 + '-' +
    ticket.nombre_cos2);
  error := fiscalEpson.establecerencabezado(4, @comando[0]);
  comando := '';
  texto := strpcopy(comando, 'Afiliado: ' + ticket.afiliado_apellido + ' ' +
    ticket.afiliado_nombre);
  error := fiscalEpson.establecerencabezado(5, @comando[0]);
  comando := '';
  texto := strpcopy(comando, 'Nro afiliado: ' + ticket.afiliado_numero);
  error := fiscalEpson.establecerencabezado(6, @comando[0]);
  comando := '';
  texto := strpcopy(comando, 'Mat. Med: ' + ticket.medico_nro_matricula);
  error := fiscalEpson.establecerencabezado(7, @comando[0]);
  comando := '';
  texto := strpcopy(comando, 'Receta: ' + ticket.numero_receta);
  error := fiscalEpson.establecerencabezado(8, @comando[0]);
  comando := '';
  texto := strpcopy(comando, 'Numero de ref: ' + ticket.valnroreferencia);
  error := fiscalEpson.establecerencabezado(10, @comando[0]);
  comando := '';
  texto := strpcopy(comando, 'REC: ' + FLOATTOSTR(ticket.importebruto) +
    '     OS: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpOS), -2)));
  error := fiscalEpson.establecercola(1, @comando[0]);
  comando := '';
  texto := strpcopy(comando, 'CO1: ' + formaDePago.ImpCO1 + ' CO2: ' +
    formaDePago.ImpCO2 + ' AFI: ' +
    FLOATTOSTR(roundto(formaDePago.calcularTotalPorAfiliado, -2)));
  error := fiscalEpson.establecercola(2, @comando[0]);
  comando := '';
  texto := strpcopy(comando,
    'EF: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpEfectivo), -2)) +
    ' CH: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpCheque), -2)) +
    ' CC: ' + FLOATTOSTR(roundto(strtofloat(formaDePago.ImpCC), -2)) + ' TJ: ' +
    FLOATTOSTR(roundto(strtofloat(formaDePago.ImpTarjeta), -2)));
  error := fiscalEpson.establecercola(3, @comando[0]);

end;




//----------------------------ENCABEZADO TALON OS-----------------------------//


//----------------------------ENCABEZADO TICKET VALE-----------------------------//
procedure TTicketBEpson.establecerEncabezadoTicketVale;
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

end;



//----------------------------ENCABEZADO TICKET VALE-----------------------------//


//----------------------------ENCABEZADO VALE --------------------------------//

procedure TTicketBEpson.establecerEncabezadoVale;
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


end;



//----------------------------ENCABEZADO VALE --------------------------------//

procedure TTicketBEpson.establecerPieTicketVale;
begin
  comando:='';
  texto:=strpcopy(comando,'REF. CPBT. '+ticket.fiscla_pv+(TUtils.rightpad(inttostr(nro_comprob), '0', 8))) ;
  error :=fiscalEpson.ImprimirTextoLibre(comando);

end;


procedure TTicketBEpson.imprimirCorteDeTicket;
begin
     comando:='';
     texto:=strpcopy(comando,'-----CORTAR-------------CORTAR------------CORTAR------------CORTAR------------️') ;
     error :=fiscalEpson.ImprimirTextoLibre(comando);

end;

//----------------------------TICKET NO FISCAL-----------------------------//

procedure TTicketBEpson.iniciarTicketNoFiscal;
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

end;


//----------------------------TICKET NO FISCAL-----------------------------//

procedure TTicketBEpson.imprimirItemsTalonOS;
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

end;

//----------------------------Finalizar Ticket-----------------------------//

procedure TTicketBEpson.finalizarTicket;
begin


  comando := '';
  texto := strpcopy(comando, 'Numero de ref:' + (ticket.valnroreferencia));
  error := fiscalEpson.establecercola(1, @comando[0]);

  if not (ticket.puntos_farmavalor = '') or (ticket.puntos_farmavalor = '0') then
  begin
    comando := '';
    texto := strpcopy(comando, 'Puntos Farmavalor: ' + (ticket.puntos_farmavalor));
    error := fiscalEpson.establecercola(2, @comando[0]);
    comando := '';
    texto := strpcopy(comando, 'Los puntos se actualizan cada 24 hs');
    error := fiscalEpson.establecercola(3, @comando[0]);
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

 end;

//----------------------------Finalizar Ticket-----------------------------//

//--------------------------descuento general----------------------------------//

procedure TTicketBEpson.aplicarDescuentoGral;
begin
  GFacturador.DataSource.DataSet.First;
    while not GFacturador.DataSource.DataSet.Eof do
    begin
      if GFacturador.DataSource.DataSet.FieldByName
        (GFacturador.Columns[22].FieldName).asfloat <> 0 then
      begin
        descripcion :=
          (GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[1]
          .FieldName).asstring);
        if (GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[18]
          .FieldName).asstring) <> '' then
        BEGIN
          descripcion := '(' +
            (GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[18]
            .FieldName).asstring) + ')' + descripcion;
        END;

        descripcioncortada := copy(descripcion, 0, 20);
        texto := strpcopy(comando, descripcioncortada);
        texto := strpcopy(precioep,
          floattostr((GFacturador.DataSource.DataSet.FieldByName
          (GFacturador.Columns[24].FieldName).asfloat) *
          ticket.coeficientetarjeta));

        error := fiscalEpson.CargarAjuste(400, comando, precioep, valorivaep, alfabetaep);

      end;
      GFacturador.DataSource.DataSet.Next;

    end;
end;
//--------------------------descuento general----------------------------------//

 //--------------------------FORMA DE PAGO-------------------------------------//

procedure TTicketBEpson.RealizarPago(const imp: string; const tipoPago: Integer; const comandos: string);
begin
  if imp <> '0' then
  begin
    monto := '';
    texto := StrPCopy(monto, imp);
    texto := StrPCopy(comando, comandos);
    error := fiscalEpson.CargarPago(200, tipoPago, 0, monto, '', comando, '','');
  end;
end;

procedure TTicketBEpson.EstablecerFormaPagoEnTicket;
begin
        
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
procedure TTicketBEpson.imprimirItemsVale;
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

end;




 //-------------------------------------------------------------------------------//
//-----------------------------CARGA DE ITEMS------------------------------------//

 //-------------------------------------------------------------------------------//
//-----------------------------CARGA DE ITEMS------------------------------------//
procedure TTicketBEpson.cargarItemsEnTicket;
begin
    GFacturador.DataSource.DataSet.First;
    while not GFacturador.DataSource.DataSet.Eof do
    begin
      if not(GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[11]
        .FieldName).asstring = '0') then
      begin
        comando := '';
        texto := strpcopy(comando, ticket.codigo_OS + ': ' +
          (GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[14]
          .FieldName).asstring + ' (' + (formatfloat('#####',
          GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[11]
          .FieldName).asfloat)) + '%)'));
        error := FiscalEpson.CargarTextoExtra(comando)
      end;
      if not(GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[12]
        .FieldName).asstring = '0') then
      begin
        comando := '';
        texto := strpcopy(comando, ticket.codigo_Co1 + ': ' +
          (GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[20]
          .FieldName).asstring + ' (' + (formatfloat('#####',
          GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[12]
          .FieldName).asfloat)) + '%)'));
        error := FiscalEpson.CargarTextoExtra(comando)
      end;
      if not(GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[13]
        .FieldName).asstring = '0') then
      begin
        comando := '';
        texto := strpcopy(comando, ticket.codigo_CoS2 + ': ' +
          (GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[27]
          .FieldName).asstring + ' (' + (formatfloat('#####',
          GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[13]
          .FieldName).asfloat)) + '%)'));
        error := FiscalEpson.CargarTextoExtra(comando)
      end;
      if NOT((ticket.sucursal = '202') OR (ticket.sucursal = '203') OR
        (ticket.sucursal = '221')) then
      BEGIN
        if GFacturador.DataSource.DataSet.FieldByName
          (GFacturador.Columns[10].FieldName).asstring = 'B' then
        begin
          valorivaep := 5;
        end;
      END;
      if ((ticket.sucursal = '202') OR (ticket.sucursal = '203') OR
        (ticket.sucursal = '221')) then
      BEGIN
        if GFacturador.DataSource.DataSet.FieldByName
          (GFacturador.Columns[10].FieldName).asstring = 'B' then
        begin
          valorivaep := 1;
        end;
      END;
      if GFacturador.DataSource.DataSet.FieldByName
        (GFacturador.Columns[10].FieldName).asstring = 'A' then
      begin
        valorivaep := 1;
      end;

      descripcion := (GFacturador.DataSource.DataSet.FieldByName
        (GFacturador.Columns[1].FieldName).asstring);

      if (GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[18]
        .FieldName).asstring) <> '0' then
      BEGIN
        descripcion := '(' +
          (GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[18]
          .FieldName).asstring) + ')' + descripcion;
      END;

      descripcioncortada := copy(descripcion, 0, 20);
      comando := '';
      texto := strpcopy(comando, descripcioncortada);

      texto := strpcopy(cantidadep,
        (GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[3]
        .FieldName).asstring));

      if valorivaep = 5 then
      begin
        texto := strpcopy(precioep,
          floattostr(((GFacturador.DataSource.DataSet.FieldByName
          (GFacturador.Columns[2].FieldName).asfloat) *
          ticket.coeficientetarjeta) / 1.21));

      end;
      if valorivaep = 1 then
      begin
        texto := strpcopy(precioep,
          floattostr(((GFacturador.DataSource.DataSet.FieldByName
          (GFacturador.Columns[2].FieldName).asfloat) *
          ticket.coeficientetarjeta)));
      end;

      texto := strpcopy(alfabetaep,
        (GFacturador.DataSource.DataSet.FieldByName(GFacturador.Columns[0]
        .FieldName).asstring));

      error := FiscalEpson.ImprimirItem(200, comando, cantidadep, precioep, valorivaep, 0,
        (''), 1, alfabetaep, (''), 7);

      GFacturador.DataSource.DataSet.Next;
    end;

end;


 // -------------------------------------------------------------------------------//
    // -----------------------------CARGA DE ITEMS------------------------------------//





procedure TTicketBEpson.crearTicketVale;
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

end;


//-----------------------------------------------------------------------------//
//----------------------Direccion fiscal----------------------------------------//

procedure TTicketBEpson.EstablecerDireccionFiscalEnTicket;
begin
  //Setea el nombre del vendedor en el ticket

  comando := '';
  texto := strpcopy(comando, '050E|0000|' + (ticket.direccionsucursal));
  error := fiscalEpson.enviarcomando(@comando[0]);
end;

//-----------------------------------------------------------------------------//
//----------------------nombre vendedor----------------------------------------//
procedure TTicketBEpson.establecerNombreVendedor;
begin

  comando := '';
  texto := strpcopy(comando, 'Vendedor: ' + (ticket.nom_vendedor));
  error := fiscalEpson.establecerencabezado(1, @comando[0]);
end;


procedure TTicketBEpson.EstablecerClienteVendedor;
begin
  // -----------------------------------------------------------------------------//
  // ----------------------cliente y vendedor----------------------------------------//
  direccioncliente := ticket.direccion;
  if direccioncliente = '' then
  begin
    ticket.direccion := ticket.DESCRIPCIONCLIENTE;
  end;
  if ticket.CONDICIONIVA = 'RESPONSABLE MONOTRIBUTO' then
    CODIGOIVA := 'M'
  else if ticket.CONDICIONIVA = 'RESPONSABLE NO INSCRIPTO' then
    CODIGOIVA := 'N'
  else if ticket.CONDICIONIVA = 'EXENTO' then
    CODIGOIVA := 'E'
  else if ticket.CONDICIONIVA = 'RESPONSABLE INSCRIPTO' then
    CODIGOIVA := 'I'
  else if ticket.CONDICIONIVA = 'CONSUMIDOR FINAL' then
    CODIGOIVA := 'F';
  { I = Responsable Inscripto
      N = No Responsable
      M = Monotributista
      E = Exento
      U = No Categorizado
      F = Consumidor Final
      T = Monotributista Social
      P = Monotributo Trabajador Independiente Promovido }
  { comando:='';
      texto:=strpcopy(comando,'Vendedor: '+(ticket.nom_vendedor)) ;
      error :=establecerencabezado (1, @comando[0]);
      comando:='';
      texto:=strpcopy(comando,'Direccion cliente: '+ticket.direccion) ;
      error :=establecerencabezado (2, @comando[0]);
      domicilio:='';
      texto:=strpcopy(domicilio,ticket.direccion) ;
      cliente:='';
      texto:=strpcopy(cliente,ticket.DESCRIPCIONCLIENTE) ;
      cuitcliente:='';
      texto:=strpcopy(cuitcliente,ticket.CUIT) ; }
  dnicliente := '';
  if ticket.dni = '' then
  begin
    ticket.dni := '1';
  end;
  if ticket.dni <> '' then
  begin
    ticket.dni := trim(ticket.dni);
  end;
  ticket.CUIT := trim(ticket.CUIT);
  if ticket.CONDICIONIVA <> 'CONSUMIDOR FINAL' then
  begin
    comando := '';
    texto := strpcopy(comando, '0B01|0000|' + ticket.DESCRIPCIONCLIENTE + '||' + ticket.direccion + '|||T|' + ticket.CUIT + '|' + CODIGOIVA + '||||');
    error := fiscalEpson.EnviarComando(@comando[0]);
  end;
  if ticket.CONDICIONIVA = 'CONSUMIDOR FINAL' then
  begin
    comando := '';
    texto := strpcopy(comando, '0B01|0000|' + ticket.DESCRIPCIONCLIENTE + '||' + ticket.direccion + '|||D|' + ticket.dni + '|' + CODIGOIVA + '||||');
    error := fiscalEpson.EnviarComando(@comando[0]);
  end;
end;




procedure TTicketBEpson.imprimirTicket(var imprimio: boolean);

begin


  error := fiscalEpson.ConsultarNumeroComprobanteUltimo('82', @respuesta, 2000);

  if not((respuesta = '') or (respuesta = 'Ninguno')) then
  begin

    nro_comprobdigital := strtoint(respuesta) + 1;
    copiadigital;
    // ---------------------------borrado encabezados y cola-----------------------//
      fiscalEpson.borrarEncabezadoYCola;
      EstablecerClienteVendedor;

    // error:=CargarComprobanteAsociado('');

    // -----------------------------------------------------------------------------//
    // ----------------------Direccion fiscal----------------------------------------//
      EstablecerDireccionFiscalEnTicket;
    { texto:=strpcopy(comando,'0B01|0000|Nombre Comprador #1||TODOS PUTOS|||T|30614104712|E|083-00001-00000027|||') ;

      error :=enviarcomando(@comando[0]); }

    // --------------------------apertura de comprobante B---------------------------//

    // error := abrircomprobante(2);
     cargarItemsEnTicket;


    // --------------------------descuento general----------------------------------//
       aplicarDescuentoGral;

    // ----------------------------descuento general---------------------------------//

    // ----------------------------PAGOS-----------------------------------------------//
      EstablecerFormaPagoEnTicket;
    // ----------------------------PAGOS-----------------------------------------------//
    // finalizacion ticket-------------------------------------------------------------//
    finalizarTicket;




  // -------------------borrado encabezado y cola------------------------------------------//
   fiscalEpson.borrarEncabezadoYCola;

  // ------------------------------------------------------------------------------------//
  comando := '';
  texto := strpcopy(comando, '08F0|0001|082|' +
    inttostr(ticket.numero_ticketfiscal));
  error := fiscalEpson.EnviarComando(comando);
  comando := '';
  texto := strpcopy(comando, '08F6|0000');
  error := fiscalEpson.EnviarComando(comando);



  // ----------------------------talon obras sociales-------------------------------------//

  if (ticket.codigo_OS <> '') or (ticket.codigo_Co1 <> '') or
    (ticket.codigo_CoS2 <> '') then
  begin
       error := fiscalEpson.cerrarComprobante();

      EstablecerEncabezadoTalonOS;

      iniciarTicketNoFiscal;

      imprimirItemsTalonOS;

      error := fiscalEpson.cerrarComprobante();

    if ticket.codigo_OS <> '' then
    begin
      z := z + 1
    end;
    if ticket.codigo_Co1 <> '' then
    begin
      z := z + 1
    end;
    comando := '';
    if z > 1 then
    begin
       error := fiscalEpson.cerrarComprobante();
        EstablecerEncabezadoTalonOS;
        iniciarTicketNoFiscal;
        imprimirItemsTalonOS;
        error := fiscalEpson.cerrarComprobante();




    end;

  end;

  //-------------------borrado encabezado y cola------------------------------------------//
    fiscalEpson.borrarEncabezadoYCola;
  //------------------------------------------------------------------------------------//

    if ticket.llevavale = 'SI' then
    BEGIN

      error := fiscalEpson.cerrarComprobante();

      crearTicketVale;
      if ticket.vale = 'S' then
      BEGIN
        crearTicketVale;

      END;

    END;

  // ----------------------------talon obras sociales-------------------------------------//
   fiscalEpson.free;
    if imprimi <> False then
    begin
      imprimi := true;
    end;




  // finalizacion ticket-------------------------------------------------------------//

end;
end;

end.