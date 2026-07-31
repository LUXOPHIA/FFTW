# LUX.Signal.FFTW

[English](README.md) | [日本語](ja/README.md)

A Delphi (Object Pascal) binding and object-oriented wrapper for **FFTW 3**, the *Fastest Fourier Transform in the West* [1][2]. `fftw3.pas` translates the complete FFTW C API for both the double-precision (`libfftw3-3.dll`) and single-precision (`libfftw3f-3.dll`) libraries, while the `LUX.Signal.FFTW.*` units wrap FFTW *plans* in generic classes whose input and output buffers are LUX grid objects — resizing a grid automatically re-creates the plans.

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：The base library supplying the complex-number records (`LUX.Complex`) and the grid classes (`LUX.Data.Grid`, `LUX.Data.Grid.T1`–`T3`) used as the transform buffers.

## 1. Overview

| Unit | Contents |
|:---|:---|
| `fftw3.pas` | Raw translation of the FFTW 3 C API: 69 entry points per precision — basic, advanced (`plan_many`) and guru (`plan_guru`, `plan_guru64`, split-array) plan constructors for c2c / r2c / c2r / r2r transforms, execution, wisdom import/export, multi-threading, allocators (`fftw_alloc_real`, `fftw_alloc_complex`), and planner diagnostics (`fftw_print_plan`, `fftw_cost`, `fftw_flops`). Declared for both `fftw_*` (double) and `fftwf_*` (single) |
| `LUX.Signal.FFTW.pas` | `IDFT` interface and the generic base class `TDFT<_TItem_,_TTimes_,_TFreqs_>`, holding the two buffers, the two plans, and the `TransTF` / `TransFT` operations |
| `D1/LUX.Signal.FFTW.D1.pas` | `IDFT1D` / `TDFT1D<…>` — buffers are `TPoinArray1D<_TItem_>`; a change of `PoinsX` propagates to the partner grid and triggers `RecreaPlans` |
| `D1/LUX.Signal.FFTW.D1.Preset.pas` | Ready-made 1-D complex-to-complex transforms: `TSingleDFTcc1D` / `TDoubleDFTcc1D` (with `ISingleDFTcc1D` / `IDoubleDFTcc1D`) |
| `D2/…`, `D3/…` | The same two-layer construction for rank 2 (`TPoinArray2D`, `fftw_plan_dft_2d`) and rank 3 (`TPoinArray3D`, `fftw_plan_dft_3d`) |
| `_DLL/`, `：FFTW/` | Prebuilt Windows DLLs, and the vendored upstream FFTW 3.3.5 Windows distribution |

Naming convention of the presets: `T` + precision (`Single` / `Double`) + `DFT` + transform kind (`cc` = complex-to-complex) + rank (`1D` / `2D` / `3D`).

## 2. Mathematical Background

### 2.1. The discrete Fourier transform

For a complex sequence $x_0,\dots,x_{N-1}$ the discrete Fourier transform (DFT) and its inverse are [5]

```math
X_k = \sum_{n=0}^{N-1} x_n\, e^{-2\pi i k n / N}, \qquad k = 0,\dots,N-1
\qquad \text{(2.1)}
```

```math
x_n = \frac{1}{N} \sum_{k=0}^{N-1} X_k\, e^{+2\pi i k n / N}, \qquad n = 0,\dots,N-1
\qquad \text{(2.2)}
```

Evaluated literally, (2.1) costs $O(N^2)$ complex operations. Fast Fourier transform algorithms of the Cooley–Tukey family [4] factor $N$ and reduce the cost to $O(N \log N)$; FFTW composes such codelets into a *plan* and chooses among the possible factorizations at plan-creation time [1].

### 2.2. FFTW's unnormalized convention

The constants `FFTW_FORWARD` $= -1$ and `FFTW_BACKWARD` $= +1$ declared in `fftw3.pas` are exactly the sign of the exponent. A forward plan computes (2.1) as written, and a backward plan computes the sum of (2.2) **without** the $1/N$ factor, so the two are inverse only up to a scale factor:

```math
\mathcal{F}^{-1}_{\text{FFTW}}\!\left(\mathcal{F}_{\text{FFTW}}(x)\right) = N\,x
\qquad \text{(2.3)}
```

Normalization is therefore the caller's responsibility; this library applies no scaling of its own.

### 2.3. Multidimensional transforms

For a rank-$d$ array of extents $N_1 \times \dots \times N_d$ the transform is the separable product

```math
X_{k_1 \dots k_d} = \sum_{n_1=0}^{N_1-1} \cdots \sum_{n_d=0}^{N_d-1}
x_{n_1 \dots n_d}\, \exp\!\left(-2\pi i \sum_{j=1}^{d} \frac{k_j n_j}{N_j}\right)
\qquad \text{(2.4)}
```

and the round-trip factor in (2.3) becomes $N = \prod_{j=1}^{d} N_j$. Separability is what lets FFTW evaluate (2.4) as successive rank-1 transforms along each axis; `fftw_plan_dft_2d` and `fftw_plan_dft_3d`, used by the `D2` and `D3` presets, take the extents in row-major order, the last index varying fastest.

