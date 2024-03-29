# if(COMMAND include_guard) include_guard(GLOBAL) endif()

macro(cmu_target_link_options target mode)
  if(COMMAND target_link_options)
    target_link_options(${target} ${mode} ${ARGN})
  else()
    target_link_libraries(${target} ${mode} ${ARGN})
  endif()
endmacro()

macro(cmu_configure_target target kind)

  set(comp_defs)
  if(CMU_DEFINES)
    list(APPEND comp_defs ${CMU_DEFINES})
  endif()

  if(CMU_DEFINES_DEBUG)
    list(APPEND comp_defs $<$<CONFIG:Debug>:${CMU_DEFINES_DEBUG}>)
  endif()

  if(CMU_DEFINES_OPT)
    list(APPEND comp_defs $<$<CONFIG:Release>:${CMU_DEFINES_OPT}>
         $<$<CONFIG:RelWithDebInfo>:${CMU_DEFINES_OPT}>)
  endif()

  if(comp_defs)
    target_compile_definitions(${target} PUBLIC ${comp_defs})
  endif()

  cmu_target_link_options(${target} PUBLIC ${CMU_LINK_FLAGS} ${CMU_LD_CC_FLAGS}
                          $<$<CONFIG:Release>:${CMU_LINK_FLAGS_OPT}>)

  target_link_libraries(${target} PUBLIC ${ARGN})

  if(CMU_HAVE_IPO AND CMU_IPO)
    set_property(TARGET ${target} PROPERTY INTERPROCEDURAL_OPTIMIZATION True)
  endif()

  set(comp_opts ${CMU_FLAGS} ${CMU_LD_CC_FLAGS})
  if(CMU_CXX_FLAGS)
    list(APPEND comp_opts $<$<COMPILE_LANGUAGE:CXX>:${CMU_CXX_FLAGS}>)
  endif()
  if(CMU_FLAGS_OPT)
    list(APPEND comp_opts $<$<CONFIG:Release>:${CMU_FLAGS_OPT}>
         $<$<CONFIG:RelWithDebInfo>:${CMU_FLAGS_OPT}>)
  endif()
  if(CMU_FLAGS_DEBUG)
    list(APPEND comp_opts $<$<CONFIG:Debug>:${CMU_FLAGS_DEBUG}>)
  endif()
  if(CMU_C_FLAGS)
    list(APPEND comp_opts $<$<COMPILE_LANGUAGE:C>:${CMU_C_FLAGS}>)
  endif()
  target_compile_options(${target} PUBLIC ${comp_opts})

  set(comp_opts ${CMU_PRIVATE_FLAGS})
  if(CMU_PRIVATE_CXX_FLAGS)
    list(APPEND comp_opts $<$<COMPILE_LANGUAGE:CXX>:${CMU_PRIVATE_CXX_FLAGS}>)
  endif()
  if(CMU_PRIVATE_C_FLAGS)
    list(APPEND comp_opts $<$<COMPILE_LANGUAGE:C>:${CMU_C_FLAGS}>)
  endif()
  if(comp_opts)
    target_compile_options(${target} PRIVATE ${comp_opts})
  endif()

  if(BUILD_SHARED_LIBS)
    set_target_properties(
      ${target}
      PROPERTIES C_VISIBILITY_PRESET hidden CXX_VISIBILITY_PRESET hidden
                 # VISIBILITY_INLINES_HIDDEN True
    )
  endif()

  if(CMU_PIC)
    set_target_properties(${target} PROPERTIES POSITION_INDEPENDENT_CODE True)
  endif()

  # target_compile_definitions(${target} PRIVATE
  # "-DCMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}")
  if(CMU_THREADS)
    target_link_libraries(${target} PUBLIC Threads::Threads)
  endif()
endmacro()

macro(cmu_add_library target)
  cmake_parse_arguments(THIS "" "" "SOURCES;DEPEND" ${ARGN})
  add_library(${target} ${THIS_SOURCES})
  cmu_configure_target(${target} library ${THIS_DEPEND})
endmacro()

macro(cmu_add_executable target)
  cmake_parse_arguments(THIS "" "" "SOURCES;DEPEND" ${ARGN})
  add_executable(${target} ${THIS_SOURCES})
  cmu_configure_target(${target} executable ${THIS_DEPEND})
endmacro()

