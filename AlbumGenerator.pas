unit AlbumGenerator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, NewPreset, Utils, DialMessages,
  IniFiles, FileCtrl, Processor;

type
  TAlbumGeneratorForm = class(TForm)
    SourceGroupBox: TGroupBox;
    ImagesDirLabel: TLabel;
    ImagesDirEdit: TEdit;
    PresetLabel: TLabel;
    PresetComboBox: TComboBox;
    AlbumParamsGroupBox: TGroupBox;
    TitleLabel: TLabel;
    TitleEdit: TEdit;
    DescriptionLabel: TLabel;
    DescriptionEdit: TEdit;
    ImagesBrowseButton: TButton;
    MainPageURLEdit: TEdit;
    MainPageURLLabel: TLabel;
    MainPageLinkEdit: TEdit;
    MainPageLinkLabel: TLabel;
    ThumbnailsParamsGroupBox: TGroupBox;
    ThumbnailsSizeUpDown: TUpDown;
    ThumbnailsIndentUpDown: TUpDown;
    IndexParamsGroupBox: TGroupBox;
    IndexColCountUpDown: TUpDown;
    IndexRowCountUpDown: TUpDown;
    LanguageComboBox: TComboBox;
    LanguageLabel: TLabel;
    RunButton: TButton;
    SavePresetButton: TButton;
    ThumbnailsSizeEdit: TEdit;
    ThumbnailsSizeLabel: TLabel;
    ThumbnailsIndentEdit: TEdit;
    ThumbnailsHorizontalIndentLabel: TLabel;
    IndexColCountEdit: TEdit;
    IndexColCountLabel: TLabel;
    IndexRowCountLabel: TLabel;
    IndexRowCountEdit: TEdit;
    DeletePresetButton: TButton;
    MiscGroupBox: TGroupBox;
    CSSFileURLEdit: TEdit;
    CSSFileURLLabel: TLabel;
    IndexLinkCheckBox: TCheckBox;
    OutputDirLabel: TLabel;
    OutputDirEdit: TEdit;
    OutputBrowseButton: TButton;
    MaxImageCountLabel: TLabel;
    MaxImageCountEdit: TEdit;
    MaxImageCountUpDown: TUpDown;
    procedure SavePresetButtonClick(Sender: TObject);
    procedure ImagesBrowseButtonClick(Sender: TObject);
    procedure OutputBrowseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RunButtonClick(Sender: TObject);
    procedure ImagesDirEditChange(Sender: TObject);
    procedure OutputDirEditChange(Sender: TObject);
    procedure TitleEditChange(Sender: TObject);
    procedure DescriptionEditChange(Sender: TObject);
    procedure MainPageURLEditChange(Sender: TObject);
    procedure MainPageLinkEditChange(Sender: TObject);
    procedure IndexLinkCheckBoxClick(Sender: TObject);
    procedure CSSFileURLEditChange(Sender: TObject);
    procedure ThumbnailsSizeUpDownClick(Sender: TObject;
      Button: TUDBtnType);
    procedure ThumbnailsIndentUpDownClick(Sender: TObject;
      Button: TUDBtnType);
    procedure IndexColCountUpDownClick(Sender: TObject;
      Button: TUDBtnType);
    procedure IndexRowCountUpDownClick(Sender: TObject;
      Button: TUDBtnType);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PresetComboBoxSelect(Sender: TObject);
    procedure LanguageComboBoxSelect(Sender: TObject);
    procedure DeletePresetButtonClick(Sender: TObject);
    procedure MaxImageCountUpDownClick(Sender: TObject;
      Button: TUDBtnType);
  private
    { Private declarations }
    LanguagesDir: string;
    PresetsDir: string;
    Language: TLanguage;
    Preset: TPreset;
    Settings: TSettings;
    function LoadLanguage(const FileName: string;
      const Default: TLanguage): TLanguage;
    function LoadPreset(const FileName: string;
      const Default: TPreset): TPreset;
    procedure SavePreset(const Preset: TPreset; const FileName: string);
    function LoadSettings(const FileName: string;
      const Default: TSettings): TSettings;
    procedure SaveSettings(const Settings: TSettings; const FileName: string);
    procedure SetLanguage(const LanguageName: string);
    procedure SetPreset(const PresetName: string);
    procedure RefreshLanguages;
    procedure RefreshPresets;
  public
    { Public declarations }
  end;

