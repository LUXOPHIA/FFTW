unit LUX.Signal.FFTW;

interface //#################################################################### ■

uses LUX, LUX.Complex,
     fftw3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TFFT

     IFFT = interface
     ['{379D220B-97B5-423B-9CD6-55E0AFE1D5DB}']
     {protected}
       ///// アクセス
       function GetTimesN :Integer;
       procedure SetTimesN( const TimesN_:Integer );
       function GetFreqsN :Integer;
       procedure SetFreqsN( const FreqsN_:Integer );
     {public}
       ///// プロパティ
       property TimesN :Integer read GetTimesN write SetTimesN;
       property FreqsN :Integer read GetFreqsN write SetFreqsN;
       ///// メソッド
       procedure TransTF;
       procedure TransFT;
     end;

     //-------------------------------------------------------------------------

     TFFT = class( TInterfacedObject )
     private
     protected
       _TimesN :Integer;
       _FreqsN :Integer;
       _PlanTF :TC_PTR;
       _PlanFT :TC_PTR;
       ///// アクセス
       function GetTimesN :Integer;
       procedure SetTimesN( const TimesN_:Integer );
       function GetFreqsN :Integer;
       procedure SetFreqsN( const FreqsN_:Integer );
       ///// メソッド
       procedure CreatePlans; virtual; abstract;
       procedure DestroPlans; virtual; abstract;
       procedure MakeBuffers; virtual; abstract;
       procedure RecreaPlans;
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property TimesN :Integer read GetTimesN write SetTimesN;
       property FreqsN :Integer read GetFreqsN write SetFreqsN;
       ///// メソッド
       procedure TransTF; virtual; abstract;
       procedure TransFT; virtual; abstract;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleFFT

     ISingleFFT = interface( IFFT )
     ['{1CF097EA-F7BE-4DD4-82A4-E1522F3AE458}']
     {protected}
       ///// アクセス
       function GetTimes( const I_:Integer ) :TSingleC;
       procedure SetTimes( const I_:Integer; const Time_:TSingleC );
       function GetFreqs( const I_:Integer ) :TSingleC;
       procedure SetFreqs( const I_:Integer; const Freq_:TSingleC );
     {public}
       ///// プロパティ
       property Times[ const I_:Integer ] :TSingleC read GetTimes write SetTimes;
       property Freqs[ const I_:Integer ] :TSingleC read GetFreqs write SetFreqs;
     end;

     //-------------------------------------------------------------------------

     TSingleFFT = class( TFFT, ISingleFFT )
     private
     protected
       _Times :TArray<TSingleC>;
       _Freqs :TArray<TSingleC>;
       ///// アクセス
       function GetTimes( const I_:Integer ) :TSingleC;
       procedure SetTimes( const I_:Integer; const Time_:TSingleC );
       function GetFreqs( const I_:Integer ) :TSingleC;
       procedure SetFreqs( const I_:Integer; const Freq_:TSingleC );
       ///// メソッド
       procedure CreatePlans; override;
       procedure DestroPlans; override;
       procedure MakeBuffers; override;
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property Times[ const I_:Integer ] :TSingleC read GetTimes write SetTimes;
       property Freqs[ const I_:Integer ] :TSingleC read GetFreqs write SetFreqs;
       ///// メソッド
       procedure TransTF; override;
       procedure TransFT; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleFFT

     IDoubleFFT = interface( IFFT )
     ['{CFBC7050-75C9-485D-BC99-8D925AB3A37B}']
     {protected}
       ///// アクセス
       function GetTimes( const I_:Integer ) :TDoubleC;
       procedure SetTimes( const I_:Integer; const Time_:TDoubleC );
       function GetFreqs( const I_:Integer ) :TDoubleC;
       procedure SetFreqs( const I_:Integer; const Freq_:TDoubleC );
     {public}
       ///// プロパティ
       property Times[ const I_:Integer ] :TDoubleC read GetTimes write SetTimes;
       property Freqs[ const I_:Integer ] :TDoubleC read GetFreqs write SetFreqs;
     end;

     //-------------------------------------------------------------------------

     TDoubleFFT = class( TFFT, IDoubleFFT )
     private
     protected
       _Times :TArray<TDoubleC>;
       _Freqs :TArray<TDoubleC>;
       ///// アクセス
       function GetTimes( const I_:Integer ) :TDoubleC;
       procedure SetTimes( const I_:Integer; const Time_:TDoubleC );
       function GetFreqs( const I_:Integer ) :TDoubleC;
       procedure SetFreqs( const I_:Integer; const Freq_:TDoubleC );
       ///// メソッド
       procedure CreatePlans; override;
       procedure DestroPlans; override;
       procedure MakeBuffers; override;
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property Times[ const I_:Integer ] :TDoubleC read GetTimes write SetTimes;
       property Freqs[ const I_:Integer ] :TDoubleC read GetFreqs write SetFreqs;
       ///// メソッド
       procedure TransTF; override;
       procedure TransFT; override;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TFFT

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TFFT.RecreaPlans;
begin
     DestroPlans;

     MakeBuffers;

     CreatePlans;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TFFT.GetTimesN :Integer;
