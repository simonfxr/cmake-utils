# if(COMMAND include_guard) include_guard(GLOBAL) endif()

cmake_minimum_required(VERSION 3.9)

set(CMU_OPT_LEVEL 2)
set(CMU_OPT_NATIVE False)
set(CMU_IPO True)

if(CMU_COMP_CLANG)
  set(CMU_PREFERRED_LINKERS mold lld gold bfd)
else()
  set(CMU_PREFERRED_LINKERS)
endif()
set(CMU_PIC True)
set(CMU_SANITIZERS)
set(CMU_WARN_LEVEL 4)
set(CMU_WARN_DATE_TIME True)
set(CMU_WARN_INLINE_FAILED False)
set(CMU_FP_MODE IEEE)
set(CMU_PREFERRED_CXX_STDLIB libc++ libstdc++)
set(CMU_THREADS False)
set(CMU_NO_EXCEPTIONS False)
set(CMU_NO_RTTI False)
set(CMU_FORTIFY_SOURCE 2)
set(CMU_STACK_PROTECTION True)
set(CMU_EAGER_LOADING True)
set(CMU_STRICT_LINKING True)
set(CMU_RELRO True)
set(CMU_CFI True)
set(CMU_MSVC_COMPLIANT True)
set(CMU_COVERAGE False)

set(CMU_LIBCPP_ABI_VERSION)

set(CMU_FLAGS_DEBUG)

set(CMU_DEBUG_GLIBCXX_SANITIZE_VECTOR True)
set(CMU_DEBUG_GLIBCXX_DEBUG True)
set(CMU_DEBUG_GLIBCXX_DEBUG_PEDANTIC True)
set(CMU_DEBUG_GLIBCXX_ASSERTIONS True)
set(CMU_DEBUG_LIBCPP_DEBUG True)
set(CMU_DEBUG_LIBCPP_ASSERTIONS True)

set(CMU_SANITIZERS)

set(CMU_FLAGS)
set(CMU_C_FLAGS)
set(CMU_CXX_FLAGS)
set(CMU_DEFINES)

set(CMU_PRIVATE_FLAGS)
set(CMU_PRIVATE_C_FLAGS)
set(CMU_PRIVATE_CXX_FLAGS)

# Flags passed to linker and compiler
set(CMU_LD_CC_FLAGS)
set(CMU_LINK_FLAGS)

set(CMU_FLAGS_O0)
set(CMU_FLAGS_O1)
set(CMU_FLAGS_O2)
set(CMU_FLAGS_O3)
set(CMU_FLAGS_O4)
set(CMU_FLAGS_OPT_NATIVE)

set(CMU_FLAGS_OPT)
set(CMU_LINK_FLAGS_OPT)

set(CMU_FLAGS_FP_IEEE)
set(CMU_FLAGS_FP_FAST)
set(CMU_FLAGS_FP_ASSOC)
set(CMU_FLAGS_FP_FINITE)

set(CMU_FLAGS_CFI)

set(CMU_FLAGS_EAGER_LOADING)
set(CMU_FLAGS_STRICT_LINKING)
set(CMU_FLAGS_RELRO)

set(CMU_FLAGS_NO_EXCEPTIONS)
set(CMU_FLAGS_NO_RTTI)

set(CMU_FLAGS_DEVIRTUALIZE_AT_LTRANS)

set(CMU_FLAGS_W0)
set(CMU_FLAGS_W1)
set(CMU_FLAGS_W2)
set(CMU_FLAGS_W3)
set(CMU_FLAGS_W4)

set(CMU_FLAGS_WARN_DATE_TIME)

set(CMU_FLAGS_C_W0)
set(CMU_FLAGS_C_W1)
set(CMU_FLAGS_C_W2)
set(CMU_FLAGS_C_W3)
set(CMU_FLAGS_C_W4)

