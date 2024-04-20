unit uPagoEfectivo;

interface
  uses ubaseFormaPago;

  type TPagoEfectivo = class(TBaseFormaPago)
  private
    FImpEfectivo:double;
  public
    property imp_efectivo:double read FImpEfectivo write FImpEfectivo;
  end;
implementation

end.
