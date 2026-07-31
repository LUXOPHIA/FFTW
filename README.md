# FFTW

[English](README.md) | [日本語](ja/README.md)

A minimal Delphi/FireMonkey demonstration of how to use the fast Fourier transform library [FFTW](https://www.fftw.org/) [1] from Delphi. A complex-valued random-walk signal is regenerated every 10 ms, transformed by a double-precision complex-to-complex FFT, and both the time-domain waveform and its raw spectrum are plotted in real time.

![](--------/_SCREENSHOT/FFTW.png)

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：Foundational mathematics library for the LUXOPHIA projects.
* [**LUX.Chart**](https://github.com/LUXOPHIA/LUX.Chart) ：Chart-plotting library providing the `TChartViewer` frame.
* [**LUX.Signal.FFTW**](https://github.com/LUXOPHIA/LUX.Signal.FFTW) ：Delphi binding and object-oriented wrapper for the FFTW 3 library.

## 1. Overview

* **Raw FFTW 3 binding** — `fftw3.pas` translates the FFTW C API to Delphi: plan creation (basic / advanced / guru interfaces), complex-to-complex, real-to-complex/complex-to-real and real-to-real plans, wisdom import/export, threading, and `fftw_malloc`-family allocators, for both the double-precision (`libfftw3-3.dll`) and single-precision (`libfftw3f-3.dll`) libraries.
* **Object-oriented wrapper** — `LUX.Signal.FFTW` wraps plans in generic classes (`TDFT<...>`, `TDFT1D<...>`) whose input/output buffers are grid objects; resizing a grid automatically re-creates the plans.
* **Ready-made presets** — `TSingleDFTcc1D` / `TDoubleDFTcc1D` provide 1-D complex-to-complex transforms out of the box (2-D and 3-D preset units are also included in the library).
* **Live demo app** — a FireMonkey form animates a Metropolis-type complex random walk, executes the forward transform each timer tick, and displays both domains with `TChartViewer`; the transform length is adjustable at run time.

## 2. Mathematical Background

The discrete Fourier transform (DFT) of a length-$N$ complex sequence $x_0,\dots,x_{N-1}$ is [2]

```math
X_k = \sum_{n=0}^{N-1} x_n\, e^{-2\pi i k n / N}, \qquad k = 0,\dots,N-1 \tag{1}
```

and its inverse is

```math
x_n = \frac{1}{N} \sum_{k=0}^{N-1} X_k\, e^{+2\pi i k n / N}. \tag{2}
```

Evaluating (1) directly costs $O(N^2)$ operations; FFT algorithms such as Cooley–Tukey [3] reduce this to $O(N \log N)$, and FFTW selects among many such algorithms at plan-creation time [1].

**FFTW's normalization convention.** `FFTW_FORWARD` computes exactly the unnormalized sum (1), and `FFTW_BACKWARD` computes the sum in (2) *without* the $1/N$ factor. Applying forward then backward therefore scales the data by $N$; normalization is left to the caller. This demo executes only the forward transform (`TransTF`) and plots the unnormalized spectrum $X_k$ as-is.

**The demo signal.** `TDoubleRandWalkC` (from the LUX library) maintains $N$ complex samples and advances every sample by one Metropolis random-walk step per timer tick, producing a continuously evolving complex signal $x_n$. No window function is applied — the samples enter the transform with an implicit rectangular window — and since the input is complex, both the real part (blue) and the imaginary part (red) are drawn in each chart.

## 3. Architecture

Class hierarchy and data flow of the wrapper:

```
・TForm1 (Main.pas)
  ┣・_Wave :IDoubleRandWalkC               ･･･ Metropolis complex random walk
  ┣・_FFT :IDoubleDFTcc1D                  ･･･ 1-D c2c double-precision DFT
  ┗・ChartViewerT / ChartViewerF           ･･･ time/frequency plots [LUX.Chart]

Data flow (one timer tick)

・_Wave
  ┗・_FFT.Times                            ･･･ (x[n])
     ┣・ChartViewerT                       ･･･ time-domain plot
     ┗・TransTF                            ･･･ fftw_execute_dft via _PlanTF
        ┗・_FFT.Freqs                      ･･･ (X[k])
           ┗・ChartViewerF                 ･･･ frequency-domain plot

Class hierarchy

・IDFT
  ┗・TDFT<_TItem_,_TTimes_,_TFreqs_>       ･･･ LUX.Signal.FFTW.pas
     ┣・_Times / _Freqs                    ･･･ grid buffers
     ┣・_PlanTF / _PlanFT                  ･･･ plans, run by TransTF/TransFT
     ┗・TDFT1D<...>                        ･･･ LUX.Signal.FFTW.D1.pas
        ┣・grid resize
        ┃  ┗・RecreaPlans                 ･･･ destroy + re-create plans
        ┗・TSingleDFTcc1D / TDoubleDFTcc1D ･･･ LUX.Signal.FFTW.D1.Preset.pas

Binding layers (call chain)

・TSingleDFTcc1D / TDoubleDFTcc1D
  ┗・fftw(f)_plan_dft_1d( N, in, out, direction, flags )
     ┗・fftw3.pas
        ┗・cdecl imports
           ┗・libfftw3-3.dll / libfftw3f-3.dll
```

File layout:

```
・FFTW/
  ┣・FFTW.dpr / FFTW.dproj     ･･･ FireMonkey demo project
  ┣・Main.pas / Main.fmx       ･･･ main form: charts, 10 ms timer, N scrollbar
  ┣・Win64/                    ･･･ build output with FFTW DLLs (Debug/Release)
  ┣・--------/_SCREENSHOT/     ･･･ screenshot
  ┗・_LIBRARY/LUXOPHIA/        ･･･ git-subtree copies of library repositories
     ┣・LUX/                   ･･･ core math & utilities (complex numbers etc.)
     ┣・LUX.Chart/             ･･･ TChartViewer plotting frame
     ┗・LUX.Signal.FFTW/       ･･･ FFTW binding and wrapper classes
        ┣・fftw3.pas           ･･･ raw FFTW 3 API translation
        ┣・LUX.Signal.FFTW.pas ･･･ generic TDFT base classes
        ┗・D1/ D2/ D3/         ･･･ 1-D/2-D/3-D wrappers and presets
```

Library repositories: [LUX](https://github.com/LUXOPHIA/LUX), [LUX.Chart](https://github.com/LUXOPHIA/LUX.Chart), [LUX.Signal.FFTW](https://github.com/LUXOPHIA/LUX.Signal.FFTW).

## 4. Usage / Controls

The animation starts automatically; a timer advances the random walk and re-runs the FFT every 10 ms.

| Control | Function |
|---|---|
| Upper chart | Time domain $x_n$ — real part (blue), imaginary part (red) |
| Lower chart | Frequency domain $X_k$ (unnormalized) — real part (blue), imaginary part (red) |
| Vertical scrollbar (right) | Transform length $N$: 2 – 2048, default 512 |
| Label (top right) | Current value of $N$ |

Changing $N$ resizes the `Times`/`Freqs` grids, which automatically re-creates the FFTW plans.

## 5. Building

* **IDE**: RAD Studio / Delphi (project format 19.5 = RAD Studio 11 Alexandria; later versions can upgrade the project).
* **Framework**: FireMonkey (FMX).
* **Platforms**: Win64 is the working target — `fftw3.pas` links against the Windows FFTW DLLs.
* **Required DLLs**: `libfftw3-3.dll` (double precision) and `libfftw3f-3.dll` (single precision) must reside next to `FFTW.exe`. Copies of the FFTW 3.3.11 build from the MSYS2 [*mingw-w64-fftw*](https://packages.msys2.org/base/mingw-w64-fftw) package — including the `libfftw3_threads-3.dll` / `libfftw3f_threads-3.dll` companions — are already bundled in `Win64\Debug|Release`.

Open `FFTW.dproj`, select the Win64 platform, and run. All library units are referenced directly from `_LIBRARY\` — no search-path setup is needed.

## 6. References

1. M. Frigo and S. G. Johnson, "[The Design and Implementation of FFTW3](https://www.fftw.org/)", *Proceedings of the IEEE*, vol. 93, no. 2, pp. 216–231, 2005.
2. Wikipedia: [*Discrete Fourier transform*](https://en.wikipedia.org/wiki/Discrete_Fourier_transform).
3. J. W. Cooley and J. W. Tukey, "An Algorithm for the Machine Calculation of Complex Fourier Series", *Mathematics of Computation*, vol. 19, pp. 297–301, 1965.
4. Wikipedia: [*Fast Fourier transform*](https://en.wikipedia.org/wiki/Fast_Fourier_transform).

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