### 2.4. Planner flags

Plan construction is a search over algorithms, controlled by the flags declared in `fftw3.pas`. The presets use `FFTW_ESTIMATE`, which selects a plan from a cost model instead of timing trial transforms, so planning is cheap and does not overwrite the buffers. The double-precision presets additionally pass `FFTW_PRESERVE_INPUT`, which forbids algorithms that would destroy the input array.

## 3. Architecture

```
DLL binding

・fftw3.pas                             ･･･ cdecl imports, 69 per precision
  ┣・libfftw3-3.dll                    ･･･ double, fftw_*
  ┗・libfftw3f-3.dll                   ･･･ single, fftwf_*

Class hierarchy — descendants listed under their ancestor

・TDFT<_TItem_,_TTimes_,_TFreqs_>       ･･･ …FFTW.pas — IDFT, TransTF/TransFT
  ┣・TDFT<_TItem_,_TGrid_>             ･･･ Times and Freqs share one grid type
  ┣・TDFT1D<_TItem_,_TTimes_,_TFreqs_> ･･･ …FFTW.D1.pas — implements IDFT1D
  ┃  ┗・TDFT1D<_TItem_,_TGrid_>
  ┃     ┣・TSingleDFTcc1D<_TGrid_>    ･･･ …FFTW.D1.Preset.pas
  ┃     ┃  ┗・TSingleDFTcc1D         ･･･ implements ISingleDFTcc1D
  ┃     ┗・TDoubleDFTcc1D<_TGrid_>
  ┃        ┗・TDoubleDFTcc1D          ･･･ implements IDoubleDFTcc1D
  ┣・TDFT2D<…>                        ･･･ …FFTW.D2.pas — implements IDFT2D
  ┃  ┗・TDFT2D<_TItem_,_TGrid_>
  ┃     ┣・TSingleDFTcc2D<_TGrid_>
  ┃     ┃  ┗・TSingleDFTcc2D         ･･･ implements ISingleDFTcc2D
  ┃     ┗・TDoubleDFTcc2D<_TGrid_>
  ┃        ┗・TDoubleDFTcc2D          ･･･ implements IDoubleDFTcc2D
  ┗・TDFT3D<…>                        ･･･ …FFTW.D3.pas — implements IDFT3D
     ┗・TDFT3D<_TItem_,_TGrid_>
        ┣・TSingleDFTcc3D<_TGrid_>
        ┃  ┗・TSingleDFTcc3D          ･･･ implements ISingleDFTcc3D
        ┗・TDoubleDFTcc3D<_TGrid_>
           ┗・TDoubleDFTcc3D           ･･･ implements IDoubleDFTcc3D
```

Lifecycle of a transform object:

```
・Create
  ┗・_TTimes_.Create / _TFreqs_.Create
     ┗・CreatePlans
        ┗・fftw(f)_plan_dft_{1,2,3}d( extents, buffers, direction, flags )

・grid resize (Poins* setter)
  ┗・_OnChange
     ┗・SetTimesN / SetFreqsN
        ┣・partner grid follows the new extent
        ┗・RecreaPlans = DestroPlans + CreatePlans

・TransTF / TransFT
  ┗・fftw_execute_dft( plan, _Times.Elem0P, _Freqs.Elem0P )

・Destroy
  ┗・DestroPlans
     ┗・_Times.DisposeOf / _Freqs.DisposeOf
```

Buffers are LUX grid objects (`TCoreArray<_TItem_>` descendants), so `Elem0P` hands FFTW a pointer to contiguous storage of `TSingleC` / `TDoubleC` records — memory-compatible with the C types `fftwf_complex` / `fftw_complex` — while `PoinsX` / `PoinsY` / `PoinsZ` supply the extents. Because a grid raises `_OnChange` whenever its size changes, plan validity is maintained automatically and the two grids are always kept at equal extents.

File layout:

```
・LUX.Signal.FFTW/
  ┣・fftw3.pas                         ･･･ raw FFTW 3 port, both precisions
  ┣・LUX.Signal.FFTW.pas               ･･･ IDFT, generic TDFT base classes
  ┣・D1/
  ┃  ┣・LUX.Signal.FFTW.D1.pas        ･･･ IDFT1D / TDFT1D (auto re-plan)
  ┃  ┗・LUX.Signal.FFTW.D1.Preset.pas ･･･ TSingleDFTcc1D / TDoubleDFTcc1D
  ┣・D2/                               ･･･ same construction for rank 2
  ┣・D3/                               ･･･ same construction for rank 3
  ┣・_DLL/
  ┃  ┣・Win32/{Debug,Release}/        ･･･ libfftw3-3.dll, libfftw3f-3.dll
  ┃  ┗・Win64/{Debug,Release}/        ･･･ libfftw3-3.dll, libfftw3f-3.dll
  ┗・：FFTW/                           ･･･ FFTW 3.3.5 Windows distribution
     ┣・fftw-3.3.5-dll32/              ･･･ DLLs, .def, fftw3.h, tools
     ┗・fftw-3.3.5-dll64/              ･･･ the same, x64
```

