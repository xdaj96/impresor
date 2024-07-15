unit uBaseFormaPago;

interface
 type TBaseFormaPago = class
   private
    FNroSucursal:string;
    FTipComprobante:string;
    FNroComprob:string;
   public
    property NroSucursal    :string read FNroSucursal     write FNroSucursal;
    property TipComprobante :string read FTipComprobante  write FTipComprobante;
    property NroComprob     :string read FNroComprob      write FNroComprob;

 end;
implementation

end.
