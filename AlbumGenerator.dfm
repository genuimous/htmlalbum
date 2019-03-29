object AlbumGeneratorForm: TAlbumGeneratorForm
  Left = 842
  Top = 435
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'HTML Album Generator'
  ClientHeight = 505
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PresetLabel: TLabel
    Left = 136
    Top = 8
    Width = 30
    Height = 13
    Caption = 'Preset'
  end
  object LanguageLabel: TLabel
    Left = 8
    Top = 8
    Width = 48
    Height = 13
    Caption = 'Language'
  end
  object SourceGroupBox: TGroupBox
    Left = 8
    Top = 56
    Width = 489
    Height = 129
    Caption = 'Source'
    TabOrder = 4
    object ImagesDirLabel: TLabel
      Left = 16
      Top = 24
      Width = 100
      Height = 13
      Caption = 'Directory with images'
    end
    object OutputDirLabel: TLabel
      Left = 16
      Top = 72
      Width = 75
      Height = 13
      Caption = 'Output directory'
    end
    object ImagesDirEdit: TEdit
      Left = 16
      Top = 40
      Width = 377
      Height = 21
      TabOrder = 0
      OnChange = ImagesDirEditChange
    end
    object ImagesBrowseButton: TButton
      Left = 400
      Top = 38
      Width = 75
      Height = 25
      Caption = 'Browse...'
      TabOrder = 1
      OnClick = ImagesBrowseButtonClick
    end
    object OutputDirEdit: TEdit
      Left = 16
      Top = 88
      Width = 377
      Height = 21
      TabOrder = 2
      OnChange = OutputDirEditChange
    end
    object OutputBrowseButton: TButton
      Left = 400
      Top = 86
      Width = 75
      Height = 25
      Caption = 'Browse...'
      TabOrder = 3
      OnClick = OutputBrowseButtonClick
    end
  end
  object PresetComboBox: TComboBox
    Left = 136
    Top = 24
    Width = 199
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnSelect = PresetComboBoxSelect
  end
  object AlbumParamsGroupBox: TGroupBox
    Left = 8
    Top = 192
    Width = 489
    Height = 129
    Caption = 'Album summary'
    TabOrder = 5
    object TitleLabel: TLabel
      Left = 16
      Top = 24
      Width = 20
      Height = 13
      Caption = 'Title'
    end
    object DescriptionLabel: TLabel
      Left = 184
      Top = 24
      Width = 53
      Height = 13
      Caption = 'Description'
    end
    object MainPageURLLabel: TLabel
      Left = 16
      Top = 72
      Width = 75
      Height = 13
      Caption = 'Main page URL'
    end
    object MainPageLinkLabel: TLabel
      Left = 248
      Top = 72
      Width = 69
      Height = 13
      Caption = 'Main page link'
    end
    object MaxImageCountLabel: TLabel
      Left = 416
      Top = 72
      Width = 34
      Height = 13
      Caption = 'Images'
    end
    object TitleEdit: TEdit
      Left = 16
      Top = 40
      Width = 161
      Height = 21
      TabOrder = 0
      OnChange = TitleEditChange
    end
    object DescriptionEdit: TEdit
      Left = 184
      Top = 40
      Width = 289
      Height = 21
      TabOrder = 1
      OnChange = DescriptionEditChange
    end
    object MainPageURLEdit: TEdit
      Left = 16
      Top = 88
      Width = 225
      Height = 21
      TabOrder = 2
      OnChange = MainPageURLEditChange
    end
    object MainPageLinkEdit: TEdit
      Left = 248
      Top = 88
      Width = 161
      Height = 21
      TabOrder = 3
      OnChange = MainPageLinkEditChange
    end
    object MaxImageCountEdit: TEdit
      Left = 416
      Top = 88
      Width = 41
      Height = 21
      TabOrder = 4
      Text = '1'
    end
    object MaxImageCountUpDown: TUpDown
      Left = 457
      Top = 88
      Width = 16
      Height = 21
      Associate = MaxImageCountEdit
      Min = 1
      Max = 9999
      Position = 1
      TabOrder = 5
      Thousands = False
      OnClick = MaxImageCountUpDownClick
    end
  end
  object ThumbnailsParamsGroupBox: TGroupBox
    Left = 104
    Top = 328
    Width = 89
    Height = 129
    Caption = 'Thumbnails'
    TabOrder = 7
    object ThumbnailsSizeLabel: TLabel
      Left = 16
      Top = 24
      Width = 20
      Height = 13
      Caption = 'Size'
    end
    object ThumbnailsHorizontalIndentLabel: TLabel
      Left = 16
      Top = 72
      Width = 30
      Height = 13
      Caption = 'Indent'
    end
    object ThumbnailsSizeUpDown: TUpDown
      Left = 57
      Top = 40
      Width = 15
      Height = 21
      Associate = ThumbnailsSizeEdit
      Min = 64
      Max = 512
      Position = 64
      TabOrder = 1
      OnClick = ThumbnailsSizeUpDownClick
    end
    object ThumbnailsIndentUpDown: TUpDown
      Left = 57
      Top = 88
      Width = 15
      Height = 21
      Associate = ThumbnailsIndentEdit
      TabOrder = 3
      OnClick = ThumbnailsIndentUpDownClick
    end
    object ThumbnailsSizeEdit: TEdit
      Left = 16
      Top = 40
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '64'
    end
    object ThumbnailsIndentEdit: TEdit
      Left = 16
      Top = 88
      Width = 41
      Height = 21
      TabOrder = 2
      Text = '0'
    end
  end
  object IndexParamsGroupBox: TGroupBox
    Left = 8
    Top = 328
    Width = 89
    Height = 129
    Caption = 'Index pages'
    TabOrder = 6
    object IndexColCountLabel: TLabel
      Left = 16
      Top = 24
      Width = 20
      Height = 13
      Caption = 'Cols'
    end
    object IndexRowCountLabel: TLabel
      Left = 16
      Top = 72
      Width = 27
      Height = 13
      Caption = 'Rows'
    end
    object IndexColCountUpDown: TUpDown
      Left = 57
      Top = 40
      Width = 15
      Height = 21
      Associate = IndexColCountEdit
      Min = 1
      Max = 10
      Position = 1
      TabOrder = 1
      OnClick = IndexColCountUpDownClick
    end
    object IndexRowCountUpDown: TUpDown
      Left = 57
      Top = 88
      Width = 15
      Height = 21
      Associate = IndexRowCountEdit
      Min = 1
      Position = 1
      TabOrder = 3
      OnClick = IndexRowCountUpDownClick
    end
    object IndexColCountEdit: TEdit
      Left = 16
      Top = 40
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '1'
    end
    object IndexRowCountEdit: TEdit
      Left = 16
      Top = 88
      Width = 41
      Height = 21
      TabOrder = 2
      Text = '1'
    end
  end
  object LanguageComboBox: TComboBox
    Left = 8
    Top = 24
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnSelect = LanguageComboBoxSelect
  end
  object RunButton: TButton
    Left = 8
    Top = 472
    Width = 489
    Height = 25
    Caption = 'Create album!'
    TabOrder = 9
    OnClick = RunButtonClick
  end
  object SavePresetButton: TButton
    Left = 342
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Save...'
    TabOrder = 2
    OnClick = SavePresetButtonClick
  end
  object DeletePresetButton: TButton
    Left = 422
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 3
    OnClick = DeletePresetButtonClick
  end
  object MiscGroupBox: TGroupBox
    Left = 200
    Top = 328
    Width = 297
    Height = 129
    Caption = 'Misc'
    TabOrder = 8
    object CSSFileURLLabel: TLabel
      Left = 16
      Top = 24
      Width = 62
      Height = 13
      Caption = 'CSS file URL'
    end
    object CSSFileURLEdit: TEdit
      Left = 16
      Top = 40
      Width = 265
      Height = 21
      TabOrder = 0
      OnChange = CSSFileURLEditChange
    end
    object IndexLinkCheckBox: TCheckBox
      Left = 16
      Top = 90
      Width = 241
      Height = 17
      Caption = 'Link to index from image pages (recommended)'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = IndexLinkCheckBoxClick
    end
  end
end
