#!/usr/bin/env bash

set -e -x

cd /io

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [[ "${PYBIN}" == *"cp37"* ]] || \
       [[ "${PYBIN}" == *"cp38"* ]] || \
       [[ "${PYBIN}" == *"cp39"* ]]; then
        "${PYBIN}/pip" install --upgrade pip wheel
        "${PYBIN}/pip" install .[test]
        "${PYBIN}/python" setup.py bdist_wheel
        "${PYBIN}/python" setup.py test
    fi
done

# Bundle external shared libraries into the wheels
for whl in dist/fastcluster*.whl; do
    auditwheel repair "$whl"
done

rm dist/*
mv wheelhouse/*.whl dist/
