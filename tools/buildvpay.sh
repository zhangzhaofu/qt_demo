#!/bin/bash
set -eo pipefail

. tools/envs.env $1 $2

./tools/builddeps.sh $1 $2

CURRENTDIR=${PWD}

cd ${BUILDROOT}

QMAKE_CONFIG="CONFIG+=release CONFIG+=qml_release CONFIG+=static"

if [ "${SYMBOLS}" != "" ]; then
    QMAKE_CONFIG+=" QMAKE_CXXFLAGS+=-g"
fi

if [ "${PLATFORM}" = "linux" ]; then
    ${QT_PATH}/bin/qmake ${CURRENTDIR}/vpay.pro CONFIG+=x86_64 ${QMAKE_CONFIG}
elif [ "${PLATFORM}" = "windows" ]; then
    ${QT_PATH}/bin/qmake -spec win32-g++ ${CURRENTDIR}/vpay.pro CONFIG+=x86_64 TARGET_BIT=m64 ${QMAKE_CONFIG}
elif [ "${PLATFORM}" = "osx" ]; then
    ${QT_PATH}/bin/qmake ${CURRENTDIR}/vpay.pro -spec macx-clang CONFIG+=x86_64 QMAKE_MACOSX_DEPLOYMENT_TARGET=10.14 ${QMAKE_CONFIG}
fi

make -j${NUM_JOBS}

if [ "${SYMBOLS}" = "" ]; then
   if [ "${PLATFORM}" = "linux" ]; then
       python ${CURRENTDIR}/tools/symbol-check.py < ${BUILDROOT}/VPay
       strip ${BUILDROOT}/VPay
   elif [ "${PLATFORM}" = "windows" ]; then
       x86_64-w64-mingw32-strip ${BUILDROOT}/release/VPay.exe
   elif [ "${PLATFORM}" = "osx" ]; then
       strip ${BUILDROOT}/VPay.app/Contents/MacOS/VPay
   fi
fi

if [ "${PLATFORM}" = "linux" ]; then
   ${CURRENTDIR}/tools/appimage.sh ${CURRENTDIR}
fi