set(CMU_FLAGS_CXX_W0)
set(CMU_FLAGS_CXX_W1)
set(CMU_FLAGS_CXX_W2)
set(CMU_FLAGS_CXX_W3)
set(CMU_FLAGS_CXX_W4)

set(CMU_FLAGS_MSVC_COMPLIANT)

if(CMU_COMP_MSVC)

  set(CMU_FLAGS_O1 /O)
  set(CMU_FLAGS_O2 /O2)
  set(CMU_FLAGS_O3 /Ox /O2 /Ob3)
  set(CMU_FLAGS_FP_IEEE /fp:precise)
  set(CMU_FLAGS_FP_FAST /fp:precise)
  set(CMU_FLAGS_FP_ASSOC /fp:precise)
  set(CMU_FLAGS_FP_FINITE /fp:fast)
  set(CMU_FLAGS_CFI /guard:cf)
  set(CMU_FLAGS_NO_EXCEPTIONS "/EHs-")
  set(CMU_FLAGS_NO_RTTI "/GR-")
  set(CMU_FLAGS_W1 /W1)
  set(CMU_FLAGS_W2 /W2)
  set(CMU_FLAGS_W3 /W3)
  set(CMU_FLAGS_W4 /W4)

  cmu_add_flag_if_supported("/Zc:__cplusplus" CMU_MSVC_ZC_CPLUSPLUS
                            CMU_FLAGS_MSVC_COMPLIANT)
  cmu_add_flag_if_supported("/permissive-" CMU_MSVC_PERMISSIVE_MINUS
                            CMU_FLAGS_MSVC_COMPLIANT)

