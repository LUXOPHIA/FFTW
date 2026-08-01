# LUX.FFTW

[English](../README.md) | [日本語](README.md)

高速フーリエ変換ライブラリ **FFTW 3**（*Fastest Fourier Transform in the West*）[1][2] の Delphi（Object Pascal）バインディングおよびオブジェクト指向ラッパー。`fftw3.pas` が倍精度（`libfftw3-3.dll`）・単精度（`libfftw3f-3.dll`）双方の FFTW C API を完全に移植し、`LUX.FFTW.*` ユニットが FFTW の *プラン* を汎用クラスで包む。入出力バッファは LUX のグリッドオブジェクトであり、グリッドをリサイズするとプランは自動的に再生成される。

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：変換バッファとして用いる複素数レコード（`LUX.Complex`）とグリッドクラス（`LUX.Data.Grid`・`LUX.Data.Grid.T1`〜`T3`）を提供する基盤ライブラリ。

## 1. 概要

| ユニット | 内容 |
|:---|:---|
| `fftw3.pas` | FFTW 3.3.11 の C API の素の移植。精度ごとに 72 個のエントリポイント — c2c / r2c / c2r / r2r 変換の basic・advanced（`plan_many`）・guru（`plan_guru`, `plan_guru64`, split-array）プラン生成、実行、プラン複製（`fftw_copy_plan`）、wisdom の入出力、マルチスレッド（別 DLL `libfftw3_threads-3.dll` / `libfftw3f_threads-3.dll` からインポート）、アロケータ（`fftw_alloc_real`, `fftw_alloc_complex`）、プランナ診断（`fftw_print_plan`, `fftw_cost`, `fftw_flops`）。`fftw_*`（倍精度）と `fftwf_*`（単精度）の双方を宣言 |
| `LUX.FFTW.pas` | `IDFT` インタフェースと汎用基底クラス `TDFT<_TItem_,_TTimes_,_TFreqs_>`。2 本のバッファ、2 個のプラン、`TransTF` / `TransFT` 操作を保持 |
| `D1/LUX.FFTW.D1.pas` | `IDFT1D` / `TDFT1D<…>` — バッファは `TPoinArray1D<_TItem_>`。`PoinsX` の変更は相手側グリッドへ伝播し `RecreaPlans` を起動する |
| `D1/LUX.FFTW.D1.Preset.pas` | 即用の 1 次元複素→複素変換：`TSingleDFTcc1D` / `TDoubleDFTcc1D`（および `ISingleDFTcc1D` / `IDoubleDFTcc1D`） |
| `D2/…`, `D3/…` | 同じ 2 層構成の 2 階（`TPoinArray2D`, `fftw_plan_dft_2d`）および 3 階（`TPoinArray3D`, `fftw_plan_dft_3d`）版 |
| `_DLL/`, `：FFTW/` | ビルド済み Win64 実行時 DLL と、同梱した MSYS2 `mingw-w64-fftw` パッケージ由来の FFTW 3.3.11 Windows ビルド [6] |

プリセットの命名規則：`T` ＋ 精度（`Single` / `Double`）＋ `DFT` ＋ 変換種別（`cc` ＝ 複素→複素）＋ 階数（`1D` / `2D` / `3D`）。

## 2. 数学的背景

### 2.1. 離散フーリエ変換

複素数列 $x_0,\dots,x_{N-1}$ に対する離散フーリエ変換（DFT）とその逆変換は [5]

```math
X_k = \sum_{n=0}^{N-1} x_n\, e^{-2\pi i k n / N}, \qquad k = 0,\dots,N-1
\qquad \text{(2.1)}
```

```math
x_n = \frac{1}{N} \sum_{k=0}^{N-1} X_k\, e^{+2\pi i k n / N}, \qquad n = 0,\dots,N-1
\qquad \text{(2.2)}
```

(2.1) を定義どおりに評価すると複素演算量は $O(N^2)$ となる。Cooley–Tukey 系 [4] の高速フーリエ変換アルゴリズムは $N$ を因数分解して計算量を $O(N \log N)$ に落とし、FFTW はそうしたコードレットを組み合わせて *プラン* を構成し、可能な因数分解の中からプラン生成時に選択する [1]。

### 2.2. FFTW の非正規化な規約

