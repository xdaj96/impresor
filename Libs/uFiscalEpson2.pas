unit uFiscalEpson2;

interface

  uses Dialogs,SysUtils,windows,udTicket,Vcl.DBGrids,uFormaDePago,uUtils,Math;
    type TConsultarVersionDll = function(descripcion: PChar;
    descripcion_largo_maximo: LongInt; var mayor: LongInt; var menor: LongInt)
    : LongInt; StdCall;

 type TConfigurarVelocidad = function(velocidad: LongInt): LongInt; StdCall;

 type TConfigurarPuerto = function(velocidad: String): LongInt; StdCall;

 type TConectar = function(): LongInt; StdCall;

 type TImprimirCierreX = function(): LongInt; StdCall;

  type TImprimirCierreZ = function(): LongInt; StdCall;

  type TDesconectar = function(): LongInt; StdCall;

  type tEstablecerEncabezado = function(numero_encabezado: integer;
    descripcion: PAnsiChar): LongInt; StdCall;

  type tAbrirComprobante = function(id_tipo_documento: integer): LongInt; StdCall;

  type tCerrarComprobante = function(): LongInt; StdCall;

  type tEnviarComando = function(commando: PAnsiChar): LongInt; StdCall;

  type tConsultarEncabezado = function(numero_encabezado: integer; respuesta: string;
    respuesta_largo_maximo: integer): LongInt; StdCall;

  type tEstablecerCola = function(numero_cola: integer; descripcion: PAnsiChar)
    : LongInt; StdCall;

  type tCargarTextoExtra = function(descripcion: string): LongInt; StdCall;

  type TImprimirItem = function(id_modificador: integer; descripcion: PAnsiChar;
    cantidad: PAnsiChar; precio: PAnsiChar; id_tasa_iva: integer;
    ii_id: integer; ii_valor: PAnsiChar; id_codigo: integer; codigo: PAnsiChar;
    codigo_unidad_matrix: PAnsiChar; código_unidad_medida: integer)
    : LongInt; StdCall;

  type TCargarPago = function(id_modificador: integer; codigo_forma_pago: integer;
    cantidad_cuotas: integer; monto: PAnsiChar; descripción_cupones: PAnsiChar;
    descripcion: PAnsiChar; descripcion_extra1: PAnsiChar;
    descripcion_extra2: PAnsiChar): LongInt; StdCall;

  type TConsultarNumeroComprobanteUltimo = function(tipo_de_comprobante: PAnsiChar;
    respuesta: PAnsiChar; respuesta_largo_maximo: LongInt): LongInt; StdCall;

  type TObtenerRespuesta = function(buffer_salida: PAnsiChar;
    largo_buffer_salida: integer; largo_final_buffer_salida: integer)
    : LongInt; StdCall;

  type TConsultarNumeroComprobanteActual = function(respuesta: PAnsiChar;
    respuesta_largo_maximo: integer): LongInt; Stdcall;

  type TConsultarFechaHora = function(respuesta: PAnsiChar;
    respuesta_largo_maximo: integer): LongInt; Stdcall;

  type TCargarAjuste = function(id_modificador: integer; descripcion: PAnsiChar;
    monto: PAnsiChar; id_tasa_iva: integer; codigo_interno: PAnsiChar)
    : LongInt; Stdcall;

  type TObtenerRespuestaExtendida = function(numero_campo: LongInt;
    buffer_salida: PAnsiChar; largo_buffer_salida: LongInt;
    largo_final_buffer_salida: LongInt): LongInt; Stdcall;

  type TImprimirTextoLibre = function(descripcion: PAnsiChar): LongInt; Stdcall;


    type TFiscalEpson = class
      private
      comando: array [0..200] of AnsiChar;
      str : Array[0..200] of Char;
      Fnro_comprob:string;
      public
      dll: THandle;
      ConfigurarVelocidad: TConfigurarVelocidad;
      ConfigurarPuerto: TConfigurarPuerto;
      Conectar: TConectar;
      ImprimirCierreX: TImprimirCierreX;
      ImprimirCierreZ: TImprimirCierreZ;
      Desconectar: TDesconectar;
      ConsultarVersionDll: TConsultarVersionDll;
      establecerencabezado: tEstablecerEncabezado;
      ConsultarEncabezado: tConsultarEncabezado;
      abrircomprobante: tAbrirComprobante;
      CerrarComprobante: tCerrarComprobante;
      EnviarComando: tEnviarComando;
      EstablecerCola: tEstablecerCola;
      CargarTextoExtra: tCargarTextoExtra;
      ImprimirItem: TImprimirItem;
      CargarPago: TCargarPago;
      ConsultarNumeroComprobanteUltimo: TConsultarNumeroComprobanteUltimo;
      ObtenerRespuesta: TObtenerRespuesta;
      ConsultarNumeroComprobanteActual: TConsultarNumeroComprobanteActual;
      ConsultarFechaHora: TConsultarFechaHora;
      ObtenerRespuestaExtendida: TObtenerRespuestaExtendida;
      Cargarajuste: TCargarAjuste;
      ImprimirTextoLibre: TImprimirTextoLibre;
      error:integer;
      mayor :integer;
      menor :integer;
      mychar:string;
      texto: string;
      ticket:TTicket;
      afiliado:string;
      FformadePago:TFormaDePago;


      {Propiedades de items}
       alfabetaep: Array[0..200] of AnsiChar;
       valorivaep: integer;
       descripcion: string;
       descripcioncortada: string;
       cantidadep: Array[0..200] of AnsiChar;
       precioep: Array[0..200] of AnsiChar;

      {Fin Propiedades Items}

      property nro_comprob:string read Fnro_comprob write Fnro_comprob;

      constructor Create;
      procedure borrarEncabezado;
      procedure borrarCola;
      function configurarImpresor(unticket:TTicket):Integer;
      procedure GenerarEtiquetasBarcodes(codigo:string);
      procedure setVendedorEnTicket();
      procedure setClienteEnTicket();
      procedure setDireccionFiscal();
      procedure cargarItemsEnTicket(GFacturador:TDBGrid);
      procedure aplicarDescuentoGral(GFacturador:TDBGrid);
      procedure cargarFormaPago(formaDePago:TFormaDePago);
      procedure finalizarTK;
      procedure EstablecerEncabezadoTalonOS;
      procedure cargarItemsTalonOS(GFacturador:TDBGrid);
      procedure EstablecerEncabezadoVale;
      procedure cargarItemVale(GFacturador:TDBGrid);
      procedure imprimirDatosVale;
      procedure EstablecerLineaRecorte;
    end;



