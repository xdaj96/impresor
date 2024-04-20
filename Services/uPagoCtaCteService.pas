unit uPagoCtaCteService;

interface
  uses sysUtils,uPagoCtaCteDAO,uFPagoCte,uFormaPagoService,uBaseFormaPago;

 type TFormaPagoCtaCteService = class(TFormaPagoService)
  private
    pagoDAO:TFPagoCuentaCteDAO;
  public
    procedure registrarFormaPago(formaPago:TBaseFormaPago);override;
    constructor Create;

 end;
implementation




constructor TFormaPagoCtaCteService.Create;
begin
   pagoDAO:= TFPagoCuentaCteDAO.Create;
end;

procedure TFormaPagoCtaCteService.registrarFormaPago(formaPago:TBaseFormaPago);
begin

  if not (formaPago is TFPagoCTE) then
     raise Exception.Create('La forma de pago ingresada no es cuenta corriente');

  try
      pagoDAO.iniciarTransaccion;
      pagoDAO.insertar(TFPagoCTE(formaPago));
      pagoDAO.commit;
   except
    on E:Exception do
    begin
      pagoDAO.rollback;
      raise Exception.Create('No se pudo registrar el pago en la cuenta corrente:'+E.Message);
    end;

   end

end;


end.
