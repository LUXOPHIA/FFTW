unit LUX.Chart.LineChart;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Generics.Collections;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     TChartLine = class;
     TLineChart = class;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartLine

     TChartLine = class
     private
       _Path :TPathData;
     protected
       _Parent  :TLineChart;
       _Color   :TAlphaColor;
       _Opacity :Single;
       _Stroke  :TStrokeBrush;
       _Values  :TArray<Single>;
       _ValuesN :Integer;
       ///// アクセス
       function GetColor :TAlphaColor;
       procedure SetColor( const Color_:TAlphaColor );
       function GetOpacity :Single;
       procedure SetOpacity( const Opacity_:Single );
       function GetStroke :TStrokeBrush;
       function GetValues( const I_:Integer ) :Single;
       procedure SetValues( const I_:Integer; const Value_:Single );
       function GetValuesN :Integer;
       procedure SetValuesN( const ValuesN_:Integer );
     public
       constructor Create( const Parent_:TLineChart );
       destructor Destroy; override;
       ///// プロパティ
       property Color                      :TAlphaColor  read GetColor   write SetColor  ;
       property Opacity                    :Single       read GetOpacity write SetOpacity;
       property Stroke                     :TStrokeBrush read GetStroke                  ;
       property Values[ const I_:Integer ] :Single       read GetValues  write SetValues ;
       property ValuesN                    :Integer      read GetValuesN write SetValuesN;
       ///// メソッド
       procedure Draw;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLineChart

     TLineChart = class( TFrame )
     private
       { private 宣言 }
     protected
       _Lines  :TObjectList<TChartLine>;
       _LinesN :Integer;
       _MinY   :Single;
       _MaxY   :Single;
       _Color  :TAlphaColor;
       ///// アクセス
       function GetLines( const I_:Integer ) :TChartLine;
       function GetLinesN :Integer;
       procedure SetLinesN( const LinesN_:Integer );
       function GetMinY :Single;
       procedure SetMinY( const MinY_:Single );
       function GetMaxY :Single;
       procedure SetMaxY( const MaxY_:Single );
       function GetColor :TAlphaColor;
       procedure SetColor( const Color_:TAlphaColor );
       ///// メソッド
       procedure Paint; override;
       function ValToScr( const Y_:Single ) :Single;
     public
       { public 宣言 }
       constructor Create( AOwner_:TComponent ); override;
       destructor Destroy; override;
       ///// プロパティ
       property Lines[ const I_:Integer ] :TChartLine  read GetLines                 ;
       property LinesN                    :Integer     read GetLinesN write SetLinesN;
       property MinY                      :Single      read GetMinY   write SetMinY  ;
       property MaxY                      :Single      read GetMaxY   write SetMaxY  ;
       property Color                     :TAlphaColor read GetColor  write SetColor ;
     end;

implementation //############################################################### ■

{$R *.fmx}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartLine

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TChartLine.GetColor :TAlphaColor;
begin
     Result := _Color;
end;

procedure TChartLine.SetColor( const Color_:TAlphaColor );
begin
     _Color := Color_;
end;

function TChartLine.GetOpacity :Single;
begin
     Result := _Opacity;
end;

procedure TChartLine.SetOpacity( const Opacity_:Single );
begin
     _Opacity := Opacity_;
end;

function TChartLine.GetStroke :TStrokeBrush;
begin
     Result := _Stroke;
end;

function TChartLine.GetValues( const I_:Integer ) :Single;
begin
     Result := _Values[ I_ ];
end;

procedure TChartLine.SetValues( const I_:Integer; const Value_:Single );
begin
     _Values[ I_ ] := Value_;
end;

function TChartLine.GetValuesN :Integer;
begin
     Result := _ValuesN;
end;

procedure TChartLine.SetValuesN( const ValuesN_:Integer );
begin
     _ValuesN := ValuesN_;

     SetLength( _Values, _ValuesN );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TChartLine.Create( const Parent_:TLineChart );
begin
     inherited Create;

     _Path   := TPathData.Create;
     _Stroke := TStrokeBrush.Create( TBrushKind.Solid, TAlphaColors.Black );

     _Parent           := Parent_;
      Color            := TAlphaColors.Black;
      Stroke.Thickness := 2;
      Stroke.Join      := TStrokeJoin.Round;
      Opacity          := 1;
      ValuesN          := 100;
end;

destructor TChartLine.Destroy;
begin
     _Stroke.DisposeOf;
     _Path  .DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TChartLine.Draw;
var
   A :Single;
   I :Integer;
begin
     with _Parent do
     begin
          A := Width / (_ValuesN-1);

          with _Path do
          begin
               Clear;

               MoveTo( TPointF.Create( 0, ValToScr( _Values[ 0 ] ) ) );

               for I := 1 to _ValuesN-1 do LineTo( TPointF.Create( A * I, ValToScr( _Values[ I ] ) ) );
          end;

          Canvas.Stroke.Assign( _Stroke );

          Canvas.DrawPath( _Path, _Opacity );
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLineChart

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TLineChart.GetLines( const I_:Integer ) :TChartLine;
begin
     Result := _Lines[ I_ ];
end;

//------------------------------------------------------------------------------

function TLineChart.GetLinesN :Integer;
begin
     Result := _LinesN;
end;

procedure TLineChart.SetLinesN( const LinesN_:Integer );
var
   N :Integer;
begin
     _LinesN := LinesN_;

     with _Lines do
     begin
          Clear;

          for N := 1 to _LinesN do Add( TChartLine.Create( Self ) );
     end;
end;

function TLineChart.GetMinY :Single;
begin
     Result := _MinY;
end;

procedure TLineChart.SetMinY( const MinY_:Single );
begin
     _MinY := MinY_;
end;

function TLineChart.GetMaxY :Single;
begin
     Result := _MaxY;
end;

procedure TLineChart.SetMaxY( const MaxY_:Single );
begin
     _MaxY := MaxY_;
end;

function TLineChart.GetColor :TAlphaColor;
begin
     Result := _Color;
end;

procedure TLineChart.SetColor( const Color_:TAlphaColor );
begin
     _Color := Color_;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TLineChart.Paint;
var
   I :Integer;
begin
     inherited;

     Canvas.Clear( _Color );

     for I := 0 to _LinesN-1 do _Lines[ I ].Draw;
end;

function TLineChart.ValToScr( const Y_:Single ) :Single;
begin
     Result := ( _MaxY - Y_ ) / ( _MaxY - _MinY ) * Height;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TLineChart.Create( AOwner_:TComponent );
begin
     inherited;

     _Lines := TObjectList<TChartLine>.Create;

     LinesN :=  1;
     MinY   := -1;
     MaxY   := +1;
     Color  := TAlphaColors.White;
end;

destructor TLineChart.Destroy;
begin
     _Lines.DisposeOf;

     inherited;
end;

end. //######################################################################### ■
