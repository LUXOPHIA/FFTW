unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation,
  LUX,
  LUX.D1,
  LUX.Complex,
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
    ///// メソッド
    procedure MakeCharts;
    procedure DrawTimes;
    procedure DrawFreqs;
    procedure RandomWalk;
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

function CosBell( const X_:Double ) :Double; overload;
begin
     if Abs( X_ ) > 1 then Result := 0
                      else Result := ( 1 + Cos( Pi * X_ ) ) / 2;
end;

function CosBell( const C_:TDoubleC ) :Double; overload;
begin
     Result := CosBell( C_.Size );
end;

function MetroWalk( const C0:TDoubleC ) :TDoubleC;
var
   C1 :TDoubleC;
   A :Double;
begin
     C1 := C0 + 0.05 * TDoubleC.RandG;

     A := CosBell( C1 ) / CosBell( C0 );

     if Random < A then Result := C1
                   else Result := C0;
end;

procedure TForm1.RandomWalk;
var
   I :Integer;
begin
     with _FFT do
     begin
          for I := 0 to TimesN-2 do Times[ I ] := Times[ I+1 ];

          Times[ TimesN-1 ] := MetroWalk( Times[ TimesN-2 ] );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _FFT := TDoubleFFT.Create;

     ScrollBarNChange( Sender );
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     RandomWalk;

     DrawTimes;

     _FFT.TransTF;

     DrawFreqs;
end;

//------------------------------------------------------------------------------

procedure TForm1.ScrollBarNChange(Sender: TObject);
begin
     _FFT.TimesN := Round( ScrollBarN.Value );

     LabelN.Text := _FFT.TimesN.ToString;

     MakeCharts;
end;

end. //######################################################################### ■
