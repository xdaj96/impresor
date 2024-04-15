﻿unit uTicketAEpson;

interface

uses uBaseTicket, uFiscalEpson, udTicket, sysUtils, Vcl.DBGrids, uFormaDePago,Dialogs,
  FiscalPrinterLib_TLB, math, uUtils;

type
  TTicketAEpson= class(TBaseTicket)

  private



    {Fin de variables de ticket}

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


  public

    { procedure imprimirFormaDePagoEnTicket;}
    {Variables de ticket ver si se pueden pasar a la clase padre...}
      dll  : THandle;
  error : LongInt;
  str : Array[0..200] of Char;
  mayor : LongInt;
  menor : LongInt;
  mychar: char;

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
    constructor Create(unTicket: TTicket; gridFacturador: TDBGRID);
     destructor Destroy;override;
    procedure ImprimirTicket(var imprimio: Boolean; var reimpresion:boolean); override;
    procedure reimpresionTK;
  end;

implementation

constructor TTicketAEpson.Create(unTicket: TTicket; gridFacturador: TDBGRID);
begin
  inherited;
 ticket:= unTicket;

     fiscalEpson.configurarImpresor(ticket);
     gFacturador:= gridFacturador;

end;

destructor TTicketAEpson.Destroy;
begin
  inherited;
end;




procedure TTicketAEpson.establecerNombreVendedor;
begin
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
          error :=FiscalEpson.enviarcomando(@comando[0]);

 //
         end;

           IF Ticket.CONDICIONIVA = 'CONSUMIDOR FINAL' THEN
         begin
          comando:='';
          texto:=strpcopy(comando,'0B01|0000|'+TICKET.DESCRIPCIONCLIENTE+'||'+TICKET.direccion+'|||D|'+ticket.dni+'|'+CODIGOIVA+'||||') ;
          error :=FiscalEpson.enviarcomando(@comando[0]);
  //
         end;



                //  error:=CargarComprobanteAsociado('');
//-----------------------------------------------------------------------------//
end;





//----------------------------TICKET NO FISCAL-----------------------------//

procedure TTicketAEpson.iniciarTicketNoFiscal;
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

//-------------------------------------------------------------------------//










//----------------------------TICKET NO FISCAL-----------------------------//






procedure TTicketAEpson.EstablecerDireccionFiscalEnTicket;
begin
//----------------------Direccion fiscal----------------------------------------//
  comando:='';
  texto:=strpcopy(comando,'050E|0000|'+(ticket.direccionsucursal)) ;

  error :=fiscalEpson.enviarcomando(@comando[0]);

 comando:='';

end;
//--------------------------descuento general----------------------------------//
procedure TTicketAEpson.aplicarDescuentoGral;
begin

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

                 error:= fiscalEpson.cargarajuste(400, comando, precioep, valorivaep, alfabetaep);

                end;
            Gfacturador.DataSource.DataSet.Next;

          end;



end;
//----------------------------descuento general---------------------------------//

procedure TTicketAEpson.finalizarTicket;
begin
  //finalizacion ticket-------------------------------------------------------------//
          comando:='';
          texto:=strpcopy(comando,'Numero de ref:' +(ticket.valnroreferencia)) ;
          error :=FiscalEpson.establecercola (1, @comando[0]);
          if not (ticket.puntos_farmavalor='') or (ticket.puntos_farmavalor='0') then
          begin
          comando:='';
          texto:=strpcopy(comando,'Puntos Farmavalor: '+(ticket.puntos_farmavalor)) ;
          error :=FiscalEpson.establecercola (2, @comando[0]);
          comando:='';
          texto:=strpcopy(comando,'Los puntos se actualizan cada 24 hs') ;
          error :=FiscalEpson.establecercola (3, @comando[0]);
          end;

end;




//----------------------------PAGOS-----------------------------------------------//

 //--------------------------FORMA DE PAGO-------------------------------------//

procedure TTicketAEpson.RealizarPago(const imp: string; const tipoPago: Integer; const comandos: string);
begin
  if imp <> '0' then
  begin
    monto := '';
    texto := StrPCopy(monto, imp);
    texto := StrPCopy(comando, comandos);
    error := fiscalEpson.CargarPago(200, tipoPago, 0, monto, '', comando, '','');
  end;
end;

procedure TTicketAEpson.EstablecerFormaPagoEnTicket;
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



//----------------------------PAGOS-----------------------------------------------//

procedure TTicketAEpson.imprimirItemsTalonOS;
begin
Gfacturador.DataSource.DataSet.First;

              while not Gfacturador.DataSource.DataSet.Eof do
              begin
                    descripcion:=(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[1].FieldName).asstring);
                    descripcioncortada:=copy(descripcion, 0, 20);

                    comando:='';
                    texto:=strpcopy(comando,(descripcioncortada)+'('+(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[3].FieldName).asstring)+')  '+floattostr(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat)) ;
                    error :=FiscalEpson.ImprimirTextoLibre(comando);
                    comando:='';
                    texto:=strpcopy(comando,' ') ;
                    error :=FiscalEpson.ImprimirTextoLibre(comando);

                    Gfacturador.DataSource.DataSet.Next;
              end;
end;



//-----------------------------CARGA DE ITEMS------------------------------------//

procedure TTicketAEpson.cargarItemsEnTicket;
begin

 Gfacturador.DataSource.DataSet.First;