`fftw3.pas` に宣言された定数 `FFTW_FORWARD` $= -1$ と `FFTW_BACKWARD` $= +1$ は、まさに指数の符号そのものである。順方向プランは (2.1) をそのまま計算し、逆方向プランは (2.2) の総和を $1/N$ 係数**なし**で計算するため、両者は定数倍を除いてしか逆にならない。

```math
\mathcal{F}^{-1}_{\text{FFTW}}\!\left(\mathcal{F}_{\text{FFTW}}(x)\right) = N\,x
\qquad \text{(2.3)}
```

したがって正規化は呼び出し側の責任であり、本ライブラリは独自のスケーリングを一切行わない。

### 2.3. 多次元変換

範囲 $N_1 \times \dots \times N_d$ の $d$ 階配列に対する変換は、分離可能な積となる。

```math
X_{k_1 \dots k_d} = \sum_{n_1=0}^{N_1-1} \cdots \sum_{n_d=0}^{N_d-1}
x_{n_1 \dots n_d}\, \exp\!\left(-2\pi i \sum_{j=1}^{d} \frac{k_j n_j}{N_j}\right)
\qquad \text{(2.4)}
```

このとき (2.3) の往復係数は $N = \prod_{j=1}^{d} N_j$ となる。FFTW が (2.4) を各軸に沿った 1 階変換の連続として評価できるのは、この分離可能性による。`D2` / `D3` プリセットが用いる `fftw_plan_dft_2d` および `fftw_plan_dft_3d` は、範囲を行優先順（最後の添字が最も速く変化する）で受け取る。

### 2.4. プランナフラグ

プラン生成はアルゴリズムの探索であり、`fftw3.pas` に宣言されたフラグで制御する。プリセットは `FFTW_ESTIMATE` を用いる。これは試験変換を計測せずコストモデルからプランを選ぶため、計画が安価でバッファを上書きしない。倍精度プリセットはさらに `FFTW_PRESERVE_INPUT` を渡し、入力配列を破壊するアルゴリズムを禁止している。

## 3. アーキテクチャ

```
DLL バインディング

・fftw3.pas                             ･･･ cdecl インポート・精度ごとに 72 関数
  ┣・libfftw3-3.dll                    ･･･ 倍精度, fftw_*
  ┣・libfftw3f-3.dll                   ･･･ 単精度, fftwf_*
  ┣・libfftw3_threads-3.dll            ･･･ 倍精度, スレッド API
  ┗・libfftw3f_threads-3.dll           ･･･ 単精度, スレッド API

クラス階層 — 子孫は祖先の下に並べる

・TDFT<_TItem_,_TTimes_,_TFreqs_>       ･･･ …FFTW.pas — IDFT・TransTF/TransFT
  ┣・TDFT<_TItem_,_TGrid_>             ･･･ Times と Freqs が同一グリッド型
  ┣・TDFT1D<_TItem_,_TTimes_,_TFreqs_> ･･･ …FFTW.D1.pas — IDFT1D を実装
  ┃  ┗・TDFT1D<_TItem_,_TGrid_>
  ┃     ┣・TSingleDFTcc1D<_TGrid_>    ･･･ …FFTW.D1.Preset.pas
  ┃     ┃  ┗・TSingleDFTcc1D         ･･･ ISingleDFTcc1D を実装
  ┃     ┗・TDoubleDFTcc1D<_TGrid_>
  ┃        ┗・TDoubleDFTcc1D          ･･･ IDoubleDFTcc1D を実装
  ┣・TDFT2D<…>                        ･･･ …FFTW.D2.pas — IDFT2D を実装
  ┃  ┗・TDFT2D<_TItem_,_TGrid_>
  ┃     ┣・TSingleDFTcc2D<_TGrid_>
  ┃     ┃  ┗・TSingleDFTcc2D         ･･･ ISingleDFTcc2D を実装
  ┃     ┗・TDoubleDFTcc2D<_TGrid_>
  ┃        ┗・TDoubleDFTcc2D          ･･･ IDoubleDFTcc2D を実装
  ┗・TDFT3D<…>                        ･･･ …FFTW.D3.pas — IDFT3D を実装
     ┗・TDFT3D<_TItem_,_TGrid_>
        ┣・TSingleDFTcc3D<_TGrid_>
        ┃  ┗・TSingleDFTcc3D          ･･･ ISingleDFTcc3D を実装
        ┗・TDoubleDFTcc3D<_TGrid_>
           ┗・TDoubleDFTcc3D           ･･･ IDoubleDFTcc3D を実装
```