implementation


  constructor TFiscalEpson.Create;
  begin

     // copiadigital;
  dll := 0;

  // instanciar dll - recordar que se require "uses Windows"

  dll := LoadLibrary('C:\dll\EpsonFiscalInterface.dll');

  // check error
  if dll = 0 then
  begin
    ShowMessage('Error al instanciar DLL');
    Exit;
  end;

  {iniciar variables}
  error:=0;
  mayor := 0;
  menor := 0;
  mychar:=' ';


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

  @abrircomprobante := GetProcAddress(dll, 'AbrirComprobante');
  if not Assigned(abrircomprobante) then
  begin
    ShowMessage('Error al asignar funcion: AbrirComprobante');
    Exit;
  end;
  @CerrarComprobante := GetProcAddress(dll, 'CerrarComprobante');
  if not Assigned(abrircomprobante) then
  begin
    ShowMessage('Error al asignar funcion: CerrarComprobante');
    Exit;
  end;
  @establecerencabezado := GetProcAddress(dll, 'EstablecerEncabezado');
  if not Assigned(abrircomprobante) then
  begin
    ShowMessage('Error al asignar funcion: CerrarComprobante');
    Exit;
  end;
  @ConsultarEncabezado := GetProcAddress(dll, 'EstablecerEncabezado');
  if not Assigned(abrircomprobante) then
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

  @ConsultarNumeroComprobanteActual :=
    GetProcAddress(dll, 'ConsultarNumeroComprobanteActual');
  if not Assigned(ConsultarNumeroComprobanteActual) then
  begin
    ShowMessage('Error al asignar funcion: ConsultarNumeroComprobanteActual');
    Exit;
  end;
  @ConsultarFechaHora := GetProcAddress(dll, 'Consultarfechahora');
  if not Assigned(ConsultarNumeroComprobanteActual) then
  begin
    ShowMessage('Error al asignar funcion: Consultarfechahora');
    Exit;
  end;

  @ObtenerRespuestaExtendida := GetProcAddress(dll,
    'ObtenerRespuestaExtendida');
  if not Assigned(ObtenerRespuestaExtendida) then
  begin
    ShowMessage('Error al asignar funcion: ObtenerRespuestaExtendida');
    Exit;
  end;
  @Cargarajuste := GetProcAddress(dll, 'CargarAjuste');
  if not Assigned(Cargarajuste) then
  begin
    ShowMessage('Error al asignar funcion: CargarAjuste');
    Exit;
  end;

  @ImprimirTextoLibre := GetProcAddress(dll, 'ImprimirTextoLibre');
  if not Assigned(ImprimirTextoLibre) then
  begin
    ShowMessage('Error al asignar funcion: ImprimirTextoLibre');
    Exit;
  end;

  @ConsultarNumeroComprobanteUltimo :=
    GetProcAddress(dll, 'ConsultarNumeroComprobanteUltimo');
  if not Assigned(ConsultarNumeroComprobanteUltimo) then
  begin
    ShowMessage('Error al asignar funcion: ConsultarNumerocomprobanteultimo');
    Exit;
  end;
  end;

  procedure TFiscalEpson.borrarCola;
  begin
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
  end;


  procedure TFiscalEpson.borrarEncabezado;
  begin
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


  end;

  function TFiscalEpson.configurarImpresor(unticket:TTicket):Integer;
  begin
      ticket:= ticket;
      error := ConsultarVersionDll( str, 100, mayor, menor );
      error := ConfigurarVelocidad( 9600 );
      error := ConfigurarPuerto( ticket.puerto_com );
      error := CerrarComprobante();
      error := Conectar();
      Result:= error;
  end;

  procedure TFiscalEpson.GenerarEtiquetasBarcodes(codigo:string);
   const
    DOC_TYPE_DNF = 21;
