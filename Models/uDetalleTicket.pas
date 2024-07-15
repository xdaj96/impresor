unit uDetalleTicket;

interface
  uses sysUtils,Xml.xmldom, Xml.XMLIntf,msxmldom, xml.xmldoc;
   type
  TDetalleFactura = class
  private
    FNroTroquel: string;
    FNomLargo: string;
    FPrecio: string;
    FCantidad: string;
    FDescuentos: string;
    FPrecioTotalDesc: string;
    FPrecioTotal: string;
    FPorcentaje: string;
    FCodAlfabeta: string;
    FCodBarrasPri: string;
    FCodIVA: string;
    FPorcentajeOS: string;
    FPorcentajeCO1: string;
    FPorcentajeCO2: string;
    FDescuentosOS: string;
    FCodLaboratorio: string;
    FCanStk: string;
    FVale: string;
    FCanVale: string;
    FTamano: string;
    FDescuentoCO1: string;
    FModificado: string;
    FGentileza: string;
    FRubro: string;
    FImporteGent: string;
    FCodAutorizacion: string;
    FNroItem: string;
    FDescuentoCO2: string;
  public
    property NroTroquel: string read FNroTroquel write FNroTroquel;
    property NomLargo: string read FNomLargo write FNomLargo;
    property Precio: string read FPrecio write FPrecio;
    property Cantidad: string read FCantidad write FCantidad;
    property Descuentos: string read FDescuentos write FDescuentos;
    property PrecioTotalDesc: string read FPrecioTotalDesc write FPrecioTotalDesc;
    property PrecioTotal: string read FPrecioTotal write FPrecioTotal;
    property Porcentaje: string read FPorcentaje write FPorcentaje;
    property CodAlfabeta: string read FCodAlfabeta write FCodAlfabeta;
    property CodBarrasPri: string read FCodBarrasPri write FCodBarrasPri;
    property CodIVA: string read FCodIVA write FCodIVA;
    property PorcentajeOS: string read FPorcentajeOS write FPorcentajeOS;
    property PorcentajeCO1: string read FPorcentajeCO1 write FPorcentajeCO1;
    property PorcentajeCO2: string read FPorcentajeCO2 write FPorcentajeCO2;
    property DescuentosOS: string read FDescuentosOS write FDescuentosOS;
    property CodLaboratorio: string read FCodLaboratorio write FCodLaboratorio;
    property CanStk: string read FCanStk write FCanStk;
    property Vale: string read FVale write FVale;
    property CanVale: string read FCanVale write FCanVale;
    property Tamano: string read FTamano write FTamano;
    property DescuentoCO1: string read FDescuentoCO1 write FDescuentoCO1;
    property Modificado: string read FModificado write FModificado;
    property Gentileza: string read FGentileza write FGentileza;
    property Rubro: string read FRubro write FRubro;
    property ImporteGent: string read FImporteGent write FImporteGent;
    property CodAutorizacion: string read FCodAutorizacion write FCodAutorizacion;
    property NroItem: string read FNroItem write FNroItem;
    property DescuentoCO2: string read FDescuentoCO2 write FDescuentoCO2;

    procedure AssignFromXmlNode(const ANode: IXMLNode);
  end;


implementation
   procedure TDetalleFactura.AssignFromXmlNode(const ANode: IXMLNode);
   begin
  NroTroquel := ANode.ChildNodes['nro_troquel'].Text;
  NomLargo := ANode.ChildNodes['nom_largo'].Text;
  Precio := ANode.ChildNodes['precio'].Text;
  Cantidad := ANode.ChildNodes['cantidad'].Text;
  Descuentos := ANode.ChildNodes['descuentos'].Text;
  PrecioTotalDesc := ANode.ChildNodes['precio_totaldesc'].Text;
  PrecioTotal := ANode.ChildNodes['precio_total'].Text;
  Porcentaje := ANode.ChildNodes['porcentaje'].Text;
  CodAlfabeta := ANode.ChildNodes['cod_alfabeta'].Text;
  CodBarrasPri := ANode.ChildNodes['cod_barraspri'].Text;
  CodIVA := ANode.ChildNodes['cod_iva'].Text;
  PorcentajeOS := ANode.ChildNodes['porcentajeos'].Text;
  PorcentajeCO1 := ANode.ChildNodes['porcentajeco1'].Text;
  PorcentajeCO2 := ANode.ChildNodes['porcentajeco2'].Text;
  DescuentosOS := ANode.ChildNodes['descuentosos'].Text;
  CodLaboratorio := ANode.ChildNodes['cod_laboratorio'].Text;
  CanStk := ANode.ChildNodes['can_stk'].Text;
  Vale := ANode.ChildNodes['vale'].Text;
  CanVale := ANode.ChildNodes['can_vale'].Text;
  Tamano := ANode.ChildNodes['tamano'].Text;
  DescuentoCO1 := ANode.ChildNodes['descuentoco1'].Text;
  Modificado := ANode.ChildNodes['modificado'].Text;
  Gentileza := ANode.ChildNodes['gentileza'].Text;
  Rubro := ANode.ChildNodes['rubro'].Text;
  ImporteGent := ANode.ChildNodes['importegent'].Text;
  CodAutorizacion := ANode.ChildNodes['cod_autorizacion'].Text;
  NroItem := ANode.ChildNodes['NroItem'].Text;
  DescuentoCO2 := ANode.ChildNodes['descuentoco2'].Text;
end;
end.