変換オブジェクトのライフサイクル：

```
・Create
  ┗・_TTimes_.Create / _TFreqs_.Create
     ┗・CreatePlans
        ┗・fftw(f)_plan_dft_{1,2,3}d( 範囲, バッファ, 方向, フラグ )

・グリッドのリサイズ（Poins* セッタ）
  ┗・_OnChange
     ┗・SetTimesN / SetFreqsN
        ┣・相手側グリッドが新しい範囲に追従
        ┗・RecreaPlans ＝ DestroPlans ＋ CreatePlans

・TransTF / TransFT
  ┗・fftw_execute_dft( plan, _Times.Elem0P, _Freqs.Elem0P )

・Destroy
  ┗・DestroPlans
     ┗・_Times.Free / _Freqs.Free
```

バッファは LUX のグリッドオブジェクト（`TCoreArray<_TItem_>` の子孫）であり、`Elem0P` が `TSingleC` / `TDoubleC` レコードの連続領域へのポインタを FFTW に渡す。これらは C の `fftwf_complex` / `fftw_complex` とメモリ互換であり、範囲は `PoinsX` / `PoinsY` / `PoinsZ` が供給する。グリッドはサイズ変更のたびに `_OnChange` を発火するため、プランの有効性は自動的に維持され、2 本のグリッドは常に等しい範囲に保たれる。

ファイル構成：

```
・LUX.FFTW/
  ┣・fftw3.pas                    ･･･ FFTW 3 API の素の移植（両精度）
  ┣・LUX.FFTW.pas                 ･･･ IDFT・汎用 TDFT 基底クラス
  ┣・D1/
  ┃  ┣・LUX.FFTW.D1.pas           ･･･ IDFT1D / TDFT1D（自動再計画）
  ┃  ┗・LUX.FFTW.D1.Preset.pas    ･･･ TSingleDFTcc1D / TDoubleDFTcc1D
  ┣・D2/                          ･･･ 2 階の同一構成
  ┣・D3/                          ･･･ 3 階の同一構成
  ┣・_DLL/
  ┃  ┗・Win64/{Debug,Release}/    ･･･ 倍・単精度＋スレッド DLL
  ┗・：FFTW/                      ･･･ FFTW 3.3.11（MSYS2 ビルド）
     ┗・fftw-3.3.11-msys2-x86_64/ ･･･ bin, include, lib, share, PKGINFO
```

## 4. 使い方

```pascal
uses LUX.Complex,
     LUX.Data.Grid.T1,
     LUX.FFTW,
     LUX.FFTW.D1.Preset;

const
     _N_ = 512;
var
   F :IDoubleDFTcc1D;
   I :Integer;
begin
     F := TDoubleDFTcc1D.Create;      // インタフェース参照：自動的に解放される

     F.Times.PoinsX := _N_;           // リサイズ ⇒ Freqs が追従 ⇒ 両プランを再生成

     for I := 0 to _N_-1 do           // 窓あたり 8 周期の実コサイン
     begin
          F.Times[ I ] := TDoubleC.Create( Cos( 2*Pi * 8 * I / _N_ ), 0 );
     end;

     F.TransTF;                       // 順変換：Times ──► Freqs

     for I := 0 to _N_-1 do
     begin
          WriteLn( I:4, F.Freqs[ I ].Size / _N_ :12:6 );   // |X[k]| / N
     end;
end;
```

`Times` と `Freqs` はグリッドオブジェクト *そのもの* であるため、標本は既定の配列プロパティを通じて読み書きでき、Delphi の配列と FFTW のバッファとの間のコピーは一切不要である。最後のループの $N$ による除算は (2.3) の正規化であり、FFTW はこれをアプリケーション側に委ねている。

## 5. 必要環境

