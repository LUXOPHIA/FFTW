unit LUX.Signal.FFTW;

interface //#################################################################### ■

uses LUX, LUX.Complex,
     LUX.Data.Lattice.T1,
     fftw3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TFFT<_TItem_,_TGrid_>

     IFFT = interface
     ['{379D220B-97B5-423B-9CD6-55E0AFE1D5DB}']
     {protected}
     {public}
       ///// メソッド
       procedure TransTF;
       procedure TransFT;
     end;

     //-------------------------------------------------------------------------

     TFFT<_TItem_:record;
          _TGrid_:TPoinArray1D<_TItem_>,constructor> = class( TInterfacedObject, IFFT )
     private
     protected
       _Times  :_TGrid_;
       _Freqs  :_TGrid_;
       _PlanTF :TC_PTR;
       _PlanFT :TC_PTR;
       ///// アクセス
       function GetTimes :_TGrid_;
       function GetFreqs :_TGrid_;
       procedure SetTimesN;
       procedure SetFreqsN;
       ///// メソッド
       procedure CreatePlans; virtual; abstract;
       procedure DestroPlans; virtual; abstract;
       procedure RecreaPlans;
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property TimesN :_TGrid_ read GetTimes;
       property FreqsN :_TGrid_ read GetFreqs;
       ///// メソッド
       procedure TransTF; virtual; abstract;
       procedure TransFT; virtual; abstract;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleFFT<_TGrid_>

     TSingleFFT<_TGrid_:TPoinArray1D<TSingleC>,constructor> = class( TFFT<TSingleC,_TGrid_> )
     private
     protected
       ///// メソッド
       procedure CreatePlans; override;
       procedure DestroPlans; override;
     public
       constructor Create;
       destructor Destroy; override;
       ///// メソッド
       procedure TransTF; override;
       procedure TransFT; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleFFT

     ISingleFFT = interface( IFFT )
     ['{1CF097EA-F7BE-4DD4-82A4-E1522F3AE458}']
     {protected}
       ///// アクセス
       function GetTimes :TPoinArray1D<TSingleC>;
       function GetFreqs :TPoinArray1D<TSingleC>;
     {public}
       ///// プロパティ
       property Times :TPoinArray1D<TSingleC> read GetTimes;
       property Freqs :TPoinArray1D<TSingleC> read GetFreqs;
     end;

     //-------------------------------------------------------------------------

     TSingleFFT = class( TSingleFFT<TPoinArray1D<TSingleC>>, ISingleFFT )
     private
     protected
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleFFT<_TGrid_>

     TDoubleFFT<_TGrid_:TPoinArray1D<TDoubleC>,constructor> = class( TFFT<TDoubleC,_TGrid_> )
     private
     protected
       ///// メソッド
       procedure CreatePlans; override;
       procedure DestroPlans; override;
     public
       constructor Create;
       destructor Destroy; override;
       ///// メソッド
       procedure TransTF; override;
       procedure TransFT; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleFFT

     IDoubleFFT = interface( IFFT )
     ['{CFBC7050-75C9-485D-BC99-8D925AB3A37B}']
     {protected}
       ///// アクセス
       function GetTimes :TPoinArray1D<TDoubleC>;
       function GetFreqs :TPoinArray1D<TDoubleC>;
     {public}
       ///// プロパティ
       property Times :TPoinArray1D<TDoubleC> read GetTimes;
       property Freqs :TPoinArray1D<TDoubleC> read GetFreqs;
     end;

     //-------------------------------------------------------------------------

     TDoubleFFT = class( TDoubleFFT<TPoinArray1D<TDoubleC>>, IDoubleFFT )
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TFFT<_TItem_,_TGrid_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TFFT<_TItem_,_TGrid_>.GetTimes :_TGrid_;
begin
     Result := _Times;
end;

function TFFT<_TItem_,_TGrid_>.GetFreqs :_TGrid_;
begin
     Result := _Freqs;
end;

procedure TFFT<_TItem_,_TGrid_>.SetTimesN;
begin
     _Freqs.PoinsX := _Times.PoinsX;

     RecreaPlans;
end;

procedure TFFT<_TItem_,_TGrid_>.SetFreqsN;
begin
     _Times.PoinsX := _Freqs.PoinsX;

     RecreaPlans;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TFFT<_TItem_,_TGrid_>.RecreaPlans;
begin
     DestroPlans;
     CreatePlans;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TFFT<_TItem_,_TGrid_>.Create;
begin
     inherited;

     _Times := _TGrid_.Create;
     _Freqs := _TGrid_.Create;

     with _Times as TPoinArray1D<_TItem_> do
     begin
          PoinsX   := 2;
         _OnChange := SetTimesN;
     end;

     with _Freqs as TPoinArray1D<_TItem_> do
     begin
          PoinsX   := 2;
         _OnChange := SetFreqsN;
     end;

     CreatePlans;
end;

destructor TFFT<_TItem_,_TGrid_>.Destroy;
begin
     DestroPlans;

     _Times.DisposeOf;
     _Freqs.DisposeOf;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleFFT

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TSingleFFT<_TGrid_>.CreatePlans;
begin
     _PlanTF := fftwf_plan_dft_1d( _Times.PoinsX, _Times.Elem0P, _Freqs.Elem0P, FFTW_FORWARD , FFTW_ESTIMATE );
     _PlanFT := fftwf_plan_dft_1d( _Freqs.PoinsX, _Times.Elem0P, _Freqs.Elem0P, FFTW_BACKWARD, FFTW_ESTIMATE );

     Assert( Assigned( _PlanTF ) );
     Assert( Assigned( _PlanFT ) );
end;

procedure TSingleFFT<_TGrid_>.DestroPlans;
begin
     fftwf_destroy_plan( _PlanTF );
     fftwf_destroy_plan( _PlanFT );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingleFFT<_TGrid_>.Create;
begin
     inherited;

end;

destructor TSingleFFT<_TGrid_>.Destroy;
begin

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TSingleFFT<_TGrid_>.TransTF;
begin
     fftwf_execute_dft( _PlanTF, _Times.Elem0P, _Freqs.Elem0P );
end;

procedure TSingleFFT<_TGrid_>.TransFT;
begin
     fftwf_execute_dft( _PlanFT, _Times.Elem0P, _Freqs.Elem0P );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleFFT

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TDoubleFFT<_TGrid_>.CreatePlans;
begin
     _PlanTF := fftw_plan_dft_1d( _Times.PoinsX, _Times.Elem0P, _Freqs.Elem0P, FFTW_FORWARD , FFTW_ESTIMATE or FFTW_PRESERVE_INPUT );
     _PlanFT := fftw_plan_dft_1d( _Freqs.PoinsX, _Times.Elem0P, _Freqs.Elem0P, FFTW_BACKWARD, FFTW_ESTIMATE or FFTW_PRESERVE_INPUT );

     Assert( Assigned( _PlanTF ) );
     Assert( Assigned( _PlanFT ) );
end;

procedure TDoubleFFT<_TGrid_>.DestroPlans;
begin
     fftw_destroy_plan( _PlanTF );
     fftw_destroy_plan( _PlanFT );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDoubleFFT<_TGrid_>.Create;
begin
     inherited;

end;

destructor TDoubleFFT<_TGrid_>.Destroy;
begin

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TDoubleFFT<_TGrid_>.TransTF;
begin
     fftw_execute_dft( _PlanTF, _Times.Elem0P, _Freqs.Elem0P );
end;

procedure TDoubleFFT<_TGrid_>.TransFT;
begin
     fftw_execute_dft( _PlanFT, _Times.Elem0P, _Freqs.Elem0P );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■