var
  AlbumGeneratorForm: TAlbumGeneratorForm;

implementation

{$R *.dfm}

const
  DefaultSettings: TSettings =
  (
    LastState:
    (
      Language: '';
      Preset: '';
    );
  );

  DefaultLanguage: TLanguage =
  (
    System:
    (
      Charset: 'iso-8859-1';
    );
    Links:
    (
      ThumbnailsHint: 'Click image for enlarge';
      Index: 'Index';
      Previous: 'Previous';
      Next: 'Next';
    );
    Titles:
    (
      MainPage: 'To main page';
      IndexNum: 'Jump to index page #%d';
      Index: 'Back to index';
      Previous: 'Previous photo';
      Next: 'Next photo';
    );
  );

  DefaultPreset: TPreset =
  (
    Directories:
    (
      Images: '';
      Output: '';
    );
    Album:
    (
      Title: 'Title';
      Description: 'Description';
      MainPageURL: '../index.htm';
      MainPageLink: 'Main page';
      MaxImageCount: 9999;
    );
    Thumbnails:
    (
      Size: 256;
      Indent: 8;
    );
    Index:
    (
      ColCount: 4;
      RowCount: 3;
    );
    Misc:
    (
      ShowIndexLink: True;
      CSSFileURL: '../style.css';
    );
  );

  IniFileExtension: string = '.ini';

  PresetsCatalog: string = 'Presets';
  LanguagesCatalog: string = 'Languages';

  SettingsFileLastState: string = 'LastState';
  SettingsFileLastStateLanguage: string = 'Language';
  SettingsFileLastStatePreset: string = 'Preset';

  PresetFileDirectories: string = 'Directories';
  PresetFileDirectoriesImages: string = 'Images';
  PresetFileDirectoriesOutput: string = 'Output';
  PresetFileAlbum: string = 'Album';
  PresetFileAlbumTitle: string = 'Title';
  PresetFileAlbumDescription: string = 'Description';
  PresetFileAlbumMainPageURL: string = 'MainPageURL';
  PresetFileAlbumMainPageLink: string = 'MainPageLink';
  PresetFileAlbumMaxImageCount: string = 'MaxImageCount';
  PresetFileThumbnails: string = 'Thumbnails';
  PresetFileThumbnailsSize: string = 'Size';
  PresetFileThumbnailsIndent: string = 'Indent';
  PresetFileIndex: string = 'Index';
  PresetFileIndexColCount: string = 'ColCount';
  PresetFileIndexRowCount: string = 'RowCount';
  PresetFileMisc: string = 'Misc';
  PresetFileMiscShowIndexLink: string = 'ShowIndexLink';
  PresetFileMiscCSSFileURL: string = 'CSSFileURL';

  LanguageFileSystem: string = 'System';
  LanguageFileSystemCharset: string = 'Charset';
  LanguageFileLinks: string = 'Links';
  LanguageFileLinksThumbnailsHint: string = 'ThumbnailsHint';
  LanguageFileLinksIndex: string = 'Index';
  LanguageFileLinksPrevious: string = 'Previous';
  LanguageFileLinksNext: string = 'Next';
  LanguageFileTitles: string = 'Titles';
  LanguageFileTitlesMainPage: string = 'MainPage';
  LanguageFileTitlesIndexNum: string = 'IndexNum';
  LanguageFileTitlesIndex: string = 'Index';
  LanguageFileTitlesPrevious: string = 'Previous';
  LanguageFileTitlesNext: string = 'Next';

resourcestring
  rsDefaultComboBoxItem = '<Default>';
  rsDeletePreset = 'Delete preset ''%s''?';
  rsFileOverwrite = 'File ''%s'' already exists. Overwrite?';
  rsFileNotExists = 'File ''%s'' not exists!';
  rsImagesDir = 'Choose images directory';
  rsOutputDir = 'Choose output directory';
  rsWorkingDirNotExists = 'Images/Output directory not exists!';
  rsClearOutputDir = 'Output directory is not empty, do you want clear it?';
  rsOverwriteAllFiles = 'Files with identical names will be overwritten, continue?';
  rsAllDone = 'All done.';