* **Delphi / RAD Studio** — ジェネリクスとレコードヘルパを備えた任意のバージョン。`fftw3.pas` は Windows DLL を名前でインポートするため、対象は Win64。
* **[LUX](https://github.com/LUXOPHIA/LUX)** 基底ライブラリ — `LUX`、`LUX.Complex`（`TSingleC` / `TDoubleC`）、`LUX.Data.Grid`（`TCoreArray<>`）、`LUX.Data.Grid.T1` … `T3`（`TPoinArray1D<>` … `TPoinArray3D<>`）。現在の LUX ツリーではこれらの複素数・グリッドユニットは `--------/2022/` アーカイブディレクトリ下にあるため、そこをコンパイラの検索パスに加える必要がある。
* **実行時 DLL** — `libfftw3-3.dll`（倍精度）と `libfftw3f-3.dll`（単精度）を実行ファイルから到達可能に置くこと（通常は実行ファイルの隣にコピーする）。マルチスレッド系のエントリポイントは別 DLL `libfftw3_threads-3.dll` / `libfftw3f_threads-3.dll` からインポートされる。4 本すべてが `_DLL\Win64\{Debug,Release}` に同梱されている。long double 版・OpenMP 版・静的／インポートライブラリ・`fftw3.h`・`fftw-wisdom` ユーティリティを含む MSYS2 `mingw-w64-fftw` 3.3.11 パッケージ一式 [6] は `：FFTW\fftw-3.3.11-msys2-x86_64` に格納されている。公式の Windows ビルドは FFTW サイトで公開されている [3]。
* **Git LFS** — `.gitattributes` が `*.dll` と `*.a` を `filter=lfs` に宣言しているため、Git LFS なしのチェックアウトではバイナリの代わりにポインタファイルが得られる。
* **FFTW 自体のライセンス** — FFTW は GNU General Public License バージョン 2 以降の下で配布される（同梱パッケージの `PKGINFO` に記載）。別途 MIT から商用ライセンスが提供されている [2]。

## 6. 制限事項

現在のソースに基づく事実であり、ラッパーを拡張する前に把握しておく価値がある。

* **実行とプラン破棄が片方の精度に固定されている。** `TDFT.TransTF` と `TDFT.TransFT` は `fftw_execute_dft` を、`TDFT.DestroPlans` は `fftwf_destroy_plan` を呼ぶ。すなわち子孫クラスの実際の精度に関わらず、それぞれ倍精度・単精度のエントリポイントである。したがって実際に動作が確認される経路は `TDouble…` プリセットであり、`fftwf_plan_dft_*` からプランを得る `TSingle…` プリセットには精度に応じたオーバーライドが必要となる。
* **`TransFT` はその場での逆変換ではない。** 両プランは同一のバッファ対（入力 `_Times.Elem0P`、出力 `_Freqs.Elem0P`）で生成され、`TransFT` もその同じ対で実行される。ゆえに `Freqs` から `Times` を復元するのではなく、`Times` の $+i$ 符号の変換を `Freqs` へ書き出す。逆変換するには、まずスペクトルを `Times` へ移す必要がある。
* **複素→複素プリセットのみが存在する。** r2c・c2r・r2r のプラン族は `fftw3.pas` に完全に宣言されているが、それらを包む `TDFT` の子孫は存在しない。wisdom とマルチスレッドについても同様である。
* 2 階・3 階の `CreatePlans` では、逆方向プランの第 1 範囲を `_Freqs` から、残りの範囲を `_Times` から取っている。変更ハンドラが両グリッドを等しい範囲に保つ限り無害であり、実際に保たれている。

## 7. 参考文献

1. Frigo, M. and Johnson, S. G., [*The Design and Implementation of FFTW3*](https://doi.org/10.1109/JPROC.2004.840301), Proceedings of the IEEE, 93(2), pp. 216–231, 2005.
2. [*FFTW Home Page*](https://www.fftw.org/), Massachusetts Institute of Technology.
3. [*Installation on Windows*](https://www.fftw.org/install/windows.html), FFTW documentation.
4. Cooley, J. W. and Tukey, J. W., [*An Algorithm for the Machine Calculation of Complex Fourier Series*](https://doi.org/10.1090/S0025-5718-1965-0178586-1), Mathematics of Computation, 19(90), pp. 297–301, 1965.
5. [*Discrete Fourier transform*](https://en.wikipedia.org/wiki/Discrete_Fourier_transform), Wikipedia.
6. [*mingw-w64-fftw*](https://packages.msys2.org/base/mingw-w64-fftw), MSYS2 Packages.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
