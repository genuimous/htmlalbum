unit NewPreset;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DataErrors;

type
  TNewPresetForm = class(TForm)
    ParamsGroupBox: TGroupBox;
    CancelButton: TButton;
    OKButton: TButton;
    NameLabel: TLabel;
    NameEdit: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewPresetForm: TNewPresetForm;

implementation

{$R *.dfm}

resourcestring
  rsNameEmpty = 'Name can not be empty!';

procedure TNewPresetForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ErrorStr: string;
begin
  if ModalResult = mrOk then
  begin
    ErrorStr := EmptyStr;
    CheckError(NameEdit.Text = EmptyStr, ErrorStr, rsNameEmpty);

    TryCloseModal(ErrorStr, Action);
  end;
end;

end.