{ TAlbumGeneratorForm }

function TAlbumGeneratorForm.LoadPreset(const FileName: string;
  const Default: TPreset): TPreset;
begin
  if FileExists(FileName) then
  begin
    with TIniFile.Create(FileName) do
    begin
      try
        with Result do
        begin
          Directories.Images := ReadString(PresetFileDirectories, PresetFileDirectoriesImages, Default.Directories.Images);
          Directories.Output := ReadString(PresetFileDirectories, PresetFileDirectoriesOutput, Default.Directories.Output);
          Album.Title := ReadString(PresetFileAlbum, PresetFileAlbumTitle, Default.Album.Title);
          Album.Description := ReadString(PresetFileAlbum, PresetFileAlbumDescription, Default.Album.Description);
          Album.MainPageURL := ReadString(PresetFileAlbum, PresetFileAlbumMainPageURL, Default.Album.MainPageURL);
          Album.MainPageLink := ReadString(PresetFileAlbum, PresetFileAlbumMainPageLink, Default.Album.MainPageLink);
          Album.MaxImageCount := ReadInteger(PresetFileAlbum, PresetFileAlbumMaxImageCount, Default.Album.MaxImageCount);
          Thumbnails.Size := ReadInteger(PresetFileThumbnails, PresetFileThumbnailsSize, Default.Thumbnails.Size);
          Thumbnails.Indent := ReadInteger(PresetFileThumbnails, PresetFileThumbnailsIndent, Default.Thumbnails.Indent);
          Index.ColCount := ReadInteger(PresetFileIndex, PresetFileIndexColCount, Default.Index.ColCount);
          Index.RowCount := ReadInteger(PresetFileIndex, PresetFileIndexRowCount, Default.Index.RowCount);
          Misc.ShowIndexLink := ReadBool(PresetFileMisc, PresetFileMiscShowIndexLink, Default.Misc.ShowIndexLink);
          Misc.CSSFileURL := ReadString(PresetFileMisc, PresetFileMiscCSSFileURL, Default.Misc.CSSFileURL);
        end;
      finally
        Free;
      end;
    end;
  end
  else
  begin
    ErrorMsg(Format(rsFileNotExists, [FileName]));
  end;
end;

procedure TAlbumGeneratorForm.SavePreset(const Preset: TPreset;
  const FileName: string);
begin
  with TIniFile.Create(FileName) do
  begin
    try
      with Preset do
      begin
        WriteString(PresetFileDirectories, PresetFileDirectoriesImages, Directories.Images);
        WriteString(PresetFileDirectories, PresetFileDirectoriesOutput, Directories.Output);
        WriteString(PresetFileAlbum, PresetFileAlbumTitle, Album.Title);
        WriteString(PresetFileAlbum, PresetFileAlbumDescription, Album.Description);
        WriteString(PresetFileAlbum, PresetFileAlbumMainPageURL, Album.MainPageURL);
        WriteString(PresetFileAlbum, PresetFileAlbumMainPageLink, Album.MainPageLink);
        WriteInteger(PresetFileAlbum, PresetFileAlbumMaxImageCount, Album.MaxImageCount);
        WriteInteger(PresetFileThumbnails, PresetFileThumbnailsSize, Thumbnails.Size);
        WriteInteger(PresetFileThumbnails, PresetFileThumbnailsIndent, Thumbnails.Indent);
        WriteInteger(PresetFileIndex, PresetFileIndexColCount, Index.ColCount);
        WriteInteger(PresetFileIndex, PresetFileIndexRowCount, Index.RowCount);
        WriteBool(PresetFileMisc, PresetFileMiscShowIndexLink, Misc.ShowIndexLink);
        WriteString(PresetFileMisc, PresetFileMiscCSSFileURL, Misc.CSSFileURL);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TAlbumGeneratorForm.SavePresetButtonClick(Sender: TObject);
var
  PresetFileName: string;
  CanCreatePresetFile: Boolean;
