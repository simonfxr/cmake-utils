# if(COMMAND include_guard)
#   include_guard(GLOBAL)
# endif()

# Establish policies before defining the helper macros, particularly CMP0219's
# preservation of backslashes in compiler-check source snippets.
cmake_minimum_required(VERSION 3.18...3.25)
if(POLICY CMP0219)
  cmake_policy(SET CMP0219 NEW)
endif()

if(NOT CMAKE_UTILS_INCLUDED)
  set(CMAKE_UTILS_INCLUDED 1)
  include("${CMAKE_CURRENT_LIST_DIR}/cmu_detect_env.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/cmu_macros.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/cmu_cflags.cmake")
endif()