elseif(CMU_COMP_GNUC)
  set(CMU_FLAGS_O1 -O1)
  set(CMU_FLAGS_O2 -O2)
  set(CMU_FLAGS_O3 -O3)
  set(CMU_FLAGS_O4 -O3)

  cmu_add_flag_if_supported("-march=native" CMU_HAVE_MARCH_NATIVE
                            CMU_FLAGS_OPT_NATIVE)

  cmu_add_flag_if_supported("-fcf-protection" CMU_HAVE_CF_PROTECTION
                            CMU_FLAGS_CFI)

  cmu_add_flag_if_supported("-fipa-pta" CMU_HAVE_IPA_PTA CMU_FLAGS_O4_LTO)
  cmu_add_flag_if_supported(
    "-fno-semantic-interposition" CMU_HAVE_NO_SEMANTIC_INTERPOSITION_PTA
    CMU_FLAGS_O4_LTO)
  cmu_add_flag_if_supported(
    "-fdevirtualize-at-ltrans" CMU_HAVE_DEVIRTUALIZE_AT_LTRANS
    CMU_FLAGS_DEVIRTUALIZE_AT_LTRANS)

  if(CMU_COMP_CLANG)
    set(CMU_FLAGS_COVERAGE -fprofile-instr-generate -fcoverage-mapping)
  else()
    cmu_add_flag_if_supported("--coverage" CMU_HAVE_COVERAGE_FLAG
                              CMU_FLAGS_COVERAGE)
  endif()

  if(CMU_OS_POSIX)
    set(CMU_FLAGS_STRICT_LINKING "-Wl,-z,defs")
    set(CMU_FLAGS_EAGER_LOADING "-Wl,-z,now")
    set(CMU_FLAGS_RELRO "-Wl,-z,relro")
  endif()

  set(CMU_FLAGS_FP_IEEE)

  if(CMU_COMP_INTEL)
    if(CMU_OS_WINDOWS)
      set(CMU_FLAGS_O1 /O1)
      set(CMU_FLAGS_O2 /O2)
      set(CMU_FLAGS_O3 /O3 /Qipo)
      set(CMU_FLAGS_OPT_NATIVE /QxHost)
      set(CMU_FLAGS_FP_IEEE "/fp:precise,source")
    else()
      set(CMU_FLAGS_O3 -ipo -O3)
      set(CMU_FLAGS_OPT_NATIVE -xHost)
      set(CMU_FLAGS_FP_IEEE -fp-model source)
    endif()
  endif()

  cmu_add_flag_if_supported("-fexcess-precision=standard"
                            CMU_HAVE_FP_NO_EXCESS_PRECISION CMU_FLAGS_FP_IEEE)
  cmu_add_flag_if_supported("-fno-fast-math" CMU_HAVE_FNO_FAST_MATH
                            CMU_FLAGS_FP_IEEE)
  cmu_add_flag_if_supported("-ffp-contract=off" CMU_HAVE_FNO_FFP_CONTRACT
                            CMU_FLAGS_FP_IEEE)

  if(CMU_ARCH_X86)
    # When IEEE fp compliance is requested, SSE2 is implicitly enabled as well,
    # for more info see here: https://gcc.gnu.org/wiki/FloatingPointMath#x86note
    set(msse2)
    if(CMU_BITS_32)
      set(msse2 "-msse2;")
    endif()
    cmu_add_flag_if_supported("${msse2}-mfpmath=sse" CMU_HAVE_FPMATH_SSE
                              CMU_FLAGS_FP_IEEE)
  endif()

  set(CMU_FLAGS_FP_FAST -ffp-contract=fast -fno-math-errno -fno-trapping-math)
  cmu_add_flag_if_supported("-fexcess-precision=fast"
                            CMU_HAVE_FACCESS_PRECISION_FAST CMU_FLAGS_FP_FAST)
  cmu_add_flag_if_supported("-fcx-limited-range" CMU_HAVE_FCX_LIMITED_RANGE
                            CMU_FLAGS_FP_FAST)

  set(CMU_FLAGS_FP_ASSOC ${CMU_FLAGS_FP_FAST} -funsafe-math-optimizations)
  set(CMU_FLAGS_FP_FINITE -ffast-math)

  set(CMU_FLAGS_NO_EXCEPTIONS "-fno-exceptions")
  set(CMU_FLAGS_NO_RTTI "-fno-rtti")

  set(CMU_FLAGS_W1 -Wall -Werror=return-type)
  set(CMU_FLAGS_C_W1 -Werror=implicit-function-declaration)

  set(CMU_FLAGS_W2 ${CMU_FLAGS_W1} -Wextra)
  set(CMU_FLAGS_C_W2 ${CMU_FLAGS_C_W1})

  cmu_check_compiler_flag("-Wdate-time" CMU_HAVE_WARN_DATE_TIME)
  if(CMU_HAVE_WARN_DATE_TIME)
    set(CMU_FLAGS_WARN_DATE_TIME -Wdate-time -Werror=date-time)
  endif()

  cmu_check_compiler_flag("-Winline" CMU_HAVE_WARN_INLINE_FAILED)
  if(CMU_HAVE_WARN_INLINE_FAILED)
    set(CMU_FLAGS_WARN_INLINE_FAILED -Winline)
  endif()

  if(CMU_COMP_INTEL)
    list(APPEND CMU_FLAGS_W2 -Wcheck)
  endif()

  set(CMU_FLAGS_W3 ${CMU_FLAGS_W2} -Wswitch)
  set(CMU_FLAGS_C_W3 ${CMU_FLAGS_C_W2})

  if(CMU_COMP_GCC)
    list(
      APPEND
      CMU_FLAGS_W3
      -Wcast-align
      -Wcast-qual
      -Wchar-subscripts
      -Wcomment
      -Wdisabled-optimization
      -Wformat
      -Wformat-nonliteral
      -Wformat-security
      -Wformat-y2k
      -Wformat=2
      -Wimport
      -Winit-self
      -Winvalid-pch
      -Wmissing-field-initializers
      -Wmissing-format-attribute
      -Wmissing-include-dirs
      -Wmissing-noreturn
      -Wparentheses
      -Wpointer-arith
      -Wredundant-decls
      -Wreturn-type
      -Wsequence-point
      -Wsign-compare
      -Wstack-protector
      -Wstrict-aliasing
      -Wswitch
      -Wswitch-enum
      -Wtrigraphs
      -Wuninitialized
      -Wunknown-pragmas
      -Wunreachable-code
      -Wunsafe-loop-optimizations
      -Wunused
      -Wunused-function
      -Wunused-label
      -Wunused-parameter
      -Wunused-value
      -Wunused-variable
      -Wvariadic-macros
      -Wvolatile-register-var
      -Wwrite-strings)
  elseif(CMU_COMP_INTEL)
    list(
      APPEND
      CMU_FLAGS_W3
      -Wcast-qual
      -Wchar-subscripts
      -Wcomment
      -Wdisabled-optimization
      -Wformat
      -Wformat-security
      -Wformat=2
      -Winit-self
      -Winvalid-pch
      -Wmissing-field-initializers
      -Wmissing-include-dirs
      -Wparentheses
      -Wpointer-arith
      -Wreturn-type
      -Wsequence-point
      -Wsign-compare
      -Wstrict-aliasing
      -Wswitch
      -Wswitch-enum
      -Wtrigraphs
      -Wuninitialized
      -Wunknown-pragmas
      -Wunreachable-code
      -Wunused
      -Wunused-function
      -Wunused-parameter
      -Wunused-variable
      -Wwrite-strings)
  elseif(CMU_COMP_CLANG)
    list(
      APPEND
      CMU_FLAGS_W3
      -Weverything
      -Wno-c++98-compat
      -Wno-c++98-compat-pedantic
      -Wno-conversion
      -Wno-documentation
      -Wno-documentation-unknown-command
      -Wno-double-promotion
      -Wno-float-equal
      -Wno-gnu-anonymous-struct
      -Wno-gnu-zero-variadic-macro-arguments
      -Wno-missing-noreturn
      -Wno-missing-prototypes
      -Wno-nested-anon-types
      -Wno-packed
      -Wno-padded
      -Wno-gnu-statement-expression
      -Wno-assume
      -Wno-disabled-macro-expansion
      -Wno-reserved-id-macro
      -Wno-declaration-after-statement
      -Wno-switch-default)
    list(APPEND CMU_FLAGS_CXX_W3 -Wno-return-std-move-in-c++11
         -Wno-unknown-warning-option -Wno-shadow-field-in-constructor)
    cmu_add_flag_if_supported("-Wno-c++20-compat" "CMU_HAVE_WNO_CXX20_COMPAT"
                              CMU_FLAGS_CXX_W3)
    cmu_add_flag_if_supported(
      "-Wno-unsafe-buffer-usage" "CMU_HAVE_WNO_UNSAFE_BUFFER_USAGE"
      CMU_FLAGS_CXX_W3)
  endif()
  set(CMU_FLAGS_W4 "${CMU_FLAGS_W3}")
  set(CMU_FLAGS_C_W4 "${CMU_FLAGS_C_W3}")
  set(CMU_FLAGS_CXX_W4 "${CMU_FLAGS_CXX_W3}")