var
  barcodeHRI_POS_NONE, barcodeHRI_POS_TOP, barcodeHRI_POS_BOTTOM, barcodeHRI_POS_BOTH: string;
  barcodeHRI_LETTER_FONT_A, barcodeHRI_LETTER_FONT_B: string;
  barcodeESC, barcodeID, barcodeTYPE, barcodeHEIGHT, barcodeWIDTH, barcodeHRI_POS, barcodeHRI_LETTER: string;
  bar1, bar2, bar3, bar4: string;
  error: integer;

  function ConstruirCodigoBarras(tipo, altura, ancho, posicionHRI, letraHRI, datos: string): string;
  begin
    Result := barcodeESC + barcodeID + tipo + altura + ancho + posicionHRI + letraHRI + datos;
  end;

begin
  // Definir constantes para códigos de barras
  barcodeHRI_POS_NONE := 'x''00''';
  barcodeHRI_POS_TOP := 'x''01''';
  barcodeHRI_POS_BOTTOM := 'x''02''';
  barcodeHRI_POS_BOTH := 'x''03''';

  barcodeHRI_LETTER_FONT_A := 'x''00''';
  barcodeHRI_LETTER_FONT_B := 'x''01''';

  barcodeESC := 'x''1B''';
  barcodeID := 'x''80''';

  // Generar Código de Barras #2
  barcodeTYPE := 'x''00''';
  barcodeHEIGHT := 'x''00''';
  barcodeWIDTH := 'x''00''';
  barcodeHRI_POS := barcodeHRI_POS_BOTTOM;
  barcodeHRI_LETTER := barcodeHRI_LETTER_FONT_A;
  bar2 := ConstruirCodigoBarras(barcodeTYPE, barcodeHEIGHT, barcodeWIDTH, barcodeHRI_POS, barcodeHRI_LETTER, '12345678901');

  // Generar Código de Barras #1
  barcodeTYPE := 'x''02''';
  barcodeHEIGHT := 'x''A2''';
  barcodeWIDTH := 'x''03''';
  barcodeHRI_POS := barcodeHRI_POS_BOTTOM;
  barcodeHRI_LETTER := barcodeHRI_LETTER_FONT_A;
  // Nota: Solo soporta 12 o 13 caracteres estrictamente
  bar1 := ConstruirCodigoBarras(barcodeTYPE, barcodeHEIGHT, barcodeWIDTH, barcodeHRI_POS, barcodeHRI_LETTER, '123456789012');

  // Generar Código de Barras #3
  barcodeTYPE := 'x''00''';
  barcodeHEIGHT := 'x''00''';
  barcodeWIDTH := 'x''00''';
  barcodeHRI_POS := barcodeHRI_POS_BOTTOM;
  barcodeHRI_LETTER := barcodeHRI_LETTER_FONT_A;
  bar3 := ConstruirCodigoBarras(barcodeTYPE, barcodeHEIGHT, barcodeWIDTH, barcodeHRI_POS, barcodeHRI_LETTER, '12345678901');

  // Generar Código de Barras #4 (forma antigua de enviar valores hexadecimales)
  bar4 := 'x''1b800230030000''200123456789';

  // Ejemplo de uso de EnviarComando
  error := EnviarComando(PAnsiChar(AnsiString('0E01|0000')));
  error := EnviarComando(PAnsiChar(AnsiString('0E02|0000|Forma nueva:')));
  error := EnviarComando(PAnsiChar(AnsiString('0E02|0000|' + bar1)));
  error := EnviarComando(PAnsiChar(AnsiString('0E02|0000|Forma antigua')));
  error := EnviarComando(PAnsiChar(AnsiString('0E02|0000|' + bar4)));
  error := EnviarComando(PAnsiChar(AnsiString('0E06|0001|1|' + bar1 + '|2|' + bar2 + '|3|' + bar3 + '|3')));

  // Ejemplo de uso de funciones relacionadas con comprobantes


  error := AbrirComprobante(DOC_TYPE_DNF);
  {error := CargarTextoExtra(bar1);
  error := CargarTextoExtra(bar4); }
  error := EstablecerCola(5, PAnsiChar(AnsiString(bar2)));
  error := EstablecerCola(8, PAnsiChar(AnsiString(bar4)));
  error := CerrarComprobante;
