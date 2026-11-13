# CMake Utils

Some collections of CMake scripts and macros to make platform/toolchain detection and setting appropiate compiler flags easier.

## Usage

Add a git submodule to your repository:
```sh
mkdir cmake
git -C cmake submodule add https://github.com/simonfxr/cmake-utils
```
Then use it from your `CMakeLists.txt`:
```cmake
include("${CMAKE_SOURCE_DIR}/cmake/cmake-utils/cmake-utils.cmake")

set(CMU_PREFERRED_LINKERS lld gold)
set(CMU_PIC True)
set(CMU_SANITIZERS ubsan)
set(CMU_WARN_LEVEL 4)
set(CMU_WARN_DATE_TIME True)
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

set(CMU_GLIBCXX_SANITIZE_VECTOR False)
set(CMU_GLIBCXX_DEBUG False)
set(CMU_GLIBCXX_DEBUG_PEDANTIC False)
set(CMU_LIBCPP_ABI_VERSION 2)
set(CMU_LIBCPP_ENABLE_NODISCARD True)
set(CMU_LIBCPP_DEBUG False)

cmu_configure()

cmu_add_library(libar SOURCES bar.cpp DEPEND Boost::regex whatever)

if(CMU_OS_ANDROID)
  if(CMU_BITS_64)
    target_link_libraries(libar Xaarch64)
  else()
    target_link_libraries(libar Xarm)
  endif()
endif()

cmu_add_executable(foo SOURCES foo.cpp baz.c DEPEND libar ...)
```

Configuration options only take effect on applicable platform/toolchain
combinations, no need for all the `if(${ARCH} AND ${OS} AND ${COMPILER} AND
${COMPILER_VERSION} VERSIONGREATER ...)` nonsense.

Contributions welcome :-)

## Compatibility checks

CMake 3.18 or newer is required. On Linux with GCC or Clang, run the compiler
and linker flag regression checks and build the debug smoke test with:

```sh
cmake -S tests -B build-checks -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++
cmake --build build-checks
ctest --test-dir build-checks --output-on-failure
```

Use `clang` and `clang++` to also check libc++ debug hardening (libc++ must be
installed). On CMake 4.4 or newer, the checks cover preservation of backslashes
in source prefixes under CMP0219.
