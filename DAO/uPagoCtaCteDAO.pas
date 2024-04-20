unit uPagoCtaCteDAO;

interface
  uses uFPagoCTE,sysUtils,udmFacturador;
  type TFPagoCuentaCteDAO = class
    private

    public
      procedure iniciarTransaccion;
      procedure commit;
      procedure insertar(formaPago:TFPagoCTE);
      procedure rollback;
  end;
implementation

  procedure TFPagoCuentaCteDAO.iniciarTransaccion;
  begin
     rollback;
     dmfacturador.ticomprobante.StartTransaction;
     dmfacturador.icomprobante.Database:=dmFacturador.getConexion;
     dmfacturador.icomprobante.Transaction:=dmFacturador.ticomprobante;
     dmfacturador.icomprobante.Close;
     dmfacturador.icomprobante.SQL.Clear;
  end;

  procedure TFPagoCuentaCteDAO.insertar(formaPago: TFPagoCTE);
  begin
    dmfacturador.icomprobante.SQL.Text:=concat(' INSERT INTO VTTBPAGOCTACTE ',
                                                   '(NRO_SUCURSAL, TIP_COMPROBANTE, NRO_COMPROBANTE, COD_CTACTE, COD_SUBCTA, COD_AUTORIZACTA, IMP_CTACTE, IMP_SALDO, ',
                                                   ' MAR_RESUMIDO, NRO_SUCURSAL_LIQ, NRO_LIQUIDACION, CAN_CUOTAS, CAN_CUOTASPEN, POR_IVA, CODIGOPAGO) ',
                                                   ' VALUES (:NRO_SUCURSAL,:TIP_COMPROBANTE , :NRO_COMPROB, :COD_CTACTE, :COD_SUBCTA, '''', :IMP_CTACTE, :IMP_SCTACTE, ''N'', 0, NULL, 0, 0, NULL, NULL)');


        dmfacturador.icomprobante.ParamByName('NRO_SUCURSAL').AsString:=formaPago.NroSucursal;
        dmfacturador.icomprobante.ParamByName('TIP_COMPROBANTE').AsString:=formaPago.TipComprobante;
        dmfacturador.icomprobante.ParamByName('nro_comprob').AsString:=formaPago.NroComprob;
        dmfacturador.icomprobante.ParamByName('COD_CTACTE').AsString:=formaPago.CodCtaCte;
        dmfacturador.icomprobante.ParamByName('cod_subcta').AsString:=formaPago.CodSubCta;
        dmfacturador.icomprobante.ParamByName('imp_ctacte').AsFloat:=formaPago.ImpCtaCte;
        dmfacturador.icomprobante.ParamByName('imp_sctacte').AsFloat:=formaPago.ImpSubCtaCte;
  end;


  procedure TFPagoCuentaCteDAO.commit;
  begin
    dmfacturador.icomprobante.Open;
    dmfacturador.ticomprobante.Commit;
  end;

  procedure TFPagoCuentaCteDAO.rollback;
  begin
    if dmfacturador.ticomprobante.InTransaction  then
        dmfacturador.ticomprobante.Rollback;
  end;

end.
