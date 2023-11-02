unit Udticket;

interface
            uses Classes, system.Generics.collections, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, MSXML, udmfacturador;

Type

TTasaIVA=class(Tobject)
  codigoIVA:String;
  netogravado: double;
  netogravadodesc: double;

  Constructor Create; overload;
  function importeTotal:Double;
  function getPorcentajeIVA:Double;

end;

  TTicketItem=class(TObject)
    nro_item:Integer;
    cod_barras:String;
    cod_troquel:String;
    cod_alfabeta:String;
    importe_unitario:Double;
    cantidad:Integer;
    porcentaje_cobertura:Double;
    importe_cobertura:Double;
    cod_iva:string;
    descuento:Double;
    cod_laboratorio:String;
    cod_rubro: string;
    codautorizacion: string;

    end;

 Titemsonline=class(TObject)
   cod_alfabeta:string;
   cantidadonline:integer;
   nombreonline: string;

   end;

  TTicketItemVAL=class(TObject)
    nro_itemVAL:string;
    cod_barrasVAL:String;
    cod_troquelVAL:String;
    cod_alfabetaVAL:String;
    importe_unitarioVAL:string;
    cantidadVAL:string;
    cantidadaprobada: string;
    porcentaje_coberturaVAL: string;
    importe_coberturaVAL:string;
    descripcionval:string;
    msjitemval: string;
    importe_afiliado: string;
    codautorizacion: string;
    cod_rta: string;




  end;

  TTicket =  class(TObject)

    afiliado_numero:String;
    afiliado_numeroco1:string;
    afiliado_nombre:String;
    afiliado_nombreco1:string;
    afiliado_apellido:String;
    afiliado_apellidoco1:String;
    medico_apellido:String;
    medico_apellidoco1:String;

    medico_nombre:String;
    medico_nombreco1:String;
    medico_tipo_matricula:String;
    medico_tipo_matriculaco1:String;
    medico_nro_matricula:String;
    medico_nro_matriculaco1:String;
    medico_codigo_provincia:String;
    medico_codigo_provinciaco1:String;

    puestocambio: string;
    cajacambio: string;
    fechacaja:TDate;
    fechaactual:string;
    hora:TTime;
    fecha_receta:tdate;
    fecha_recetaco1:tdate;
    numero_receta: string;
    numero_recetaco1: string;
    numero_ticketfiscal: integer;
    codigo_OS:String;
    nombre_os: string;
    codigo_Co1:String;
    nombre_co1: string;
    codigo_Cos2:String;
    nombre_cos2: string;
    codigo_validador: string;
    codigoos_validador: string;
    cod_afiliadoplanos: string;
    info_adicional: string;
    pide_dni: string;
    codigo_seguridad: string;
    documento: string;
    dias_validez: string;
    dias_validezco: string;
    codigoos_prestador: string;
    codigo_tratamiento: string;
    CodAccion: string;
    path_validador: string;
    path_respuesta: string;
    codigo_os_validador: string;
    codigo_planos_validador: string;
    nro_caja: string;
    cod_vendedor: string;
    nom_vendedor: string;
    itemstotales: integer;
    importebruto: double;
    importeneto: double;
    importegentileza: double;
    saldocc: double;
    alfabetastock: string;
    nombrestock: string;
    estadoticket: integer;
    importetotal_iva: double;
    importetotalsin_iva: double;
    importetotaldescuento: double;
    importecargoos: double;
    importecargoco1: double;
    importecargoco2: double;
    efectivo: double;
    tarjeta: double;
    cheque: double;
    ctacte: double;



    TotalesIVA: TDictionary <STRING, TTasaIVA>;
    codigocheque: string;
    numerocheque: string;
    codigotarjeta: string;
    coeficientetarjeta: double;
    cod_cliente: string;
    puntos_farmavalor: string;
    recargo: string;
    cuitsucursal:string;


    codigocc: string;
    nombrecc: string;
    codigosubcc: string;
    valecantidad: string;
    valecantidadmax: string;
    llevavale: string;

    //-----------------proveedor online--------/
    cuitproveedor: string;
    facturaproveedor: string;

    //----------------historial afiliado-------------------//
    afiliadohistorial: string;
    //-------------------droga------------------------//
    monodroga: string;
    desdroga: string;




   //----------------nrocomprobantenofiscal-----------//
    nrocomprobantenf: string;
    marstock: string;
    rankingcompra: string;
    rankingventa: string;


   //--------------------clave modificar precios----------//

   clavemodificar: string;
   p441f: string;
   claveok: string;
   perfil: string;
   modulocaja: string;
   ventanas: string;
   ofertas: string;
   region: string;
   fiscal: string;
   talon: string;
   cola: string;
   vale: string;



    fec_operativa: tdate;
    nombre_terminal: string;
    fiscla_pv: string;
    puerto_com: string;
    fechafiscal: tdatetime;
    sucursal: string;
    direccionsucursal: string;
    comprobante: string;
    tip_comprobante: string;

    CUIT: STRING;
    CONDICIONIVA:  STRING;
    DESCRIPCIONCLIENTE: STRING;
    codigocliente: STRING;
    direccion: string;
    telefono: string;
    url: string;
    dni: string;
    errores: string;



    items:  TList;
    itemsval: tlist;
    itemsonline: tlist;



