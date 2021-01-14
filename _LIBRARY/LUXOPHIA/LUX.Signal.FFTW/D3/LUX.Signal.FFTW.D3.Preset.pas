unit LUX.Signal.FFTW.D3.Preset;

interface //#################################################################### ■

uses LUX, LUX.Complex,
     LUX.Data.Grid.T3,
     LUX.Signal.FFTW,
     LUX.Signal.FFTW.D3,
     fftw3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDFTcc3D<_TGrid_>

     TSingleDFTcc3D<_TGrid_:TPoinArray3D<TSingleC>,constructor> = class( TDFT3D<TSingleC,_TGrid_> )
     private
     protected
       ///// メソッド
       procedure CreatePlans; override;
     public
       constructor Create;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDFTcc3D

     ISingleDFTcc3D = interface( IDFT )
     ['{91BD25A1-F1DA-4A06-B8E3-4F90AEAE14E1}']
     {protected}
       ///// アクセス
       function GetTimes :TPoinArray3D<TSingleC>;
       function GetFreqs :TPoinArray3D<TSingleC>;
     {public}
       ///// プロパティ
       property Times :TPoinArray3D<TSingleC> read GetTimes;
       property Freqs :TPoinArray3D<TSingleC> read GetFreqs;
     end;

     //-------------------------------------------------------------------------

     TSingleDFTcc3D = class( TSingleDFTcc3D<TPoinArray3D<TSingleC>>, ISingleDFTcc3D )
     private
     protected
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleDFTcc3D<_TGrid_>

     TDoubleDFTcc3D<_TGrid_:TPoinArray3D<TDoubleC>,constructor> = class( TDFT3D<TDoubleC,_TGrid_> )
     private
     protected
       ///// メソッド
       procedure CreatePlans; override;
     public
       constructor Create;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleDFTcc3D

     IDoubleDFTcc3D = interface( IDFT )
     ['{D1CD51C8-2FA5-4F6D-97BB-3EB6A80787DD}']
     {protected}
       ///// アクセス
       function GetTimes :TPoinArray3D<TDoubleC>;
       function GetFreqs :TPoinArray3D<TDoubleC>;
     {public}
       ///// プロパティ
       property Times :TPoinArray3D<TDoubleC> read GetTimes;
       property Freqs :TPoinArray3D<TDoubleC> read GetFreqs;
     end;

     //-------------------------------------------------------------------------

     TDoubleDFTcc3D = class( TDoubleDFTcc3D<TPoinArray3D<TDoubleC>>, IDoubleDFTcc3D )
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDFTcc3D<_TGrid_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TSingleDFTcc3D<_TGrid_>.CreatePlans;
begin
     _PlanTF := fftwf_plan_dft_3d( _Times.PoinsX,
                                   _Times.PoinsY,
                                   _Times.PoinsZ,
                                   _Times.Elem0P,
                                   _Freqs.Elem0P, FFTW_FORWARD , FFTW_ESTIMATE );
     _PlanFT := fftwf_plan_dft_3d( _Freqs.PoinsX,
                                   _Times.PoinsY,
                                   _Times.PoinsZ,
                                   _Times.Elem0P,
                                   _Freqs.Elem0P, FFTW_BACKWARD, FFTW_ESTIMATE );

     Assert( Assigned( _PlanTF ) );
     Assert( Assigned( _PlanFT ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingleDFTcc3D<_TGrid_>.Create;
begin
     inherited;

end;

destructor TSingleDFTcc3D<_TGrid_>.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDFTcc3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleDFTcc3D<_TGrid_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TDoubleDFTcc3D<_TGrid_>.CreatePlans;
begin
     _PlanTF := fftw_plan_dft_3d( _Times.PoinsX,
                                  _Times.PoinsY,
                                  _Times.PoinsZ,
                                  _Times.Elem0P,
                                  _Freqs.Elem0P, FFTW_FORWARD , FFTW_ESTIMATE or FFTW_PRESERVE_INPUT );
     _PlanFT := fftw_plan_dft_3d( _Freqs.PoinsX,
                                  _Times.PoinsY,
                                  _Times.PoinsZ,
                                  _Times.Elem0P,
                                  _Freqs.Elem0P, FFTW_BACKWARD, FFTW_ESTIMATE or FFTW_PRESERVE_INPUT );

     Assert( Assigned( _PlanTF ) );
     Assert( Assigned( _PlanFT ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDoubleDFTcc3D<_TGrid_>.Create;
begin
     inherited;

end;

destructor TDoubleDFTcc3D<_TGrid_>.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleDFTcc3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
