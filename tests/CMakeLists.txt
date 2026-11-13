cmake_minimum_required(VERSION 3.18...3.25)
if(POLICY CMP0219)
  cmake_policy(SET CMP0219 NEW)
endif()
project(cmake_utils_checks LANGUAGES C CXX)

set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_BUILD_TYPE Debug)
include("${CMAKE_CURRENT_LIST_DIR}/../cmake-utils.cmake")

set(CMAKE_REQUIRED_FLAGS "-DCMU_REQUIRED_FLAG=1")
set(ENV{LC_ALL} C)
cmu_check_c_compiler_flag("-Wall" CMU_TEST_C_VALID
  "#ifndef CMU_REQUIRED_FLAG\n#error required flags lost\n#endif")
cmu_check_cxx_compiler_flag("-Wall" CMU_TEST_CXX_VALID
  "#ifndef CMU_REQUIRED_FLAG\n#error required flags lost\n#endif")
cmu_check_c_compiler_flag("-fcmu-invalid-flag" CMU_TEST_C_INVALID)
cmu_check_cxx_compiler_flag("-fcmu-invalid-flag" CMU_TEST_CXX_INVALID)
if(NOT CMU_TEST_C_VALID OR NOT CMU_TEST_CXX_VALID)
  message(FATAL_ERROR "A supported compiler flag failed")
endif()
if(POLICY CMP0219)
  cmu_check_cxx_compiler_flag("-Wall" CMU_TEST_PREFIX
    [=[#define CMU_ESCAPE "\n"]=])
  cmu_check_c_compiler_flag("-Wall" CMU_TEST_C_PREFIX
    [=[#define CMU_ESCAPE "\n"]=])
  cmu_check_compiler_flag("-Wall" CMU_TEST_GENERIC_PREFIX
    [=[#define CMU_ESCAPE "\n"]=])
  if(NOT CMU_TEST_PREFIX OR NOT CMU_TEST_C_PREFIX OR NOT CMU_TEST_GENERIC_PREFIX)
    message(FATAL_ERROR "An escaped source prefix failed")
  endif()
endif()
if(CMU_TEST_C_INVALID OR CMU_TEST_CXX_INVALID)
  message(FATAL_ERROR "An unsupported compiler flag was accepted")
endif()
if(NOT CMAKE_REQUIRED_FLAGS STREQUAL "-DCMU_REQUIRED_FLAG=1" OR
   NOT "$ENV{LC_ALL}" STREQUAL "C")
  message(FATAL_ERROR "Compiler checks changed the required flags or locale")
endif()

cmu_check_c_linker_flag("-Wl,--as-needed" CMU_TEST_C_LINKER)
cmu_check_cxx_linker_flag("-Wl,--as-needed" CMU_TEST_CXX_LINKER)
cmu_check_linker_flag("-Wl,--as-needed;-Wl,--no-as-needed" CMU_TEST_LINKER_LIST)
cmu_check_linker_flag("-Wl,--cmu-invalid-flag" CMU_TEST_LINKER_INVALID)
if(NOT CMU_TEST_C_LINKER OR NOT CMU_TEST_CXX_LINKER OR
   NOT CMU_TEST_LINKER_LIST OR CMU_TEST_LINKER_INVALID)
  message(FATAL_ERROR "Linker flag detection failed")
endif()

cmu_configure()
cmu_add_executable(cmake_utils_smoke SOURCES "${CMAKE_CURRENT_LIST_DIR}/smoke.cpp")
enable_testing()
add_test(NAME cmake_utils_smoke COMMAND cmake_utils_smoke)
