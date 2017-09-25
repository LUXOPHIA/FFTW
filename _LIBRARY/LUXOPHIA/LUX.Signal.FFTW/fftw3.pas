unit fftw3;

interface //#################################################################### ■

  type TC_FFTW_R2R_KIND = TC_INT32_T;

  const FFTW_R2HC                   :TC_INT = 0;
  const FFTW_HC2R                   :TC_INT = 1;
  const FFTW_DHT                    :TC_INT = 2;
  const FFTW_REDFT00                :TC_INT = 3;
  const FFTW_REDFT01                :TC_INT = 4;
  const FFTW_REDFT10                :TC_INT = 5;
  const FFTW_REDFT11                :TC_INT = 6;
  const FFTW_RODFT00                :TC_INT = 7;
  const FFTW_RODFT01                :TC_INT = 8;
  const FFTW_RODFT10                :TC_INT = 9;
  const FFTW_RODFT11                :TC_INT = 10;
  const FFTW_FORWARD                :TC_INT = -1;
  const FFTW_BACKWARD               :TC_INT = +1;
  const FFTW_MEASURE                :TC_INT = 0;
  const FFTW_DESTROY_INPUT          :TC_INT = 1;
  const FFTW_UNALIGNED              :TC_INT = 2;
  const FFTW_CONSERVE_MEMORY        :TC_INT = 4;
  const FFTW_EXHAUSTIVE             :TC_INT = 8;
  const FFTW_PRESERVE_INPUT         :TC_INT = 16;
  const FFTW_PATIENT                :TC_INT = 32;
  const FFTW_ESTIMATE               :TC_INT = 64;
  const FFTW_WISDOM_ONLY            :TC_INT = 2097152;
  const FFTW_ESTIMATE_PATIENT       :TC_INT = 128;
  const FFTW_BELIEVE_PCOST          :TC_INT = 256;
  const FFTW_NO_DFT_R2HC            :TC_INT = 512;
  const FFTW_NO_NONTHREADED         :TC_INT = 1024;
  const FFTW_NO_BUFFERING           :TC_INT = 2048;
  const FFTW_NO_INDIRECT_OP         :TC_INT = 4096;
  const FFTW_ALLOW_LARGE_GENERIC    :TC_INT = 8192;
  const FFTW_NO_RANK_SPLITS         :TC_INT = 16384;
  const FFTW_NO_VRANK_SPLITS        :TC_INT = 32768;
  const FFTW_NO_VRECURSE            :TC_INT = 65536;
  const FFTW_NO_SIMD                :TC_INT = 131072;
  const FFTW_NO_SLOW                :TC_INT = 262144;
  const FFTW_NO_FIXED_RADIX_LARGE_N :TC_INT = 524288;
  const FFTW_ALLOW_PRUNING          :TC_INT = 1048576;

  type Tfftw_iodim = record
         _n  :TC_INT;
         _is :TC_INT;
         _os :TC_INT;
       end;
  type Tfftw_iodim64 = record
         _n  :TC_INTPTR_T;
         _is :TC_INTPTR_T;
         _os :TC_INTPTR_T;
       end;

    function fftw_plan_dft(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_dft_1d(
      import
      integer(C_INT), value :: n
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_dft_2d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_dft_3d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      integer(C_INT), value :: n2
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_many_dft(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      integer(C_INT), value :: howmany
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      integer(C_INT), dimension(*), intent(in) :: inembed
      integer(C_INT), value :: istride
      integer(C_INT), value :: idist
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), dimension(*), intent(in) :: onembed
      integer(C_INT), value :: ostride
      integer(C_INT), value :: odist
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru_dft(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim), dimension(*), intent(in) :: howmany_dims
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru_split_dft(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim), dimension(*), intent(in) :: howmany_dims
      real(C_DOUBLE), dimension(*), intent(out) :: ri
      real(C_DOUBLE), dimension(*), intent(out) :: ii
      real(C_DOUBLE), dimension(*), intent(out) :: ro
      real(C_DOUBLE), dimension(*), intent(out) :: io
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru64_dft(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim64), dimension(*), intent(in) :: howmany_dims
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru64_split_dft(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim64), dimension(*), intent(in) :: howmany_dims
      real(C_DOUBLE), dimension(*), intent(out) :: ri
      real(C_DOUBLE), dimension(*), intent(out) :: ii
      real(C_DOUBLE), dimension(*), intent(out) :: ro
      real(C_DOUBLE), dimension(*), intent(out) :: io
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    procedure fftw_execute_dft(
      import
      type(C_PTR), value :: p
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(inout) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
    ); cdecl; external _DLLNAME_;
    
    procedure fftw_execute_split_dft(
      import
      type(C_PTR), value :: p
      real(C_DOUBLE), dimension(*), intent(inout) :: ri
      real(C_DOUBLE), dimension(*), intent(inout) :: ii
      real(C_DOUBLE), dimension(*), intent(out) :: ro
      real(C_DOUBLE), dimension(*), intent(out) :: io
    ); cdecl; external _DLLNAME_;
    
    function fftw_plan_many_dft_r2c(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      integer(C_INT), value :: howmany
      real(C_DOUBLE), dimension(*), intent(out) :: in
      integer(C_INT), dimension(*), intent(in) :: inembed
      integer(C_INT), value :: istride
      integer(C_INT), value :: idist
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), dimension(*), intent(in) :: onembed
      integer(C_INT), value :: ostride
      integer(C_INT), value :: odist
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_dft_r2c(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      real(C_DOUBLE), dimension(*), intent(out) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_dft_r2c_1d(
      import
      integer(C_INT), value :: n
      real(C_DOUBLE), dimension(*), intent(out) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_dft_r2c_2d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      real(C_DOUBLE), dimension(*), intent(out) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_dft_r2c_3d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      integer(C_INT), value :: n2
      real(C_DOUBLE), dimension(*), intent(out) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_many_dft_c2r(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      integer(C_INT), value :: howmany
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      integer(C_INT), dimension(*), intent(in) :: inembed
      integer(C_INT), value :: istride
      integer(C_INT), value :: idist
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_INT), dimension(*), intent(in) :: onembed
      integer(C_INT), value :: ostride
      integer(C_INT), value :: odist
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_dft_c2r(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_dft_c2r_1d(
      import
      integer(C_INT), value :: n
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_dft_c2r_2d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_dft_c2r_3d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      integer(C_INT), value :: n2
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru_dft_r2c(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim), dimension(*), intent(in) :: howmany_dims
      real(C_DOUBLE), dimension(*), intent(out) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru_dft_c2r(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim), dimension(*), intent(in) :: howmany_dims
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru_split_dft_r2c(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim), dimension(*), intent(in) :: howmany_dims
      real(C_DOUBLE), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: ro
      real(C_DOUBLE), dimension(*), intent(out) :: io
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru_split_dft_c2r(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim), dimension(*), intent(in) :: howmany_dims
      real(C_DOUBLE), dimension(*), intent(out) :: ri
      real(C_DOUBLE), dimension(*), intent(out) :: ii
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru64_dft_r2c(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim64), dimension(*), intent(in) :: howmany_dims
      real(C_DOUBLE), dimension(*), intent(out) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru64_dft_c2r(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim64), dimension(*), intent(in) :: howmany_dims
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru64_split_dft_r2c(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim64), dimension(*), intent(in) :: howmany_dims
      real(C_DOUBLE), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: ro
      real(C_DOUBLE), dimension(*), intent(out) :: io
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru64_split_dft_c2r(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim64), dimension(*), intent(in) :: howmany_dims
      real(C_DOUBLE), dimension(*), intent(out) :: ri
      real(C_DOUBLE), dimension(*), intent(out) :: ii
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    procedure fftw_execute_dft_r2c(
      import
      type(C_PTR), value :: p
      real(C_DOUBLE), dimension(*), intent(inout) :: in
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(out) :: out
    ); cdecl; external _DLLNAME_;
    
    procedure fftw_execute_dft_c2r(
      import
      type(C_PTR), value :: p
      complex(C_DOUBLE_COMPLEX), dimension(*), intent(inout) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
    ); cdecl; external _DLLNAME_;
    
    procedure fftw_execute_split_dft_r2c(
      import
      type(C_PTR), value :: p
      real(C_DOUBLE), dimension(*), intent(inout) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: ro
      real(C_DOUBLE), dimension(*), intent(out) :: io
    ); cdecl; external _DLLNAME_;
    
    procedure fftw_execute_split_dft_c2r(
      import
      type(C_PTR), value :: p
      real(C_DOUBLE), dimension(*), intent(inout) :: ri
      real(C_DOUBLE), dimension(*), intent(inout) :: ii
      real(C_DOUBLE), dimension(*), intent(out) :: out
    ); cdecl; external _DLLNAME_;
    
    function fftw_plan_many_r2r(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      integer(C_INT), value :: howmany
      real(C_DOUBLE), dimension(*), intent(out) :: in
      integer(C_INT), dimension(*), intent(in) :: inembed
      integer(C_INT), value :: istride
      integer(C_INT), value :: idist
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_INT), dimension(*), intent(in) :: onembed
      integer(C_INT), value :: ostride
      integer(C_INT), value :: odist
      integer(C_FFTW_R2R_KIND), dimension(*), intent(in) :: kind
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_r2r(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      real(C_DOUBLE), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_FFTW_R2R_KIND), dimension(*), intent(in) :: kind
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_r2r_1d(
      import
      integer(C_INT), value :: n
      real(C_DOUBLE), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_FFTW_R2R_KIND), value :: kind
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_r2r_2d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      real(C_DOUBLE), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_FFTW_R2R_KIND), value :: kind0
      integer(C_FFTW_R2R_KIND), value :: kind1
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_r2r_3d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      integer(C_INT), value :: n2
      real(C_DOUBLE), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_FFTW_R2R_KIND), value :: kind0
      integer(C_FFTW_R2R_KIND), value :: kind1
      integer(C_FFTW_R2R_KIND), value :: kind2
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru_r2r(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim), dimension(*), intent(in) :: howmany_dims
      real(C_DOUBLE), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_FFTW_R2R_KIND), dimension(*), intent(in) :: kind
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_plan_guru64_r2r(
      import
      integer(C_INT), value :: rank
      type(fftw_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftw_iodim64), dimension(*), intent(in) :: howmany_dims
      real(C_DOUBLE), dimension(*), intent(out) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
      integer(C_FFTW_R2R_KIND), dimension(*), intent(in) :: kind
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    procedure fftw_execute_r2r(
      import
      type(C_PTR), value :: p
      real(C_DOUBLE), dimension(*), intent(inout) :: in
      real(C_DOUBLE), dimension(*), intent(out) :: out
    ); cdecl; external _DLLNAME_;
    
    procedure fftw_destroy_plan(
      import
      type(C_PTR), value :: p
    ); cdecl; external _DLLNAME_;
    
    procedure fftw_forget_wisdom(
      import
    ); cdecl; external _DLLNAME_;
    
    procedure fftw_cleanup(
      import
    ); cdecl; external _DLLNAME_;
    
    procedure fftw_set_timelimit(
      import
      real(C_DOUBLE), value :: t
    ); cdecl; external _DLLNAME_;
    
    procedure fftw_plan_with_nthreads(
      import
      integer(C_INT), value :: nthreads
    ); cdecl; external _DLLNAME_;
    
    integer(C_INT) function fftw_init_threads() bind(C, name='fftw_init_threads')
      import
    end function fftw_init_threads
    
    procedure fftw_cleanup_threads(
      import
    ); cdecl; external _DLLNAME_;
    
    procedure fftw_make_planner_thread_safe(
      import
    ); cdecl; external _DLLNAME_;
    
    integer(C_INT) function fftw_export_wisdom_to_filename(filename) bind(C, name='fftw_export_wisdom_to_filename')
      import
      character(C_CHAR), dimension(*), intent(in) :: filename
    end function fftw_export_wisdom_to_filename
    
    procedure fftw_export_wisdom_to_file(
      import
      type(C_PTR), value :: output_file
    ); cdecl; external _DLLNAME_;
    
    type(C_PTR) function fftw_export_wisdom_to_string() bind(C, name='fftw_export_wisdom_to_string')
      import
    end function fftw_export_wisdom_to_string
    
    procedure fftw_export_wisdom(
      import
      type(C_FUNPTR), value :: write_char
      type(C_PTR), value :: data
    ); cdecl; external _DLLNAME_;
    
    integer(C_INT) function fftw_import_system_wisdom() bind(C, name='fftw_import_system_wisdom')
      import
    end function fftw_import_system_wisdom
    
    integer(C_INT) function fftw_import_wisdom_from_filename(filename) bind(C, name='fftw_import_wisdom_from_filename')
      import
      character(C_CHAR), dimension(*), intent(in) :: filename
    end function fftw_import_wisdom_from_filename
    
    integer(C_INT) function fftw_import_wisdom_from_file(input_file) bind(C, name='fftw_import_wisdom_from_file')
      import
      type(C_PTR), value :: input_file
    end function fftw_import_wisdom_from_file
    
    integer(C_INT) function fftw_import_wisdom_from_string(input_string) bind(C, name='fftw_import_wisdom_from_string')
      import
      character(C_CHAR), dimension(*), intent(in) :: input_string
    end function fftw_import_wisdom_from_string
    
    integer(C_INT) function fftw_import_wisdom(read_char,data) bind(C, name='fftw_import_wisdom')
      import
      type(C_FUNPTR), value :: read_char
      type(C_PTR), value :: data
    end function fftw_import_wisdom
    
    procedure fftw_fprint_plan(
      import
      type(C_PTR), value :: p
      type(C_PTR), value :: output_file
    ); cdecl; external _DLLNAME_;
    
    procedure fftw_print_plan(
      import
      type(C_PTR), value :: p
    ); cdecl; external _DLLNAME_;
    
    function fftw_sprint_plan(
      import
      type(C_PTR), value :: p
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_malloc(
      import
      integer(C_SIZE_T), value :: n
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_alloc_real(
      import
      integer(C_SIZE_T), value :: n
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftw_alloc_complex(
      import
      integer(C_SIZE_T), value :: n
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    procedure fftw_free(
      import
      type(C_PTR), value :: p
    ); cdecl; external _DLLNAME_;
    
    procedure fftw_flops(
      import
      type(C_PTR), value :: p
      real(C_DOUBLE), intent(out) :: add
      real(C_DOUBLE), intent(out) :: mul
      real(C_DOUBLE), intent(out) :: fmas
    ); cdecl; external _DLLNAME_;
    
    real(C_DOUBLE) function fftw_estimate_cost(p) bind(C, name='fftw_estimate_cost')
      import
      type(C_PTR), value :: p
    end function fftw_estimate_cost
    
    real(C_DOUBLE) function fftw_cost(p) bind(C, name='fftw_cost')
      import
      type(C_PTR), value :: p
    end function fftw_cost
    
    integer(C_INT) function fftw_alignment_of(p) bind(C, name='fftw_alignment_of')
      import
      real(C_DOUBLE), dimension(*), intent(out) :: p
    end function fftw_alignment_of

  type Tfftwf_iodim = record
         _n  :TC_INT;
         _is :TC_INT;
         _os :TC_INT;
       end;
  type Tfftwf_iodim64 = record
         _n  :TC_INTPTR_T;
         _is :TC_INTPTR_T;
         _os :TC_INTPTR_T;
       end;

    function fftwf_plan_dft(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_dft_1d(
      import
      integer(C_INT), value :: n
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_dft_2d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_dft_3d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      integer(C_INT), value :: n2
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_many_dft(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      integer(C_INT), value :: howmany
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      integer(C_INT), dimension(*), intent(in) :: inembed
      integer(C_INT), value :: istride
      integer(C_INT), value :: idist
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), dimension(*), intent(in) :: onembed
      integer(C_INT), value :: ostride
      integer(C_INT), value :: odist
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru_dft(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim), dimension(*), intent(in) :: howmany_dims
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru_split_dft(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim), dimension(*), intent(in) :: howmany_dims
      real(C_FLOAT), dimension(*), intent(out) :: ri
      real(C_FLOAT), dimension(*), intent(out) :: ii
      real(C_FLOAT), dimension(*), intent(out) :: ro
      real(C_FLOAT), dimension(*), intent(out) :: io
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru64_dft(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim64), dimension(*), intent(in) :: howmany_dims
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: sign
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru64_split_dft(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim64), dimension(*), intent(in) :: howmany_dims
      real(C_FLOAT), dimension(*), intent(out) :: ri
      real(C_FLOAT), dimension(*), intent(out) :: ii
      real(C_FLOAT), dimension(*), intent(out) :: ro
      real(C_FLOAT), dimension(*), intent(out) :: io
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    procedure fftwf_execute_dft(
      import
      type(C_PTR), value :: p
      complex(C_FLOAT_COMPLEX), dimension(*), intent(inout) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
    ); cdecl; external _DLLNAME_;
    
    procedure fftwf_execute_split_dft(
      import
      type(C_PTR), value :: p
      real(C_FLOAT), dimension(*), intent(inout) :: ri
      real(C_FLOAT), dimension(*), intent(inout) :: ii
      real(C_FLOAT), dimension(*), intent(out) :: ro
      real(C_FLOAT), dimension(*), intent(out) :: io
    ); cdecl; external _DLLNAME_;
    
    function fftwf_plan_many_dft_r2c(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      integer(C_INT), value :: howmany
      real(C_FLOAT), dimension(*), intent(out) :: in
      integer(C_INT), dimension(*), intent(in) :: inembed
      integer(C_INT), value :: istride
      integer(C_INT), value :: idist
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), dimension(*), intent(in) :: onembed
      integer(C_INT), value :: ostride
      integer(C_INT), value :: odist
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_dft_r2c(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      real(C_FLOAT), dimension(*), intent(out) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_dft_r2c_1d(
      import
      integer(C_INT), value :: n
      real(C_FLOAT), dimension(*), intent(out) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_dft_r2c_2d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      real(C_FLOAT), dimension(*), intent(out) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_dft_r2c_3d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      integer(C_INT), value :: n2
      real(C_FLOAT), dimension(*), intent(out) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_many_dft_c2r(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      integer(C_INT), value :: howmany
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      integer(C_INT), dimension(*), intent(in) :: inembed
      integer(C_INT), value :: istride
      integer(C_INT), value :: idist
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_INT), dimension(*), intent(in) :: onembed
      integer(C_INT), value :: ostride
      integer(C_INT), value :: odist
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_dft_c2r(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_dft_c2r_1d(
      import
      integer(C_INT), value :: n
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_dft_c2r_2d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_dft_c2r_3d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      integer(C_INT), value :: n2
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru_dft_r2c(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim), dimension(*), intent(in) :: howmany_dims
      real(C_FLOAT), dimension(*), intent(out) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru_dft_c2r(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim), dimension(*), intent(in) :: howmany_dims
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru_split_dft_r2c(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim), dimension(*), intent(in) :: howmany_dims
      real(C_FLOAT), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: ro
      real(C_FLOAT), dimension(*), intent(out) :: io
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru_split_dft_c2r(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim), dimension(*), intent(in) :: howmany_dims
      real(C_FLOAT), dimension(*), intent(out) :: ri
      real(C_FLOAT), dimension(*), intent(out) :: ii
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru64_dft_r2c(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim64), dimension(*), intent(in) :: howmany_dims
      real(C_FLOAT), dimension(*), intent(out) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru64_dft_c2r(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim64), dimension(*), intent(in) :: howmany_dims
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru64_split_dft_r2c(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim64), dimension(*), intent(in) :: howmany_dims
      real(C_FLOAT), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: ro
      real(C_FLOAT), dimension(*), intent(out) :: io
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru64_split_dft_c2r(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim64), dimension(*), intent(in) :: howmany_dims
      real(C_FLOAT), dimension(*), intent(out) :: ri
      real(C_FLOAT), dimension(*), intent(out) :: ii
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    procedure fftwf_execute_dft_r2c(
      import
      type(C_PTR), value :: p
      real(C_FLOAT), dimension(*), intent(inout) :: in
      complex(C_FLOAT_COMPLEX), dimension(*), intent(out) :: out
    ); cdecl; external _DLLNAME_;
    
    procedure fftwf_execute_dft_c2r(
      import
      type(C_PTR), value :: p
      complex(C_FLOAT_COMPLEX), dimension(*), intent(inout) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
    ); cdecl; external _DLLNAME_;
    
    procedure fftwf_execute_split_dft_r2c(
      import
      type(C_PTR), value :: p
      real(C_FLOAT), dimension(*), intent(inout) :: in
      real(C_FLOAT), dimension(*), intent(out) :: ro
      real(C_FLOAT), dimension(*), intent(out) :: io
    ); cdecl; external _DLLNAME_;
    
    procedure fftwf_execute_split_dft_c2r(
      import
      type(C_PTR), value :: p
      real(C_FLOAT), dimension(*), intent(inout) :: ri
      real(C_FLOAT), dimension(*), intent(inout) :: ii
      real(C_FLOAT), dimension(*), intent(out) :: out
    ); cdecl; external _DLLNAME_;
    
    function fftwf_plan_many_r2r(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      integer(C_INT), value :: howmany
      real(C_FLOAT), dimension(*), intent(out) :: in
      integer(C_INT), dimension(*), intent(in) :: inembed
      integer(C_INT), value :: istride
      integer(C_INT), value :: idist
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_INT), dimension(*), intent(in) :: onembed
      integer(C_INT), value :: ostride
      integer(C_INT), value :: odist
      integer(C_FFTW_R2R_KIND), dimension(*), intent(in) :: kind
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_r2r(
      import
      integer(C_INT), value :: rank
      integer(C_INT), dimension(*), intent(in) :: n
      real(C_FLOAT), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_FFTW_R2R_KIND), dimension(*), intent(in) :: kind
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_r2r_1d(
      import
      integer(C_INT), value :: n
      real(C_FLOAT), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_FFTW_R2R_KIND), value :: kind
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_r2r_2d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      real(C_FLOAT), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_FFTW_R2R_KIND), value :: kind0
      integer(C_FFTW_R2R_KIND), value :: kind1
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_r2r_3d(
      import
      integer(C_INT), value :: n0
      integer(C_INT), value :: n1
      integer(C_INT), value :: n2
      real(C_FLOAT), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_FFTW_R2R_KIND), value :: kind0
      integer(C_FFTW_R2R_KIND), value :: kind1
      integer(C_FFTW_R2R_KIND), value :: kind2
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru_r2r(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim), dimension(*), intent(in) :: howmany_dims
      real(C_FLOAT), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_FFTW_R2R_KIND), dimension(*), intent(in) :: kind
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_plan_guru64_r2r(
      import
      integer(C_INT), value :: rank
      type(fftwf_iodim64), dimension(*), intent(in) :: dims
      integer(C_INT), value :: howmany_rank
      type(fftwf_iodim64), dimension(*), intent(in) :: howmany_dims
      real(C_FLOAT), dimension(*), intent(out) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
      integer(C_FFTW_R2R_KIND), dimension(*), intent(in) :: kind
      integer(C_INT), value :: flags
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    procedure fftwf_execute_r2r(
      import
      type(C_PTR), value :: p
      real(C_FLOAT), dimension(*), intent(inout) :: in
      real(C_FLOAT), dimension(*), intent(out) :: out
    ); cdecl; external _DLLNAME_;
    
    procedure fftwf_destroy_plan(
      import
      type(C_PTR), value :: p
    ); cdecl; external _DLLNAME_;
    
    procedure fftwf_forget_wisdom(
      import
    ); cdecl; external _DLLNAME_;
    
    procedure fftwf_cleanup(
      import
    ); cdecl; external _DLLNAME_;
    
    procedure fftwf_set_timelimit(
      import
      real(C_DOUBLE), value :: t
    ); cdecl; external _DLLNAME_;
    
    procedure fftwf_plan_with_nthreads(
      import
      integer(C_INT), value :: nthreads
    ); cdecl; external _DLLNAME_;
    
    integer(C_INT) function fftwf_init_threads() bind(C, name='fftwf_init_threads')
      import
    end function fftwf_init_threads
    
    procedure fftwf_cleanup_threads(
      import
    ); cdecl; external _DLLNAME_;
    
    procedure fftwf_make_planner_thread_safe(
      import
    ); cdecl; external _DLLNAME_;
    
    integer(C_INT) function fftwf_export_wisdom_to_filename(filename) bind(C, name='fftwf_export_wisdom_to_filename')
      import
      character(C_CHAR), dimension(*), intent(in) :: filename
    end function fftwf_export_wisdom_to_filename
    
    procedure fftwf_export_wisdom_to_file(
      import
      type(C_PTR), value :: output_file
    ); cdecl; external _DLLNAME_;
    
    type(C_PTR) function fftwf_export_wisdom_to_string() bind(C, name='fftwf_export_wisdom_to_string')
      import
    end function fftwf_export_wisdom_to_string
    
    procedure fftwf_export_wisdom(
      import
      type(C_FUNPTR), value :: write_char
      type(C_PTR), value :: data
    ); cdecl; external _DLLNAME_;
    
    integer(C_INT) function fftwf_import_system_wisdom() bind(C, name='fftwf_import_system_wisdom')
      import
    end function fftwf_import_system_wisdom
    
    integer(C_INT) function fftwf_import_wisdom_from_filename(filename) bind(C, name='fftwf_import_wisdom_from_filename')
      import
      character(C_CHAR), dimension(*), intent(in) :: filename
    end function fftwf_import_wisdom_from_filename
    
    integer(C_INT) function fftwf_import_wisdom_from_file(input_file) bind(C, name='fftwf_import_wisdom_from_file')
      import
      type(C_PTR), value :: input_file
    end function fftwf_import_wisdom_from_file
    
    integer(C_INT) function fftwf_import_wisdom_from_string(input_string) bind(C, name='fftwf_import_wisdom_from_string')
      import
      character(C_CHAR), dimension(*), intent(in) :: input_string
    end function fftwf_import_wisdom_from_string
    
    integer(C_INT) function fftwf_import_wisdom(read_char,data) bind(C, name='fftwf_import_wisdom')
      import
      type(C_FUNPTR), value :: read_char
      type(C_PTR), value :: data
    end function fftwf_import_wisdom
    
    procedure fftwf_fprint_plan(
      import
      type(C_PTR), value :: p
      type(C_PTR), value :: output_file
    ); cdecl; external _DLLNAME_;
    
    procedure fftwf_print_plan(
      import
      type(C_PTR), value :: p
    ); cdecl; external _DLLNAME_;
    
    function fftwf_sprint_plan(
      import
      type(C_PTR), value :: p
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_malloc(
      import
      integer(C_SIZE_T), value :: n
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_alloc_real(
      import
      integer(C_SIZE_T), value :: n
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    function fftwf_alloc_complex(
      import
      integer(C_SIZE_T), value :: n
    ) :TC_PTR; cdecl; external _DLLNAME_;
    
    procedure fftwf_free(
      import
      type(C_PTR), value :: p
    ); cdecl; external _DLLNAME_;
    
    procedure fftwf_flops(
      import
      type(C_PTR), value :: p
      real(C_DOUBLE), intent(out) :: add
      real(C_DOUBLE), intent(out) :: mul
      real(C_DOUBLE), intent(out) :: fmas
    ); cdecl; external _DLLNAME_;
    
    real(C_DOUBLE) function fftwf_estimate_cost(p) bind(C, name='fftwf_estimate_cost')
      import
      type(C_PTR), value :: p
    end function fftwf_estimate_cost
    
    real(C_DOUBLE) function fftwf_cost(p) bind(C, name='fftwf_cost')
      import
      type(C_PTR), value :: p
    end function fftwf_cost
    
    integer(C_INT) function fftwf_alignment_of(p) bind(C, name='fftwf_alignment_of')
      import
      real(C_FLOAT), dimension(*), intent(out) :: p
    end function fftwf_alignment_of

implementation //############################################################### ■

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