begin
  with TNewPresetForm.Create(Self) do
  begin
    try
      ShowModal;

      if ModalResult = mrOk then
      begin
        PresetFileName := PresetsDir + NameEdit.Text + IniFileExtension;

        CanCreatePresetFile := True;
        if FileExists(PresetFileName) then
        begin
          CanCreatePresetFile := QuestionMsg(Format(rsFileOverwrite, [PresetFileName])) = ID_YES;
        end;

        if CanCreatePresetFile then
        begin
          SavePreset(Preset, PresetFileName);
          RefreshPresets;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TAlbumGeneratorForm.ImagesBrowseButtonClick(Sender: TObject);
var
  Dir: string;
begin
  if SelectDirectory(rsImagesDir, EmptyStr, Dir) then
  begin
    ImagesDirEdit.Text := Dir;
  end;
end;

procedure TAlbumGeneratorForm.OutputBrowseButtonClick(Sender: TObject);
var
  Dir: string;
begin
  if SelectDirectory(rsOutputDir, EmptyStr, Dir) then
  begin
    OutputDirEdit.Text := Dir;
  end;
end;

procedure TAlbumGeneratorForm.FormCreate(Sender: TObject);
begin
  Settings := LoadSettings(SettingsFileName, DefaultSettings);

  LanguagesDir := IncludeTrailingPathDelimiter(ExtractFilePath(ApplicationFileName) + LanguagesCatalog);
  PresetsDir := IncludeTrailingPathDelimiter(ExtractFilePath(ApplicationFileName) + PresetsCatalog);

  ForceDirectories(LanguagesDir);
  ForceDirectories(PresetsDir);

  RefreshLanguages;
  RefreshPresets;
end;

function TAlbumGeneratorForm.LoadLanguage(const FileName: string;
  const Default: TLanguage): TLanguage;
begin
  if FileExists(FileName) then
  begin
    with TIniFile.Create(FileName) do
    begin
      try
        with Result do
        begin
          System.Charset := ReadString(LanguageFileSystem, LanguageFileSystemCharset, Default.System.Charset);
          Links.ThumbnailsHint := ReadString(LanguageFileLinks, LanguageFileLinksThumbnailsHint, Default.Links.ThumbnailsHint);
          Links.Index := ReadString(LanguageFileLinks, LanguageFileLinksIndex, Default.Links.Index);
          Links.Previous := ReadString(LanguageFileLinks, LanguageFileLinksPrevious, Default.Links.Previous);
          Links.Next := ReadString(LanguageFileLinks, LanguageFileLinksNext, Default.Links.Next);
          Titles.MainPage := ReadString(LanguageFileTitles, LanguageFileTitlesMainPage, Default.Titles.MainPage);
          Titles.IndexNum := ReadString(LanguageFileTitles, LanguageFileTitlesIndexNum, Default.Titles.IndexNum);
          Titles.Index := ReadString(LanguageFileTitles, LanguageFileTitlesIndex, Default.Titles.Index);
          Titles.Previous := ReadString(LanguageFileTitles, LanguageFileTitlesPrevious, Default.Titles.Previous);
          Titles.Next := ReadString(LanguageFileTitles, LanguageFileTitlesNext, Default.Titles.Next);
        end;
      finally
        Free;
      end;
    end;
  end
  else
  begin
    ErrorMsg(Format(rsFileNotExists, [FileName]));
  end;
end;

procedure TAlbumGeneratorForm.RunButtonClick(Sender: TObject);
begin
  if DirectoryExists(Preset.Directories.Images) and (DirectoryExists(Preset.Directories.Output)) then
  begin
    if not DirectoryIsEmpty(Preset.Directories.Output) then
    begin
      if QuestionMsg(rsClearOutputDir) = ID_YES then
      begin
        ClearDir(Preset.Directories.Output);
      end
      else
      begin
        if not (QuestionMsg(rsOverwriteAllFiles) = ID_YES) then
        begin
          Exit;
        end;
      end;
    end;

    with TProcessorForm.Create(Self, Language, Preset) do
    begin
      try
        ShowModal;

        if not Canceled then
        begin
          InfoMsg(rsAllDone);
        end;
      finally
        Free;
      end;
    end;
  end
  else
  begin
    ErrorMsg(rsWorkingDirNotExists);
  end;