endif()

if(NOT CMU_FLAGS_O4)
  set(CMU_FLAGS_O4 "${CMU_FLAGS_O3}")
endif()

macro(cmu_replace_global_cmake_flags pat repl)
  set(types ${CMAKE_CONFIGURATION_TYPES})
  if(NOT types)
    set(types DEBUG RELEASE RELWITHDEBINFO MINSIZEREL)
  endif()

  foreach(ty "" ${types})
    if(ty)
      set(ty "_${ty}")
    endif()
    foreach(pref "" _C_FLAGS _CXX_FLAGS)
      set(v "CMAKE${pref}${ty}")
      if(DEFINED "${v}")
        string(REGEX REPLACE "${pat}" "${repl}" "${v}" "${${v}}")
      endif()
    endforeach()
  endforeach()
endmacro()

macro(cmu_add_global_cmake_linker_flags)
  set(types ${CMAKE_CONFIGURATION_TYPES})
  if(NOT types)
    set(types DEBUG RELEASE RELWITHDEBINFO MINSIZEREL)
  endif()

  foreach(ty "" ${types})
    if(ty)
      set(ty "_${ty}")
    endif()
    foreach(kind EXE SHARED STATIC MODULE)
      set(v "CMAKE_${kind}_LINKER_FLAGS${ty}")
      list(APPEND "${v}" ${ARGN})
    endforeach()
  endforeach()
