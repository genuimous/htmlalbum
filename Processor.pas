unit Processor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Utils, StdCtrls, ComCtrls, ExtCtrls, DialMessages;

type
  TCreateThumbnail = procedure(const PictureFile, ThumbnailFile: string;
    const Size: Integer);

  TProcessorForm = class(TForm)
    ProgressLabel: TLabel;
    ProgressBar: TProgressBar;
    CancelButton: TButton;
    RunJob: TTimer;
    ImageCounterLabel: TLabel;
    procedure CancelButtonClick(Sender: TObject);
    procedure RunJobTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    ImagingDLLInstance: THandle;
    CreateThumbnail: TCreateThumbnail;
    Language: TLanguage;
    Preset: TPreset;
    function IndexName(const Num: Integer): string;
    function ImageName(const Num: Integer): string;
    function IndexLinkList(const Current, Total: Integer): string;
    procedure GenerateIndex(ImageList: TStringList);
    procedure GenerateImagePage(ImageList: TStringList;
      const ImageIndex: Integer);
  public
    { Public declarations }
    Canceled: Boolean;
    constructor Create(AOwner: TComponent; const Language: TLanguage;
      const Preset: TPreset); reintroduce;
  end;

var
  ProcessorForm: TProcessorForm;

implementation

uses Math;

{$R *.dfm}

const
  ImagingDLL: string = 'VampImg.dll';
  CreateThumbnailProc: string = 'ProportionalResize';

  ImageExtensions: array[0..6] of string = ('.jpg', 'jpeg', '.gif', '.png',
    '.tif', '.tiff', '.bmp');

  ImageNameFiller: Char = '0';

  HTMLFileExtension: string = '.htm';

  HTMLIndexName: string = 'index';
  ThumbnailSuffix: string = '_small';

resourcestring
  rsImagingDLLLoadingError = 'Error loading %s!';

{ TProgressForm }

constructor TProcessorForm.Create(AOwner: TComponent;
  const Language: TLanguage; const Preset: TPreset);
begin
  inherited Create(AOwner);

  Self.Language := Language;
  Self.Preset := Preset;

  Canceled := False;
end;

procedure TProcessorForm.CancelButtonClick(Sender: TObject);
begin
  Canceled := True;
end;

procedure TProcessorForm.RunJobTimer(Sender: TObject);
var
  ImageList: TStringList;
  ImageExtensionCounter: Integer;
  ImageCounter: Integer;
begin
  RunJob.Enabled := False;

  ImagingDLLInstance := LoadLibrary(PAnsiChar(ExtractFilePath(ApplicationFileName) + ImagingDLL));
  if ImagingDLLInstance <> 0 then
  begin
    @CreateThumbnail := GetProcAddress(ImagingDLLInstance, PChar(CreateThumbnailProc));

    ImageList := TStringList.Create;
    try
      for ImageExtensionCounter := 0 to Length(ImageExtensions) - 1 do
      begin
        ListFileDir(ImageList, Preset.Directories.Images, ChangeFileExt(AllFileNamesMask, ImageExtensions[ImageExtensionCounter]), True);
      end;
      ImageList.Sort;

      GenerateIndex(ImageList);

      ProgressBar.Max := Min(Preset.Album.MaxImageCount, ImageList.Count);
      for ImageCounter := 0 to ImageList.Count - 1 do
      begin
        if Canceled then
        begin
          Break;
        end;

        GenerateImagePage(ImageList, ImageCounter);
        CopyFile(PChar(IncludeTrailingPathDelimiter(Preset.Directories.Images) + ImageList[ImageCounter]), PChar(IncludeTrailingPathDelimiter(Preset.Directories.Output) + ImageName(ImageCounter + 1) + ExtractFileExt(ImageList[ImageCounter])), False);
        CreateThumbnail(IncludeTrailingPathDelimiter(Preset.Directories.Images) + ImageList[ImageCounter], IncludeTrailingPathDelimiter(Preset.Directories.Output) + ImageName(ImageCounter + 1) + ThumbnailSuffix + ExtractFileExt(ImageList[ImageCounter]), Preset.Thumbnails.Size);

        ImageCounterLabel.Caption := IntToStr(ImageCounter + 1);
        ProgressBar.StepIt;
        Application.ProcessMessages;

        if (ImageCounter = Preset.Album.MaxImageCount - 1) then
        begin
          Break;
        end;
      end;
    finally
      FreeAndNil(ImageList);
    end;
  end
  else
  begin
    ErrorMsg(Format(rsImagingDLLLoadingError, [ImagingDLL]));
  end;

  Close;
