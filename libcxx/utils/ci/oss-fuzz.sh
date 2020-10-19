#!/bin/bash -eu

#
# This script runs the continuous fuzzing tests on OSS-Fuzz.
#

if [[ ${SANITIZER} = *undefined* ]]; then
  CXXFLAGS="${CXXFLAGS} -fsanitize=unsigned-integer-overflow -fsanitize-trap=unsigned-integer-overflow"
fi

for test in libcxx/test/libcxx/fuzzing/*.pass.cpp; do
    ${CXX} ${CXXFLAGS} \
        -std=c++14 \
        -DLIBCPP_OSS_FUZZ \
        -nostdinc++ -cxx-isystem libcxx/include \
        -o "${OUT}/$(basename ${test})" \
        ${test} \
        ${LIB_FUZZING_ENGINE}
done
