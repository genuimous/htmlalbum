program HTMLAlbum;

uses
  Forms,
  Utils in 'Utils.pas',
  AlbumGenerator in 'AlbumGenerator.pas' {AlbumGeneratorForm},
  NewPreset in 'NewPreset.pas' {NewPresetForm},
  Processor in 'Processor.pas' {ProcessorForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'HTML Album';
  Application.CreateForm(TAlbumGeneratorForm, AlbumGeneratorForm);
  Application.Run;
end.
