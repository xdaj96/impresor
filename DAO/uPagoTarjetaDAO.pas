unit uPagoTarjetaDAO;

interface
  uses uPagoTarjeta,sysUtils,udmFacturador;
  type TPagoTarjetaDAO = class
    private

    public
      procedure iniciarTransaccion;
      procedure commit;
      procedure insertar(formaPago:TPagoTarjeta);
      procedure rollback;
  end;
implementation

  procedure TPagoTarjetaDAO.iniciarTransaccion;
  begin
     rollback;
     dmfacturador.ticomprobante.StartTransaction;
     dmfacturador.icomprobante.Database:=dmFacturador.getConexion;
     dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
     dmfacturador.icomprobante.Close;
     dmfacturador.icomprobante.SQL.Clear;
  end;

  procedure TPagoTarjetaDAO.insertar(formaPago: TPagoTarjeta);
  begin

   dmfacturador.icomprobante.SQL.Text:=concat(' INSERT INTO VTTBPAGOTARJETA (NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_TARJETA, NRO_TARJETA, COD_MONEDA, NRO_CUPON, ',
                                                   ' IMP_TARJETA, IMP_COTIZ, NRO_CUOTA, NRO_AUTORIZACION, NRO_LIQUIDACION, FEC_VENCIMIENTO, NRO_PIN, POR_IVA, CODIGOPAGO)',
                                                   ' VALUES (:NRO_SUCURSAL, :TIP_COMPROBANTE, :NRO_COMPROBANTE, :COD_TARJETA, ''0'', ''$'', NULL, :IMP_TARJETA, NULL, 0, 0, NULL, CURRENT_DATE , 0, NULL, NULL)');
   dmfacturador.icomprobante.ParamByName('NRO_SUCURSAL').AsString:=formaPago.NroSucursal;
   dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=formaPago.TipComprobante;
   dmfacturador.icomprobante.ParamByName('NRO_COMPROBANTE').AsString:=formaPago.NroComprob;
   dmfacturador.icomprobante.ParamByName('IMP_TARJETA').AsFloat:=formaPago.importe;
   dmfacturador.icomprobante.ParamByName('COD_TARJETA').AsString:=formaPago.codigo;
   dmfacturador.icomprobante.ExecSQL;
  end;


  procedure TPagoTarjetaDAO.commit;
  begin
    //dmfacturador.icomprobante.Open;
    dmfacturador.ticomprobante.Commit;
  end;

  procedure TPagoTarjetaDAO.rollback;
  begin
    if dmfacturador.ticomprobante.InTransaction  then
        dmfacturador.ticomprobante.Rollback;
  end;

end.