begin
     Result := _TimesN;
end;

procedure TFFT.SetTimesN( const TimesN_:Integer );
begin
     _TimesN := TimesN_;
     _FreqsN := TimesN_;

     RecreaPlans;
end;

function TFFT.GetFreqsN :Integer;
begin
     Result := _FreqsN;
end;

procedure TFFT.SetFreqsN( const FreqsN_:Integer );
begin
     _FreqsN := FreqsN_;
     _TimesN := FreqsN_;

     RecreaPlans;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TFFT.Create;
begin
     inherited;

     _TimesN := 2;
     _FreqsN := 2;

     MakeBuffers;

     CreatePlans;
end;

destructor TFFT.Destroy;
begin
     DestroPlans;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleFFT

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TSingleFFT.CreatePlans;
begin
     _PlanTF := fftwf_plan_dft_1d( _TimesN, @_Times[0], @_Freqs[0], FFTW_FORWARD , FFTW_ESTIMATE );
     _PlanFT := fftwf_plan_dft_1d( _FreqsN, @_Times[0], @_Freqs[0], FFTW_BACKWARD, FFTW_ESTIMATE );

     Assert( Assigned( _PlanTF ) );
     Assert( Assigned( _PlanFT ) );
end;

procedure TSingleFFT.DestroPlans;
begin
     fftwf_destroy_plan( _PlanTF );
     fftwf_destroy_plan( _PlanFT );
end;

procedure TSingleFFT.MakeBuffers;
begin
     SetLength( _Times, _TimesN );
     SetLength( _Freqs, _FreqsN );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TSingleFFT.GetTimes( const I_:Integer ) :TSingleC;
begin
     Result := _Times[ I_ ];
end;

procedure TSingleFFT.SetTimes( const I_:Integer; const Time_:TSingleC );
begin
     _Times[ I_ ] := Time_;
end;

function TSingleFFT.GetFreqs( const I_:Integer ) :TSingleC;
begin
     Result := _Freqs[ I_ ];
end;

procedure TSingleFFT.SetFreqs( const I_:Integer; const Freq_:TSingleC );
begin
     _Freqs[ I_ ] := Freq_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingleFFT.Create;
begin
     inherited;

end;

destructor TSingleFFT.Destroy;
begin

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TSingleFFT.TransTF;
begin
     fftwf_execute_dft( _PlanTF, @_Times[0], @_Freqs[0] );
end;

procedure TSingleFFT.TransFT;
begin
     fftwf_execute_dft( _PlanFT, @_Times[0], @_Freqs[0] );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleFFT

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TDoubleFFT.CreatePlans;
begin
     _PlanTF := fftw_plan_dft_1d( _TimesN, @_Times[0], @_Freqs[0], FFTW_FORWARD , FFTW_ESTIMATE );
     _PlanFT := fftw_plan_dft_1d( _FreqsN, @_Times[0], @_Freqs[0], FFTW_BACKWARD, FFTW_ESTIMATE );

     Assert( Assigned( _PlanTF ) );
     Assert( Assigned( _PlanFT ) );
end;

procedure TDoubleFFT.DestroPlans;
begin
     fftw_destroy_plan( _PlanTF );
     fftw_destroy_plan( _PlanFT );
end;

procedure TDoubleFFT.MakeBuffers;
begin
     SetLength( _Times, _TimesN );
     SetLength( _Freqs, _FreqsN );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TDoubleFFT.GetTimes( const I_:Integer ) :TDoubleC;
begin
     Result := _Times[ I_ ];
end;

procedure TDoubleFFT.SetTimes( const I_:Integer; const Time_:TDoubleC );
begin
     _Times[ I_ ] := Time_;
end;

function TDoubleFFT.GetFreqs( const I_:Integer ) :TDoubleC;
begin
     Result := _Freqs[ I_ ];
end;

procedure TDoubleFFT.SetFreqs( const I_:Integer; const Freq_:TDoubleC );
begin
     _Freqs[ I_ ] := Freq_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDoubleFFT.Create;
begin
     inherited;

end;

destructor TDoubleFFT.Destroy;
begin

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TDoubleFFT.TransTF;
begin
     fftw_execute_dft( _PlanTF, @_Times[0], @_Freqs[0] );
end;

procedure TDoubleFFT.TransFT;
begin
     fftw_execute_dft( _PlanFT, @_Times[0], @_Freqs[0] );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■