end;

//--------------------TICKET FISCAL------------------------------//

procedure TFiscalEpson.setVendedorEnTicket();

begin
    comando:='';
    texto:=strpcopy(comando,'Vendedor: '+(ticket.nom_vendedor)) ;
    error :=establecerencabezado (1, @comando[0]);
end;

procedure TFiscalEpson.setClienteEnTicket();
var
direccionCliente:string;
begin
   direccionCliente:=ticket.direccion;
   if direccionCliente='' then
   begin
    ticket.direccion:=ticket.DESCRIPCIONCLIENTE;
   end;
end;

procedure TFiscalEpson.setDireccionFiscal();
begin
    comando:='';
    texto:=strpcopy(comando,'050E|0000|'+(ticket.direccionsucursal)) ;
    error :=enviarcomando(@comando[0]);
end;

procedure TFiscalEpson.cargarItemsEnTicket(GFacturador:TDBGrid);


begin
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

                   texto:=strpcopy(precioep,floattostr((gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[2].FieldName).asfloat)*ticket.coeficientetarjeta)) ;

                   texto:=strpcopy(alfabetaep,(gfacturador.DataSource.DataSet.FieldByName(Gfacturador.Columns[0].FieldName).asstring)) ;

                   error:=ImprimirItem(200,comando,cantidadep,precioep,valorivaep,0,(''),1,alfabetaep,(''),7);

                   Gfacturador.DataSource.DataSet.Next;
                  end;