if(CMU_LANG_C)
  include(CheckCSourceCompiles)
  include(CMakeCheckCompilerFlagCommonPatterns)
  macro(cmu_check_c_compiler_flag _FLAG _RESULT)
    set(SAFE_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
    set(_PREFIX "")
    foreach(v ${ARGN})
      set(_PREFIX "${_PREFIX}${v}\n")
    endforeach()
    if(CMU_COMP_INTEL)
      set(CMAKE_REQUIRED_FLAGS
          "${CMAKE_REQUIRED_FLAGS} -diag-error=10006 -diag-error=10159")
    elseif(CMU_COMP_GNUC)
      set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} -Werror")
    endif()
    set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} ${_FLAG}")
    # Normalize locale during test compilation.
    set(_CheckCCompilerFlag_LOCALE_VARS LC_ALL LC_MESSAGES LANG)
    foreach(v ${_CheckCCompilerFlag_LOCALE_VARS})
      set(_CheckCCompilerFlag_SAVED_${v} "$ENV{${v}}")
      set(ENV{${v}} C)
    endforeach()
    check_compiler_flag_common_patterns(_CheckCCompilerFlag_COMMON_PATTERNS)
    check_c_source_compiles(
      "${_PREFIX}int main(void) { return 0; }"
      ${_RESULT}
      # Some compilers do not fail with a bad flag
      FAIL_REGEX
      "ignoring unknown option" # ICC
      "option .* not supported" # ICC
      "command line option .* is valid for .* but not for C\\\\+\\\\+" # GNU
      ${_CheckCXXCompilerFlag_COMMON_PATTERNS})
    foreach(v ${_CheckCCompilerFlag_LOCALE_VARS})
      set(ENV{${v}} ${_CheckCCompilerFlag_SAVED_${v}})
      unset(_CheckCCompilerFlag_SAVED_${v})
    endforeach()
    unset(_CheckCCompilerFlag_LOCALE_VARS)
    unset(_CheckCCompilerFlag_COMMON_PATTERNS)
    set(CMAKE_REQUIRED_FLAGS "${SAFE_CMAKE_REQUIRED_FLAGS}")
  endmacro()

  macro(cmu_check_c_linker_flag _FLAG _RESULT)
     check_linker_flag(C ${_FLAG} ${_RESULT})
  endmacro()
else()
  macro(cmu_check_c_compiler_flag _FLAG _RESULT)

  endmacro()

  macro(cmu_check_c_linker_flag _FLAG _RESULT)

  endmacro()
endif()

if(CMU_LANG_CXX)
  include(CheckCXXSourceCompiles)
  include(CMakeCheckCompilerFlagCommonPatterns)

  macro(cmu_check_cxx_compiler_flag _FLAG _RESULT)
    set(SAFE_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
    set(_PREFIX "")
    foreach(v ${ARGN})
      set(_PREFIX "${_PREFIX}${v}\n")
    endforeach()
    if(CMU_COMP_INTEL)
      set(CMAKE_REQUIRED_FLAGS
          "${CMAKE_REQUIRED_FLAGS} -diag-error=10006 -diag-error=10159")
    elseif(CMU_COMP_GNUC)
      set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} -Werror")
    endif()
    set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} ${_FLAG}")
    # Normalize locale during test compilation.
    set(_CheckCXXCompilerFlag_LOCALE_VARS LC_ALL LC_MESSAGES LANG)
    foreach(v ${_CheckCXXCompilerFlag_LOCALE_VARS})
      set(_CheckCXXCompilerFlag_SAVED_${v} "$ENV{${v}}")
      set(ENV{${v}} C)
    endforeach()
    check_compiler_flag_common_patterns(_CheckCXXCompilerFlag_COMMON_PATTERNS)
    check_cxx_source_compiles(
      "${_PREFIX}int main() { return 0; }"
      ${_RESULT}
      # Some compilers do not fail with a bad flag
      FAIL_REGEX
      "ignoring unknown option" # ICC
      "option .* not supported" # ICC
      "command line option .* is valid for .* but not for C\\\\+\\\\+" # GNU
      ${_CheckCXXCompilerFlag_COMMON_PATTERNS})
    foreach(v ${_CheckCXXCompilerFlag_LOCALE_VARS})
      set(ENV{${v}} ${_CheckCXXCompilerFlag_SAVED_${v}})
      unset(_CheckCXXCompilerFlag_SAVED_${v})
    endforeach()
    unset(_CheckCXXCompilerFlag_LOCALE_VARS)
    unset(_CheckCXXCompilerFlag_COMMON_PATTERNS)
    set(CMAKE_REQUIRED_FLAGS "${SAFE_CMAKE_REQUIRED_FLAGS}")
  endmacro()

  macro(cmu_check_cxx_linker_flag _FLAG _RESULT)
     check_linker_flag(CXX ${_FLAG} ${_RESULT})
  endmacro()
else()
  macro(cmu_check_cxx_compiler_flag _FLAG _RESULT _PREFIX)

  endmacro()

  macro(cmu_check_cxx_linker_flag _FLAG _RESULT)
     check_linker_flag(C ${_FLAG} ${_RESULT})
  endmacro()
endif()

macro(cmu_check_compiler_flag flag var)
  if(CMU_LANG_CXX)
    cmu_check_cxx_compiler_flag("${flag}" ${var} ${ARGN})
  else()
    cmu_check_c_compiler_flag("${flag}" ${var} ${ARGN})
  endif()
endmacro()

macro(cmu_add_flag_if_supported flag var list)
  cmu_check_compiler_flag("${flag}" ${var} ${ARGN})
  if(${var})
    list(APPEND ${list} "${flag}")
  endif()
endmacro()

macro(cmu_check_linker_flag flag var)
  if(CMU_LANG_CXX)
    cmu_check_cxx_linker_flag("${flag}" ${var} ${ARGN})
  else()
    cmu_check_c_linker_flag("${flag}" ${var} ${ARGN})
  endif()
endmacro()

macro(cmu_add_linker_flag_if_supported flag var list)
  cmu_check_linker_flag("${flag}" ${var} ${ARGN})
  if(${var})
    list(APPEND ${list} "${flag}")
  endif()
endmacro()
