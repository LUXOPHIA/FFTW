unit LUX.Chart.Viewer;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Generics.Collections,
  LUX, LUX.D1, LUX.D2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     TChartAtom = class;
       TChartPoin = class;
       TChartCurv = class;
       TChartScal = class;
         TChartScaX = class;
         TChartScaY = class;
     TChartViewer = class;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartAtom

     TChartAtom = class
     private
     protected
       _Paren   :TChartViewer;
       _Opacity :Single;
       _Stroke  :TStrokeBrush;
       _Filler  :TBrush;
       ///// アクセス
       function GetOpacity :Single;
       procedure SetOpacity( const Opacity_:Single );
     public
       constructor Create( const Paren_:TChartViewer );
       destructor Destroy; override;
       ///// プロパティ
       property Paren   :TChartViewer  read   _Paren                   ;
       property Opacity :Single       read GetOpacity write SetOpacity;
       property Stroke  :TStrokeBrush read   _Stroke                  ;
       property Filler  :TBrush       read   _Filler                  ;
       ///// メソッド
       procedure Draw; virtual;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartPoin

     TChartPoin = class( TChartAtom )
     private
     protected
       _Pos    :TSingle2D;
       _Radius :Single;
       _Border :Single;
       ///// アクセス
       function GetPos :TSingle2D;
       procedure SetPos( const Pos_:TSingle2D );
       function GetRadius :Single;
       procedure SetRadius( const Radius_:Single );
       function GetBorder :Single;
       procedure SetBorder( const Border_:Single );
     public
       constructor Create( const Paren_:TChartViewer );
       destructor Destroy; override;
       ///// プロパティ
       property Pos    :TSingle2D read GetPos    write SetPos   ;
       property Radius :Single    read GetRadius write SetRadius;
       property Border :Single    read GetBorder write SetBorder;
       ///// メソッド
       procedure Draw; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartCurv

     TChartCurv = class( TChartAtom )
     private
       _Path :TPathData;
     protected
       _Poins   :TArray<TSingle2D>;
       _PoinsN  :Integer;
       ///// アクセス
       function GetPoins( const I_:Integer ) :TSingle2D;
       procedure SetPoins( const I_:Integer; const Value_:TSingle2D );
       function GetPoinsN :Integer;
       procedure SetPoinsN( const ValuesN_:Integer );
     public
       constructor Create( const Paren_:TChartViewer );
       destructor Destroy; override;
       ///// プロパティ
       property Poins[ const I_:Integer ] :TSingle2D read GetPoins  write SetPoins ; default;
       property PoinsN                    :Integer   read GetPoinsN write SetPoinsN;
       ///// メソッド
       procedure Draw; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartScal

     TChartScal = class( TChartAtom )
     protected
       _Interv :Single;
       ///// アクセス
       function GetInterv :Single;
       procedure SetInterv( const Interv_:Single );
     public
       constructor Create( const Paren_:TChartViewer );
       destructor Destroy; override;
       ///// プロパティ
       property Interv :Single read GetInterv write SetInterv;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartScaX

     TChartScaX = class( TChartScal )
     protected
     public
       constructor Create( const Paren_:TChartViewer );
       destructor Destroy; override;
       ///// メソッド
       procedure Draw; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartScaY

     TChartScaY = class( TChartScal )
     protected
     public
       constructor Create( const Paren_:TChartViewer );
       destructor Destroy; override;
       ///// メソッド
       procedure Draw; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartAxis

     TChartAxis = class( TChartAtom )
     protected
     public
       constructor Create( const Paren_:TChartViewer );
       destructor Destroy; override;
       ///// メソッド
       procedure Draw; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartViewer

     TChartViewer = class( TFrame )
     private
       { private 宣言 }
     protected
       _Area      :TSingleArea2D;
       _AreaColor :TAlphaColor;
       _Axis      :TChartAxis;
       _ScaXs     :TList<TChartScaX>;
       _ScaYs     :TList<TChartScaY>;
       _Elems     :TObjectList<TChartAtom>;
       ///// アクセス
       function GetMinX :Single;
       procedure SetMinX( const MinX_:Single );
       function GetMaxX :Single;
       procedure SetMaxX( const MaxX_:Single );
       function GetMinY :Single;
       procedure SetMinY( const MinY_:Single );
       function GetMaxY :Single;
       procedure SetMaxY( const MaxY_:Single );
       function GetAreaColor :TAlphaColor;
       procedure SetAreaColor( const BackColor_:TAlphaColor );
       ///// メソッド
       procedure Paint; override;
     public
       { public 宣言 }
       constructor Create( AOwner_:TComponent ); override;
       destructor Destroy; override;
       ///// プロパティ
       property MinX      :Single                  read GetMinX      write SetMinX     ;
       property MaxX      :Single                  read GetMaxX      write SetMaxX     ;
       property MinY      :Single                  read GetMinY      write SetMinY     ;
       property MaxY      :Single                  read GetMaxY      write SetMaxY     ;
       property AreaColor :TAlphaColor             read GetAreaColor write SetAreaColor;
       property Axis      :TChartAxis              read   _Axis                        ;
       property ScaXs     :TList<TChartScaX>       read   _ScaXs                       ;
       property ScaYs     :TList<TChartScaY>       read   _ScaYs                       ;
       property Elems     :TObjectList<TChartAtom> read   _Elems                       ;
       ///// メソッド
       function PosToScrX( const Pos_:Single ) :Single;
       function PosToScrY( const Pos_:Single ) :Single;
       function PosToScr( const Pos_:TSingle2D ) :TPointF;
       function ScrToPosX( const Scr_:Single ) :Single;
       function ScrToPosY( const Scr_:Single ) :Single;
       function ScrToPos( const Scr_:TPointF ) :TSingle2D;
       procedure DrawCirc( const Center_:TSingle2D; const Radius_,Opacity_:Single );
     end;