endmacro()

macro(cmu_enable_sanitizers)
  set(sans)
  set(sep)
  foreach(san ${ARGV})
    if(san STREQUAL "asan")
      cmu_check_compiler_flag(-fsanitize=address CMU_HAVE_ASAN)
      if(CMU_HAVE_ASAN)
        set(sans "${sans}${sep}address")
        set(sep ",")
      endif()
    elseif(san STREQUAL "ubsan")
      cmu_check_compiler_flag(-fsanitize=undefined CMU_HAVE_UBSAN)
      if(CMU_HAVE_UBSAN)
        set(sans "${sans}${sep}undefined")
        set(sep ",")
      endif()
    elseif(san STREQUAL "tsan")
      cmu_check_compiler_flag(-fsanitize=thread CMU_HAVE_TSAN)
      if(CMU_HAVE_TSAN)
        set(sans "${sans}${sep}thread")
        set(sep ",")
      endif()
    elseif(san STREQUAL "lsan")
      cmu_check_compiler_flag(-fsanitize=leak CMU_HAVE_LSAN)
      if(CMU_HAVE_LSAN)
        set(sans "${sans}${sep}leak")
        set(sep ",")
      endif()
    else()
      message(WARNING "unknown sanitizer: \"${san}\"")
    endif()
  endforeach()
  if(sans)
    # when sanitizers are enabled -Wl,-z,defs needs to be disabled
    set(CMU_STRICT_LINKING False)
    list(APPEND CMU_LD_CC_FLAGS "-fsanitize=${sans}")
    list(APPEND CMU_FLAGS "-fno-omit-frame-pointer")
  endif()
endmacro()

macro(cmu_add_global_cmake_flags flags)
  set(types ${CMAKE_CONFIGURATION_TYPES})
  if(NOT types)
    set(types DEBUG RELEASE RELWITHDEBINFO MINSIZEREL)
  endif()

  foreach(ty "" ${types})
    if(ty)
      set(ty "_${ty}")
    endif()
    foreach(pref "" _C_FLAGS _CXX_FLAGS)
      set(v "CMAKE${pref}${ty}")
      if(DEFINED ${v})
        set($v "${${v}} ${flags}")
        message(STATUS "${v}=${${v}}")
      endif()
    endforeach()
  endforeach()
endmacro()

macro(cmu_configure_preferred_linkers)
  set(CMU_LINKER)
  foreach(ld ${ARGV})
    if(NOT (ld MATCHES "^(gold|mold|lld|bfd)$"))
      message(WARNING "Ignoring unknown linker: ${ld}")
    elseif(NOT CMU_LINKER AND CMU_COMP_CLANG)
      list(APPEND CMU_LINK_FLAGS "-fuse-ld=${ld}")
      set(CMU_LINKER ${ld})
    elseif(NOT CMU_LINKER AND CMU_COMP_GNUC)
      cmu_add_linker_flag_if_supported("-fuse-ld=${ld}" "CMU_HAVE_LD_${ld}"
                                       CMU_LINK_FLAGS)
      if(CMU_HAVE_LD_${ld})
        set(CMU_LINKER ${ld})
      endif()
    endif()
  endforeach()
endmacro()

