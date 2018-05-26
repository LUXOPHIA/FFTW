unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation,
  LUX,
  LUX.D1,
  LUX.D2,
  LUX.Complex,
  LUX.Complex.D1,
  LUX.Chart.Viewer,
  LUX.Signal.FFTW;

type
  TForm1 = class(TForm)
    ChartViewerT: TChartViewer;
    ChartViewerF: TChartViewer;
    Timer1: TTimer;
    Panel1: TPanel;
      LabelN: TLabel;
      ScrollBarN: TScrollBar;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private 宣言 }
    _Wave   :IDoubleRandWalkC;
    _CurvTR :TChartCurv;
    _CurvTI :TChartCurv;
    _CurvFR :TChartCurv;
    _CurvFI :TChartCurv;
    ///// メソッド
    procedure InitChartsT;
    procedure InitChartsF;
    procedure DrawTimes;
    procedure DrawFreqs;
  public
    { public 宣言 }
    _FFT :IDoubleFFT;
    ///// メソッド
    procedure MakeWave;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

uses System.Math;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.InitChartsT;
begin
     _CurvTI := TChartCurv.Create( ChartViewerT );
     _CurvTR := TChartCurv.Create( ChartViewerT );

     with ChartViewerT do
     begin
          MinX :=  0;
          MaxX :=  1;
          MinY := -1;
          MaxY := +1;

          ( Elems[ 1 ] as TChartScaY ).Interv := 0.125;
          ( Elems[ 3 ] as TChartScaY ).Interv := 0.50;
     end;

     with _CurvTR do
     begin
          Stroke.Color     := TAlphaColors.Blue;
          Stroke.Thickness := 2;
     end;

     with _CurvTI do
     begin
          Stroke.Color     := TAlphaColors.Red;
          Stroke.Thickness := 2;
     end;
end;

procedure TForm1.InitChartsF;
begin
     _CurvFI := TChartCurv.Create( ChartViewerF );
     _CurvFR := TChartCurv.Create( ChartViewerF );

     with ChartViewerF do
     begin
          MinX :=  0;
          MaxX :=  1;
          MinY := -Pi4;
          MaxY := +Pi4;

          ( Elems[ 1 ] as TChartScaY ).Interv := P2i;
          ( Elems[ 3 ] as TChartScaY ).Interv := Pi2;
     end;

     with _CurvFR do
     begin
          Stroke.Color     := TAlphaColors.Blue;
          Stroke.Thickness := 1;
     end;

     with _CurvFI do
     begin
          Stroke.Color     := TAlphaColors.Red;
          Stroke.Thickness := 1;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.DrawTimes;
var
   J :Integer;
begin
     with ChartViewerT do
     begin
          with _FFT do
          begin
               for J := 0 to TimesN-1 do
               begin
                    with Times[ J ] do
                    begin
                         _CurvTR.Poins[ J ] := TSingle2D.Create( J / TimesN, R );
                         _CurvTI.Poins[ J ] := TSingle2D.Create( J / TimesN, I );
                    end;
               end;

               with Times[ 0 ] do
               begin
                    _CurvTR.Poins[ TimesN ] := TSingle2D.Create( 1, R );
                    _CurvTI.Poins[ TimesN ] := TSingle2D.Create( 1, I );
               end;
          end;

          Repaint;
     end;
end;

procedure TForm1.DrawFreqs;
var
   J :Integer;
begin
     with ChartViewerF do
     begin
          with _FFT do
          begin
               for J := 0 to FreqsN-1 do
               begin
                    with Freqs[ J ] do
                    begin
                         _CurvFR.Poins[ J ] := TSingle2D.Create( J / FreqsN, R );
                         _CurvFI.Poins[ J ] := TSingle2D.Create( J / FreqsN, I );
                    end;
               end;

               with Freqs[ 0 ] do
               begin
                    _CurvFR.Poins[ FreqsN ] := TSingle2D.Create( 1, R );
                    _CurvFI.Poins[ FreqsN ] := TSingle2D.Create( 1, I );
               end;
          end;

          Repaint;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.MakeWave;
var
   N, I :Integer;
begin
     N := Round( ScrollBarN.Value );

     if N <> _FFT.TimesN then
     begin
          _Wave.WalksN := N;

          _FFT.TimesN := N;

          LabelN.Text := N.ToString;

          _CurvTR.PoinsN := N+1;
          _CurvTI.PoinsN := N+1;
          _CurvFR.PoinsN := N+1;
          _CurvFI.PoinsN := N+1;
     end;

     _Wave.AddStep;

     with _FFT do
     begin
          for I := 0 to TimesN-1 do Times[ I ] := _Wave[ I ];
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     ScrollBarN.SmallChange := 1;

     InitChartsT;
     InitChartsF;

     _Wave := TDoubleRandWalkC.Create;

     _FFT := TDoubleFFT.Create;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     MakeWave;

     DrawTimes;

     _FFT.TransTF;

     DrawFreqs;
end;

end. //######################################################################### ■