//----datosvalidacion //
     valbono: string;
     valcodigorespuesta: string;
     valdescripcionrespuesta: string;
     valmsjrespuesta: string;
     valnroreferencia: string;
     nrorefadicional: string;
     nroticketadicional: string;
     valnro_item: string;
     valcod_troquel: string;
     valimporte_unitarioval: string;

//-------TABLA IVA------//

     IVAA: double;
     IVAB: double;
     IVAC: double;
     IVAD: double;
     IVAE: double;
     IVAF: double;
     IVAs: double;

     Constructor Create; overload;



end;


implementation

{ TTicket }

constructor TTicket.Create;
begin
   TotalesIVA:=TDictionary<string, TTasaIVA>.create;
   itemsOnLine:=Tlist.create();

end;


{ TTasaIVA }

constructor TTasaIVA.Create;
begin
  self.netogravado:=0;
  self.netogravadodesc:=0;
  self.codigoIVA:='';

end;

function TTasaIVA.getPorcentajeIVA: Double;
var
  unaTasa:Double;
    IVAA: double;
     IVAB: double;
     IVAC: double;
     IVAD: double;
     IVAE: double;
     IVAF: double;
     IVAs: double;
begin
unaTasa:=0;
   //-------------------------tablas ivas-------------------------------//
  dmfacturador.qtablaiva.Close;
  dmfacturador.qtablaiva.SQL.Text:=concat('select cod_iva, por_iva from prmaiva');
  dmfacturador.qtablaiva.Open;
  dmfacturador.qtablaiva.First;
  while not dmfacturador.qtablaiva.Eof do
  begin
  if dmfacturador.qtablaiva.Fields[0].Text='A' THEN
  BEGIN
    IVAA:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
  if dmfacturador.qtablaiva.Fields[0].Text='B' THEN
  BEGIN
    IVAB:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
    if dmfacturador.qtablaiva.Fields[0].Text='C' THEN
  BEGIN
    IVAC:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
    if dmfacturador.qtablaiva.Fields[0].Text='D' THEN
  BEGIN
    IVAD:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
      if dmfacturador.qtablaiva.Fields[0].Text='E' THEN
  BEGIN
    IVAE:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
      if dmfacturador.qtablaiva.Fields[0].Text='F' THEN
  BEGIN
    IVAF:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
      if dmfacturador.qtablaiva.Fields[0].Text='s' THEN
  BEGIN
    IVAs:=dmfacturador.qtablaiva.Fields[1].AsFloat;
  END;
  dmfacturador.qtablaiva.Next;
  end;

  //-------------------------tablas ivas-------------------------------//
if self.codigoIVA ='A' then unaTasa:=IVAA
  else if codigoIVA=  'B' then unaTasa:=IVAB
  else if codigoIVA='D' then unaTasa:=IVAD
  else if codigoIVA=  'E' then unaTasa:=IVAE
  else if codigoIVA=  's' then unaTasa:=IVAs;

 getPorcentajeIVA:=unaTasa;
end;


function TTasaIVA.importeTotal: Double;
begin
  importeTotal:=netogravado+netogravadodesc;
end;

end.
