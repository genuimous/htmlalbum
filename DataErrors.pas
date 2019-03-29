unit DataErrors;

interface

uses
  Forms, SysUtils, Utils, DialMessages;

function IsError(const Condition: Boolean; const ErrorText: string): Boolean;
procedure CheckError(const Condition: Boolean; var ErrorStr: string;
  const ErrorText: string);
procedure TryCloseModal(const ErrorStr: string; var Action: TCloseAction);

implementation

function IsError(const Condition: Boolean; const ErrorText: string): Boolean;
begin
  if Condition then
  begin
    ErrorMsg(ErrorText);
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

procedure CheckError(const Condition: Boolean; var ErrorStr: string;
  const ErrorText: string);
begin
  if Condition then
  begin
    ErrorStr := AddStr(ErrorStr, ErrorText, LineBreak);
  end;
end;

procedure TryCloseModal(const ErrorStr: string; var Action: TCloseAction);
begin
  if ErrorStr <> EmptyStr then
  begin
    ErrorMsg(ErrorStr);
    Action := caNone;    
  end;
end;

end.
