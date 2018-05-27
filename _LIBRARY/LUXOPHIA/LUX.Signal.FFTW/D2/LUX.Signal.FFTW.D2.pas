unit LUX.Signal.FFTW.D2;

interface //#################################################################### ■

uses LUX,
     LUX.Data.Lattice.T2,
     LUX.Signal.FFTW,
     fftw3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDFT2D<_TItem_,_TTimes_,_TFreqs_>

     IDFT2D = interface( IDFT )
     ['{2C6F6E4E-4A0B-4F2E-A1BC-4863F4B7AA8F}']
     {protected}
     {public}
     end;

     //-------------------------------------------------------------------------

     TDFT2D<_TItem_:record;
            _TTimes_:TPoinArray2D<_TItem_>,constructor;
            _TFreqs_:TPoinArray2D<_TItem_>,constructor> = class( TDFT<_TItem_,_TTimes_,_TFreqs_>, IDFT2D )
     private
     protected
       ///// アクセス
       procedure SetTimesN;
       procedure SetFreqsN;
     public
       constructor Create;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDFT2D<_TItem_,_TGrid_>

     TDFT2D<_TItem_:record;
            _TGrid_:TPoinArray2D<_TItem_>,constructor> = class( TDFT2D<_TItem_,_TGrid_,_TGrid_>, IDFT2D )
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDFT2D<_TItem_,_TGrid_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

procedure TDFT2D<_TItem_,_TTimes_,_TFreqs_>.SetTimesN;
begin
     with _Freqs as TPoinArray2D<_TItem_> do
     begin
          PoinsX := _Times.PoinsX;
          PoinsY := _Times.PoinsY;
     end;

     RecreaPlans;
end;

procedure TDFT2D<_TItem_,_TTimes_,_TFreqs_>.SetFreqsN;
begin
     with _Times as TPoinArray2D<_TItem_> do
     begin
          PoinsX := _Freqs.PoinsX;
          PoinsY := _Freqs.PoinsY;
     end;

     RecreaPlans;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDFT2D<_TItem_,_TTimes_,_TFreqs_>.Create;
begin
     inherited;

     with _Times as TPoinArray2D<_TItem_> do
     begin
          _OnChange := SetTimesN;

          PoinsX := 2;
          PoinsY := 2;
     end;

     with _Freqs as TPoinArray2D<_TItem_> do
     begin
          _OnChange := SetFreqsN;

          PoinsX := 2;
          PoinsY := 2;
     end;
end;

destructor TDFT2D<_TItem_,_TTimes_,_TFreqs_>.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDFT2D<_TItem_,_TGrid_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■