end;

procedure TAlbumGeneratorForm.ImagesDirEditChange(Sender: TObject);
begin
  Preset.Directories.Images := ImagesDirEdit.Text;
end;

procedure TAlbumGeneratorForm.OutputDirEditChange(Sender: TObject);
begin
  Preset.Directories.Output := OutputDirEdit.Text;
end;

procedure TAlbumGeneratorForm.TitleEditChange(Sender: TObject);
begin
  Preset.Album.Title := TitleEdit.Text;
end;

procedure TAlbumGeneratorForm.DescriptionEditChange(Sender: TObject);
begin
  Preset.Album.Description := DescriptionEdit.Text;
end;

procedure TAlbumGeneratorForm.MainPageURLEditChange(Sender: TObject);
begin
  Preset.Album.MainPageURL := MainPageURLEdit.Text;
end;

procedure TAlbumGeneratorForm.MainPageLinkEditChange(Sender: TObject);
begin
  Preset.Album.MainPageLink := MainPageLinkEdit.Text;
end;

procedure TAlbumGeneratorForm.IndexLinkCheckBoxClick(Sender: TObject);
begin
  Preset.Misc.ShowIndexLink := IndexLinkCheckBox.Checked;
end;

procedure TAlbumGeneratorForm.CSSFileURLEditChange(Sender: TObject);
begin
  Preset.Misc.CSSFileURL := CSSFileURLEdit.Text;
end;

procedure TAlbumGeneratorForm.ThumbnailsSizeUpDownClick(Sender: TObject;
  Button: TUDBtnType);
begin
  Preset.Thumbnails.Size := ThumbnailsSizeUpDown.Position;
end;

procedure TAlbumGeneratorForm.ThumbnailsIndentUpDownClick(
  Sender: TObject; Button: TUDBtnType);
begin
  Preset.Thumbnails.Indent := ThumbnailsIndentUpDown.Position;
end;

procedure TAlbumGeneratorForm.IndexColCountUpDownClick(Sender: TObject;
  Button: TUDBtnType);
begin
  Preset.Index.ColCount := IndexColCountUpDown.Position;
end;

procedure TAlbumGeneratorForm.IndexRowCountUpDownClick(Sender: TObject;
  Button: TUDBtnType);
begin
  Preset.Index.RowCount := IndexRowCountUpDown.Position;
end;

function TAlbumGeneratorForm.LoadSettings(const FileName: string;
  const Default: TSettings): TSettings;
begin
  if FileExists(FileName) then
  begin
    with TIniFile.Create(FileName) do
    begin
      try
        with Result do
        begin
          LastState.Language := ReadString(SettingsFileLastState, SettingsFileLastStateLanguage, Default.LastState.Language);
          LastState.Preset := ReadString(SettingsFileLastState, SettingsFileLastStatePreset, Default.LastState.Preset);
        end;
      finally
        Free;
      end;
    end;
  end
  else
  begin
    ErrorMsg(Format(rsFileNotExists, [FileName]));
  end;
end;

procedure TAlbumGeneratorForm.SaveSettings(const Settings: TSettings;
  const FileName: string);
begin
  with TIniFile.Create(FileName) do
  begin
    try
      with Settings do
      begin
        WriteString(SettingsFileLastState, SettingsFileLastStateLanguage, LastState.Language);
        WriteString(SettingsFileLastState, SettingsFileLastStatePreset, LastState.Preset);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TAlbumGeneratorForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveSettings(Settings, SettingsFileName);
end;

