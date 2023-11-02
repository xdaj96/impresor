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
  uUtils in 'Utils\uUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfimpresor, fimpresor);
  Application.CreateForm(TdmFacturador, dmFacturador);
  Application.Run;
end.
