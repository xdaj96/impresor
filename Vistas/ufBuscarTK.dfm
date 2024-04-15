object fBuscarTK: TfBuscarTK
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Numero de TK'
  ClientHeight = 138
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 124
    Height = 13
    Caption = 'Ingrese numero de ticket:'
  end
  object Label2: TLabel
    Left = 8
    Top = 0
    Width = 105
    Height = 13
    Caption = 'Tipo de comprobante:'
  end
  object eNroTK: TEdit
    Left = 8
    Top = 67
    Width = 217
    Height = 21
    TabOrder = 0
    OnKeyPress = eNroTKKeyPress
  end
  object BitBtn1: TBitBtn
    Left = 80
    Top = 105
    Width = 75
    Height = 25
    Caption = 'Buscar..'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object combotipo: TComboBox
    Left = 8
    Top = 19
    Width = 217
    Height = 23
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Bitstream Vera Sans Mono'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
end
