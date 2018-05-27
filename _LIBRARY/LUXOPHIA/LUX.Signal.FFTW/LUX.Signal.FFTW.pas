unit LUX.Signal.FFTW;

interface //#################################################################### ■

uses LUX,
     LUX.Data.Lattice,
     fftw3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDFT<_TItem_,_TTimes_,_TFreqs_>

     IDFT = interface
     ['{65986659-4EB3-46E9-BD5E-A8C7ED6F5949}']
     {protected}
     {public}
       ///// メソッド
       procedure TransTF;
       procedure TransFT;
     end;

     //-------------------------------------------------------------------------

     TDFT<_TItem_:record;
          _TTimes_:TCoreArray<_TItem_>,constructor;
          _TFreqs_:TCoreArray<_TItem_>,constructor> = class( TInterfacedObject, IDFT )
     private
     protected
       _Times  :_TTimes_;
       _Freqs  :_TFreqs_;
       _PlanTF :TC_PTR;
       _PlanFT :TC_PTR;
       ///// アクセス
       function GetTimes :_TTimes_;
       function GetFreqs :_TFreqs_;
       ///// メソッド
       procedure CreatePlans; virtual; abstract;
       procedure DestroPlans;
       procedure RecreaPlans;
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property Times :_TTimes_ read GetTimes;
       property Freqs :_TFreqs_ read GetFreqs;
       ///// メソッド
       procedure TransTF;
       procedure TransFT;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDFT<_TItem_,_TGrid_>

     TDFT<_TItem_:record;
          _TGrid_:TCoreArray<_TItem_>,constructor> = class( TDFT<_TItem_,_TGrid_,_TGrid_> )
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDFT<_TItem_,_TTimes_,_TFreqs_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TDFT<_TItem_,_TTimes_,_TFreqs_>.GetTimes :_TTimes_;
begin
     Result := _Times;
end;

function TDFT<_TItem_,_TTimes_,_TFreqs_>.GetFreqs :_TFreqs_;
begin
     Result := _Freqs;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TDFT<_TItem_,_TTimes_,_TFreqs_>.DestroPlans;
begin
     fftwf_destroy_plan( _PlanTF );
     fftwf_destroy_plan( _PlanFT );
end;

procedure TDFT<_TItem_,_TTimes_,_TFreqs_>.RecreaPlans;
begin
     DestroPlans;
     CreatePlans;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDFT<_TItem_,_TTimes_,_TFreqs_>.Create;
begin
     inherited;

     _Times := _TTimes_.Create;
     _Freqs := _TFreqs_.Create;

     CreatePlans;
end;

destructor TDFT<_TItem_,_TTimes_,_TFreqs_>.Destroy;
begin
     DestroPlans;

     _Times.DisposeOf;
     _Freqs.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TDFT<_TItem_,_TTimes_,_TFreqs_>.TransTF;
begin
     fftw_execute_dft( _PlanTF, _Times.Elem0P, _Freqs.Elem0P );
end;

procedure TDFT<_TItem_,_TTimes_,_TFreqs_>.TransFT;
begin
     fftw_execute_dft( _PlanFT, _Times.Elem0P, _Freqs.Elem0P );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDFT<_TItem_,_TGrid_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■