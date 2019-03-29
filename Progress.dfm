object ProgressForm: TProgressForm
  Left = 747
  Top = 611
  Width = 345
  Height = 148
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
  object StepProgressLabel: TLabel
    Left = 8
    Top = 8
    Width = 89
    Height = 13
    Caption = 'StepProgressLabel'
  end
  object OverallProgressLabel: TLabel
    Left = 8
    Top = 48
    Width = 76
    Height = 13
    Caption = 'Overall progress'
  end
  object StepProgressBar: TProgressBar
    Left = 8
    Top = 24
    Width = 321
    Height = 16
    TabOrder = 0
  end
  object OverallProgressBar: TProgressBar
    Left = 8
    Top = 64
    Width = 321
    Height = 16
    TabOrder = 1
  end
  object CancelButton: TButton
    Left = 256
    Top = 88
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    Default = True
    TabOrder = 2
    OnClick = CancelButtonClick
  end
  object RunJob: TTimer
    Enabled = False
    Interval = 1
    OnTimer = RunJobTimer
    Left = 8
    Top = 88
  end
end
