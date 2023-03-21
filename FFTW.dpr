program FFTW;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  LUX.FMX.Forms in '_LIBRARY\LUXOPHIA\LUX\FMX\LUX.FMX.Forms.pas',
  fftw3 in '_LIBRARY\LUXOPHIA\LUX.Signal.FFTW\fftw3.pas',
  LUX.Signal.FFTW in '_LIBRARY\LUXOPHIA\LUX.Signal.FFTW\LUX.Signal.FFTW.pas',
  LUX.Chart.Viewer in '_LIBRARY\LUXOPHIA\LUX.Chart\_FMX\LUX.Chart.Viewer.pas' {ChartViewer: TFrame},
  LUX.Complex.D1 in '_LIBRARY\LUXOPHIA\LUX\Complex\LUX.Complex.D1.pas',
  LUX.Complex in '_LIBRARY\LUXOPHIA\LUX\Complex\LUX.Complex.pas',
  LUX.Signal.FFTW.D1 in '_LIBRARY\LUXOPHIA\LUX.Signal.FFTW\D1\LUX.Signal.FFTW.D1.pas',
  LUX.Signal.FFTW.D1.Preset in '_LIBRARY\LUXOPHIA\LUX.Signal.FFTW\D1\LUX.Signal.FFTW.D1.Preset.pas',
  LUX.Signal.FFTW.D3 in '_LIBRARY\LUXOPHIA\LUX.Signal.FFTW\D3\LUX.Signal.FFTW.D3.pas',
  LUX.Signal.FFTW.D2 in '_LIBRARY\LUXOPHIA\LUX.Signal.FFTW\D2\LUX.Signal.FFTW.D2.pas',
  LUX.Signal.FFTW.D2.Preset in '_LIBRARY\LUXOPHIA\LUX.Signal.FFTW\D2\LUX.Signal.FFTW.D2.Preset.pas',
  LUX.Signal.FFTW.D3.Preset in '_LIBRARY\LUXOPHIA\LUX.Signal.FFTW\D3\LUX.Signal.FFTW.D3.Preset.pas',
  LUX.FMX.Controls in '_LIBRARY\LUXOPHIA\LUX\FMX\LUX.FMX.Controls.pas',
  LUX.Data.Grid.T1.D1 in '_LIBRARY\LUXOPHIA\LUX\Data\Grid\LUX.Data.Grid.T1.D1.pas',
  LUX.Data.Grid.T1 in '_LIBRARY\LUXOPHIA\LUX\Data\Grid\LUX.Data.Grid.T1.pas',
  LUX.Data.Grid.T2.D1 in '_LIBRARY\LUXOPHIA\LUX\Data\Grid\LUX.Data.Grid.T2.D1.pas',
  LUX.Data.Grid.T2 in '_LIBRARY\LUXOPHIA\LUX\Data\Grid\LUX.Data.Grid.T2.pas',
  LUX.Data.Grid.T3.D3 in '_LIBRARY\LUXOPHIA\LUX\Data\Grid\LUX.Data.Grid.T3.D3.pas',
  LUX.Data.Grid.T3 in '_LIBRARY\LUXOPHIA\LUX\Data\Grid\LUX.Data.Grid.T3.pas',
  LUX.Data.Grid in '_LIBRARY\LUXOPHIA\LUX\Data\Grid\LUX.Data.Grid.pas',
  LUX.FMX.Pratform in '_LIBRARY\LUXOPHIA\LUX\FMX\LUX.FMX.Pratform.pas',
  LUX.D5 in '_LIBRARY\LUXOPHIA\LUX\LUX.D5.pas',
  LUX.DN in '_LIBRARY\LUXOPHIA\LUX\LUX.DN.pas',
  LUX in '_LIBRARY\LUXOPHIA\LUX\LUX.pas',
  LUX.D1 in '_LIBRARY\LUXOPHIA\LUX\LUX.D1.pas',
  LUX.D2 in '_LIBRARY\LUXOPHIA\LUX\LUX.D2.pas',
  LUX.D2x2 in '_LIBRARY\LUXOPHIA\LUX\LUX.D2x2.pas',
  LUX.D2x4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D2x4.pas',
  LUX.D2x4x4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D2x4x4.pas',
  LUX.D3 in '_LIBRARY\LUXOPHIA\LUX\LUX.D3.pas',
  LUX.D3x3 in '_LIBRARY\LUXOPHIA\LUX\LUX.D3x3.pas',
  LUX.D3x4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D3x4.pas',
  LUX.D3x4x4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D3x4x4.pas',
  LUX.D4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D4.pas',
  LUX.D4x4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D4x4.pas',
  LUX.D4x4x4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D4x4x4.pas',
  LUX.Curve.CatRom in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.CatRom.pas',
  LUX.Curve in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.pas',
  LUX.Curve.Bezier in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.Bezier.pas',
  LUX.Curve.BSpline.D2 in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.BSpline.D2.pas',
  LUX.Curve.BSpline in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.BSpline.pas',
  LUX.Curve.D2 in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.D2.pas',
  LUX.Curve.Poly in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.Poly.pas',
  LUX.Curve.Bezier.D2 in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.Bezier.D2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