implementation //############################################################### ■

{$R *.fmx}

uses System.Math;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartAtom

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TChartAtom.GetOpacity :Single;
begin
     Result := _Opacity;
end;

procedure TChartAtom.SetOpacity( const Opacity_:Single );
begin
     _Opacity := Opacity_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TChartAtom.Create( const Paren_:TChartViewer );
begin
     inherited Create;

     _Stroke := TStrokeBrush.Create( TBrushKind.Solid, TAlphaColors.Null );
     _Filler := TBrush      .Create( TBrushKind.Solid, TAlphaColors.Null );

     _Paren       := Paren_;
     _Opacity     := 1;
     _Stroke.Join := TStrokeJoin.Round;

     _Paren._Elems.Add( Self );
end;

destructor TChartAtom.Destroy;
begin
     _Paren._Elems.Remove( Self );

     _Stroke.DisposeOf;
     _Filler.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TChartAtom.Draw;
begin
     with _Paren.Canvas do
     begin
          Stroke.Assign( _Stroke );
          Fill  .Assign( _Filler );
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartPoin

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TChartPoin.GetPos :TSingle2D;
begin
     Result := _Pos;
end;

procedure TChartPoin.SetPos( const Pos_:TSingle2D );
begin
     _Pos := Pos_;
end;

//------------------------------------------------------------------------------

function TChartPoin.GetRadius :Single;
begin
     Result := _Radius;
end;

procedure TChartPoin.SetRadius( const Radius_:Single );
begin
     _Radius := Radius_;
end;

function TChartPoin.GetBorder :Single;
begin
     Result := _Border;
end;

procedure TChartPoin.SetBorder( const Border_:Single );
begin
     _Border := Border_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TChartPoin.Create( const Paren_:TChartViewer );
begin
     inherited;

     _Pos    := TSingle2D.Create( 0, 0 );
     _Radius := 5;
     _Border := 0;
end;

destructor TChartPoin.Destroy;
begin

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TChartPoin.Draw;
begin
     inherited;

     with _Paren do
     begin
          DrawCirc( _Pos, _Radius, _Opacity );
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartCurv

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TChartCurv.GetPoins( const I_:Integer ) :TSingle2D;
begin
     Result := _Poins[ I_ ];
end;

procedure TChartCurv.SetPoins( const I_:Integer; const Value_:TSingle2D );
begin
     _Poins[ I_ ] := Value_;
end;

function TChartCurv.GetPoinsN :Integer;
begin
     Result := _PoinsN;
end;