while not Gfacturador.DataSource.DataSet.Eof do
          begin
                if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[11].FieldName).asstring='0') then
                begin
                comando:='';
                texto:=strpcopy(comando,ticket.codigo_OS +': '+(Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[14].FieldName).asstring+' ('+(formatfloat('#####', Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[11].FieldName).asfloat))+'%)')) ;
                error:= FiscalEpson.CargarTextoExtra( comando );
                end;
                if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[12].FieldName).asstring='0') then
                begin
                comando:='';
                texto:=strpcopy(comando,ticket.codigo_Co1 +': '+(Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[20].FieldName).asstring+' ('+(formatfloat('#####', Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[12].FieldName).asfloat))+'%)')) ;
                error:= FiscalEpson.CargarTextoExtra( comando ) ;
                end;
                if not (Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[13].FieldName).asstring='0') then
                begin
                comando:='';
                texto:=strpcopy(comando,ticket.codigo_CoS2 +': '+(Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[27].FieldName).asstring+' ('+(formatfloat('#####', Gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[13].FieldName).asfloat))+'%)')) ;
                error:= FiscalEpson.CargarTextoExtra( comando );
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

           error:=FiscalEpson.ImprimirItem(200,comando,cantidadep,precioep,valorivaep,0,(''),1,alfabetaep,(''),7);

           Gfacturador.DataSource.DataSet.Next;
          end;


end;
//-----------------------------CARGA DE ITEMS------------------------------------//


//----------------------------ENCABEZADO TICKET VALE-----------------------------//
procedure TTicketAEpson.establecerEncabezadoTicketVale;
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

procedure TTicketAEpson.establecerEncabezadoVale;
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

procedure TTicketAEpson.establecerPieTicketVale;
begin
  comando:='';
  texto:=strpcopy(comando,'REF. CPBT. '+ticket.fiscla_pv+(TUtils.rightpad(inttostr(nro_comprob), '0', 8))) ;
  error :=fiscalEpson.ImprimirTextoLibre(comando);

end;


procedure TTicketAEpson.imprimirCorteDeTicket;
begin
     comando:='';
     texto:=strpcopy(comando,'-----CORTAR-------------CORTAR------------CORTAR------------CORTAR------------️') ;
     error :=fiscalEpson.ImprimirTextoLibre(comando);

end;


 //-------------------------------------------------------------------------------//
//-----------------------------CARGA DE ITEMS------------------------------------//
procedure TTicketAEpson.imprimirItemsVale;
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

procedure TTicketAEpson.crearTicketVale;
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




procedure TTicketAEpson.ImprimirTicket(var imprimio: Boolean; var reimpresion:boolean);
var
tapaAbierta:Integer;
begin


  fiscalEpson.Conectar;
  verificarPapel;
  error:= FiscalEpson.ConsultarNumeroComprobanteUltimo('81',@respuesta,2000);

     if not ((respuesta='') or (respuesta='Ninguno') ) then
      begin
       if not ImprimiParteTK then
       begin
        nro_comprobdigital:=strtoint(respuesta)+1;
        copiadigital;
        //---------------------------borrado encabezados y cola-----------------------//
        fiscalEpson.borrarEncabezadoYCola;
        //-----------------------------------------------------------------------------//
        establecerNombreVendedor;
        EstablecerDireccionFiscalEnTicket;
        // -----------------------------------------------------------------------------//
        // --------------------------apertura de comprobante A---------------------------//
        // error := fiscalEpson.abrircomprobante(2);
        {Corresponde al ticket fiscal}
        cargarItemsEnTicket;
        aplicarDescuentoGral;
        EstablecerFormaPagoEnTicket;
        finalizarTicket;
        {Corresponde al ticket fiscal}
        imprimi:=true;
        respuesta:='';
        tipcomprob:='';
        ImprimiParteTK:= true;
        texto:=strpcopy(tipcomprob,'81') ;
        error:= FiscalEpson.ConsultarNumeroComprobanteActual(@respuesta,2000);
        numeroc:=respuesta;

        if not ((numeroc='') or (numeroc='Ninguno')) then
        begin
          nro_comprob:=strtoint(respuesta);
          respuesta:='';
          ticket.fechafiscal:=(now);
          ticket.numero_ticketfiscal:=nro_comprob;

        end
        else
          imprimi:=False;
        end;
        error := FiscalEpson.CerrarComprobante();
      end;

     //-------------------borrado encabezado y cola------------------------------------------//
      fiscalEpson.borrarEncabezadoYCola;

      if reimpresion and ImprimiParteTK then
      begin
        reimpresionTK;

      end;
       verificarPapel;
        reimpresionTK;
 //-----------REIMPRESION DE TICKET -------------------------------------------//
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
      verificarPapel;
      z := 0;
      if ticket.talon = 'S' then
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
      verificarPapel;
        error := fiscalEpson.cerrarComprobante();
        EstablecerEncabezadoTalonOS;

        iniciarTicketNoFiscal;
        imprimirItemsTalonOS;
        verificarPapel;
        error := fiscalEpson.cerrarComprobante();

      end;

    end;

    // -------------------borrado encabezado y cola------------------------------------------//
    fiscalEpson.borrarEncabezadoYCola;
    // ------------------------------------------------------------------------------------//

    if ticket.llevavale = 'SI' then
    BEGIN

      error := fiscalEpson.cerrarComprobante();
      verificarPapel;
      crearTicketVale;
      if ticket.vale = 'S' then
      BEGIN
        verificarPapel;
        crearTicketVale;

      END;

    END;
    fiscalEpson.Desconectar;
    imprimi:=true;
end;

procedure TTicketAEpson.reimpresionTK;
begin
  //------------------------------------------------------------------------------------//
  //-----------REIMPRESION DE TICKET -------------------------------------------//

  comando := '';
  texto := strpcopy(comando, '08F0|0001|081|' + inttostr(ticket.numero_ticketfiscal));
  error := FiscalEpson.enviarcomando(Comando);
  comando := '';

  texto := strpcopy(comando, '08F6|0000');
  error := FiscalEpson.enviarcomando(Comando);
end;




end.
