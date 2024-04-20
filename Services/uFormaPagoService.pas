unit uFormaPagoService;

interface
   uses uBaseFormaPago;

   type
     TFormaPagoService = class
      public
       procedure registrarFormaPago(formaPago:TBaseFormaPago); virtual; abstract;

     end;



implementation



end.
