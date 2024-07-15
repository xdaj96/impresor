unit uPagoTarjeta;

interface
  uses ubaseFormaPago;

  type TPagoTarjeta = class(TBaseFormaPago)
  private
    FCodigo:string;
    FImporte:double;
  public
    property codigo:string read FCodigo write FCodigo;
    property importe:double read FImporte write FImporte;
  end;
implementation

end.