end;

procedure TProcessorForm.FormActivate(Sender: TObject);
begin
  RunJob.Enabled := True;
end;

procedure TProcessorForm.GenerateIndex(ImageList: TStringList);
var
  HTMLFile: TextFile;

  IndexCount, IndexCounter: Integer;

  StartIndex, EndIndex: Integer;
  ImageCount: Integer;
  ImageCounter: Integer;
begin
  IndexCount := Min(Preset.Album.MaxImageCount, ImageList.Count) div (Preset.Index.ColCount * Preset.Index.RowCount) + Sign(Min(Preset.Album.MaxImageCount, ImageList.Count) mod (Preset.Index.ColCount * Preset.Index.RowCount));

  for IndexCounter := 0 to IndexCount - 1 do
  begin
    StartIndex := IndexCounter * Preset.Index.ColCount * Preset.Index.RowCount;
    if IndexCounter < IndexCount - 1 then
    begin
      EndIndex := (IndexCounter + 1) * Preset.Index.ColCount * Preset.Index.RowCount - 1;
    end
    else
    begin
      EndIndex := Min(Preset.Album.MaxImageCount, ImageList.Count) - 1;
    end;

    AssignFile(HTMLFile, IncludeTrailingPathDelimiter(Preset.Directories.Output) + IndexName(IndexCounter + 1) + HTMLFileExtension);

    try
      Rewrite(HTMLFile);

      Writeln(HTMLFile, '<html>');
      Writeln(HTMLFile, '  <head>');
      Writeln(HTMLFile, '    <meta http-equiv="Content-Type" content="text/html; charset=' + Language.System.Charset + '">');
      Writeln(HTMLFile, '    <link rel="stylesheet" type="text/css" href="' + Preset.Misc.CSSFileURL + '">');
      Writeln(HTMLFile, '    <title>' + Preset.Album.Title + '</title>');
      Writeln(HTMLFile, '  </head>');
      Writeln(HTMLFile, '  <body>');
      Writeln(HTMLFile, '    <table width=100% height=100%>');
      Writeln(HTMLFile, '      <tbody>');
      Writeln(HTMLFile, '        <tr valign="center">');
      Writeln(HTMLFile, '          <td align="center">');
      Writeln(HTMLFile, '            <table align="center" width="' + IntToStr(Preset.Index.ColCount * (Preset.Thumbnails.Indent + Preset.Thumbnails.Size + Preset.Thumbnails.Indent)) + '" style="font-family: Tahoma, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: normal">');
      Writeln(HTMLFile, '              <tbody>');
      if Preset.Album.Title <> EmptyStr then
      begin
        Writeln(HTMLFile, '                <tr>');
        Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '"><br></td>');
        Writeln(HTMLFile, '                </tr>');
        Writeln(HTMLFile, '                <tr>');
        Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '" align="center"><h1>' + Preset.Album.Title + '</h1></td>');
        Writeln(HTMLFile, '                </tr>');
      end;
      if Preset.Album.Description <> EmptyStr then
      begin
        Writeln(HTMLFile, '                <tr>');
        Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '" align="center">' + Preset.Album.Description + '</td>');
        Writeln(HTMLFile, '                </tr>');
        Writeln(HTMLFile, '                <tr>');
        Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '"><br></td>');
        Writeln(HTMLFile, '                </tr>');
      end;
      if (Preset.Album.MainPageURL <> EmptyStr) and (Preset.Album.MainPageLink <> EmptyStr) then
      begin
        Writeln(HTMLFile, '                <tr>');
        Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '" align="center"><a href="' + Preset.Album.MainPageURL + '" title="' + Language.Titles.MainPage + '">' + Preset.Album.MainPageLink + '</a></td>');
        Writeln(HTMLFile, '                </tr>');
        Writeln(HTMLFile, '                <tr>');
        Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '"><br></td>');
        Writeln(HTMLFile, '                </tr>');
      end;
      Writeln(HTMLFile, '                <tr>');
      Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '" align="center">' + Language.Links.ThumbnailsHint + '</td>');
      Writeln(HTMLFile, '                </tr>');
      Writeln(HTMLFile, '                <tr>');
      Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '"><br></td>');
      Writeln(HTMLFile, '                </tr>');
      Writeln(HTMLFile, '                <tr>');
      Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '"><hr></td>');
      Writeln(HTMLFile, '                </tr>');

      ImageCount := 0;
      Writeln(HTMLFile, '                <tr>');
      for ImageCounter := StartIndex to EndIndex do
      begin
        Inc(ImageCount);

        if (ImageCount mod Preset.Index.ColCount = 1) and (ImageCount > 1) then
        begin
          Writeln(HTMLFile, '                </tr>');
          Writeln(HTMLFile, '                <tr>');
        end;

        Writeln(HTMLFile, '                  <td align="center" valign="center" width="' + IntToStr(Preset.Thumbnails.Indent + Preset.Thumbnails.Size + Preset.Thumbnails.Indent) + '" height="' + IntToStr(Preset.Thumbnails.Indent + Preset.Thumbnails.Size + Preset.Thumbnails.Indent) + '"><a href="' + ImageName(ImageCounter + 1) + HTMLFileExtension + '" title="' + ImageName(ImageCounter + 1) + ExtractFileExt(ImageList[ImageCounter]) + '"><img src="' + ImageName(ImageCounter + 1) + ThumbnailSuffix + ExtractFileExt(ImageList[ImageCounter]) + '" alt="' + ImageName(ImageCounter + 1) + ExtractFileExt(ImageList[ImageCounter]) + '" border="0"></a></td>');
      end;
      Writeln(HTMLFile, '                </tr>');

      Writeln(HTMLFile, '                <tr>');
      Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '"><hr></td>');
      Writeln(HTMLFile, '                </tr>');
      Writeln(HTMLFile, '                <tr>');
      Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '"><br></td>');
      Writeln(HTMLFile, '                </tr>');
      Writeln(HTMLFile, '                <tr>');
      Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '" align="center" style="font-family: Tahoma, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: normal">' + IndexLinkList(IndexCounter + 1, IndexCount) + '</td>');
      Writeln(HTMLFile, '                </tr>');
      Writeln(HTMLFile, '                <tr>');
      Writeln(HTMLFile, '                  <td colspan="' + IntToStr(Preset.Index.ColCount) + '"><br></td>');
      Writeln(HTMLFile, '                </tr>');
      Writeln(HTMLFile, '              </tbody>');
      Writeln(HTMLFile, '            </table>');
      Writeln(HTMLFile, '          </td>');
      Writeln(HTMLFile, '        </tr>');
      Writeln(HTMLFile, '      </tbody>');
      Writeln(HTMLFile, '    </table>');
      Writeln(HTMLFile, '  </body>');
      Writeln(HTMLFile, '</html>');
    finally
      CloseFile(HTMLFile);
    end;
  end;
