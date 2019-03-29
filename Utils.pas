unit Utils;

interface

uses
  Classes, SysUtils;

type
  TLanguage = record
    System: record
      Charset: string;
    end;
    Links: record
      ThumbnailsHint: string;
      Index: string;
      Previous: string;
      Next: string;
    end;
    Titles: record
      MainPage: string;
      IndexNum: string;
      Index: string;
      Previous: string;
      Next: string;
    end;
  end;

  TPreset = record
    Directories: record
      Images: string;
      Output: string;
    end;
    Album: record
      Title: string;
      Description: string;
      MainPageURL: string;
      MainPageLink: string;
      MaxImageCount: Integer;
    end;
    Thumbnails: record
      Size: Integer;
      Indent: Integer;
    end;
    Index: record
      ColCount: Integer;
      RowCount: Integer;
    end;
    Misc: record
      ShowIndexLink: Boolean;
      CSSFileURL: string;
    end;
  end;

  TSettings = record
    LastState: record
      Language: string;
      Preset: string;
    end;
  end;

const
  LineBreak: string = #10#13;
  Space: string = ' ';
  AllFileNamesMask: string = '*.*';

function ApplicationFileName: string;
function SettingsFileName: string;
procedure ListFileDir(FileList: TStrings; const Dir: string;
  const Mask: string; const GetExtension: Boolean);
function DirectoryIsEmpty(const Dir: string): Boolean;
procedure ClearDir(const Dir: string);
function AddStr(const Str: string; const AdditionalStr: string;
  const DelimiterStr: string): string;

implementation

function ApplicationFileName: string;
begin
  Result := ParamStr(0);
end;

function SettingsFileName: string;
const
  SettingsFileExt: string = '.ini';
begin
  Result := ChangeFileExt(ParamStr(0), SettingsFileExt);
end;

procedure ListFileDir(FileList: TStrings; const Dir: string;
  const Mask: string; const GetExtension: Boolean);
var
  SR: TSearchRec;
begin
  if FindFirst(IncludeTrailingPathDelimiter(Dir) + Mask, faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr and faDirectory) <> faDirectory then
      begin
        if GetExtension then
        begin
          FileList.Add(SR.Name);
        end
        else
        begin
          FileList.Add(ChangeFileExt(SR.Name, EmptyStr));
        end;
      end;
    until FindNext(SR) <> 0;

    FindClose(SR);
  end;
end;

function DirectoryIsEmpty(const Dir: string): Boolean;
const
  SelfDirName: string = '.';
  UpperLevelDirName: string = '..';
  AnyDirEntriesMask: string = '*.*';
var
  SR: TSearchRec;
begin
  Result := True;

  if FindFirst(IncludeTrailingPathDelimiter(Dir) + AnyDirEntriesMask, faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Name <> SelfDirName) and (SR.Name <> UpperLevelDirName) then
      begin
        Result := False;
        Break;
      end;
    until FindNext(SR) <> 0;

    FindClose(SR);
  end;
end;

procedure ClearDir(const Dir: string);
const
  SelfDirName: string = '.';
  UpperLevelDirName: string = '..';
  AnyDirEntriesMask: string = '*.*';
var
  SR: TSearchRec;
begin
  if FindFirst(IncludeTrailingPathDelimiter(Dir) + AnyDirEntriesMask, faAnyFile, SR) = 0 then
  begin
    repeat
      if ((SR.Attr and faDirectory) = faDirectory) then
      begin
        if (SR.Name <> SelfDirName) and (SR.Name <> UpperLevelDirName) then
        begin
          ClearDir(IncludeTrailingPathDelimiter(Dir) + SR.Name);
          RmDir(IncludeTrailingPathDelimiter(Dir) + SR.Name);
        end;
      end
      else
      begin
        DeleteFile(IncludeTrailingPathDelimiter(Dir) + SR.Name);
      end;
    until FindNext(SR) <> 0;

    FindClose(SR);
  end;
end;

function AddStr(const Str: string; const AdditionalStr: string;
  const DelimiterStr: string): string;
begin
  if Str = EmptyStr then
  begin
    Result := AdditionalStr;
  end
  else
  begin
    Result := Str + DelimiterStr + AdditionalStr;
  end;  
end;

end.