procedure TChartCurv.SetPoinsN( const ValuesN_:Integer );
begin
     _PoinsN := ValuesN_;

     SetLength( _Poins, _PoinsN );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TChartCurv.Create( const Paren_:TChartViewer );
begin
     inherited;

     _Path := TPathData.Create;

     PoinsN := 100;
end;

destructor TChartCurv.Destroy;
begin
     _Path.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TChartCurv.Draw;
var
   I :Integer;
begin
     inherited;

     with _Paren do
     begin
          with _Path do
          begin
               Clear;

               MoveTo( PosToScr( _Poins[ 0 ] ) );

               for I := 1 to _PoinsN-1 do LineTo( PosToScr( _Poins[ I ] ) );
          end;

          Canvas.DrawPath( _Path, _Opacity );
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartGrid

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TChartScal.GetInterv :Single;
begin
     Result := _Interv;
end;

procedure TChartScal.SetInterv( const Interv_:Single );
begin
     _Interv := Interv_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TChartScal.Create( const Paren_:TChartViewer );
begin
     inherited;

     _Interv := 0.1;
end;

destructor TChartScal.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartScaX

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TChartScaX.Create( const Paren_:TChartViewer );
begin
     inherited;

     _Paren._ScaXs.Add( Self );
end;

destructor TChartScaX.Destroy;
begin
     _Paren._ScaXs.Remove( Self );

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TChartScaX.Draw;
var
   I0, I1, I :Integer;
   X :Single;
   P0, P1 :TSingle2D;
begin
     inherited;

     with _Paren do
     begin
          I0 := Ceil ( _Area.Min.X / _Interv );
          I1 := Floor( _Area.Max.X / _Interv );

          P0.Y := _Area.Min.Y;
          P1.Y := _Area.Max.Y;
          for I := I0 to I1 do
          begin
               X := I * _Interv;

               P0.X := X;
               P1.X := X;

               Canvas.DrawLine( PosToScr( P0 ), PosToScr( P1 ), _Opacity );
          end;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartScaY

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TChartScaY.Create( const Paren_:TChartViewer );
begin
     inherited;

     _Paren._ScaYs.Add( Self );
end;

destructor TChartScaY.Destroy;
begin
     _Paren._ScaYs.Remove( Self );

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TChartScaY.Draw;
var
   I0, I1, I :Integer;
   Y :Single;
   P0, P1 :TSingle2D;
begin
     inherited;

     with _Paren do
     begin
          I0 := Ceil ( _Area.Min.Y / _Interv );
          I1 := Floor( _Area.Max.Y / _Interv );

          P0.X := _Area.Min.X;
          P1.X := _Area.Max.X;
          for I := I0 to I1 do
          begin
               Y := I * _Interv;

               P0.Y := Y;
               P1.Y := Y;

               Canvas.DrawLine( PosToScr( P0 ), PosToScr( P1 ), _Opacity );
          end;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartAxis

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TChartAxis.Create( const Paren_:TChartViewer );
begin
     inherited;

     _Stroke.Color := TAlphaColorF.Create( 1/2, 1/2, 1/2 ).ToAlphaColor;
end;

destructor TChartAxis.Destroy;
begin

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TChartAxis.Draw;
var
   P0, P1 :TSingle2D;
begin
     inherited;

     with _Paren do
     begin
          with Canvas do
          begin
               P0.X := _Area.Min.X;  P0.Y := 0;
               P1.X := _Area.Max.X;  P1.Y := 0;

               DrawLine( PosToScr( P0 ), PosToScr( P1 ), _Opacity );

               P0.X := 0;  P0.Y := _Area.Min.Y;
               P1.X := 0;  P1.Y := _Area.Max.Y;

               DrawLine( PosToScr( P0 ), PosToScr( P1 ), _Opacity );
          end;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChartViewer

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TChartViewer.GetMinX :Single;
begin
     Result := _Area.Min.X;
end;

procedure TChartViewer.SetMinX( const MinX_:Single );
begin
     _Area.Min.X := MinX_;  Repaint;
end;

function TChartViewer.GetMaxX :Single;
begin
     Result := _Area.Max.X;
end;

procedure TChartViewer.SetMaxX( const MaxX_:Single );
begin
     _Area.Max.X := MaxX_;  Repaint;
