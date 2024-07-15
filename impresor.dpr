program impresor;



uses
  Vcl.Forms,
  Uimpresor in 'Uimpresor.pas' {fimpresor},
  Udticket in 'Udticket.pas',
  UdmFacturador in 'UdmFacturador.pas' {dmFacturador: TDataModule},
  uFiscalEpson in 'Libs\uFiscalEpson.pas',
  uFiscalEpson2 in 'Libs\uFiscalEpson2.pas',
  uRegistryHelper in 'Helpers\uRegistryHelper.pas',
  uBaseTicket in 'Models\uBaseTicket.pas',
  UFormaDePago in 'Models\UFormaDePago.pas',
  UFormaPago in 'Models\UFormaPago.pas',
  uTicketBEpson in 'Models\uTicketBEpson.pas',
  uTicketTEpson in 'Models\uTicketTEpson.pas',
  uUtils in 'Utils\uUtils.pas',
  Vcl.Themes,
  Vcl.Styles,
  uPagoChequeDAO in 'DAO\uPagoChequeDAO.pas',
  uPagoChequeService in 'Services\uPagoChequeService.pas',
  uTicketAEpson in 'Models\uTicketAEpson.pas',
  ufBuscarTK in 'Vistas\ufBuscarTK.pas',
  uPagoCtaCteDAO in 'DAO\uPagoCtaCteDAO.pas',
  uFPagoCte in 'Models\uFPagoCte.pas',
  uPagoCtaCteService in 'Services\uPagoCtaCteService.pas',
  uFormaPagoService in 'Services\uFormaPagoService.pas',
  uBaseFormaPago in 'Models\uBaseFormaPago.pas',
  uPagoCheque in 'Models\uPagoCheque.pas',
  uPagoEfectivo in 'Models\uPagoEfectivo.pas',
  uPagoTarjeta in 'Models\uPagoTarjeta.pas',
  uPagoEfectivoService in 'Services\uPagoEfectivoService.pas',
  uPagoTarjetaService in 'Services\uPagoTarjetaService.pas',
  uPagoEfectivoDAO in 'DAO\uPagoEfectivoDAO.pas',
  uPagoTarjetaDAO in 'DAO\uPagoTarjetaDAO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(Tfimpresor, fimpresor);
  Application.CreateForm(TdmFacturador, dmFacturador);
  Application.Run;
end.