macro(cmu_configure_preferred_cxx_stdlib)
  set(CMU_CXX_STDLIB)
  foreach(stdlib ${ARGV})
    if(NOT CMU_CXX_STDLIB)
      if(stdlib STREQUAL "libc++")
        if(CMU_COMP_CLANG)
          list(APPEND CMU_CXX_FLAGS -stdlib=libc++)
          list(APPEND CMU_LINK_FLAGS -stdlib=libc++)
          set(CMU_CXX_STDLIB libc++)
        endif()
      elseif(stdlib STREQUAL "libstdc++")
        if(CMU_COMP_GNUC)
          set(CMU_CXX_STDLIB libstdc++)
        endif()
      else()
        message(WARNING "Ignoring unknown C++ standard library: ${stdlib}")
      endif()
    endif()
  endforeach()
endmacro()

macro(cmu_configure)

  if(NOT COMMAND check_ipo_supported)
    include(CheckIPOSupported)
  endif()
  check_ipo_supported(RESULT CMU_HAVE_IPO)
  if(CMU_HAVE_IPO AND CMU_IPO)
    list(APPEND CMU_FLAGS_O4_LTO ${CMU_FLAGS_DEVIRTUALIZE_AT_LTRANS})
  endif()

  list(APPEND CMU_FLAGS_OPT ${CMU_FLAGS_O${CMU_OPT_LEVEL}})
  if(CMU_OPT_NATIVE)
    list(APPEND CMU_FLAGS_OPT ${CMU_FLAGS_OPT_NATIVE})
  endif()
  if(CMU_IPO AND (CMU_OPT_LEVEL STREQUAL 4))
    list(APPEND CMU_FLAGS_OPT ${CMU_FLAGS_O4_LTO})
    list(APPEND CMU_LINK_FLAGS_OPT ${CMU_FLAGS_O4_LTO})
  endif()

  cmu_configure_preferred_linkers(${CMU_PREFERRED_LINKERS})

  cmu_enable_sanitizers(${CMU_SANITIZERS})

  list(APPEND CMU_FLAGS ${CMU_FLAGS_W${CMU_WARN_LEVEL}})
  if(CMU_WARN_DATE_TIME)
    list(APPEND CMU_PRIVATE_FLAGS ${CMU_FLAGS_WARN_DATE_TIME})
  endif()
  if(CMU_WARN_INLINE_FAILED)
    list(APPEND CMU_PRIVATE_FLAGS ${CMU_FLAGS_WARN_INLINE_FAILED})
  endif()
  list(APPEND CMU_PRIVATE_C_FLAGS ${CMU_FLAGS_C_W${CMU_WARN_LEVEL}})
  list(APPEND CMU_PRIVATE_CXX_FLAGS ${CMU_FLAGS_CXX_W${CMU_WARN_LEVEL}})

  list(APPEND CMU_FLAGS ${CMU_FLAGS_FP_${CMU_FP_MODE}})
  if(CMU_LANG_CXX)
    cmu_configure_preferred_cxx_stdlib(${CMU_PREFERRED_CXX_STDLIB})
  endif()

  if(CMU_THREADS)
    set(CMAKE_THREAD_PREFER_PTHREAD True)
    set(THREADS_PREFER_PTHREAD_FLAG True)
    find_package(Threads REQUIRED)
  endif()

  if(CMU_NO_EXCEPTIONS)
    list(APPEND CMU_FLAGS ${CMU_FLAGS_NO_EXCEPTIONS})
  endif()

  if(CMU_NO_RTTI)
    list(APPEND CMU_CXX_FLAGS ${CMU_FLAGS_NO_RTTI})
  endif()

  if(CMU_FORTIFY_SOURCE GREATER 0)
    list(APPEND CMU_DEFINES_OPT "_FORTIFY_SOURCE=${CMU_FORTIFY_SOURCE}")
  endif()

  if(CMU_CFI)
    list(APPEND CMU_LD_CC_FLAGS ${CMU_FLAGS_CFI})
  endif()

  if(CMU_EAGER_LOADING)
    list(APPEND CMU_LINK_FLAGS ${CMU_FLAGS_EAGER_LOADING})
  endif()

  if(CMU_STRICT_LINKING)
    list(APPEND CMU_LINK_FLAGS ${CMU_FLAGS_STRICT_LINKING})
  endif()

  if(CMU_RELRO)
    list(APPEND CMU_LINK_FLAGS ${CMU_FLAGS_RELRO})
  endif()

  if(CMU_STACK_PROTECTION)
    if(CMU_COMP_GNUC)
      cmu_add_flag_if_supported("-fstack-protector-strong"
                                CMU_HAVE_STACK_PROTECTOR_STRONG CMU_FLAGS)

      if(NOT CMU_HAVE_STACK_PROTECTOR_STRONG)
        cmu_add_flag_if_supported("-fstack-protector" CMU_HAVE_STACK_PROTECTOR
                                  CMU_FLAGS)
      endif()

      cmu_add_flag_if_supported("-fstack-clash-protection"
                                CMU_HAVE_STACK_CLASH_PROTECTION CMU_FLAGS)
    endif()
  endif()

  if(CMU_MSVC_COMPLIANT)
    list(APPEND CMU_FLAGS ${CMU_FLAGS_MSVC_COMPLIANT})
  endif()

  if(CMU_COVERAGE)
    list(APPEND CMU_LD_CC_FLAGS ${CMU_FLAGS_COVERAGE})
  endif()

  if(CMU_CXX_STDLIB STREQUAL "libstdc++")
    if(CMU_DEBUG_GLIBCXX_SANITIZE_VECTOR)
      list(APPEND CMU_DEFINES_DEBUG "_GLIBCXX_SANITIZE_VECTOR=1")
    endif()
    if(CMU_DEBUG_GLIBCXX_DEBUG_PEDANTIC)
      set(CMU_DEBUG_GLIBCXX_DEBUG True)
      list(APPEND CMU_DEFINES_DEBUG "_GLIBCXX_DEBUG_PEDANTIC=1")
    endif()
    if(CMU_DEBUG_GLIBCXX_DEBUG)
      list(APPEND CMU_DEFINES_DEBUG "_GLIBCXX_DEBUG=1")
    endif()
    if(CMU_DEBUG_GLIBCXX_ASSERTIONS)
      list(APPEND CMU_DEFINES_DEBUG "_GLIBCXX_ASSERTIONS=1")
    endif()
  elseif(CMU_CXX_STDLIB STREQUAL "libc++")
    if(CMU_LIBCPP_ABI_VERSION)
      list(APPEND CMU_DEFINES "_LIBCPP_ABI_VERSION=${CMU_LIBCPP_ABI_VERSION}")
    endif()
    if(CMU_DEBUG_LIBCPP_ENABLE_NODISCARD)
      list(APPEND CMU_DEFINES_DEBUG "_LIBCPP_ENABLE_NODISCARD=1")
    endif()
    if(CMU_DEBUG_LIBCPP_DEBUG)
      set(CMU_DEBUG_LIBCPP_DEBUG False)
      cmu_check_cxx_compiler_flag("-D_LIBCPP_DEBUG=1 -stdlib=libc++"
                                  CMU_HAVE_LIBCPP_DEBUG "#include <string>")
      if(CMU_HAVE_LIBCPP_DEBUG)
        list(APPEND CMU_DEFINES_DEBUG "_LIBCPP_DEBUG=1")
      endif()
    endif()
    if(CMU_DEBUG_LIBCPP_ASSERTIONS)
      list(APPEND CMU_DEFINES_DEBUG "_LIBCPP_ENABLE_ASSERTIONS=1")
    endif()
  endif()
endmacro()
