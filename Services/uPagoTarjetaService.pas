unit uPagoTarjetaService;

interface
  uses sysUtils,uPagoTarjetaDAO,uPagoTarjeta,uFormaPagoService,uBaseFormaPago;

 type TPagoTarjetaService = class(TFormaPagoService)
  private
    pagoDAO:TPagoTarjetaDAO;
  public
    procedure registrarFormaPago(formaPago:TBaseFormaPago);override;
    constructor Create;

 end;
implementation




constructor TPagoTarjetaService.Create;
begin
   pagoDAO:= TPagoTarjetaDAO.Create;
end;

procedure TPagoTarjetaService.registrarFormaPago(formaPago:TBaseFormaPago);
begin

  if not (formaPago is TPagoTarjeta) then
     raise Exception.Create('La forma de pago ingresada no es tarjeta');

  try
      pagoDAO.iniciarTransaccion;
      pagoDAO.insertar(TPagoTarjeta(formaPago));
      pagoDAO.commit;
   except
    on E:Exception do
    begin
      pagoDAO.rollback;
      raise Exception.Create('No se pudo registrar el pago en tarjeta:'+E.Message);
    end;

   end

end;


end.
