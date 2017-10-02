unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation,
  LUX,
  LUX.D1,
  LUX.Complex,
  LUX.Complex.D1,
  LUX.Signal.FFTW,
  LUX.Chart.LineChart;

type
  TForm1 = class(TForm)
    LineChartT: TLineChart;
    LineChartF: TLineChart;
    Timer1: TTimer;
    Panel1: TPanel;
      LabelN: TLabel;
      ScrollBarN: TScrollBar;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ScrollBarNChange(Sender: TObject);
  private
    { private 宣言 }
    _DoInit :Boolean;
    _Wave   :IDoubleRandWalkC;
    ///// メソッド
    procedure MakeCharts;
    procedure DrawTimes;
    procedure DrawFreqs;
    procedure MakeWave;
  public
    { public 宣言 }
    _FFT :IDoubleFFT;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

uses System.Math;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TForm1.MakeCharts;
begin
     with LineChartT do
     begin
          MinY := -1;
          MaxY := +1;

          LinesN := 2;

          with Lines[ 0 ] do
          begin
               ValuesN          := _FFT.TimesN;
               Stroke.Color     := TAlphaColors.Blue;
               Stroke.Thickness := 2;
          end;
          with Lines[ 1 ] do
          begin
               ValuesN          := _FFT.TimesN;
               Stroke.Color     := TAlphaColors.Red;
               Stroke.Thickness := 2;
          end;
     end;

     with LineChartF do
     begin
          MinY := -Pi4;
          MaxY := +Pi4;

          LinesN := 2;

          with Lines[ 0 ] do
          begin
               ValuesN          := _FFT.FreqsN;
               Stroke.Color     := TAlphaColors.Blue;
               Stroke.Thickness := 1;
          end;
          with Lines[ 1 ] do
          begin
               ValuesN          := _FFT.FreqsN;
               Stroke.Color     := TAlphaColors.Red;
               Stroke.Thickness := 1;
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.DrawTimes;
var
   J :Integer;
begin
     with LineChartT do
     begin
          with _FFT do
          begin
               for J := 0 to TimesN-1 do
               begin
                    with Times[ J ] do
                    begin
                         Lines[ 0 ].Values[ J ] := I;
                         Lines[ 1 ].Values[ J ] := R;
                    end;
               end;
          end;

          Repaint;
     end;
end;

procedure TForm1.DrawFreqs;
var
   J :Integer;
begin
     with LineChartF do
     begin
          with _FFT do
          begin
               for J := 0 to FreqsN-1 do
               begin
                    with Freqs[ J ] do
                    begin
                         Lines[ 0 ].Values[ J ] := I;
                         Lines[ 1 ].Values[ J ] := R;
                    end;
               end;
          end;

          Repaint;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.MakeWave;
var
   N, I :Integer;
begin
     if _DoInit then
     begin
          N := Round( ScrollBarN.Value );

          _Wave.WalksN := N;

          _FFT.TimesN := N;

          LabelN.Text := N.ToString;

          MakeCharts;

          _DoInit := False;
     end;

     _Wave.AddStep;

     with _FFT do
     begin
          for I := 0 to TimesN-1 do Times[ I ] := _Wave[ I ];
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     ScrollBarN.SmallChange := 1;

     _Wave := TDoubleRandWalkC.Create;

     _FFT := TDoubleFFT.Create;

     ScrollBarNChange( Sender );
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     MakeWave;

     DrawTimes;

     _FFT.TransTF;

     DrawFreqs;
end;

//------------------------------------------------------------------------------

procedure TForm1.ScrollBarNChange(Sender: TObject);
begin
     _DoInit := True;
end;

end. //######################################################################### ■
