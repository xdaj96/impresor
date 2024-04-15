unit uPagoChequeDAO;

interface
  uses udmFacturador,IBX.IBQUERY,uPagoCheque;
  type TPagoChequeDAO = class
     private

     public
     procedure iniciarTransaccion;
     procedure insertarPago(cheque:TPagoCheque);
     procedure Commit;
     procedure Rollback;
  end;
implementation

     procedure TPagoChequeDAO.iniciarTransaccion;
     begin
       if dmfacturador.ticomprobante.InTransaction  then
          Rollback;

        dmfacturador.ticomprobante.StartTransaction;
        dmfacturador.icomprobante.Database:=dmFacturador.getConexion;
        dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
        dmfacturador.icomprobante.Close;
        dmfacturador.icomprobante.SQL.Clear;
     end;

     procedure TPagoChequeDAO.insertarPago(cheque:TPagoCheque);
     begin
       dmfacturador.icomprobante.SQL.Text:=concat(' INSERT INTO VTTBPAGOCHEQUE (NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_BANCO, COD_CTA, NRO_CHEQUE, IMP_CHEQUE) VALUES (:sucursal,:tip_comprobante, :nro_comprobante, :cod_banco, '''', :nro_cheque, :importe_cheque);');
       dmfacturador.icomprobante.ParamByName('SUCURSAL').AsString:=cheque.nro_sucursal;
       dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=cheque.tip_comprobante;
       dmfacturador.icomprobante.ParamByName('nro_comprobante').AsString:=cheque.nro_comprobante;
       dmfacturador.icomprobante.ParamByName('cod_banco').AsString:=cheque.cod_banco;
       dmfacturador.icomprobante.ParamByName('nro_cheque').AsString:=cheque.nro_cheque;
       dmfacturador.icomprobante.ParamByName('importe_cheque').AsFloat:=cheque.importe;
          dmfacturador.icomprobante.Open;
     end;


     procedure TPagoChequeDAO.Commit;
     begin
        dmfacturador.ticomprobante.Commit;
     end;


     procedure TPagoChequeDAO.Rollback;
     begin
        dmfacturador.ticomprobante.Rollback;
     end;
end.