end;

function TChartViewer.GetMinY :Single;
begin
     Result := _Area.Min.Y;
end;

procedure TChartViewer.SetMinY( const MinY_:Single );
begin
     _Area.Min.Y := MinY_;  Repaint;
end;

function TChartViewer.GetMaxY :Single;
begin
     Result := _Area.Max.Y;
end;

procedure TChartViewer.SetMaxY( const MaxY_:Single );
begin
     _Area.Max.Y := MaxY_;  Repaint;
end;

//------------------------------------------------------------------------------

function TChartViewer.GetAreaColor :TAlphaColor;
begin
     Result := _AreaColor;
end;

procedure TChartViewer.SetAreaColor( const BackColor_:TAlphaColor );
begin
     _AreaColor := BackColor_;  Repaint;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TChartViewer.Paint;
var
   I :Integer;
begin
     inherited;

     Canvas.Clear( _AreaColor );

     for I := 0 to _Elems.Count-1 do _Elems[ I ].Draw;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TChartViewer.Create( AOwner_:TComponent );
begin
     inherited;

     AutoCapture := True;

     _Elems := TObjectList<TChartAtom>.Create;
     _ScaXs := TList<TChartScaX>      .Create;
     _ScaYs := TList<TChartScaY>      .Create;

     MinX  := -1;
     MaxX  := +1;
     MinY  := -1;
     MaxY  := +1;
     AreaColor := TAlphaColors.White;

     with TChartScaX.Create( Self ) do
     begin
          Interv       := 1/50;
          Stroke.Color := TAlphaColorF.Create( 7/8, 7/8, 7/8 ).ToAlphaColor;
     end;
     with TChartScaY.Create( Self ) do
     begin
          Interv       := 1/50;
          Stroke.Color := TAlphaColorF.Create( 7/8, 7/8, 7/8 ).ToAlphaColor;
     end;
     with TChartScaX.Create( Self ) do
     begin
          Interv       := 1/10;
          Stroke.Color := TAlphaColorF.Create( 3/4, 3/4, 3/4 ).ToAlphaColor;
     end;
     with TChartScaY.Create( Self ) do
     begin
          Interv       := 1/10;
          Stroke.Color := TAlphaColorF.Create( 3/4, 3/4, 3/4 ).ToAlphaColor;
     end;

     _Axis := TChartAxis.Create( Self );
end;

destructor TChartViewer.Destroy;
begin
     _ScaXs.DisposeOf;
     _ScaYs.DisposeOf;

     _Elems.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

function TChartViewer.PosToScrX( const Pos_:Single ) :Single;
begin
     Result := ( Pos_ - _Area.Min.X ) / ( _Area.Max.X - _Area.Min.X ) * Width ;
end;

function TChartViewer.PosToScrY( const Pos_:Single ) :Single;
begin
     Result := ( Pos_ - _Area.Max.Y ) / ( _Area.Min.Y - _Area.Max.Y ) * Height;
end;

function TChartViewer.PosToScr( const Pos_:TSingle2D ) :TPointF;
begin
     Result.X := PosToScrX( Pos_.X );
     Result.Y := PosToScrY( Pos_.Y );
end;

function TChartViewer.ScrToPosX( const Scr_:Single ) :Single;
begin
     Result := Scr_ / Width  * ( _Area.Max.X - _Area.Min.X ) + _Area.Min.X;
end;

function TChartViewer.ScrToPosY( const Scr_:Single ) :Single;
begin
     Result := Scr_ / Height * ( _Area.Min.Y - _Area.Max.Y ) + _Area.Max.Y;
end;

function TChartViewer.ScrToPos( const Scr_:TPointF ) :TSingle2D;
begin
     Result.X := ScrToPosX( Scr_.X );
     Result.Y := ScrToPosY( Scr_.Y );
end;

//------------------------------------------------------------------------------

procedure TChartViewer.DrawCirc( const Center_:TSingle2D; const Radius_,Opacity_:Single );
var
   R :TRectF;
begin
     R := TRectF.Create( PosToScr( Center_ ) );
     R.Inflate( Radius_, Radius_ );

     Canvas.FillEllipse( R, Opacity_ );
end;

end. //######################################################################### ■
