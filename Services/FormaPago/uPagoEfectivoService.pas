unit uPagoEfectivoService;

interface
  uses sysUtils,uPagoEfectivoDAO,uPagoEfectivo,uFormaPagoService,uBaseFormaPago;

 type TPagoEfectivoService = class(TFormaPagoService)
  private
    pagoDAO:TPagoEfectivoDAO;
  public
    procedure registrarFormaPago(formaPago:TBaseFormaPago);override;
    constructor Create;

 end;
implementation




constructor TPagoEfectivoService.Create;
begin
   pagoDAO:= TPagoEfectivoDAO.Create;
end;

procedure TPagoEfectivoService.registrarFormaPago(formaPago:TBaseFormaPago);
begin

  if not (formaPago is TPagoEfectivo) then
     raise Exception.Create('La forma de pago ingresada no es efectivo');

  try
      pagoDAO.iniciarTransaccion;
      pagoDAO.insertar(TPagoEfectivo(formaPago));
      pagoDAO.commit;
   except
    on E:Exception do
    begin
      pagoDAO.rollback;
      raise Exception.Create('No se pudo registrar el pago en efectivo:'+E.Message);
    end;

   end

end;


end.
