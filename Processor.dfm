object ProcessorForm: TProcessorForm
  Left = 747
  Top = 611
  Width = 345
  Height = 108
  BorderIcons = []
  Caption = 'Progress'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressLabel: TLabel
    Left = 8
    Top = 8
    Width = 79
    Height = 13
    Caption = 'Creating album...'
  end
  object ImageCounterLabel: TLabel
    Left = 8
    Top = 56
    Width = 6
    Height = 13
    Caption = '0'
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 24
    Width = 321
    Height = 16
    Step = 1
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 256
    Top = 48
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    Default = True
    TabOrder = 1
    OnClick = CancelButtonClick
  end
  object RunJob: TTimer
    Enabled = False
    Interval = 1
    OnTimer = RunJobTimer
    Left = 184
    Top = 16
  end
end