procedure TAlbumGeneratorForm.PresetComboBoxSelect(Sender: TObject);
begin
  with PresetComboBox do
  begin
    if ItemIndex > 0 then
    begin
      DeletePresetButton.Enabled := True;
      Preset := LoadPreset(PresetsDir + Items[ItemIndex] + IniFileExtension, DefaultPreset);
      Settings.LastState.Preset := Items[ItemIndex];
    end
    else
    begin
      DeletePresetButton.Enabled := False;
      Preset := DefaultPreset;
      Settings.LastState.Preset := EmptyStr;
    end;
  end;

  ImagesDirEdit.Text := Preset.Directories.Images;
  OutputDirEdit.Text := Preset.Directories.Output;
  TitleEdit.Text := Preset.Album.Title;
  DescriptionEdit.Text := Preset.Album.Description;
  MainPageURLEdit.Text := Preset.Album.MainPageURL;
  MainPageLinkEdit.Text := Preset.Album.MainPageLink;
  MaxImageCountUpDown.Position := Preset.Album.MaxImageCount;
  ThumbnailsSizeUpDown.Position := Preset.Thumbnails.Size;
  ThumbnailsIndentUpDown.Position := Preset.Thumbnails.Indent;
  IndexColCountUpDown.Position := Preset.Index.ColCount;
  IndexRowCountUpDown.Position := Preset.Index.RowCount;
  IndexLinkCheckBox.Checked := Preset.Misc.ShowIndexLink;
  CSSFileURLEdit.Text := Preset.Misc.CSSFileURL;
end;

procedure TAlbumGeneratorForm.LanguageComboBoxSelect(Sender: TObject);
begin
  with LanguageComboBox do
  begin
    if ItemIndex > 0 then
    begin
      Language := LoadLanguage(LanguagesDir + Items[ItemIndex] + IniFileExtension, DefaultLanguage);
      Settings.LastState.Language := Items[ItemIndex];
    end
    else
    begin
      Language := DefaultLanguage;
      Settings.LastState.Language := EmptyStr;
    end;
  end;
end;

procedure TAlbumGeneratorForm.SetLanguage(const LanguageName: string);
var
  LanguageIndex: Integer;
  LanguageCounter: Integer;
begin
  LanguageIndex := 0;

  with LanguageComboBox do
  begin
    if LanguageName <> EmptyStr then
    begin
      for LanguageCounter := 0 to Items.Count - 1 do
      begin
        if Items[LanguageCounter] = LanguageName then
        begin
          LanguageIndex := LanguageCounter;
        end;
      end;
    end;

    ItemIndex := LanguageIndex;
  end;

  LanguageComboBoxSelect(Self);
end;

procedure TAlbumGeneratorForm.SetPreset(const PresetName: string);
var
  PresetIndex: Integer;
  PresetCounter: Integer;
begin
  PresetIndex := 0;

  with PresetComboBox do
  begin
    if PresetName <> EmptyStr then
    begin
      for PresetCounter := 0 to Items.Count - 1 do
      begin
        if Items[PresetCounter] = PresetName then
        begin
          PresetIndex := PresetCounter;
        end;
      end;
    end;

    ItemIndex := PresetIndex;
  end;

  PresetComboBoxSelect(Self);
end;

procedure TAlbumGeneratorForm.RefreshLanguages;
begin
  with LanguageComboBox do
  begin
    Items.Clear;
    Items.Add(rsDefaultComboBoxItem);
    ListFileDir(Items, LanguagesDir, ChangeFileExt(AllFileNamesMask, IniFileExtension), False);
  end;

  SetLanguage(Settings.LastState.Language);
end;

procedure TAlbumGeneratorForm.RefreshPresets;
begin
  with PresetComboBox do
  begin
    Items.Clear;
    Items.Add(rsDefaultComboBoxItem);
    ListFileDir(Items, PresetsDir, ChangeFileExt(AllFileNamesMask, IniFileExtension), False);
  end;

  SetPreset(Settings.LastState.Preset);
end;

procedure TAlbumGeneratorForm.DeletePresetButtonClick(Sender: TObject);
var
  PresetFileName: string;
begin
  with PresetComboBox do
  begin
    if QuestionMsg(Format(rsDeletePreset, [Items[ItemIndex]])) = ID_YES then
    begin
      PresetFileName := PresetsDir + Items[ItemIndex] + IniFileExtension;

      if FileExists(PresetFileName) then
      begin
        DeleteFile(PresetFileName);
        RefreshPresets;
      end
      else
      begin
        ErrorMsg(Format(rsFileNotExists, [PresetFileName]));
      end;
    end;
  end;
end;

procedure TAlbumGeneratorForm.MaxImageCountUpDownClick(Sender: TObject;
  Button: TUDBtnType);
begin
  Preset.Album.MaxImageCount := MaxImageCountUpDown.Position;
end;

end.
