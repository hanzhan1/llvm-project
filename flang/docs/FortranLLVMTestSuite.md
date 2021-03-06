# Fortran Tests in the LLVM Test Suite

```eval_rst
.. contents::
   :local:
```

The [LLVM Test Suite](https://github.com/llvm/llvm-test-suite) is a
separate git repo from the main LLVM project. We recommend that
first-time users read through [LLVM Test Suite
Guide](https://llvm.org/docs/TestSuiteGuide.html) which describes the
organizational structure of the test suite and how to run it.

Although the Flang driver is unable to generate code at this time, we
are neverthelesss incrementally adding Fortran tests into the LLVM
Test Suite. We are currently testing against GFortran while we make
progress towards completing the new Flang driver with full
code-generation capabilities.

## Running the LLVM test-suite with Fortran

Fortran support can be enabled by setting the following CMake variables:
```
% cmake -DCMAKE_Fortran_COMPILER=<path to Fortran compiler> \
        -DTEST_SUITE_FORTRAN:STRING=ON \
        -C../test-suite/cmake/caches/O3.cmake \
        ../test-suite
```

At the moment, there is only a "hello world" Fortran test. A current
shortcoming in the design of the test suite is that building the C/C++
tests is conflated with building and running the Fortran tests,
i.e. it is not possible to only build and run the Fortran tests with
the exception of the [External
tests](https://llvm.org/docs/TestSuiteGuide.html#external-suites).


## Running the SPEC CPU 2017

We recently added CMake hooks into the LLVM Test Suite to support
Fortran tests from [SPEC CPU 2017](https://www.spec.org/cpu2017/). We
strongly encourage the use of the CMake Ninja (1.10 or later) generator
due to better support for Fortran module dependency detection. Some of
the SPEC CPU 2017 Fortran tests, those that are derived from climate
codes, require support for little-endian/big-endian byte swapping
capabilities which we automatically detect at CMake configuration
time.  Note that a copy of SPEC CPU 2017 must be purchased by your
home institution and is not provided by LLVM.


Here is an example of how to build SPEC CPU 2017 with GCC

```
cmake -G "Ninja" -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_Fortran_COMPILER=gfortran \
    -DTEST_SUITE_COLLECT_CODE_SIZE:STRING=OFF \
    -DTEST_SUITE_SUBDIRS:STRING="External/SPEC" \
    -DTEST_SUITE_FORTRAN:STRING=ON \
    -DTEST_SUITE_SPEC2017_ROOT=<path to SPEC directory>  ..
```
