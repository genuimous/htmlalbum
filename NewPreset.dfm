object NewPresetForm: TNewPresetForm
  Left = 890
  Top = 674
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'New Preset'
  ClientHeight = 129
  ClientWidth = 233
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ParamsGroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 217
    Height = 81
    Caption = 'Preset parameters'
    TabOrder = 0
    object NameLabel: TLabel
      Left = 16
      Top = 24
      Width = 28
      Height = 13
      Caption = 'Name'
    end
    object NameEdit: TEdit
      Left = 16
      Top = 40
      Width = 185
      Height = 21
      TabOrder = 0
    end
  end
  object CancelButton: TButton
    Left = 150
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object OKButton: TButton
    Left = 70
    Top = 96
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
end
