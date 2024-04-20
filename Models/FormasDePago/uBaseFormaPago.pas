unit uBaseFormaPago;

interface
 type TBaseFormaPago = class
   private
       fNroSucursal: string;
       fTipComprobante: string;
       fNroComprob: string;
   public
    property NroSucursal: string read fNroSucursal write fNroSucursal;
    property TipComprobante: string read fTipComprobante write fTipComprobante;
    property NroComprob: string read fNroComprob write fNroComprob;

 end;
implementation

end.
