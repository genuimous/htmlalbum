unit DialMessages;

interface

uses
  Windows, Forms;

procedure InfoMsg(const Msg: string);
procedure ErrorMsg(const Msg: string);
procedure WarningMsg(const Msg: string);
function QuestionMsg(const Msg: string): Byte;

implementation

resourcestring
  rsInfo = 'Information';
  rsError = 'Error';
  rsWarning = 'Warning';
  rsQuestion = 'Question';

procedure InfoMsg(const Msg: string);
begin
  MessageBox(Application.Handle, PChar(Msg), PChar(rsInfo), MB_ICONINFORMATION or MB_OK);
end;

procedure ErrorMsg(const Msg: string);
begin
  MessageBox(Application.Handle, PChar(Msg), PChar(rsError), MB_ICONERROR or MB_OK);
end;

procedure WarningMsg(const Msg: string);
begin
  MessageBox(Application.Handle, PChar(Msg), PChar(rsWarning), MB_ICONWARNING or MB_OK);
end;

function QuestionMsg(const Msg: string): Byte;
begin
  Result := MessageBox(Application.Handle, PChar(Msg), PChar(rsQuestion), MB_ICONQUESTION or MB_YESNOCANCEL);
end;

end.
