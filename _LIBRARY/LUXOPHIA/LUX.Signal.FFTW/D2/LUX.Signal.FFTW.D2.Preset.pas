unit LUX.Signal.FFTW.D2.Preset;

interface //#################################################################### ■

uses LUX, LUX.Complex,
     LUX.Data.Lattice.T2,
     LUX.Signal.FFTW,
     LUX.Signal.FFTW.D2,
     fftw3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDFTcc2D<_TGrid_>

     TSingleDFTcc2D<_TGrid_:TPoinArray2D<TSingleC>,constructor> = class( TDFT2D<TSingleC,_TGrid_> )
     private
     protected
       ///// メソッド
       procedure CreatePlans; override;
     public
       constructor Create;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDFTcc2D

     ISingleDFTcc2D = interface( IDFT )
     ['{9BD48A53-E422-4543-93BF-E494AC504C04}']
     {protected}
       ///// アクセス
       function GetTimes :TPoinArray2D<TSingleC>;
       function GetFreqs :TPoinArray2D<TSingleC>;
     {public}
       ///// プロパティ
       property Times :TPoinArray2D<TSingleC> read GetTimes;
       property Freqs :TPoinArray2D<TSingleC> read GetFreqs;
     end;

     //-------------------------------------------------------------------------

     TSingleDFTcc2D = class( TSingleDFTcc2D<TPoinArray2D<TSingleC>>, ISingleDFTcc2D )
     private
     protected
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleDFTcc2D<_TGrid_>

     TDoubleDFTcc2D<_TGrid_:TPoinArray2D<TDoubleC>,constructor> = class( TDFT2D<TDoubleC,_TGrid_> )
     private
     protected
       ///// メソッド
       procedure CreatePlans; override;
     public
       constructor Create;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleDFTcc2D

     IDoubleDFTcc2D = interface( IDFT )
     ['{0D310AB7-CA29-424E-8E91-AF2FA4616FCD}']
     {protected}
       ///// アクセス
       function GetTimes :TPoinArray2D<TDoubleC>;
       function GetFreqs :TPoinArray2D<TDoubleC>;
     {public}
       ///// プロパティ
       property Times :TPoinArray2D<TDoubleC> read GetTimes;
       property Freqs :TPoinArray2D<TDoubleC> read GetFreqs;
     end;

     //-------------------------------------------------------------------------

     TDoubleDFTcc2D = class( TDoubleDFTcc2D<TPoinArray2D<TDoubleC>>, IDoubleDFTcc2D )
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDFTcc2D<_TGrid_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TSingleDFTcc2D<_TGrid_>.CreatePlans;
begin
     _PlanTF := fftwf_plan_dft_2d( _Times.PoinsX,
                                   _Times.PoinsY,
                                   _Times.Elem0P,
                                   _Freqs.Elem0P, FFTW_FORWARD , FFTW_ESTIMATE );
     _PlanFT := fftwf_plan_dft_2d( _Freqs.PoinsX,
                                   _Times.PoinsY,
                                   _Times.Elem0P,
                                   _Freqs.Elem0P, FFTW_BACKWARD, FFTW_ESTIMATE );

     Assert( Assigned( _PlanTF ) );
     Assert( Assigned( _PlanFT ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingleDFTcc2D<_TGrid_>.Create;
begin
     inherited;

end;

destructor TSingleDFTcc2D<_TGrid_>.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDFTcc2D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleDFTcc2D<_TGrid_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TDoubleDFTcc2D<_TGrid_>.CreatePlans;
begin
     _PlanTF := fftw_plan_dft_2d( _Times.PoinsX,
                                  _Times.PoinsY,
                                  _Times.Elem0P,
                                  _Freqs.Elem0P, FFTW_FORWARD , FFTW_ESTIMATE or FFTW_PRESERVE_INPUT );
     _PlanFT := fftw_plan_dft_2d( _Freqs.PoinsX,
                                  _Times.PoinsY,
                                  _Times.Elem0P,
                                  _Freqs.Elem0P, FFTW_BACKWARD, FFTW_ESTIMATE or FFTW_PRESERVE_INPUT );

     Assert( Assigned( _PlanTF ) );
     Assert( Assigned( _PlanFT ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDoubleDFTcc2D<_TGrid_>.Create;
begin
     inherited;

end;

destructor TDoubleDFTcc2D<_TGrid_>.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleDFTcc2D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■