end;

function TProcessorForm.IndexName(const Num: Integer): string;
begin
  if Num = 1 then
  begin
    Result := HTMLIndexName;
  end
  else
  begin
    Result := HTMLIndexName + IntToStr(Num);
  end;
end;

function TProcessorForm.IndexLinkList(const Current,
  Total: Integer): string;
const
  ItemBegin: string = '[';
  ItemEnd: string = ']';
var
  Counter: Integer;
begin
  Result := EmptyStr;

  for Counter := 1 to Total do
  begin
    if Result <> EmptyStr then
    begin
    Result := Result + Space;
    end;

    if Counter = Current then
    begin
      Result := Result + ItemBegin + IntToStr(Counter) + ItemEnd;
    end
    else
    begin
      Result := Result + '<a href="' + IndexName(Counter) + HTMLFileExtension + '" title="' + Format(Language.Titles.IndexNum, [Counter]) + '">' + ItemBegin + IntToStr(Counter) + ItemEnd + '</a>';
    end;
  end;
end;

procedure TProcessorForm.GenerateImagePage(ImageList: TStringList;
  const ImageIndex: Integer);
var
  HTMLFile: TextFile;
begin
  AssignFile(HTMLFile, IncludeTrailingPathDelimiter(Preset.Directories.Output) + ImageName(ImageIndex + 1) + HTMLFileExtension);

  try
    Rewrite(HTMLFile);

    Writeln(HTMLFile, '<html>');
    Writeln(HTMLFile, '  <head>');
    Writeln(HTMLFile, '    <meta http-equiv="Content-Type" content="text/html; charset=' + Language.System.Charset + '">');
    Writeln(HTMLFile, '    <link rel="stylesheet" type="text/css" href="' + Preset.Misc.CSSFileURL + '">');
    Writeln(HTMLFile, '    <title>' + ChangeFileExt(ImageList[ImageIndex], EmptyStr) + '</title>');
    Writeln(HTMLFile, '  </head>');
    Writeln(HTMLFile, '  <body>');
    Writeln(HTMLFile, '    <table width=100% height=100%>');
    Writeln(HTMLFile, '      <tbody>');
    Writeln(HTMLFile, '        <tr valign="center">');
    Writeln(HTMLFile, '          <td align="center">');
    Writeln(HTMLFile, '            <table align="center" style="font-family: Tahoma, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: normal">');
    Writeln(HTMLFile, '              <tbody>');
    Writeln(HTMLFile, '                <tr>');
    Writeln(HTMLFile, '                  <td colspan="3"><br></td>');
    Writeln(HTMLFile, '                </tr>');
    Writeln(HTMLFile, '                <tr>');
    Writeln(HTMLFile, '                  <td colspan="3"><img src="' + ImageName(ImageIndex + 1) + ExtractFileExt(ImageList[ImageIndex]) + '" alt="' + ImageName(ImageIndex + 1) + ExtractFileExt(ImageList[ImageIndex]) + '"></td>');
    Writeln(HTMLFile, '                </tr>');
    Writeln(HTMLFile, '                <tr>');
    Writeln(HTMLFile, '                  <td colspan="3"><br></td>');
    Writeln(HTMLFile, '                </tr>');
    Writeln(HTMLFile, '                <tr>');
    if ImageIndex > 0 then
    begin
      Writeln(HTMLFile, '                  <td align="left" width="200"><a href="' + ImageName((ImageIndex - 1) + 1) + HTMLFileExtension + '" title="' + Language.Titles.Previous + '">&lt;&lt; ' + Language.Links.Previous + '</a></td>');
    end
    else
    begin
      Writeln(HTMLFile, '                  <td align="left" width="200">&lt;&lt; ' + Language.Links.Previous + '</td>');
    end;
    if Preset.Misc.ShowIndexLink then
    begin
      Writeln(HTMLFile, '                  <td align="center"><a href="' + IndexName(Trunc((ImageIndex + 1) / (Preset.Index.ColCount * Preset.Index.RowCount)) + 1) + HTMLFileExtension + '" title="' + Language.Titles.Index + '">' + Language.Links.Index + '</a></td>')
    end
    else
    begin
        Writeln(HTMLFile, '                  <td align="center"></td>');
    end;
    if ImageIndex < ImageList.Count - 1 then
    begin
      Writeln(HTMLFile, '                  <td align="right" width="200"><a href="' + ImageName((ImageIndex + 1) + 1) + HTMLFileExtension + '" title="' + Language.Titles.Next + '">' + Language.Links.Next + ' &gt;&gt;</a></td>');
    end
    else
    begin
      Writeln(HTMLFile, '                  <td align="right" width="200">' + Language.Links.Next + ' &gt;&gt;</td>');
    end;
    Writeln(HTMLFile, '                </tr>');
    Writeln(HTMLFile, '                <tr>');
    Writeln(HTMLFile, '                  <td colspan="3"><br></td>');
    Writeln(HTMLFile, '                </tr>');    
    Writeln(HTMLFile, '              </tbody>');
    Writeln(HTMLFile, '            </table>');
    Writeln(HTMLFile, '          </td>');
    Writeln(HTMLFile, '        </tr>');
    Writeln(HTMLFile, '      </tbody>');    
    Writeln(HTMLFile, '    </table>');
    Writeln(HTMLFile, '  </body>');
    Writeln(HTMLFile, '</html>');
  finally
    CloseFile(HTMLFile);
  end;
end;

function TProcessorForm.ImageName(const Num: Integer): string;
begin
  Result := IntToStr(Num);

  while Length(Result) < Length(IntToStr(Preset.Album.MaxImageCount)) do
  begin
    Result := ImageNameFiller + Result;
  end;
end;

end.
