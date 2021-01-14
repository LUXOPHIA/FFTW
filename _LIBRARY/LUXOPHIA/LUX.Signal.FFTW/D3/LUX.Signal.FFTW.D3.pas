unit LUX.Signal.FFTW.D3;

interface //#################################################################### ■

uses LUX,
     LUX.Data.Grid.T3,
     LUX.Signal.FFTW,
     fftw3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDFT3D<_TItem_,_TTimes_,_TFreqs_>

     IDFT3D = interface( IDFT )
     ['{F0DB55E8-C305-4DC8-A359-B264532C5D26}']
     {protected}
     {public}
     end;

     //-------------------------------------------------------------------------

     TDFT3D<_TItem_:record;
            _TTimes_:TPoinArray3D<_TItem_>,constructor;
            _TFreqs_:TPoinArray3D<_TItem_>,constructor> = class( TDFT<_TItem_,_TTimes_,_TFreqs_>, IDFT3D )
     private
     protected
       ///// アクセス
       procedure SetTimesN;
       procedure SetFreqsN;
     public
       constructor Create;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDFT3D<_TItem_,_TGrid_>

     TDFT3D<_TItem_:record;
            _TGrid_:TPoinArray3D<_TItem_>,constructor> = class( TDFT3D<_TItem_,_TGrid_,_TGrid_>, IDFT3D )
     private
     protected
     public
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDFT3D<_TItem_,_TGrid_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

procedure TDFT3D<_TItem_,_TTimes_,_TFreqs_>.SetTimesN;
begin
     with _Freqs as TPoinArray3D<_TItem_> do
     begin
          PoinsX := _Times.PoinsX;
          PoinsY := _Times.PoinsY;
          PoinsZ := _Times.PoinsZ;
     end;

     RecreaPlans;
end;

procedure TDFT3D<_TItem_,_TTimes_,_TFreqs_>.SetFreqsN;
begin
     with _Times as TPoinArray3D<_TItem_> do
     begin
          PoinsX := _Freqs.PoinsX;
          PoinsY := _Freqs.PoinsY;
          PoinsZ := _Freqs.PoinsZ;
     end;

     RecreaPlans;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDFT3D<_TItem_,_TTimes_,_TFreqs_>.Create;
begin
     inherited;

     with _Times as TPoinArray3D<_TItem_> do
     begin
          _OnChange := SetTimesN;

          PoinsX := 2;
          PoinsY := 2;
          PoinsZ := 2;
     end;

     with _Freqs as TPoinArray3D<_TItem_> do
     begin
          _OnChange := SetFreqsN;

          PoinsX := 2;
          PoinsY := 2;
          PoinsZ := 2;
     end;
end;

destructor TDFT3D<_TItem_,_TTimes_,_TFreqs_>.Destroy;
begin

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■