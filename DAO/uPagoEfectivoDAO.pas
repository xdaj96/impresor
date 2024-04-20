unit uPagoEfectivoDAO;

interface
  uses uPagoEfectivo,sysUtils,udmFacturador;
  type TPagoEfectivoDAO = class
    private

    public
      procedure iniciarTransaccion;
      procedure commit;
      procedure insertar(formaPago:TPagoEfectivo);
      procedure rollback;
  end;
implementation

  procedure TPagoEfectivoDAO.iniciarTransaccion;
  begin
     rollback;
     dmfacturador.ticomprobante.StartTransaction;
     dmfacturador.icomprobante.Database:=dmFacturador.getConexion;
     dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
     dmfacturador.icomprobante.Close;
     dmfacturador.icomprobante.SQL.Clear;
  end;

  procedure TPagoEfectivoDAO.insertar(formaPago: TPagoEfectivo);
  begin
        dmfacturador.icomprobante.SQL.Text:=concat('INSERT INTO VTTBPAGOEFECTIVO (NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_MONEDA, IMP_EFECTIVO, IMP_COTIZ, POR_IVA)',                                                 ' VALUES (:NRO_SUCURSAL, :TIP_COMPROBANTE, :NRO_COMPROBANTE, ''$'', :IMP_EFECTIVO, NULL, NULL)');
        dmfacturador.icomprobante.ParamByName('NRO_SUCURSAL').AsString:=formaPago.NroSucursal;
        dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=formaPago.TipComprobante;
        dmfacturador.icomprobante.ParamByName('nro_comprobANTE').AsString:=formaPago.NroComprob;
        dmfacturador.icomprobante.ParamByName('imp_EFECTIVO').AsFloat:=formaPago.imp_efectivo;
        dmfacturador.icomprobante.ExecSQL;
  end;


  procedure TPagoEfectivoDAO.commit;
  begin
    //dmfacturador.icomprobante.Open;
    dmfacturador.ticomprobante.Commit;
  end;

  procedure TPagoEfectivoDAO.rollback;
  begin
    if dmfacturador.ticomprobante.InTransaction  then
        dmfacturador.ticomprobante.Rollback;
  end;

end.
