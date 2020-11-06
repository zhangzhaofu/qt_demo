#!/bin/bash
set -eo pipefail

. tools/envs.env $1 $2

if [ "${BUILDDIR}" = "" ]; then
    echo "Unsupported target"
    exit 1
fi

mkdir -p ${BUILDROOT}

echo "Building in ${BUILDROOT}"

./tools/buildqt.sh || (cat ${QT_PATH}/build.log && false)
echo "Qt: OK"
