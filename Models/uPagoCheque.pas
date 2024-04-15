unit uPagoCheque;

interface
  type TPagoCheque = class
    private
    Fsucursal:string;
    Ftip_comprobante:string;
    Fnro_comprobante:string;
    Fcod_banco:string;
    Fnro_cheque:string;
    Fimporte:double;

    public
      property nro_sucursal   :string read Fsucursal        write Fsucursal;
      property tip_comprobante:string read Ftip_comprobante write Ftip_comprobante;
      property nro_comprobante:string read Fnro_comprobante write Fnro_comprobante;
      property cod_banco      :string read Fcod_banco       write Fcod_banco;
      property nro_cheque     :string read Fnro_cheque      write Fnro_cheque;
      property importe        :double read Fimporte         write Fimporte;

      constructor Create;

  end;
implementation

  constructor TPagoCheque.Create;
  begin
    Fsucursal:='';
    Ftip_comprobante:='';
    Fnro_comprobante:='';
    Fcod_banco:='';
    Fnro_cheque:='';
    Fimporte:=0;
  end;


end.