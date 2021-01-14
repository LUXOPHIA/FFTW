unit LUX.Signal.FFTW.D1.Preset;

interface //#################################################################### ■

uses LUX, LUX.Complex,
     LUX.Data.Grid.T1,
     LUX.Signal.FFTW,
     LUX.Signal.FFTW.D1,
     fftw3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDFTcc1D<_TGrid_>

     TSingleDFTcc1D<_TGrid_:TPoinArray1D<TSingleC>,constructor> = class( TDFT1D<TSingleC,_TGrid_> )
     private
     protected
       ///// メソッド
       procedure CreatePlans; override;
     public
       constructor Create;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDFTcc1D

     ISingleDFTcc1D = interface( IDFT )
     ['{077D2505-12A4-44AB-97AE-494C1BE9D69B}']
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

     TSingleDFTcc1D = class( TSingleDFTcc1D<TPoinArray1D<TSingleC>>, ISingleDFTcc1D )
     private
     protected
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleDFTcc1D<_TGrid_>

     TDoubleDFTcc1D<_TGrid_:TPoinArray1D<TDoubleC>,constructor> = class( TDFT1D<TDoubleC,_TGrid_> )
     private
     protected
       ///// メソッド
       procedure CreatePlans; override;
     public
       constructor Create;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleDFTcc1D

     IDoubleDFTcc1D = interface( IDFT )
     ['{78D6A162-8D29-4980-8F86-6B9BDAB50805}']
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

     TDoubleDFTcc1D = class( TDoubleDFTcc1D<TPoinArray1D<TDoubleC>>, IDoubleDFTcc1D )
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDFTcc1D<_TGrid_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TSingleDFTcc1D<_TGrid_>.CreatePlans;
begin
     _PlanTF := fftwf_plan_dft_1d( _Times.PoinsX,
                                   _Times.Elem0P,
                                   _Freqs.Elem0P, FFTW_FORWARD , FFTW_ESTIMATE );
     _PlanFT := fftwf_plan_dft_1d( _Freqs.PoinsX,
                                   _Times.Elem0P,
                                   _Freqs.Elem0P, FFTW_BACKWARD, FFTW_ESTIMATE );

     Assert( Assigned( _PlanTF ) );
     Assert( Assigned( _PlanFT ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingleDFTcc1D<_TGrid_>.Create;
begin
     inherited;

end;

destructor TSingleDFTcc1D<_TGrid_>.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDFTcc1D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleDFTcc1D<_TGrid_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TDoubleDFTcc1D<_TGrid_>.CreatePlans;
begin
     _PlanTF := fftw_plan_dft_1d( _Times.PoinsX, _Times.Elem0P, _Freqs.Elem0P, FFTW_FORWARD , FFTW_ESTIMATE or FFTW_PRESERVE_INPUT );
     _PlanFT := fftw_plan_dft_1d( _Freqs.PoinsX, _Times.Elem0P, _Freqs.Elem0P, FFTW_BACKWARD, FFTW_ESTIMATE or FFTW_PRESERVE_INPUT );

     Assert( Assigned( _PlanTF ) );
     Assert( Assigned( _PlanFT ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDoubleDFTcc1D<_TGrid_>.Create;
begin
     inherited;

end;

destructor TDoubleDFTcc1D<_TGrid_>.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleDFTcc1D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■