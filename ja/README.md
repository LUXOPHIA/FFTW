# FFTW

[English](../README.md) | [日本語](README.md)

高速フーリエ変換ライブラリ [FFTW](https://www.fftw.org/) [1] を Delphi から利用する方法を示す、最小構成の Delphi/FireMonkey デモです。複素数値のランダムウォーク信号を 10 ms ごとに更新し、倍精度の複素→複素 FFT で変換して、時間領域波形とその生スペクトルをリアルタイムに描画します。

![](../--------/_SCREENSHOT/FFTW.png)

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：LUXOPHIA プロジェクトの基盤数学ライブラリ。
* [**LUX.Chart**](https://github.com/LUXOPHIA/LUX.Chart) ：`TChartViewer` フレームを提供するチャート描画ライブラリ。
* [**LUX.FFTW**](https://github.com/LUXOPHIA/LUX.FFTW) ：FFTW 3 ライブラリの Delphi バインディングとオブジェクト指向ラッパ。

## 1. 概要

* **FFTW 3 の生バインディング** — `fftw3.pas` は FFTW の C API を Delphi へ翻訳したものです。プラン生成（basic / advanced / guru インタフェース）、複素→複素・実→複素／複素→実・実→実プラン、wisdom の入出力、スレッド対応、`fftw_malloc` 系アロケータを、倍精度（`libfftw3-3.dll`）と単精度（`libfftw3f-3.dll`）の両ライブラリについて網羅しています。
* **オブジェクト指向ラッパ** — `LUX.FFTW` はプランをジェネリッククラス（`TDFT<...>`、`TDFT1D<...>`）で包み、入出力バッファをグリッドオブジェクトとして扱います。グリッドをリサイズするとプランは自動的に再生成されます。
* **既成プリセット** — `TSingleDFTcc1D` / `TDoubleDFTcc1D` が 1 次元の複素→複素変換をそのまま提供します（ライブラリには 2 次元・3 次元のプリセットユニットも含まれます）。
* **ライブデモアプリ** — FireMonkey フォームがメトロポリス型の複素ランダムウォークをアニメーションさせ、タイマーごとに順変換を実行し、`TChartViewer` で両領域を表示します。変換長は実行中に変更できます。

## 2. 数学的背景

長さ $N$ の複素数列 $x_0,\dots,x_{N-1}$ の離散フーリエ変換（DFT）は [2]

```math
X_k = \sum_{n=0}^{N-1} x_n\, e^{-2\pi i k n / N}, \qquad k = 0,\dots,N-1 \tag{1}
```

であり、その逆変換は

```math
x_n = \frac{1}{N} \sum_{k=0}^{N-1} X_k\, e^{+2\pi i k n / N} \tag{2}
```

です。式 (1) の直接評価には $O(N^2)$ の演算が必要ですが、Cooley–Tukey [3] に代表される FFT アルゴリズムはこれを $O(N \log N)$ に削減します。FFTW はプラン生成時に多数のアルゴリズムから最適なものを選択します [1]。

**FFTW の正規化規約** — `FFTW_FORWARD` は正規化なしの和 (1) をそのまま計算し、`FFTW_BACKWARD` は式 (2) の和を $1/N$ 係数 *なし* で計算します。したがって順変換と逆変換を続けて適用するとデータは $N$ 倍にスケールされ、正規化は呼び出し側に委ねられます。本デモは順変換（`TransTF`）のみを実行し、正規化していないスペクトル $X_k$ をそのまま描画します。

**デモ信号** — `TDoubleRandWalkC`（LUX ライブラリ）は $N$ 個の複素サンプルを保持し、タイマーごとに全サンプルをメトロポリス型ランダムウォークで 1 ステップ進めることで、連続的に変化する複素信号 $x_n$ を生成します。窓関数は適用されません（暗黙の矩形窓）。入力が複素数のため、各チャートには実部（青）と虚部（赤）の両方が描かれます。

## 3. アーキテクチャ

ラッパのクラス階層とデータフロー：

```
・TForm1 (Main.pas)
  ┣・_Wave :IDoubleRandWalkC               ･･･ メトロポリス複素ランダムウォーク
  ┣・_FFT :IDoubleDFTcc1D                  ･･･ 1次元 c2c 倍精度 DFT
  ┗・ChartViewerT / ChartViewerF           ･･･ 時間／周波数チャート [LUX.Chart]

データフロー（タイマー1周期）

・_Wave
  ┗・_FFT.Times                            ･･･ (x[n])
     ┣・ChartViewerT                       ･･･ 時間領域チャート
     ┗・TransTF                            ･･･ fftw_execute_dft（_PlanTF 経由）
        ┗・_FFT.Freqs                      ･･･ (X[k])
           ┗・ChartViewerF                 ･･･ 周波数領域チャート

クラス階層

・IDFT
  ┗・TDFT<_TItem_,_TTimes_,_TFreqs_>       ･･･ LUX.FFTW.pas
     ┣・_Times / _Freqs                    ･･･ グリッドバッファ
     ┣・_PlanTF / _PlanFT                  ･･･ プラン。TransTF/TransFT が実行
     ┗・TDFT1D<...>                        ･･･ LUX.FFTW.D1.pas
        ┣・グリッドのリサイズ
        ┃  ┗・RecreaPlans                 ･･･ プランを破棄して再生成
        ┗・TSingleDFTcc1D / TDoubleDFTcc1D ･･･ LUX.FFTW.D1.Preset.pas

バインディング階層（呼び出しの連鎖）

・TSingleDFTcc1D / TDoubleDFTcc1D
  ┗・fftw(f)_plan_dft_1d( N, in, out, direction, flags )
     ┗・fftw3.pas
        ┗・cdecl インポート
           ┗・libfftw3-3.dll / libfftw3f-3.dll
```

ファイル構成：

```
・FFTW/
  ┣・FFTW.dpr / FFTW.dproj ･･･ FireMonkey デモプロジェクト
  ┣・Main.pas / Main.fmx   ･･･ フォーム：チャート・10ms タイマー・N バー
  ┣・Win64/                ･･･ ビルド出力。同梱の FFTW DLL（Debug/Release）
  ┣・--------/_SCREENSHOT/ ･･･ スクリーンショット
  ┗・_LIBRARY/LUXOPHIA/    ･･･ ライブラリリポジトリの git-subtree コピー
     ┣・LUX/               ･･･ 基礎数学・ユーティリティ（複素数など）
     ┃  ┗・--------/2022/  ･･･ 2022 年版ユニット（.dpr 参照）
     ┣・LUX.Chart/         ･･･ TChartViewer 描画フレーム
     ┗・LUX.FFTW/          ･･･ FFTW バインディングとラッパクラス
        ┣・fftw3.pas       ･･･ FFTW 3 API の生翻訳
        ┣・LUX.FFTW.pas    ･･･ ジェネリックな TDFT 基底クラス
        ┗・D1/ D2/ D3/     ･･･ 1次元／2次元／3次元のラッパとプリセット
```

ライブラリリポジトリ：[LUX](https://github.com/LUXOPHIA/LUX)、[LUX.Chart](https://github.com/LUXOPHIA/LUX.Chart)、[LUX.FFTW](https://github.com/LUXOPHIA/LUX.FFTW)。

## 4. 使い方／操作

アニメーションは自動的に開始し、タイマーが 10 ms ごとにランダムウォークを進めて FFT を再実行します。

| 操作対象 | 機能 |
|---|---|
| 上段チャート | 時間領域 $x_n$ — 実部（青）、虚部（赤） |
| 下段チャート | 周波数領域 $X_k$（正規化なし）— 実部（青）、虚部（赤） |
| 右側の縦スクロールバー | 変換長 $N$：2 – 2048、既定値 512 |
| 右上のラベル | 現在の $N$ の値 |

$N$ を変更すると `Times`/`Freqs` グリッドがリサイズされ、FFTW プランが自動的に再生成されます。

## 5. ビルド

* **IDE**：RAD Studio / Delphi（プロジェクト形式 19.5 = RAD Studio 11 Alexandria。以降のバージョンではプロジェクトをアップグレードできます）。
* **フレームワーク**：FireMonkey（FMX）。
* **プラットフォーム**：動作対象は Win64 です — `fftw3.pas` は Windows 用 FFTW DLL とリンクします。
* **必要な DLL**：`libfftw3-3.dll`（倍精度）と `libfftw3f-3.dll`（単精度）を `FFTW.exe` と同じ場所に置く必要があります。MSYS2 の [*mingw-w64-fftw*](https://packages.msys2.org/base/mingw-w64-fftw) パッケージ由来の FFTW 3.3.11 ビルドのコピー（`libfftw3_threads-3.dll` / `libfftw3f_threads-3.dll` を含む）が `Win64\Debug|Release` に同梱済みです。

`FFTW.dproj` を開き、Win64 プラットフォームを選択して実行してください。ライブラリユニットはすべて `_LIBRARY\` から直接参照されるため、検索パスの設定は不要です。

## 6. 参考文献

1. M. Frigo and S. G. Johnson, "[The Design and Implementation of FFTW3](https://www.fftw.org/)", *Proceedings of the IEEE*, vol. 93, no. 2, pp. 216–231, 2005.
2. Wikipedia: [*Discrete Fourier transform*](https://en.wikipedia.org/wiki/Discrete_Fourier_transform).
3. J. W. Cooley and J. W. Tukey, "An Algorithm for the Machine Calculation of Complex Fourier Series", *Mathematics of Computation*, vol. 19, pp. 297–301, 1965.
4. Wikipedia: [*Fast Fourier transform*](https://en.wikipedia.org/wiki/Fast_Fourier_transform).

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
