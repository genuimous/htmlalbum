unit Progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Utils, StdCtrls, ComCtrls, ExtCtrls;

type
  TProgressForm = class(TForm)
    StepProgressLabel: TLabel;
    StepProgressBar: TProgressBar;
    OverallProgressLabel: TLabel;
    OverallProgressBar: TProgressBar;
    CancelButton: TButton;
    RunJob: TTimer;
    procedure CancelButtonClick(Sender: TObject);
    procedure RunJobTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    Language: TLanguage;
    Preset: TPreset;
    CancelProcess: Boolean;
    procedure Run;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; const Language: TLanguage;
      const Preset: TPreset); reintroduce;
  end;

var
  ProgressForm: TProgressForm;

implementation

{$R *.dfm}

{ TProgressForm }

constructor TProgressForm.Create(AOwner: TComponent;
  const Language: TLanguage; const Preset: TPreset);
begin
  inherited Create(AOwner);

  Self.Language := Language;
  Self.Preset := Preset;

  CancelProcess := False;
end;

procedure TProgressForm.CancelButtonClick(Sender: TObject);
begin
  CancelProcess := True;
end;

procedure TProgressForm.Run;
begin
end;

procedure TProgressForm.RunJobTimer(Sender: TObject);
begin
  RunJob.Enabled := False;

  Close;
end;

procedure TProgressForm.FormActivate(Sender: TObject);
begin
  RunJob.Enabled := True;
end;

end.