end;

  procedure TFiscalEpson.aplicarDescuentoGral(GFacturador: TDBGrid);
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
            error:= cargarajuste(400, comando, precioep, valorivaep, alfabetaep);

          end;
            Gfacturador.DataSource.DataSet.Next;
    end;


  end;


  procedure TFiscalEpson.cargarFormaPago(formaDePago:TFormaDePago);
  var
  monto:Pansichar;
  begin
     FformadePago:= formaDePago;
     afiliado:= floatTostr(formaDePago.calcularTotalPorAfiliado);
                if formaDePago.impEfectivo<>'0' then
                begin
                monto:='';
                texto:=strpcopy(monto,formaDePago.impEfectivo);
                comando:='';
                texto:=strpcopy(comando,'') ;
                error:= CargarPago(200,8,0,monto,'',comando,'','');
                end;

                if formaDePago.impTarjeta<>'0' then
                begin

                monto:='';
                texto:=strpcopy(monto,formaDePago.impTarjeta) ;
                comando:='';
                texto:=strpcopy(comando,'Tarjeta '+ticket.codigotarjeta+': ') ;
                error:= CargarPago(200,20,0,monto,'',comando,'','');
                end;

                if formaDePago.impCC<>'0' then
                begin

                monto:='';
                texto:=strpcopy(monto,formaDePago.impCC) ;
                comando:='';
                texto:=strpcopy(comando,'CC '+ticket.codigocc+' '+ticket.nombrecc) ;
                error:= CargarPago(200,6,0,monto,'',comando,'','');


                end;
                if formaDePago.impCheque<>'0' then
                begin

                 monto:='';
                texto:=strpcopy(monto,formaDePago.impCheque) ;
                comando:='';
                texto:=strpcopy(comando,'') ;
                error:= CargarPago(200,3,0,monto,'',comando,'','');



                end;
                if formaDePago.impOS<>'0' then
                begin

                monto:='';
                texto:=strpcopy(monto,formaDePago.impOS) ;
                comando:='';
                texto:=strpcopy(comando,ticket.nombre_os) ;
                error:= CargarPago(200,99,0,monto,'',comando,'','');


                end;
                if formaDePago.impCO1<>'0' then
                begin

                monto:='';
                texto:=strpcopy(monto,formaDePago.impCO1) ;
                comando:='';
                texto:=strpcopy(comando,ticket.nombre_co1) ;
                error:= CargarPago(200,99,0,monto,'',comando,'','');



                end;
                if formaDePago.impCO2 <>'0' then
                begin

                 monto:='';
                texto:=strpcopy(monto,formaDePago.impCO2) ;
                comando:='';
                texto:=strpcopy(comando,ticket.nombre_cos2) ;
                error:= CargarPago(200,99,0,monto,'',comando,'','');
                end;

  end;

  procedure TFiscalEpson.finalizarTK;
  begin
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

  end;

  //--------------------TICKET FISCAL------------------------------//


  //--------------------TALON DE OBRA SOCIALES------------------------------//


  procedure TFiscalEpson.EstablecerEncabezadoTalonOS;
  begin
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
                      texto:=strpcopy(comando,'Coseguro 2: '+ticket.codigo_Cos2+'-'+ticket.nombre_cos2) ;
                      error :=establecerencabezado (4, @comando[0]);
                      comando:='';
                      texto:=strpcopy(comando,'Afiliado: '+ticket.afiliado_apellido+' '+ticket.afiliado_nombre) ;
                      error :=establecerencabezado (5, @comando[0]);
                      comando:='';
                      texto:=strpcopy(comando,'Nro afiliado: '+ticket.afiliado_numero) ;
                      error :=establecerencabezado (6, @comando[0]);
                      comando:='';
                      texto:=strpcopy(comando,'Mat. Med: '+ticket.medico_nro_matricula) ;
                      error :=establecerencabezado (7, @comando[0]);
                      comando:='';
                      texto:=strpcopy(comando,'Receta: '+ticket.numero_receta) ;
                      error :=establecerencabezado (8, @comando[0]);
                      comando:='';
                      texto:=strpcopy(comando,'Numero de ref: '+ticket.valnroreferencia) ;
                      error :=establecerencabezado (10, @comando[0]);
                      comando:='';
                      texto:=strpcopy(comando,'REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(FformadePago.impOS),-2)) );
                      error :=establecercola (1, @comando[0]);
                      comando:='';
                      texto:=strpcopy(comando,'CO1: '+FformadePago.impCO1+' CO2: '+FformadePago.impCO2+' AFI: '+floattostr(roundto(strToFloat(afiliado),-2))) ;
                      error :=establecercola (2, @comando[0]);
                      comando:='';
                      texto:=strpcopy(comando,'EF: '+floattostr(roundto(strtofloat(FformadePago.IMPEFECTIVO),-2))+' CH: '+floattostr(roundto(strtofloat(FformadePago.impCheque),-2))+' CC: '+floattostr(roundto(strtofloat(FformadePago.impCC),-2))+' TJ: '+floattostr(roundto(strtofloat(FformadePago.impTarjeta),-2)) );
                      error :=establecercola (3, @comando[0]);

                      {-----------------------------------------------------------}

                       error :=abrircomprobante(21);

                      comando:='';
                      texto:=strpcopy(comando,'DOCUMENTO NO FISCAL FARMACIAS') ;
                      error :=ImprimirTextoLibre(comando);
                      comando:='';
                      texto:=strpcopy(comando,'NRO TICKET: '+ticket.fiscla_pv+(TUtils.rightpad(nro_comprob, '0', 8))) ;
                      error :=ImprimirTextoLibre(comando);
                      comando:='';
                      texto:=strpcopy(comando,'--------------------------------------------------') ;
                      error :=ImprimirTextoLibre(comando);


  end;

  procedure TFiscalEpson.cargarItemsTalonOS(GFacturador:TDBGrid);
  begin
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
  end;


  //--------------------TALON DE OBRA SOCIALES------------------------------//


  //--------------------VALES ------------------------------//
   procedure TFiscalEpson.EstablecerEncabezadoVale;
   begin


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
                  texto:=strpcopy(comando,'REC: '+FLOATTOSTR(ticket.importebruto)+'     OS: '+floattostr(roundto(strtofloat(FformaDePago.impOS),-2)) );
                  error :=establecercola (1, @comando[0]);
                  comando:='';
                  texto:=strpcopy(comando,'CO1: '+FformaDePago.impco1+' CO2: '+FformaDePago.impCO2+' AFI: '+floattostr(roundto(strToFloat(afiliado),-2))) ;
                  error :=establecercola (2, @comando[0]);
                  comando:='';
                  texto:=strpcopy(comando,'EF: '+floattostr(roundto(strtofloat(FformaDePago.impEfectivo),-2))+' CH: '+floattostr(roundto(strtofloat(FformaDePago.impCheque),-2))+' CC: '+floattostr(roundto(strtofloat(FformaDePago.impCC),-2))+' TJ: '+floattostr(roundto(strtofloat(FformaDePago.impTARJETA),-2)) );
                  error :=establecercola (3, @comando[0]);
                  comando:='';

                  error := abrircomprobante(21);

                  texto:=strpcopy(comando,'--------------------------------------------------') ;
                  error :=ImprimirTextoLibre(comando);
                  comando:='';
                  texto:=strpcopy(comando,'Emision VR'+ticket.fiscla_pv+': '+ticket.fiscla_pv+(TUtils.rightpad(nro_comprob, '0', 8))) ;
                  error :=ImprimirTextoLibre(comando);
   end;



   procedure TFiscalEpson.cargarItemVale(GFacturador:TDBGrid);
   begin

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
                  texto:=strpcopy(comando,'REF. CPBT. '+ticket.fiscla_pv+(TUtils.rightpad(nro_comprob, '0', 8))) ;
                  error :=ImprimirTextoLibre(comando);


   end;


   procedure TFiscalEpson.imprimirDatosVale;
   begin
     comando:='';
     texto:=strpcopy(comando,'Emision VR'+ticket.fiscla_pv+': '+ticket.fiscla_pv+(TUtils.rightpad(nro_comprob, '0', 8))) ;
     error :=ImprimirTextoLibre(comando);
     texto:=strpcopy(comando,'Vendedor: '+(ticket.nom_vendedor)) ;
     error :=ImprimirTextoLibre(comando);
     texto:=strpcopy(comando,'Obra Social: '+ticket.codigo_OS+'-'+ticket.nombre_os) ;
     error :=ImprimirTextoLibre(comando);
     texto:=strpcopy(comando,'Afiliado: '+ticket.afiliado_apellido+' '+ticket.afiliado_nombre) ;
     error :=ImprimirTextoLibre(comando);
     texto:=strpcopy(comando,'Fecha: '+(datetostr(now))) ;

   end;


  //--------------------VALES ------------------------------//

  procedure TFiscalEpson.EstablecerLineaRecorte;
  begin
     texto:=strpcopy(comando,'-----CORTAR-------------CORTAR------------CORTAR------------CORTAR------------️') ;
     error :=ImprimirTextoLibre(comando);
  end;





end.
