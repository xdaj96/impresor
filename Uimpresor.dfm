object fimpresor: Tfimpresor
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Impresor'
  ClientHeight = 519
  ClientWidth = 531
  Color = clBtnFace
  UseDockManager = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pg: TPageControl
    Left = 3
    Top = 0
    Width = 530
    Height = 517
    ActivePage = Principal
    TabOrder = 0
    object Principal: TTabSheet
      Caption = 'Principal'
      object Label1: TLabel
        Left = 445
        Top = 468
        Width = 64
        Height = 13
        Caption = 'Versi'#243'n 0.5.0'
      end
      object flist: TFileListBox
        Left = 0
        Top = 3
        Width = 517
        Height = 97
        ItemHeight = 13
        Mask = '*.xml'
        TabOrder = 0
      end
      object mticket: TMemo
        Left = 0
        Top = 102
        Width = 517
        Height = 163
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Bitstream Vera Sans Mono'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object binsertar: TBitBtn
        Left = 242
        Top = 254
        Width = 81
        Height = 25
        Caption = 'Insertar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Bitstream Vera Sans Mono'
        Font.Style = []
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFF0E0BAB2321B3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA9A8E31712CB312EBAFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFCFCFE4A47CD201AF22C29B6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC1C1E62A24E81B13FF33
          31B6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF6160C8332BFF150EF52F2CBCFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCDBF51610B62F2CF41B
          18FC1E1BFA3330C2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFAFADE73A38DA4248FF1417F81614DEBEBCEAFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2623C34B4FE73D
          4AFE2029F1423DD6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF3D37D07C84F36F87FF6673F73D39D5FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC9C9F440
          3CDC7D93FC6882FB6A7EF83531D9EFEFFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFBBB8F45958E87D96FD6781F86C84FA677BF74541DFF2F1
          FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBAB8F36367ED88
          A7FF6B83F87695FC4E56ECCCCBF6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF312CDF707BF281A5FD728DF981A2FD4649E9A7A3
          F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF38
          30E58197F87EA0FA85A9FC819DFA2E29E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2B23E69BBDFE788DF84E47EAF9F9
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFF8884F13735EA4840EBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentFont = False
        TabOrder = 2
        Visible = False
        OnClick = binsertarClick
      end
      object Blimpiartodo: TBitBtn
        Left = 329
        Top = 254
        Width = 109
        Height = 25
        Caption = 'Limpiar (F2)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Bitstream Vera Sans Mono'
        Font.Style = []
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
          9C9699746D70716A6B716A6B716A6B716A6B716A6B716A6B716A6B716A6B716A
          6D9C9699FFFFFFFFFFFFFFFFFFFFFFFF776C70A2AFA5A2AFA5A2AFA5A2AFA5A2
          AFA5A2AFA5A2AFA5A2AFA5A2AFA5A2AFA5796E72FFFFFFFFFFFFFFFFFFFFFFFF
          837B7FC9C5C7008036278E5236945CA9BEAF9BB9A5008036008036008036C9C5
          C7837B7FFFFFFFFFFFFFFFFFFFC5C0C2A19B9CE8E6E604904248A872E0DFDDE0
          DFDDE0DFDDE0DFDD64B286049042E8E6E6A19B9CDDDADBFFFFFFFFFFFFACA5A8
          C9C5C7F0EEED84D6AF26A863E1E8E3F0EEEDF0EEEDE1E8E317A35984D6AFF0EE
          EDC9C5C7BFBABCFFFFFFFFFFFF91888CE8E6E6FCFBF9EDF5F0FCFBF9EDF5F0FC
          FBF9FCFBF9DDF1E6EDF5F0DFF1E6FCFBF9E8E6E69F979BFFFFFFFFFFFF7E7478
          FFFEFEFFFEFEFFFEFEFFFEFE0BAF60B3E6CCB3E6CC0BAF60FFFEFEFFFEFEFFFE
          FEFFFEFE887E82FFFFFFFFFFFF877F83F0EEEDF0EEEDF0EEEDF0EEED23AD6C64
          B28664B28615A963E0E8E3F0EEEDF0EEEDF0EEED8C8488FFFFFFFFFFFF9F9598
          DDDCDADDDCDADDDCDADDDCDADDDCDA019750019750DDDCDADDDCDADDDCDADDDC
          DADDDCDA9F9598FFFFFFFFFFFFAAA2A5CBC8C7CBC8C7CBC8C7CBC8C7CBC8C7CB
          C8C7CBC8C7CBC8C7CBC8C7CBC8C7CBC8C7CBC8C7AAA2A5FFFFFF186B1D0A791C
          0A791C0A791C0A791C0A791C0A791C0A791C0A791C0A791C0A791C0A791C0A79
          1C0A791C0A791C136A181F8B3635C06435C06435C06435C06435C06435C06435
          C06435C06435C06435C06435C06435C06435C06435C0640D8326229B4541D48E
          41D48E41D48E41D48E41D48E41D48E41D48E41D48E41D48E41D48E41D48E41D4
          8E41D48E41D48E0E94372D9A47239E4D1C96461A9040178B3C16873915863815
          863815863815863816883A178B3C1A90411C96461F9C4B219740FFFFFF55985A
          096F15086A14086512076311076211076211076211076211076412086713096B
          14096F1546914CFFFFFFFFFFFFFFFFFF6CAC73388E42167B220A74170A74170A
          74170A74170A74170A74171C7E2842944C76B27DFFFFFFFFFFFF}
        ParentFont = False
        TabOrder = 3
        Visible = False
        OnClick = BlimpiartodoClick
      end
      object HASAR: THASAR
        Left = 416
        Top = 3
        Width = 32
        Height = 32
        ControlData = {000300004F0300004F030000}
      end
      object bimprimir: TBitBtn
        Left = 0
        Top = 254
        Width = 121
        Height = 25
        Caption = 'Imprimir'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Bitstream Vera Sans Mono'
        Font.Style = []
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFD7C39BECE3D6ECE3D6ECE3D6ECE3D6ECE3D6ECE3D6D7C39BFFFF
          FFFFFFFFFFFFFFFFFFFFB0ACACB1ACACA7A2A2726C73C4AB7FEDE1D5EDE1D5ED
          E1D5EDE1D5EDE1D5EDE1D5C4AB7F767177A49E9EA9A4A4ABA5A5958F8FC3C0BF
          C3C0BF837D84C6A874E0CBAEE0CBAEE0CBAEE0CBAEE0CBAEE0CBAEC6A874837D
          84C3C0BFC3C0BF999292A49FA1D1CFCED1CFCED3D2D1D2D2D3D0D0D2D0D0D2D0
          D0D2D0D0D2D0D0D2D0D0D2D2D2D3D3D2D1BACAD76E9BE3A49FA1AAA7A7D9D7D7
          D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7
          D78AC3E9004BFBABA8A8B7B3B3E6E8E9D6C5AFBC6B10BB6A0FBB6A0FBB6A0FBB
          6A0FBB6A0FBB6A0FBB6A0FBB6A0FBC6B10D6C5AFE6E8E9B8B5B5BCB9BAEEF2F5
          BA7B3EE1A942E1A842E1A842E1A842E1A842E1A842E1A842E1A842E1A842E1A9
          42BA7B3EEEF2F5BFBBBCCDC8C9F8FCFFCD9753EEC670EEC771EEC771EEC771EE
          C771EEC771EEC771EEC771EEC771EEC670CD9753F8FCFFCECBCCD2D0D0FCFFFF
          D7A55CEDC977E9BF68E9BF68E9BF68E9BF68E9BF68E9BF68E9BF68E9BF68EDC9
          77D7A55CFCFFFFD4D1D0DEDCDBFFFFFFE8C070E0AC54B99D6BD7BD91D7BD91D7
          BD91D7BD91D7BD91D7BD91B99D6BE0AC54E8C070FFFFFFE3DFDFD1CBCDBCBBC0
          DEB673CF9E5FC4AB7FDFCAADDFCAADDFCAADDFCAADDFCAADDFCAADC4AB7FCD99
          56DDB36EBEBDC1D1CACCFFFFFFFFFFFFFFFFFFFFFFFFD0BD98ECDFD1ECDFD1EC
          DFD1ECDFD1ECDFD1ECDFD1D0BD98FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFD5C4A4EFE4D8EFE4D8EFE4D8EFE4D8EFE4D8EFE4D8D5C4A4FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDED0B8F5EDE4F5EDE4F5
          EDE4F5EDE4F5EDE4F5EDE4DED0B8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFE2D6C1F8F3EAF8F3EAF8F3EAF8F3EAF8F3EAF8F3EAE2D6C1FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7DDCDEFE8DBEFE8DBEF
          E8DBEFE8DBEFE8DBEFE8DBE8DFD0FFFFFFFFFFFFFFFFFFFFFFFF}
        ParentFont = False
        TabOrder = 5
        Visible = False
        OnClick = bimprimirClick
      end
      object Gfacturador: TDBGrid
        Left = 1
        Top = 280
        Width = 516
        Height = 182
        TabStop = False
        Color = clWhite
        DataSource = dsource
        DrawingStyle = gdsGradient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 6
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        StyleElements = []
        Columns = <
          item
            Expanded = False
            FieldName = 'NRO_TROQUEL'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            ReadOnly = True
            Title.Caption = 'Troquel'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Width = 90
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOM_LARGO'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            ReadOnly = True
            Title.Caption = 'Descripcion'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Width = 250
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRECIO'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            ReadOnly = True
            Title.Caption = 'Precio'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Visible = True
          end
          item
            Color = clInfoText
            Expanded = False
            FieldName = 'CANTIDAD'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHighlightText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = [fsBold]
            Title.Caption = 'Cantidad'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Width = 71
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESCUENTOS'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            ReadOnly = True
            Title.Caption = 'Descuentos'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRECIO_TOTALDESC'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            ReadOnly = True
            Title.Caption = 'Precio c/descuento'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRECIO_TOTAL'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            ReadOnly = True
            Title.Caption = 'Precio Total'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Width = 97
            Visible = True
          end
          item
            Color = clGreen
            Expanded = False
            FieldName = 'porcentaje'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindow
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = [fsBold]
            Title.Caption = 'Porcentaje'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Width = 76
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COD_ALFABETA'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            ReadOnly = True
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COD_BARRASPRI'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            ReadOnly = True
            Title.Caption = 'Codigo de barras'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COD_IVA'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            ReadOnly = True
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Visible = True
          end
          item
            Color = clMoneyGreen
            Expanded = False
            FieldName = 'PORCENTAJEOS'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = [fsBold]
            Title.Caption = '%OS'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Visible = True
          end
          item
            Color = clInactiveCaption
            Expanded = False
            FieldName = 'PORCENTAJECO1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = [fsBold]
            Title.Caption = '%CO1'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PORCENTAJECO2'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            Title.Caption = '%CO2'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESCUENTOSOS'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            Title.Caption = 'DescuentosOS'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COD_LABORATORIO'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            Title.Caption = 'Laboratorio'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'can_stk'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            Title.Caption = 'STOCK'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VALE'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            ReadOnly = True
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Width = 52
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'can_vale'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            Title.Caption = 'Cantidad Vale'
            Title.Color = clMenuBar
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Width = 108
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'tamano'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            Title.Caption = 'Tama'#241'o'
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'Bitstream Vera Sans Mono'
            Title.Font.Style = []
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESCUENTOCO1'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Modificado'
            Visible = True
          end
          item
            Color = clTeal
            Expanded = False
            FieldName = 'GENTILEZA'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RUBRO'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'IMPORTEGENT'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clDefault
            Font.Height = -15
            Font.Name = 'Bitstream Vera Sans Mono'
            Font.Style = []
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CODAUTORIZACION'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Item'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESCUENTOCO2'
            Visible = True
          end>
      end
      object Bimprimire: TBitBtn
        Left = 127
        Top = 254
        Width = 109
        Height = 25
        Caption = 'ImprimirE'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Bitstream Vera Sans Mono'
        Font.Style = []
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFD7C39BECE3D6ECE3D6ECE3D6ECE3D6ECE3D6ECE3D6D7C39BFFFF
          FFFFFFFFFFFFFFFFFFFFB0ACACB1ACACA7A2A2726C73C4AB7FEDE1D5EDE1D5ED
          E1D5EDE1D5EDE1D5EDE1D5C4AB7F767177A49E9EA9A4A4ABA5A5958F8FC3C0BF
          C3C0BF837D84C6A874E0CBAEE0CBAEE0CBAEE0CBAEE0CBAEE0CBAEC6A874837D
          84C3C0BFC3C0BF999292A49FA1D1CFCED1CFCED3D2D1D2D2D3D0D0D2D0D0D2D0
          D0D2D0D0D2D0D0D2D0D0D2D2D2D3D3D2D1BACAD76E9BE3A49FA1AAA7A7D9D7D7
          D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7
          D78AC3E9004BFBABA8A8B7B3B3E6E8E9D6C5AFBC6B10BB6A0FBB6A0FBB6A0FBB
          6A0FBB6A0FBB6A0FBB6A0FBB6A0FBC6B10D6C5AFE6E8E9B8B5B5BCB9BAEEF2F5
          BA7B3EE1A942E1A842E1A842E1A842E1A842E1A842E1A842E1A842E1A842E1A9
          42BA7B3EEEF2F5BFBBBCCDC8C9F8FCFFCD9753EEC670EEC771EEC771EEC771EE
          C771EEC771EEC771EEC771EEC771EEC670CD9753F8FCFFCECBCCD2D0D0FCFFFF
          D7A55CEDC977E9BF68E9BF68E9BF68E9BF68E9BF68E9BF68E9BF68E9BF68EDC9
          77D7A55CFCFFFFD4D1D0DEDCDBFFFFFFE8C070E0AC54B99D6BD7BD91D7BD91D7
          BD91D7BD91D7BD91D7BD91B99D6BE0AC54E8C070FFFFFFE3DFDFD1CBCDBCBBC0
          DEB673CF9E5FC4AB7FDFCAADDFCAADDFCAADDFCAADDFCAADDFCAADC4AB7FCD99
          56DDB36EBEBDC1D1CACCFFFFFFFFFFFFFFFFFFFFFFFFD0BD98ECDFD1ECDFD1EC
          DFD1ECDFD1ECDFD1ECDFD1D0BD98FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFD5C4A4EFE4D8EFE4D8EFE4D8EFE4D8EFE4D8EFE4D8D5C4A4FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDED0B8F5EDE4F5EDE4F5
          EDE4F5EDE4F5EDE4F5EDE4DED0B8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFE2D6C1F8F3EAF8F3EAF8F3EAF8F3EAF8F3EAF8F3EAE2D6C1FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7DDCDEFE8DBEFE8DBEF
          E8DBEFE8DBEFE8DBEFE8DBE8DFD0FFFFFFFFFFFFFFFFFFFFFFFF}
        ParentFont = False
        TabOrder = 7
        Visible = False
        OnClick = BimprimireClick
      end
      object Button2: TButton
        Left = 215
        Top = 461
        Width = 84
        Height = 25
        Caption = 'ESTADO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Bitstream Vera Sans Mono'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        Visible = False
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 135
        Top = 461
        Width = 84
        Height = 25
        Caption = 'IMPRIMIR Z'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Bitstream Vera Sans Mono'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        Visible = False
        OnClick = Button3Click
      end
      object btnReimprimir: TBitBtn
        Left = 1
        Top = 461
        Width = 136
        Height = 25
        Caption = 'Reimprimir'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Bitstream Vera Sans Mono'
        Font.Style = []
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFD7C39BECE3D6ECE3D6ECE3D6ECE3D6ECE3D6ECE3D6D7C39BFFFF
          FFFFFFFFFFFFFFFFFFFFB0ACACB1ACACA7A2A2726C73C4AB7FEDE1D5EDE1D5ED
          E1D5EDE1D5EDE1D5EDE1D5C4AB7F767177A49E9EA9A4A4ABA5A5958F8FC3C0BF
          C3C0BF837D84C6A874E0CBAEE0CBAEE0CBAEE0CBAEE0CBAEE0CBAEC6A874837D
          84C3C0BFC3C0BF999292A49FA1D1CFCED1CFCED3D2D1D2D2D3D0D0D2D0D0D2D0
          D0D2D0D0D2D0D0D2D0D0D2D2D2D3D3D2D1BACAD76E9BE3A49FA1AAA7A7D9D7D7
          D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7D7D9D7
          D78AC3E9004BFBABA8A8B7B3B3E6E8E9D6C5AFBC6B10BB6A0FBB6A0FBB6A0FBB
          6A0FBB6A0FBB6A0FBB6A0FBB6A0FBC6B10D6C5AFE6E8E9B8B5B5BCB9BAEEF2F5
          BA7B3EE1A942E1A842E1A842E1A842E1A842E1A842E1A842E1A842E1A842E1A9
          42BA7B3EEEF2F5BFBBBCCDC8C9F8FCFFCD9753EEC670EEC771EEC771EEC771EE
          C771EEC771EEC771EEC771EEC771EEC670CD9753F8FCFFCECBCCD2D0D0FCFFFF
          D7A55CEDC977E9BF68E9BF68E9BF68E9BF68E9BF68E9BF68E9BF68E9BF68EDC9
          77D7A55CFCFFFFD4D1D0DEDCDBFFFFFFE8C070E0AC54B99D6BD7BD91D7BD91D7
          BD91D7BD91D7BD91D7BD91B99D6BE0AC54E8C070FFFFFFE3DFDFD1CBCDBCBBC0
          DEB673CF9E5FC4AB7FDFCAADDFCAADDFCAADDFCAADDFCAADDFCAADC4AB7FCD99
          56DDB36EBEBDC1D1CACCFFFFFFFFFFFFFFFFFFFFFFFFD0BD98ECDFD1ECDFD1EC
          DFD1ECDFD1ECDFD1ECDFD1D0BD98FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFD5C4A4EFE4D8EFE4D8EFE4D8EFE4D8EFE4D8EFE4D8D5C4A4FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDED0B8F5EDE4F5EDE4F5
          EDE4F5EDE4F5EDE4F5EDE4DED0B8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFE2D6C1F8F3EAF8F3EAF8F3EAF8F3EAF8F3EAF8F3EAE2D6C1FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7DDCDEFE8DBEFE8DBEF
          E8DBEFE8DBEFE8DBEFE8DBE8DFD0FFFFFFFFFFFFFFFFFFFFFFFF}
        ParentFont = False
        TabOrder = 10
        OnClick = btnReimprimirClick
      end
    end
    object Configuracion: TTabSheet
      Caption = 'Configuracion'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Bguardar: TBitBtn
        Left = 35
        Top = 415
        Width = 91
        Height = 25
        Caption = 'Guardar'
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000C1761BC27519
          BD6B13B96504B96504B96504BA6504BA6504BA6504BA6504BA6504BA6504BA65
          04BC690AB96A15C3791FD5933DEFB736CDC6C0E9F8FFDBE5F6DBE8F8DBE8F8DB
          E8F9DBE8F8DAE7F8DBE7F8D8E4F5E9F6FFCDC6C0EAA714C0761DCD9551E8AE3C
          DCD7D4ECE8E9ADA0A2A79B9E9E939594898C8A818583797C7B7276685F64ECE8
          E9DCD7D4E59E20C77B25D09653EAB447DCD7D4EFF0EFDFDEDCE1E0DFE0DFDEDF
          E0DDE0DFDDDFDEDDDFE0DEDBD9D9EDEDEDDCD7D4E7A62BC9802BD49B58EBB950
          DCD7D4ECE8E9A99D9FA4999E9A919492888B897F8582797C7A7177655C62ECE8
          E9DCD7D4E8AC37CC8531D69E5BEDBD5ADCD7D4FFFFFFFFFEFEFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCD7D4EAB340D08B34D9A45EF0C263
          DCD7D4ECE8E9A99D9FA4999E9A919492888B897F8582797C7A7177655C62ECE8
          E9DCD7D4EDB749D2903AD8A35CF0C66DDCD7D4FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCD7D4EEBD54D7963EDEAC69F9D281
          C1975C9A7B6095775E97795D97795D97795D97795D97795C97795C95775E9A7A
          5EC19A64F7CA6BD99B44DDAB67F6D58BFFD056C0A887C8C5C9CEC6BFCDC6C0CD
          C6C0CDC6BFD6D0CAD6D3D0CFCED4C0A888FFD25DF3CC75DCA148DCA966F6D993
          FBC85DC2B4A2D7DEEBDDDDDDDCDDDEDCDBDDE7E8EAC8BAA7A29692C2B4A2C6BC
          A9FBCB63F3D07EE0A74CE5B973F6DA97FBCC62C8BAA7DDE0E9E1DFDDE0DFDEDF
          DDDCEFF3F99F886FE5AF479E9189C7BDB2FDCF6AF5D484E3AC51E9BC75F8DD9E
          FDCF69CEC0AFE3E7EFE7E5E3E6E5E4E5E4E2F1F6FFBAA386FFE873B5AB9ECAC0
          B8FFD26EF9DA8EE7B25BEAC079F8E09BFBD165D3C4AFEAEEF6ECEBE8ECEBE9EB
          E9E6FBFFFFA28E78DEAF4FA89C95D1C7B9FFDA78F5D889E2A442ECC47EFEF4D5
          FFE290DCD7D4F5FFFFF6FEFFF6FEFFF6FDFFFFFFFFDFDDDCC8BAA7DFDDDCE5E4
          E2FFDE88E4AA45FCF5ECECC681F0CA82F4CA7DE8C788EFCF94EFD498EDCF92EE
          D092EED093F2D396F7D79BF6D69BE6C48AEBB552FDF9F2FFFFFF}
        ModalResult = 4
        TabOrder = 0
        OnClick = BguardarClick
      end
      object Btestear: TBitBtn
        Left = 125
        Top = 415
        Width = 90
        Height = 25
        Caption = 'Testear'
        Kind = bkOK
        NumGlyphs = 2
        TabOrder = 1
      end
      object VLparametros: TValueListEditor
        Left = 35
        Top = 19
        Width = 462
        Height = 390
        Strings.Strings = (
          'Ruta base de datos='
          'Ruta base de configuracion='
          'Numero de sucursal='
          'Numero de comprobante='
          'Numero de Pv='
          'Puerto COM fiscal='
          'Ruta reportes='
          'Version IFH='
          'P-441F='
          'Ruta impresion='
          'Marca del Fiscal='
          'Modulo de caja='
          'Ruta errores='
          'Copia Talon='
          'Vale duplicado='
          'Conformidad afiliado='
          'Talon valida online='
          '')
        TabOrder = 2
        TitleCaptions.Strings = (
          'Parametro'
          'Valor')
        ColWidths = (
          158
          298)
      end
    end
  end
  object dsource: TDataSource
    DataSet = cdsdetalle
    Left = 451
    Top = 72
  end
  object cdsdetalle: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    Left = 384
    Top = 75
    object cdsdetalleCOD_ALFABETA: TStringField
      FieldName = 'COD_ALFABETA'
    end
    object cdsdetalleNRO_TROQUEL: TStringField
      FieldName = 'NRO_TROQUEL'
    end
    object cdsdetalleVALE: TStringField
      FieldName = 'VALE'
    end
    object cdsdetalleCOD_BARRASPRI: TStringField
      FieldName = 'COD_BARRASPRI'
    end
    object cdsdetalleNOM_LARGO: TStringField
      DisplayWidth = 40
      FieldName = 'NOM_LARGO'
      Size = 40
    end
    object cdsdetalleCOD_IVA: TStringField
      FieldName = 'COD_IVA'
    end
    object cdsdetallePRECIO: TCurrencyField
      FieldName = 'PRECIO'
    end
    object cdsdetalleCANTIDAD: TIntegerField
      FieldName = 'CANTIDAD'
    end
    object cdsdetallePRECIO_TOTAL: TCurrencyField
      FieldKind = fkInternalCalc
      FieldName = 'PRECIO_TOTAL'
    end
    object cdsdetallePRECIO_TOTALDESC: TCurrencyField
      FieldKind = fkInternalCalc
      FieldName = 'PRECIO_TOTALDESC'
    end
    object cdsdetalleDESCUENTOS: TCurrencyField
      DisplayWidth = 2
      FieldKind = fkInternalCalc
      FieldName = 'DESCUENTOS'
    end
    object cdsdetallePORCENTAJEOS: TFloatField
      FieldName = 'PORCENTAJEOS'
      Precision = 3
    end
    object cdsdetallePORCENTAJECO1: TFloatField
      FieldName = 'PORCENTAJECO1'
    end
    object cdsdetallePORCENTAJECO2: TFloatField
      FieldName = 'PORCENTAJECO2'
    end
    object cdsdetalleDESCUENTOSOS: TCurrencyField
      DisplayWidth = 10
      FieldName = 'DESCUENTOSOS'
    end
    object cdsdetalleDESCUENTOCO1: TCurrencyField
      DisplayWidth = 10
      FieldName = 'DESCUENTOCO1'
    end
    object cdsdetalleDESCUENTOCO2: TCurrencyField
      DisplayWidth = 10
      FieldName = 'DESCUENTOCO2'
    end
    object cdsdetalleCOD_LABORATORIO: TStringField
      DisplayWidth = 5
      FieldName = 'COD_LABORATORIO'
      Size = 5
    end
    object cdsdetallecan_stk: TIntegerField
      FieldName = 'can_stk'
    end
    object cdsdetalletamano: TIntegerField
      FieldName = 'tamano'
    end
    object cdsdetalleModificado: TBooleanField
      FieldName = 'Modificado'
    end
    object cdsdetalleGENTILEZA: TIntegerField
      FieldName = 'GENTILEZA'
    end
    object cdsdetalleRUBRO: TStringField
      FieldName = 'RUBRO'
    end
    object cdsdetalleIMPORTEGENT: TFloatField
      FieldName = 'IMPORTEGENT'
    end
    object cdsdetalleCODAUTORIZACION: TStringField
      FieldName = 'CODAUTORIZACION'
    end
    object cdsdetalleporcentaje: TFloatField
      DisplayWidth = 2
      FieldName = 'porcentaje'
      Precision = 3
    end
    object cdsdetalleItem: TIntegerField
      FieldName = 'Item'
    end
    object cdsdetallecan_vale: TStringField
      FieldName = 'can_vale'
    end
    object cdsdetalleimportetotal: TAggregateField
      FieldName = 'importetotal'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(precio_total)'
    end
    object cdsdetalledescuentos_total: TAggregateField
      FieldName = 'descuentos_total'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(descuentos)'
    end
    object cdsdetallenetoxcobrar: TAggregateField
      FieldName = 'netoxcobrar'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(precio_totaldesc)'
    end
    object cdsdetalleDESCUENTOTOTALOS: TAggregateField
      FieldName = 'DESCUENTOTOTALOS'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(descuentosos)'
    end
    object cdsdetalleDESCUENTOTOTALCO1: TAggregateField
      FieldName = 'DESCUENTOTOTALCO1'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(descuentoco1)'
    end
    object cdsdetalleDESCUENTOTOTALCO2: TAggregateField
      FieldName = 'DESCUENTOTOTALCO2'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(descuentoco2)'
    end
    object cdsdetalleTOTALGENTILEZA: TAggregateField
      FieldName = 'TOTALGENTILEZA'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'sum(IMPORTEGENT)'
    end
  end
  object contador: TTimer
    Interval = 2000
    OnTimer = contadorTimer
    Left = 419
    Top = 128
  end
end