## 4. Usage

```pascal
uses LUX.Complex,
     LUX.Data.Grid.T1,
     LUX.Signal.FFTW,
     LUX.Signal.FFTW.D1.Preset;

const
     _N_ = 512;
var
   F :IDoubleDFTcc1D;
   I :Integer;
begin
     F := TDoubleDFTcc1D.Create;      // interface reference: released automatically

     F.Times.PoinsX := _N_;           // resize ⇒ Freqs follows ⇒ both plans re-created

     for I := 0 to _N_-1 do           // a real cosine of 8 cycles per window
     begin
          F.Times[ I ] := TDoubleC.Create( Cos( 2*Pi * 8 * I / _N_ ), 0 );
     end;

     F.TransTF;                       // forward transform: Times ──► Freqs

     for I := 0 to _N_-1 do
     begin
          WriteLn( I:4, F.Freqs[ I ].Size / _N_ :12:6 );   // |X[k]| / N
     end;
end;
```

`Times` and `Freqs` *are* the grid objects, so samples are read and written through their default array property and no copy between Delphi arrays and FFTW buffers is ever needed. The division by $N$ in the last loop is the normalization of (2.3), which FFTW leaves to the application.

## 5. Requirements

* **Delphi / RAD Studio** — any version with generics and record helpers. `fftw3.pas` imports Windows DLLs by name, so Win32 and Win64 are the supported targets.
* **[LUX](https://github.com/LUXOPHIA/LUX)** base library — `LUX`, `LUX.Complex` (`TSingleC` / `TDoubleC`), `LUX.Data.Grid` (`TCoreArray<>`), and `LUX.Data.Grid.T1` … `T3` (`TPoinArray1D<>` … `TPoinArray3D<>`). In the current LUX tree these complex and grid units reside under the `--------/2022/` archive directory, which must therefore be on the compiler search path.
* **Runtime DLLs** — `libfftw3-3.dll` (double precision) and `libfftw3f-3.dll` (single precision) must be reachable from the executable, normally by copying them next to it. Both are bundled in `_DLL\Win32\{Debug,Release}` and `_DLL\Win64\{Debug,Release}`; the complete upstream Windows distribution — including `libfftw3l-3.dll` (long double), the module-definition files, and the `fftw-wisdom` utilities — is vendored under `：FFTW\fftw-3.3.5-dll32` and `：FFTW\fftw-3.3.5-dll64`. Official Windows builds are published on the FFTW site [3].
* **Git LFS** — `.gitattributes` declares `*.dll filter=lfs`, so a checkout without Git LFS yields pointer files instead of the DLLs.
* **License of FFTW itself** — the bundled `COPYRIGHT` and `COPYING` files place FFTW under the GNU General Public License, version 2 or later; a separate commercial license is available from MIT [2].

## 6. Limitations

Grounded in the current sources, and worth knowing before extending the wrapper:

* **Execution and plan destruction are hard-wired to one precision.** `TDFT.TransTF` and `TDFT.TransFT` call `fftw_execute_dft`, while `TDFT.DestroPlans` calls `fftwf_destroy_plan` — the double- and single-precision entry points respectively, regardless of the actual precision of the descendant. The `TDouble…` presets are thus the exercised path; the `TSingle…` presets, whose plans come from `fftwf_plan_dft_*`, would need precision-aware overrides.
* **`TransFT` is not an in-place inverse.** Both plans are created over the same buffer pair (`_Times.Elem0P` as input, `_Freqs.Elem0P` as output) and `TransFT` executes with that same pair, so it computes the $+i$-signed transform of `Times` into `Freqs` rather than reconstructing `Times` from `Freqs`. Inversion therefore requires moving the spectrum into `Times` first.
* **Only complex-to-complex presets exist.** The r2c, c2r and r2r plan families are fully declared in `fftw3.pas`, but no `TDFT` descendant wraps them; the same applies to wisdom and to multi-threading.
* In the rank-2 and rank-3 `CreatePlans`, the first extent of the backward plan is taken from `_Freqs` while the remaining extents come from `_Times`. This is harmless as long as the change handlers keep both grids at equal extents, which they do.

## 7. References

1. Frigo, M. and Johnson, S. G., [*The Design and Implementation of FFTW3*](https://doi.org/10.1109/JPROC.2004.840301), Proceedings of the IEEE, 93(2), pp. 216–231, 2005.
2. [*FFTW Home Page*](https://www.fftw.org/), Massachusetts Institute of Technology.
3. [*Installation on Windows*](https://www.fftw.org/install/windows.html), FFTW documentation.
4. Cooley, J. W. and Tukey, J. W., [*An Algorithm for the Machine Calculation of Complex Fourier Series*](https://doi.org/10.1090/S0025-5718-1965-0178586-1), Mathematics of Computation, 19(90), pp. 297–301, 1965.
5. [*Discrete Fourier transform*](https://en.wikipedia.org/wiki/Discrete_Fourier_transform), Wikipedia.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
