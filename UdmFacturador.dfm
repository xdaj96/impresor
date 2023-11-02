object dmFacturador: TdmFacturador
  OldCreateOrder = False
  Height = 883
  Width = 939
  object dsfact: TDataSource
    DataSet = DPRINCIPAL
    Left = 99
    Top = 109
  end
  object datosbusqueda: TDataSource
    Left = 408
    Top = 227
  end
  object databasefire: TIBDatabase
    Params.Strings = (
      'user_name=SYSDBA'
      'password=nmpnet'
      'lc_ctype=ISO8859_1')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 24
    Top = 13
  end
  object transactionprod: TIBTransaction
    DefaultDatabase = databasefire
    Left = 160
    Top = 189
  end
  object qbusqueda: TIBQuery
    Database = databasefire
    Transaction = transactionprod
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      ' select first(100)                   DISTINCT a.cod_alfabeta,'
      
        '                                                    a.nro_troque' +
        'l,'
      
        '                                                    a.cod_barras' +
        'pri,'
      '                                                    a.nom_largo,'
      '                                                    a.cod_iva,'
      '                                                    s.can_stk,'
      
        '                                                    a.cod_tamano' +
        ','
      
        '                                                    a.cod_labora' +
        'torio,'
      
        '                                                   coalesce(CAST' +
        '('
      '                                                    CASE'
      
        '                                                    WHEN a.mar_i' +
        'mpsug='#39'N'#39' and a.mar_precioventa='#39'S'#39' THEN'
      '                                                     b.imp_venta'
      
        '                                                     when a.mar_' +
        'impsug='#39'N'#39' and a.mar_precioventa='#39'N'#39' THEN'
      
        '                                                     (b.imp_comp' +
        'ra*(1+r.por_margen/100))'
      
        '                                                      when a.mar' +
        '_impsug='#39'S'#39' AND A.mar_precioventa='#39'S'#39' then'
      
        '                                                     (a.imp_suge' +
        'rido)'
      
        '                                                     when A.mar_' +
        'impsug='#39'S'#39' AND A.mar_precioventa='#39'N'#39' then'
      
        '                                                      ((a.imp_su' +
        'gerido*r.por_margen/100) + a.imp_sugerido)'
      
        '                                                      END AS DEC' +
        'IMAL (10,2)),0) as PRECIO,'
      
        '                                                     c.POR_VAR_P' +
        'RECIO as varlabo,'
      
        '                                                     r.por_var_p' +
        'recio as VARRUBRO,'
      
        '                                                     r.cod_rubro' +
        ','
      
        '                                                     d.des_droga' +
        ','
      
        '                                                     f.des_accfa' +
        'rm'
      
        '                                                     from  prmal' +
        'aboratorio c, prmarubro r,'
      
        '                                                     prmaproduct' +
        'o a left join cotbprecio b on a.cod_alfabeta=b.cod_alfabeta'
      
        '                                                     LEFT JOIN p' +
        'rmaaccionfarm f ON  f.cod_accfarm=a.cod_acc_farm'
      
        '                                                     LEFT JOIN p' +
        'rmamonodroga d ON  D.cod_droga=a.cod_droga'
      
        '                                                     left join  ' +
        ' prmastock s on    a.cod_alfabeta=s.cod_alfabeta and s.nro_sucur' +
        'sal=b.nro_sucursal'
      
        '                                                     where (cod_' +
        'barraspri= :Barras Or NRO_TROQUEL= :Troquel or (a.nom_largo like' +
        ' :nombre ) )'
      
        '                                                     AND a.cod_r' +
        'ubro=r.cod_rubro'
      
        '                                                     and c.cod_l' +
        'aboratorio=a.cod_laboratorio'
      
        '                                                     and not(mar' +
        '_baja='#39'S'#39' and s.can_stk=0)'
      
        '                                                     and b.nro_s' +
        'ucursal=:sucursal')
    Left = 88
    Top = 188
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'Barras'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'Troquel'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'nombre'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'sucursal'
        ParamType = ptUnknown
      end>
    object qbusquedaCOD_ALFABETA: TIntegerField
      FieldName = 'COD_ALFABETA'
      Origin = '"PRMAPRODUCTO"."COD_ALFABETA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qbusquedaNRO_TROQUEL: TIntegerField
      FieldName = 'NRO_TROQUEL'
      Origin = '"PRMAPRODUCTO"."NRO_TROQUEL"'
      Required = True
    end
    object qbusquedaCOD_BARRASPRI: TIBStringField
      FieldName = 'COD_BARRASPRI'
      Origin = '"PRMAPRODUCTO"."COD_BARRASPRI"'
      Size = 15
    end
    object qbusquedaNOM_LARGO: TIBStringField
      FieldName = 'NOM_LARGO'
      Origin = '"PRMAPRODUCTO"."NOM_LARGO"'
      Size = 100
    end
    object qbusquedaCOD_IVA: TIBStringField
      FieldName = 'COD_IVA'
      Origin = '"PRMAPRODUCTO"."COD_IVA"'
      Required = True
      Size = 1
    end
    object qbusquedaCAN_STK: TSmallintField
      FieldName = 'CAN_STK'
      Origin = '"PRMASTOCK"."CAN_STK"'
    end
    object qbusquedaPRECIO: TIBBCDField
      FieldName = 'PRECIO'
      ProviderFlags = []
      Precision = 18
      Size = 2
    end
    object qbusquedaCOD_RUBRO: TIBStringField
      FieldName = 'COD_RUBRO'
      Origin = '"PRMARUBRO"."COD_RUBRO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 2
    end
    object qbusquedaCOD_LABORATORIO: TIBStringField
      FieldName = 'COD_LABORATORIO'
      Origin = '"PRMALABORATORIO"."COD_LABORATORIO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 4
    end
    object qbusquedaVARLABO: TIBBCDField
      FieldName = 'VARLABO'
      Origin = '"PRMALABORATORIO"."POR_VAR_PRECIO"'
      Precision = 9
      Size = 3
    end
    object qbusquedaVARRUBRO: TIBBCDField
      FieldName = 'VARRUBRO'
      Origin = '"PRMARUBRO"."POR_VAR_PRECIO"'
      Precision = 9
      Size = 3
    end
    object qbusquedacod_tamano: TSmallintField
      FieldName = 'cod_tamano'
    end
    object qbusquedaDES_ACCFARM: TIBStringField
      FieldName = 'DES_ACCFARM'
      Origin = '"PRMAACCIONFARM"."DES_ACCFARM"'
      Size = 50
    end
    object qbusquedaDES_DROGA: TIBStringField
      FieldName = 'DES_DROGA'
      Origin = '"PRMAMONODROGA"."DES_DROGA"'
      Size = 50
    end
  end
  object DPRINCIPAL: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    Left = 24
    Top = 67
    object DPRINCIPALCOD_ALFABETA: TStringField
      FieldName = 'COD_ALFABETA'
    end
    object DPRINCIPALNRO_TROQUEL: TStringField
      FieldName = 'NRO_TROQUEL'
    end
    object DPRINCIPALVALE: TStringField
      FieldName = 'VALE'
    end
    object DPRINCIPALCOD_BARRASPRI: TStringField
      FieldName = 'COD_BARRASPRI'
    end
    object DPRINCIPALNOM_LARGO: TStringField
      DisplayWidth = 40
      FieldName = 'NOM_LARGO'
      Size = 40
    end
    object DPRINCIPALCOD_IVA: TStringField
      FieldName = 'COD_IVA'
    end
    object DPRINCIPALPRECIO: TCurrencyField
      FieldName = 'PRECIO'
    end
    object DPRINCIPALCANTIDAD: TIntegerField
      FieldName = 'CANTIDAD'
    end
    object DPRINCIPALporcentaje: TIntegerField
      FieldName = 'porcentaje'
    end
    object DPRINCIPALPRECIO_TOTAL: TCurrencyField
      FieldKind = fkInternalCalc
      FieldName = 'PRECIO_TOTAL'
    end
    object DPRINCIPALPRECIO_TOTALDESC: TCurrencyField
      FieldKind = fkInternalCalc
      FieldName = 'PRECIO_TOTALDESC'
    end
    object DPRINCIPALDESCUENTOS: TCurrencyField
      FieldKind = fkInternalCalc
      FieldName = 'DESCUENTOS'
    end
    object DPRINCIPALPORCENTAJEOS: TFloatField
      FieldName = 'PORCENTAJEOS'
    end
    object DPRINCIPALPORCENTAJECO1: TFloatField
      FieldName = 'PORCENTAJECO1'
    end
    object DPRINCIPALPORCENTAJECO2: TFloatField
      FieldName = 'PORCENTAJECO2'
    end
    object DPRINCIPALDESCUENTOSOS: TCurrencyField
      FieldName = 'DESCUENTOSOS'
    end
    object DPRINCIPALDESCUENTOCO1: TCurrencyField
      FieldName = 'DESCUENTOCO1'
    end
    object DPRINCIPALDESCUENTOCO2: TCurrencyField
      FieldName = 'DESCUENTOCO2'
    end
    object DPRINCIPALCOD_LABORATORIO: TStringField
      DisplayWidth = 5
      FieldName = 'COD_LABORATORIO'
      Size = 5
    end
    object DPRINCIPALcan_stk: TIntegerField
      FieldName = 'can_stk'
    end
    object DPRINCIPALcan_vale: TStringField
      FieldName = 'can_vale'
    end
    object DPRINCIPALtamano: TIntegerField
      FieldName = 'tamano'
    end
    object DPRINCIPALModificado: TBooleanField
      FieldName = 'Modificado'
    end
    object DPRINCIPALimportetotal: TAggregateField
      FieldName = 'importetotal'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(precio_total)'
    end
    object DPRINCIPALdescuentos_total: TAggregateField
      FieldName = 'descuentos_total'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(descuentos)'
    end
    object DPRINCIPALnetoxcobrar: TAggregateField
      FieldName = 'netoxcobrar'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(precio_totaldesc)'
    end
    object DPRINCIPALDESCUENTOTOTALOS: TAggregateField
      FieldName = 'DESCUENTOTOTALOS'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(descuentosos)'
    end
    object DPRINCIPALDESCUENTOTOTALCO1: TAggregateField
      FieldName = 'DESCUENTOTOTALCO1'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(descuentoco1)'
    end
    object DPRINCIPALDESCUENTOTOTALCO2: TAggregateField
      FieldName = 'DESCUENTOTOTALCO2'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(descuentoco2)'
    end
  end
  object qafiliados: TIBQuery
    Database = databasefire
    Transaction = transactionprod
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select des_afiliado, nro_afiliado from osmaafiliado where cod_pl' +
        'anos=:codigo OR DES_AFILIADO like :NOMBRE')
    Left = 84
    Top = 12
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'codigo'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'NOMBRE'
        ParamType = ptUnknown
      end>
  end
  object dataafiliados: TDataSource
    DataSet = qafiliados
    Left = 101
    Top = 64
  end
  object tranafiliados: TIBTransaction
    DefaultDatabase = databasefire
    Left = 158
    Top = 64
  end
  object qiafiliados: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 147
    Top = 13
  end
  object dsecundario: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 187
    object dsecundarioCOD_ALFABETA: TStringField
      FieldName = 'COD_ALFABETA'
    end
    object dsecundarioNRO_TROQUEL: TStringField
      FieldName = 'NRO_TROQUEL'
    end
    object dsecundarioCOD_BARRASPRI: TStringField
      FieldName = 'COD_BARRASPRI'
    end
    object dsecundarioNOM_LARGO: TStringField
      FieldName = 'NOM_LARGO'
      Size = 40
    end
    object dsecundarioCOD_IVA: TStringField
      FieldName = 'COD_IVA'
    end
    object dsecundarioCAN_STK: TIntegerField
      FieldName = 'CAN_STK'
    end
    object dsecundarioPRECIO: TStringField
      FieldName = 'PRECIO'
    end
    object dsecundarioDESCUENTO: TStringField
      FieldName = 'DESCUENTO'
    end
    object dsecundarioPRECIO_TOTAL: TFloatField
      FieldName = 'PRECIO_TOTAL'
    end
    object dsecundarioRUBRO: TStringField
      FieldName = 'RUBRO'
    end
    object dsecundarioDESCUENTOOS: TStringField
      FieldName = 'DESCUENTOOS'
    end
    object dsecundarioDESCUENTOCO1: TStringField
      FieldName = 'DESCUENTOCO1'
    end
    object dsecundarioDESCUENTOCO2: TStringField
      FieldName = 'DESCUENTOCO2'
    end
    object dsecundarioCOD_LABORATORIO: TStringField
      FieldName = 'COD_LABORATORIO'
    end
    object dsecundariocod_tamano: TStringField
      FieldName = 'cod_tamano'
    end
    object dsecundariodes_accion: TStringField
      FieldName = 'des_accion'
      Size = 50
    end
    object dsecundariodes_droga: TStringField
      FieldName = 'des_droga'
      Size = 50
    end
  end
  object dsbusqueda: TDataSource
    DataSet = dsecundario
    Left = 472
    Top = 227
  end
  object qosmaplanesos: TIBQuery
    Database = databasefire
    Transaction = transactionprod
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select POR_DESOS from osmaplanesos  where cod_planos=:PLAN and c' +
        'od_rubro like :rubro')
    Left = 360
    Top = 227
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'PLAN'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'rubro'
        ParamType = ptUnknown
      end>
  end
  object qNROVALIDACION: TIBQuery
    Database = databasefire
    Transaction = IBTransactionVAL
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select first 1 idcomprobante from osmacomprobvalidaciones  order' +
        ' by idcomprobante desc')
    Left = 256
    Top = 24
  end
  object IBTransactionVAL: TIBTransaction
    DefaultDatabase = databasefire
    Left = 256
    Top = 64
  end
  object IBQcodigoprestador: TIBQuery
    Database = databasefire
    Transaction = transactionprod
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 368
    Top = 24
  end
  object ibqcaja: TIBQuery
    Database = databasefire
    Transaction = transactionprod
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 84
    Top = 424
  end
  object icomprobante: TIBQuery
    Database = databasefire
    Transaction = ticomprobante
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 624
    Top = 64
  end
  object ticomprobante: TIBTransaction
    DefaultDatabase = databasefire
    Left = 624
    Top = 112
  end
  object qvendedor: TIBQuery
    Database = databasefire
    Transaction = tpanel1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 25
    Top = 368
  end
  object qcomprobante: TIBQuery
    Database = databasefire
    Transaction = tpanel1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select TIP_COMPROBANTE, TIP_IMPRE from vtmatipcomprob where tip_' +
        'comprobante like :LETRA  AND MAR_TIPOPROCESO='#39'F'#39)
    Left = 96
    Top = 253
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'LETRA'
        ParamType = ptUnknown
      end>
    object qcomprobanteTIP_COMPROBANTE: TIBStringField
      FieldName = 'TIP_COMPROBANTE'
      Origin = '"VTMATIPCOMPROB"."TIP_COMPROBANTE"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 3
    end
    object qcomprobanteTIP_IMPRE: TIBStringField
      FieldName = 'TIP_IMPRE'
      Origin = '"VTMATIPCOMPROB"."TIP_IMPRE"'
      Size = 1
    end
  end
  object tpanel1: TIBTransaction
    DefaultDatabase = databasefire
    Left = 101
    Top = 306
  end
  object Dscomprobante: TDataSource
    DataSet = qcomprobante
    Left = 104
    Top = 368
  end
  object qpanel2: TIBQuery
    Database = databasefire
    Transaction = transactionprod
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 176
    Top = 368
  end
  object qtipocomprob: TIBQuery
    Database = databasefire
    Transaction = transactionprod
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 168
    Top = 254
  end
  object qcliente: TIBQuery
    Database = databasefire
    Transaction = transactionprod
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 464
    Top = 368
  end
  object qicliente: TIBQuery
    Database = databasefire
    Transaction = traninsertcliente
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 464
    Top = 416
  end
  object traninsertcliente: TIBTransaction
    DefaultDatabase = databasefire
    Left = 560
    Top = 416
  end
  object DSicliente: TDataSource
    Left = 512
    Top = 416
  end
  object qupdatecliente: TIBQuery
    Database = databasefire
    Transaction = traninsertcliente
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 408
    Top = 416
  end
  object cdsfactura: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    Left = 768
    Top = 67
    object cdsfacturacod_alfabeta: TStringField
      FieldName = 'cod_alfabeta'
    end
    object cdsfacturacod_barraspri: TStringField
      FieldName = 'cod_barraspri'
    end
    object cdsfacturanom_largo: TStringField
      FieldName = 'nom_largo'
    end
    object cdsfacturacantidad: TStringField
      FieldName = 'cantidad'
    end
    object cdsfacturacantidadcontrol: TStringField
      FieldName = 'cantidadcontrol'
    end
  end
  object dsfactura: TDataSource
    DataSet = cdsfactura
    Left = 696
    Top = 64
  end
  object frxDBDataset1: TfrxDBDataset
    UserName = 'frxDBDataset'
    CloseDataSource = False
    DataSet = cdsfacturareporte
    BCDToCurrency = False
    Left = 32
    Top = 576
  end
  object reportefactonline: TfrxReport
    Version = '5.1.5'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 42600.377013194390000000
    ReportOptions.LastChange = 42604.603447511600000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      'begin'
      ''
      'end.')
    Left = 113
    Top = 576
    Datasets = <
      item
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset'
      end>
    Variables = <>
    Style = <
      item
        Name = 'Title'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Fill.BackColor = clGray
      end
      item
        Name = 'Header'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
      end
      item
        Name = 'Group header'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Fill.BackColor = 16053492
      end
      item
        Name = 'Data'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
      end
      item
        Name = 'Group footer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
      end
      item
        Name = 'Header line'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        Frame.Width = 2.000000000000000000
      end>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 215.900000000000000000
      PaperHeight = 279.400000000000000000
      PaperSize = 1
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        Height = 26.456710000000000000
        Top = 18.897650000000000000
        Width = 740.409927000000000000
        object Memo1: TfrxMemoView
          Align = baWidth
          Width = 740.409927000000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Fill.BackColor = clGray
          HAlign = haCenter
          Memo.UTF8W = (
            'Productos Inexistentes')
          ParentFont = False
          Style = 'Title'
          VAlign = vaCenter
        end
      end
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 68.031540000000000000
        Width = 740.409927000000000000
        object Memo2: TfrxMemoView
          Width = 740.787401574802900000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          Frame.Width = 2.000000000000000000
          ParentFont = False
          Style = 'Header line'
        end
        object Memo3: TfrxMemoView
          Width = 151.000000000000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'Nombre')
          ParentFont = False
          Style = 'Header'
        end
        object Memo4: TfrxMemoView
          Left = 151.000000000000000000
          Width = 151.000000000000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'Codigo de barras')
          ParentFont = False
          Style = 'Header'
        end
        object Memo5: TfrxMemoView
          Left = 302.000000000000000000
          Width = 151.000000000000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'cantidad')
          ParentFont = False
          Style = 'Header'
        end
        object Memo6: TfrxMemoView
          Left = 453.000000000000000000
          Width = 151.000000000000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'cantidad control')
          ParentFont = False
          Style = 'Header'
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 151.181200000000000000
        Width = 740.409927000000000000
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset'
        RowCount = 0
        object Memo7: TfrxMemoView
          Width = 151.000000000000000000
          Height = 18.897650000000000000
          DataField = 'nom_largo'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[frxDBDataset."nom_largo"]')
          ParentFont = False
          Style = 'Data'
        end
        object Memo8: TfrxMemoView
          Left = 151.000000000000000000
          Width = 151.000000000000000000
          Height = 18.897650000000000000
          DataField = 'cod_barraspri'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[frxDBDataset."cod_barraspri"]')
          ParentFont = False
          Style = 'Data'
        end
        object Memo9: TfrxMemoView
          Left = 302.000000000000000000
          Width = 151.000000000000000000
          Height = 18.897650000000000000
          DataField = 'cantidad'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[frxDBDataset."cantidad"]')
          ParentFont = False
          Style = 'Data'
        end
        object Memo10: TfrxMemoView
          Left = 453.000000000000000000
          Width = 151.000000000000000000
          Height = 18.897650000000000000
          DataField = 'cantidadcontrol'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[frxDBDataset."cantidadcontrol"]')
          ParentFont = False
          Style = 'Data'
        end
      end
      object PageFooter1: TfrxPageFooter
        FillType = ftBrush
        Height = 26.456710000000000000
        Top = 234.330860000000000000
        Width = 740.409927000000000000
        object Memo11: TfrxMemoView
          Align = baWidth
          Width = 740.409927000000000000
          Frame.Typ = [ftTop]
          Frame.Width = 2.000000000000000000
        end
        object Memo12: TfrxMemoView
          Top = 1.000000000000000000
          Height = 22.677180000000000000
          AutoWidth = True
          Memo.UTF8W = (
            '[Date] [Time]')
        end
        object Memo13: TfrxMemoView
          Align = baRight
          Left = 664.819327000000000000
          Top = 1.000000000000000000
          Width = 75.590600000000000000
          Height = 22.677180000000000000
          HAlign = haRight
          Memo.UTF8W = (
            'Page [Page#]')
        end
      end
    end
  end
  object cdsfacturareporte: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    Left = 121
    Top = 528
    object cdsfacturareportecod_alfabeta: TStringField
      FieldName = 'cod_alfabeta'
    end
    object cdsfacturareportecod_barraspri: TStringField
      FieldName = 'cod_barraspri'
    end
    object cdsfacturareportenom_largo: TStringField
      FieldName = 'nom_largo'
    end
    object cdsfacturareportecantidad: TStringField
      FieldName = 'cantidad'
    end
    object cdsfacturareportecantidadcontrol: TStringField
      FieldName = 'cantidadcontrol'
    end
    object cdsfacturareportenro_factura: TStringField
      FieldName = 'nro_factura'
    end
  end
  object dsfacturareporte: TDataSource
    Left = 32
    Top = 528
  end
  object qnrocomprob: TIBQuery
    Database = databasefire
    Transaction = transcomprob
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select des_afiliado, nro_afiliado from osmaafiliado where cod_pl' +
        'anos=:codigo OR DES_AFILIADO like :NOMBRE')
    Left = 28
    Top = 252
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'codigo'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'NOMBRE'
        ParamType = ptUnknown
      end>
  end
  object transcomprob: TIBTransaction
    DefaultDatabase = databasefire
    Left = 24
    Top = 304
  end
  object CDSetiquetas: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 248
    Top = 523
    object CDSetiquetascod_alfabeta: TStringField
      FieldName = 'cod_alfabeta'
    end
    object CDSetiquetasNRO_TROQUEL: TStringField
      FieldName = 'NRO_TROQUEL'
    end
    object CDSetiquetasCOD_BARRASPRI: TStringField
      FieldName = 'COD_BARRASPRI'
    end
    object CDSetiquetasNOM_LARGO: TStringField
      FieldName = 'NOM_LARGO'
      Size = 40
    end
    object CDSetiquetasCOD_IVA: TStringField
      FieldName = 'COD_IVA'
    end
    object CDSetiquetasCAN_STK: TIntegerField
      FieldName = 'CAN_STK'
    end
    object CDSetiquetasPRECIO: TStringField
      FieldName = 'PRECIO'
    end
    object CDSetiquetasDESCUENTO: TStringField
      FieldName = 'DESCUENTO'
    end
    object CDSetiquetasPRECIO_TOTAL: TFloatField
      FieldName = 'PRECIO_TOTAL'
    end
    object CDSetiquetaSRUBRO: TStringField
      FieldName = 'RUBRO'
    end
    object CDSetiquetasDESCUENTOOS: TStringField
      FieldName = 'DESCUENTOOS'
    end
    object CDSetiquetasDESCUENTOCO1: TStringField
      FieldName = 'DESCUENTOCO1'
    end
    object CDSetiquetasDESCUENTOCO2: TStringField
      FieldName = 'DESCUENTOCO2'
    end
    object CDSetiquetasCOD_LABORATORIO: TStringField
      FieldName = 'COD_LABORATORIO'
    end
    object CDSetiquetascod_tamano: TStringField
      FieldName = 'cod_tamano'
      Size = 10
    end
    object CDSetiquetasdes_accion: TStringField
      FieldName = 'des_accion'
      Size = 40
    end
    object CDSetiquetasdes_droga: TStringField
      FieldName = 'des_droga'
      Size = 40
    end
  end
  object dsetiquetas: TDataSource
    DataSet = CDSetiquetas
    Left = 320
    Top = 520
  end
  object frxetiquetas: TfrxDBDataset
    UserName = 'frxetiquetas'
    CloseDataSource = False
    FieldAliases.Strings = (
      'cod_alfabeta=cod_alfabeta'
      'NRO_TROQUEL=NRO_TROQUEL'
      'COD_BARRASPRI=COD_BARRASPRI'
      'NOM_LARGO=NOM_LARGO'
      'COD_IVA=COD_IVA'
      'CAN_STK=CAN_STK'
      'PRECIO=PRECIO'
      'DESCUENTO=DESCUENTO'
      'PRECIO_TOTAL=PRECIO_TOTAL'
      'RUBRO=RUBRO'
      'DESCUENTOOS=DESCUENTOOS'
      'DESCUENTOCO1=DESCUENTOCO1'
      'DESCUENTOCO2=DESCUENTOCO2'
      'COD_LABORATORIO=COD_LABORATORIO')
    DataSource = dsetiquetas
    BCDToCurrency = False
    Left = 248
    Top = 568
  end
  object reporteetiquetas: TfrxReport
    Version = '5.1.5'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 42618.544030810200000000
    ReportOptions.LastChange = 42618.639292824080000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      'begin'
      ''
      'end.')
    Left = 321
    Top = 568
    Datasets = <
      item
        DataSet = frxetiquetas
        DataSetName = 'frxetiquetas'
      end>
    Variables = <>
    Style = <
      item
        Name = 'Title'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Fill.BackColor = clGray
      end
      item
        Name = 'Header'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
      end
      item
        Name = 'Group header'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Fill.BackColor = 16053492
      end
      item
        Name = 'Data'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
      end
      item
        Name = 'Group footer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
      end
      item
        Name = 'Header line'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        Frame.Width = 2.000000000000000000
      end>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 215.900000000000000000
      PaperHeight = 279.400000000000000000
      PaperSize = 1
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Columns = 4
      ColumnWidth = 49.000000000000000000
      ColumnPositions.Strings = (
        '0'
        '49'
        '98'
        '147')
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 90.708720000000000000
        Top = 18.897650000000000000
        Width = 185.196970000000000000
        DataSet = frxetiquetas
        DataSetName = 'frxetiquetas'
        RowCount = 0
        object Shape1: TfrxShapeView
          Left = 1.779530000000000000
          Top = 1.000000000000000000
          Width = 181.417440000000000000
          Height = 86.929190000000000000
        end
        object Memo1: TfrxMemoView
          Left = 3.559060000000000000
          Top = 22.456710000000000000
          Width = 30.236240000000000000
          Height = 37.795300000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            '$')
          ParentFont = False
        end
        object Line1: TfrxLineView
          Left = 2.000000000000000000
          Top = 64.252010000000000000
          Width = 181.417440000000000000
          Color = clBlack
          Diagonal = True
        end
        object Line2: TfrxLineView
          Left = 2.000000000000000000
          Top = 18.897650000000000000
          Width = 181.417440000000000000
          Color = clBlack
          Diagonal = True
        end
        object frxetiquetasPRECIO: TfrxMemoView
          Left = 37.795300000000000000
          Top = 22.677180000000000000
          Width = 117.165430000000000000
          Height = 37.795300000000000000
          DataField = 'PRECIO'
          DataSet = frxetiquetas
          DataSetName = 'frxetiquetas'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[frxetiquetas."PRECIO"]')
          ParentFont = False
          WordWrap = False
          Wysiwyg = False
        end
        object frxetiquetasNOM_LARGO: TfrxMemoView
          Left = 6.559060000000000000
          Top = 2.779530000000001000
          Width = 173.858282360000000000
          Height = 15.118120000000000000
          StretchMode = smActualHeight
          DataField = 'NOM_LARGO'
          DataSet = frxetiquetas
          DataSetName = 'frxetiquetas'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[frxetiquetas."NOM_LARGO"]')
          ParentFont = False
          WordBreak = True
          WordWrap = False
        end
        object frxetiquetasCOD_BARRASPRI: TfrxMemoView
          Left = 5.000000000000000000
          Top = 68.031540000000010000
          Width = 170.078850000000000000
          Height = 15.118120000000000000
          StretchMode = smActualHeight
          DataField = 'COD_BARRASPRI'
          DataSet = frxetiquetas
          DataSetName = 'frxetiquetas'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[frxetiquetas."COD_BARRASPRI"]')
          ParentFont = False
          WordBreak = True
        end
      end
    end
  end
  object basecfg: TIBDatabase
    DatabaseName = 'C:\BASEPRUEBA\farmbase\fwdat.fdb'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=nmpnet'
      'lc_ctype=ISO8859_1')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 144
    Top = 421
  end
  object qcaja: TIBQuery
    Database = basecfg
    Transaction = trancaja
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 28
    Top = 424
  end
  object trancaja: TIBTransaction
    DefaultDatabase = basecfg
    Left = 80
    Top = 480
  end
  object qlimite: TIBQuery
    Database = databasefire
    Transaction = tranlimite
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select '
      'CAN_MAXUNIDXREC,'
      'CAN_MAXUNIDXREN,'
      'CAN_MAXUNIDXTICKET,'
      'CAN_MAXRENXTICKET'
      'from osmalimites O, PRMATAMANO P'
      'where O.COD_TAMANO=P.COD_TAMANO'
      'AND cod_planos=:plan and tip_tratamiento=:tratamiento')
    Left = 240
    Top = 256
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'plan'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'tratamiento'
        ParamType = ptUnknown
      end>
    object qlimiteCAN_MAXUNIDXREC: TSmallintField
      FieldName = 'CAN_MAXUNIDXREC'
      Origin = '"OSMALIMITES"."CAN_MAXUNIDXREC"'
    end
    object qlimiteCAN_MAXUNIDXREN: TSmallintField
      FieldName = 'CAN_MAXUNIDXREN'
      Origin = '"OSMALIMITES"."CAN_MAXUNIDXREN"'
    end
    object qlimiteCAN_MAXUNIDXTICKET: TSmallintField
      FieldName = 'CAN_MAXUNIDXTICKET'
      Origin = '"OSMALIMITES"."CAN_MAXUNIDXTICKET"'
    end
    object qlimiteCAN_MAXRENXTICKET: TSmallintField
      FieldName = 'CAN_MAXRENXTICKET'
      Origin = '"OSMALIMITES"."CAN_MAXRENXTICKET"'
    end
  end
  object tranlimite: TIBTransaction
    DefaultDatabase = databasefire
    Left = 240
    Top = 304
  end
  object qdire: TIBQuery
    Database = databasefire
    Transaction = transdire
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select des_direccion from sumasucursal where nro_sucursal=:sucur' +
        'sal')
    Left = 236
    Top = 364
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'sucursal'
        ParamType = ptUnknown
      end>
    object qdireDES_DIRECCION: TIBStringField
      FieldName = 'DES_DIRECCION'
      Origin = '"SUMASUCURSAL"."DES_DIRECCION"'
      Size = 40
    end
  end
  object transdire: TIBTransaction
    DefaultDatabase = databasefire
    Left = 240
    Top = 416
  end
  object qcuit: TIBQuery
    Database = databasefire
    Transaction = tcuit
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select nro_cuit from sumasucursal where nro_sucursal=:sucursal')
    Left = 248
    Top = 189
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'sucursal'
        ParamType = ptUnknown
      end>
    object qcuitNRO_CUIT: TIBStringField
      FieldName = 'NRO_CUIT'
      Origin = '"SUMASUCURSAL"."NRO_CUIT"'
      Size = 13
    end
  end
  object tcuit: TIBTransaction
    DefaultDatabase = databasefire
    Left = 245
    Top = 138
  end
  object cdsreporteiva: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 760
    Top = 456
    object cdsreporteivafecha: TDateField
      FieldName = 'fecha'
    end
    object cdsreporteivacomprobante: TStringField
      FieldName = 'comprobante'
      Size = 40
    end
    object cdsreporteivadescripcion: TStringField
      DisplayWidth = 30
      FieldName = 'descripcion'
      Size = 30
    end
    object cdsreporteivacliente: TStringField
      FieldName = 'cliente'
    end
    object cdsreporteivacuit: TStringField
      FieldName = 'cuit'
    end
    object cdsreporteivanetogravado: TCurrencyField
      FieldName = 'netogravado'
    end
    object cdsreporteivatasa: TFloatField
      FieldName = 'tasa'
    end
    object cdsreporteivaimporteiva: TCurrencyField
      FieldName = 'importeiva'
    end
    object cdsreporteivanogravado: TCurrencyField
      FieldName = 'nogravado'
    end
    object cdsreporteivapercepcionibb: TFloatField
      FieldName = 'percepcionibb'
    end
    object cdsreporteivatotal: TCurrencyField
      FieldName = 'total'
    end
  end
  object qreporteiva: TIBQuery
    Database = databasefire
    Transaction = transactionprod
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select'
      'SUBSTR(v.nro_comprobante, 1, 2) as puestoventa,'
      'min(v.nro_comprobante)as minimo,'
      'MAX(v.nro_comprobante)as maximo,'
      'v.tip_comprobante,'
      't.des_comp,'
      'i.por_porcentaje,'
      ''
      'case when t.mar_letra='#39'A'#39' then c.nro_cuit else NULL end as cuit,'
      
        'case when t.mar_letra='#39'A'#39' then V.nom_cliente else '#39'CONSUMIDOR FI' +
        'NAL'#39' end as cliente,'
      ''
      'cast(fec_comprobante as date) as fecha,'
      'SUM (cast((v.imp_bruto) as decimal (10,2))) as bruto,'
      'sum(cast(i.imp_iva+i.imp_iva_desc as decimal(10,2)))  as iva,'
      
        'sum(case when i.por_porcentaje>0 then (cast(i.imp_netograv+i.imp' +
        '_netograv_desc as decimal(10,2))) end )  as netogravado,'
      
        'sum(case when i.por_porcentaje=0 then (cast(i.imp_netograv+i.imp' +
        '_netograv_desc as decimal(10,2))) end ) as netonogravado,'
      'sum(cast(i.imp_netograv_desc as decimal(10,2))) as netogravdesc,'
      
        'sum(cast(i.imp_iva_desc+i.imp_iva+i.imp_netograv+i.imp_netograv_' +
        'desc as decimal(10,2))) as total'
      ''
      'from vtmacomprobemitido v'
      
        'inner join vtmatipcomprob t on v.tip_comprobante=t.tip_comproban' +
        'te'
      'left join mkmacliente c on v.cod_cliente=c.cod_cliente'
      
        'inner join vtmaporcentajesiva i  on i.tip_comprobante=t.tip_comp' +
        'robante and  v.nro_comprobante=i.nro_comprobante and v.nro_sucur' +
        'sal=i.nro_sucursal,'
      'sumasucursal s'
      'where'
      'v.nro_sucursal=s.nro_sucursal'
      'and'
      's.nro_sucursal=i.nro_sucursal'
      'and'
      
        ' (CAST(v.fec_comprobante AS DATE))  between (:desde) and (:hasta' +
        ')'
      'and v.nro_sucursal=:sucursal'
      ''
      ''
      'AND T.MAR_SUBDIA = '#39'V'#39
      
        'anD t.tip_comprobante  NOT IN ('#39'NCT'#39','#39'NCA'#39','#39'IA0'#39','#39'IA1'#39','#39'IA2'#39','#39'IA' +
        '3'#39','#39'IA4'#39','#39'RA6'#39','#39'IA5'#39','#39'IA6'#39','#39'IA7'#39','#39'IA8'#39','#39'IA9'#39','#39'IAD'#39','#39'IAF'#39','#39'IAG'#39','#39 +
        'IAH'#39','#39'IAI'#39','#39'IAJ'#39','#39'IAK'#39','#39'TA0'#39','#39'TA1'#39','#39'TA2'#39','#39'TA3'#39','#39'TA4'#39','#39'TA5'#39','#39'TA6'#39 +
        ','#39'TA7'#39','#39'TA8'#39','#39'TA9'#39','#39'TAD'#39','#39'TAF'#39','#39'TAG'#39','#39'TAE'#39','#39'TAH'#39','#39'TAI'#39','#39'TAJ'#39','#39'TA' +
        'K'#39','#39'IV0'#39','#39'IV1'#39','#39'IV2'#39','#39'IV3'#39','#39'IV4'#39','#39'IV5'#39','#39'IV6'#39','#39'IV8'#39','#39'IV7'#39','#39'IV9'#39','#39 +
        'IVD'#39','#39'IVG'#39','#39'IVF'#39','#39'IVJ'#39','#39'TKM'#39')'
      'group by 1,4,5,6,7,8,9'
      ''
      ''
      'union all'
      ''
      'select'
      'SUBSTR(v.nro_comprobante, 1, 2) as puestoventa,'
      'min(v.nro_comprobante)as minimo,'
      'MAX(v.nro_comprobante)as maximo,'
      'v.tip_comprobante,'
      't.des_comp,'
      'i.por_porcentaje,'
      ''
      'case when t.mar_letra='#39'A'#39' then c.nro_cuit else NULL end as cuit,'
      
        'case when t.mar_letra='#39'A'#39' then V.nom_cliente else '#39'CONSUMIDOR FI' +
        'NAL'#39' end as cliente,'
      ''
      
        'cast(fec_comprobante as date) as fecha,                --(cast(i' +
        '.imp_iva+i.imp_iva_desc as decimal(10,2)))*100  as iva'
      
        'sum(case when t.tip_comprobante in ('#39'NCT'#39','#39'NCA'#39') THEN cast(v.imp' +
        '_bruto*-1 as decimal (10,2)) ELSE cast(V.IMP_BRUTO as decimal (1' +
        '0,2)) END )as bruto,'
      
        'sum(case when t.tip_comprobante in ('#39'NCT'#39','#39'NCA'#39') THEN (cast(i.im' +
        'p_iva+i.imp_iva_desc as decimal (10,2)))*-1 ELSE (cast(i.imp_iva' +
        '+i.imp_iva_desc as decimal (10,2))) END) as iva,'
      
        'sum(case when i.por_porcentaje>0 then (case when t.tip_comproban' +
        'te in ('#39'NCT'#39','#39'NCA'#39') THEN (cast(i.imp_netograv+i.imp_netograv_des' +
        'c as decimal (10,2))*-1) ELSE (cast(i.imp_netograv+i.imp_netogra' +
        'v_desc as decimal (10,2))) END) end )as netogravado,'
      
        'sum(case when i.por_porcentaje=0 then (case when t.tip_comproban' +
        'te in ('#39'NCT'#39','#39'NCA'#39') THEN (cast(i.imp_netograv+i.imp_netograv_des' +
        'c as decimal (10,2))*-1) ELSE (cast(i.imp_netograv+i.imp_netogra' +
        'v_desc as decimal (10,2))) END) end) as netonogravado,'
      
        'sum(case when t.tip_comprobante in ('#39'NCT'#39','#39'NCA'#39') THEN (cast(i.im' +
        'p_netograv_desc as decimal (10,2))*-1) ELSE (cast(i.imp_netograv' +
        '_desc as decimal (10,2)))END )as netogravdesc,'
      
        'sum((case when t.tip_comprobante in ('#39'NCT'#39','#39'NCA'#39') THEN -1 else 1' +
        ' end)* (cast(i.imp_iva_desc+i.imp_iva+i.imp_netograv+i.imp_netog' +
        'rav_desc as decimal(10,2)))) as total'
      ''
      'from vtmacomprobemitido v'
      
        'inner join vtmatipcomprob t on v.tip_comprobante=t.tip_comproban' +
        'te'
      'left join mkmacliente c on v.cod_cliente=c.cod_cliente'
      
        'inner join vtmaporcentajesiva i  on i.tip_comprobante=t.tip_comp' +
        'robante and  v.nro_comprobante=i.nro_comprobante and v.nro_sucur' +
        'sal=i.nro_sucursal,'
      'sumasucursal s'
      ''
      'where'
      'v.nro_sucursal=s.nro_sucursal'
      'and'
      's.nro_sucursal=i.nro_sucursal'
      'and'
      
        ' (CAST(v.fec_comprobante AS DATE))  between (:desde) and (:hasta' +
        ')'
      'and v.nro_sucursal=:sucursal'
      ''
      'AND T.MAR_SUBDIA = '#39'V'#39
      
        'anD t.tip_comprobante IN ('#39'NCT'#39','#39'NCA'#39','#39'IA0'#39','#39'IA1'#39','#39'IA2'#39','#39'IA3'#39','#39'I' +
        'A4'#39','#39'IA5'#39','#39'IA6'#39','#39'RA6'#39','#39'IA7'#39','#39'IA8'#39','#39'IA9'#39','#39'IAD'#39','#39'IAF'#39','#39'IAG'#39','#39'IAH'#39',' +
        #39'IAI'#39','#39'IAJ'#39','#39'IAK'#39','#39'TA0'#39','#39'TA1'#39','#39'TA2'#39','#39'TA3'#39','#39'TA4'#39','#39'TA5'#39','#39'TA6'#39','#39'TA7' +
        #39','#39'TA8'#39','#39'TA9'#39','#39'TAD'#39','#39'TAF'#39','#39'TAG'#39','#39'TAE'#39','#39'TAH'#39','#39'TAI'#39','#39'TAJ'#39','#39'TAK'#39','#39'I' +
        'V0'#39','#39'IV1'#39','#39'IV2'#39','#39'IV3'#39','#39'IV4'#39','#39'IV5'#39','#39'IV6'#39','#39'IV7'#39','#39'IV8'#39','#39'IV9'#39','#39'IVD'#39',' +
        #39'IVG'#39','#39'IVF'#39','#39'IVJ'#39','#39'TKM'#39')'
      'group by 1,4,5,6,7,8,9'
      ''
      'order by 9')
    Left = 760
    Top = 384
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'desde'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'hasta'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'sucursal'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'desde'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'hasta'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'sucursal'
        ParamType = ptUnknown
      end>
    object qreporteivaPUESTOVENTA: TIBStringField
      FieldName = 'PUESTOVENTA'
      ProviderFlags = []
      Size = 80
    end
    object qreporteivaMINIMO: TFloatField
      FieldName = 'MINIMO'
      ProviderFlags = []
    end
    object qreporteivaMAXIMO: TFloatField
      FieldName = 'MAXIMO'
      ProviderFlags = []
    end
    object qreporteivaTIP_COMPROBANTE: TIBStringField
      FieldName = 'TIP_COMPROBANTE'
      Origin = '"VTMACOMPROBEMITIDO"."TIP_COMPROBANTE"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 3
    end
    object qreporteivaPOR_PORCENTAJE: TIBBCDField
      FieldName = 'POR_PORCENTAJE'
      Origin = '"VTMAPORCENTAJESIVA"."POR_PORCENTAJE"'
      Precision = 9
      Size = 3
    end
    object qreporteivaCUIT: TIBStringField
      FieldName = 'CUIT'
      ProviderFlags = []
      Size = 13
    end
    object qreporteivaCLIENTE: TIBStringField
      FieldName = 'CLIENTE'
      ProviderFlags = []
      Size = 40
    end
    object qreporteivaFECHA: TDateField
      FieldName = 'FECHA'
      ProviderFlags = []
    end
    object qreporteivaBRUTO: TIBBCDField
      FieldName = 'BRUTO'
      ProviderFlags = []
      Precision = 18
      Size = 2
    end
    object qreporteivaIVA: TIBBCDField
      FieldName = 'IVA'
      ProviderFlags = []
      Precision = 18
      Size = 2
    end
    object qreporteivaNETOGRAVADO: TIBBCDField
      FieldName = 'NETOGRAVADO'
      ProviderFlags = []
      Precision = 18
      Size = 2
    end
    object qreporteivaNETONOGRAVADO: TIBBCDField
      FieldName = 'NETONOGRAVADO'
      ProviderFlags = []
      Precision = 18
      Size = 2
    end
    object qreporteivaNETOGRAVDESC: TIBBCDField
      FieldName = 'NETOGRAVDESC'
      ProviderFlags = []
      Precision = 18
      Size = 2
    end
    object qreporteivaTOTAL: TIBBCDField
      FieldName = 'TOTAL'
      ProviderFlags = []
      Precision = 18
      Size = 2
    end
    object qreporteivaDES_COMP: TIBStringField
      FieldName = 'DES_COMP'
      Origin = '"VTMATIPCOMPROB"."DES_COMP"'
      Required = True
      Size = 30
    end
  end
  object tranreporteiva: TIBTransaction
    DefaultDatabase = databasefire
    Left = 832
    Top = 384
  end
  object dsreporteiva: TDataSource
    DataSet = cdsreporteiva
    Left = 832
    Top = 456
  end
  object qdroga: TIBQuery
    Database = databasefire
    Transaction = transactionprod
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select des_droga from prmamonodroga where des_droga like :droga')
    Left = 160
    Top = 308
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'droga'
        ParamType = ptUnknown
      end>
    object qdrogaDES_DROGA: TIBStringField
      FieldName = 'DES_DROGA'
      Origin = '"PRMAMONODROGA"."DES_DROGA"'
      Size = 50
    end
  end
  object dsdroga: TDataSource
    DataSet = qdroga
    Left = 192
    Top = 304
  end
  object qtablaiva: TIBQuery
    Database = databasefire
    Transaction = tpanel1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select cod_iva, por_iva from prmaiva')
    Left = 624
    Top = 213
  end
  object qbusquedastock: TIBQuery
    Database = databasefire
    Transaction = ticomprobante
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select can_stk from prmastock where cod_Alfabeta=:codigo and nro' +
        '_sucursal=:sucursal')
    Left = 712
    Top = 112
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'codigo'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'sucursal'
        ParamType = ptUnknown
      end>
  end
  object qinsertlineastock: TIBQuery
    Database = databasefire
    Transaction = ticomprobante
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select can_stk from prmastock where cod_Alfabeta=:codigo and nro' +
        '_sucursal=:sucursal')
    Left = 792
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'codigo'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'sucursal'
        ParamType = ptUnknown
      end>
  end
  object qranking: TIBQuery
    Database = databasefire
    Transaction = tranking
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 36
    Top = 640
  end
  object tranking: TIBTransaction
    DefaultDatabase = databasefire
    Left = 96
    Top = 640
  end
end
