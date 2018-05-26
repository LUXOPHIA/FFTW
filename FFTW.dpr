program FFTW;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  LUX.FMX.Forms in '_LIBRARY\LUXOPHIA\LUX\FMX\LUX.FMX.Forms.pas',
  fftw3 in '_LIBRARY\LUXOPHIA\LUX.Signal.FFTW\fftw3.pas',
  LUX.Signal.FFTW in '_LIBRARY\LUXOPHIA\LUX.Signal.FFTW\LUX.Signal.FFTW.pas',
  LUX.Chart.Viewer in '_LIBRARY\LUXOPHIA\LUX.Chart\FMX\LUX.Chart.Viewer.pas' {ChartViewer: TFrame},
  LUX.Complex.D1 in '_LIBRARY\LUXOPHIA\LUX\Complex\LUX.Complex.D1.pas',
  LUX.Complex in '_LIBRARY\LUXOPHIA\LUX\Complex\LUX.Complex.pas',
  LUX.Data.Octree in '_LIBRARY\LUXOPHIA\LUX\Data\LUX.Data.Octree.pas',
  LUX.Data.Tree in '_LIBRARY\LUXOPHIA\LUX\Data\LUX.Data.Tree.pas',
  LUX.Data.Dictionary in '_LIBRARY\LUXOPHIA\LUX\Data\LUX.Data.Dictionary.pas',
  LUX.Data.Lattice in '_LIBRARY\LUXOPHIA\LUX\Data\LUX.Data.Lattice.pas',
  LUX.Data.Octree.Atom in '_LIBRARY\LUXOPHIA\LUX\Data\LUX.Data.Octree.Atom.pas',
  LUX.Data.Lattice.T2 in '_LIBRARY\LUXOPHIA\LUX\Data\Lattice\LUX.Data.Lattice.T2.pas',
  LUX.Data.Lattice.T3 in '_LIBRARY\LUXOPHIA\LUX\Data\Lattice\LUX.Data.Lattice.T3.pas',
  LUX.Data.Lattice.T1 in '_LIBRARY\LUXOPHIA\LUX\Data\Lattice\LUX.Data.Lattice.T1.pas',
  LUX.Data.Lattice.T1.D1 in '_LIBRARY\LUXOPHIA\LUX\Data\Lattice\T1\LUX.Data.Lattice.T1.D1.pas',
  LUX.Data.Lattice.T2.D1 in '_LIBRARY\LUXOPHIA\LUX\Data\Lattice\T2\LUX.Data.Lattice.T2.D1.pas',
  LUX.Data.Lattice.T3.D3 in '_LIBRARY\LUXOPHIA\LUX\Data\Lattice\T3\LUX.Data.Lattice.T3.D3.pas',
  LUX.D5 in '_LIBRARY\LUXOPHIA\LUX\LUX.D5.pas',
  LUX.DN in '_LIBRARY\LUXOPHIA\LUX\LUX.DN.pas',
  LUX.M2 in '_LIBRARY\LUXOPHIA\LUX\LUX.M2.pas',
  LUX.M3 in '_LIBRARY\LUXOPHIA\LUX\LUX.M3.pas',
  LUX.M4 in '_LIBRARY\LUXOPHIA\LUX\LUX.M4.pas',
  LUX in '_LIBRARY\LUXOPHIA\LUX\LUX.pas',
  LUX.D1 in '_LIBRARY\LUXOPHIA\LUX\LUX.D1.pas',
  LUX.D2.M4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D2.M4.pas',
  LUX.D2 in '_LIBRARY\LUXOPHIA\LUX\LUX.D2.pas',
  LUX.D2.V4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D2.V4.pas',
  LUX.D3.M4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D3.M4.pas',
  LUX.D3 in '_LIBRARY\LUXOPHIA\LUX\LUX.D3.pas',
  LUX.D3.V4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D3.V4.pas',
  LUX.D4.M4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D4.M4.pas',
  LUX.D4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D4.pas',
  LUX.D4.V4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D4.V4.pas',
  LUX.Curve.T1.D3 in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.T1.D3.pas',
  LUX.Curve.T2.D1 in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.T2.D1.pas',
  LUX.Curve.T2.D2 in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.T2.D2.pas',
  LUX.Curve.T2.D3 in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.T2.D3.pas',
  LUX.Curve.T1.D1 in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.T1.D1.pas',
  LUX.Curve.T1.D2 in '_LIBRARY\LUXOPHIA\LUX\Curve\LUX.Curve.T1.D2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
