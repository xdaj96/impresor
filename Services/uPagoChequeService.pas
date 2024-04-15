unit uPagoChequeService;

interface
  uses uPagoChequeDAO,UdTicket,Sysutils,math,uUtils,uPagoCheque;

 type TPagoChequeService = class
 private
    pagoChequeDao:TPagoChequeDAO;
    function asignarDatosCheque(ticket:TTicket;nro_comprob:integer):TPagoCheque;
 public
    procedure procesarPagoCheque(ticket:TTicket;nro_comprob:integer);
    constructor Create;
    destructor Destroy;
 end;
implementation


    constructor TPagoChequeService.Create;
    begin
         pagoChequeDAO:= TPagoChequeDAO.Create;
    end;

    destructor TPagoChequeService.Destroy;
    begin
         pagoChequeDAO.Free;
    end;

    function TPagoChequeService.asignarDatosCheque(ticket:TTicket;nro_comprob:integer):TPagoCheque;
    var
      pagoCheque: TPagoCheque;
    begin
      pagoCheque:= TPagoCheque.Create;
      pagoCheque.nro_sucursal := ticket.sucursal;
      pagoCheque.tip_comprobante := TICKET.comprobante;
      pagoCheque.nro_comprobante := ticket.fiscla_pv + (TUtils.rightpad(inttostr(nro_comprob), '0', 8));
      pagoCheque.cod_banco := ticket.codigocheque;
      pagoCheque.nro_cheque := ticket.numerocheque;
      pagoCheque.importe := TICKET.cheque;
      Result:= pagoCheque;
    end;

    procedure TPagoChequeService.procesarPagoCheque(ticket:TTicket;nro_comprob:integer);
    var
      pagoCheque:TPagoCheque;
    begin
        try
           pagoCheque:= asignarDatosCheque(ticket,nro_comprob);
           pagoChequeDao.iniciarTransaccion;
           pagoChequeDao.insertarPago(pagoCheque);
           pagoChequeDao.Commit;
        finally
          pagoCheque.Free;
        end;
    end;
end.
