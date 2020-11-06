#!/bin/bash
set -eo pipefail

if [ -f ${QT_PATH}/build.done ]; then
    exit 0
fi

QTSRCDIR=/qt-everywhere-src-${QTVERSION}

if [ ! -d ${QTSRCDIR} ]; then
   if [ ! -d ${BUILDROOT}/qt-everywhere-src-${QTVERSION} ]; then
       echo "Qt: Downloading..."
       curl -sL -o ${BUILDROOT}/qt-everywhere-src-${QTVERSION}.tar.xz https://download.qt.io/archive/qt/${QTMAJOR}/${QTVERSION}/single/qt-everywhere-src-${QTVERSION}.tar.xz
       echo "${QTHASH}  ${BUILDROOT}/qt-everywhere-src-${QTVERSION}.tar.xz" | shasum -a 256 --check
       $(cd ${BUILDROOT} && \
       tar xf qt-everywhere-src-${QTVERSION}.tar.xz && \
       rm qt-everywhere-src-${QTVERSION}.tar.xz)
   fi
   QTSRCDIR=${BUILDROOT}/qt-everywhere-src-${QTVERSION}
fi

echo "Qt: building with ${NUM_JOBS} cores in ${QT_PATH}"
mkdir ${QT_PATH}
cd ${QTSRCDIR}

if [ "${PLATFORM}" = "linux" ]; then
    QTOPTIONS="-reduce-relocations -ltcg -xcb -bundled-xcb-xinput -gstreamer"
elif [ "${PLATFORM}" = "windows" ]; then
    QTOPTIONS="-xplatform win32-g++ -device-option CROSS_COMPILE=/usr/bin/x86_64-w64-mingw32- -skip qtwayland -opengl desktop"
elif [ "${PLATFORM}" = "osx" ]; then
    QTOPTIONS="-skip qtwayland -ltcg"
fi

tmpdir=qt-${PLATFORM}
mkdir ${tmpdir}
cd ${tmpdir}

../configure --recheck-all -opensource -confirm-license \
    ${QTOPTIONS} -release -static -prefix ${QT_PATH} -nomake tests -nomake examples -no-compile-examples \
    -no-zlib -qt-libpng -qt-libjpeg -no-openssl \
    -no-sql-db2 -no-sql-ibase -no-sql-mysql -no-sql-oci -no-sql-odbc -no-sql-psql -no-sql-sqlite2 -no-sql-tds \
    -no-cups -no-dbus -no-gif -no-feature-testlib \
    -skip qt3d -skip qtquick3d -skip qtlottie -skip qtactiveqt -skip qtandroidextras -skip qtcanvas3d -skip qtcharts -skip qtconnectivity -skip qtdatavis3d -skip qtdoc -skip qtgamepad \
    -skip qtlocation -skip qtmacextras -skip qtnetworkauth -skip qtpurchasing -skip qtremoteobjects -skip qtscript -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtxmlpatterns \
    -skip qtspeech -skip qttranslations -skip qtvirtualkeyboard -skip qtwebchannel -skip qtwebsockets -skip qtwebview -skip qtwinextras -skip qtx11extras -skip qtwebengine > ${QT_PATH}/build.log 2>&1

make -j${NUM_JOBS} >> ${QT_PATH}/build.log 2>&1
make install >> ${QT_PATH}/build.log 2>&1

touch ${QT_PATH}/build.done
