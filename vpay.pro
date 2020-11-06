TARGET = VPay

VERSION_MAJOR = 0
VERSION_MINOR = 0
VERSION_PATCH = 1
VERSION_PRERELEASE = 
VERSION = $${VERSION_MAJOR}.$${VERSION_MINOR}.$${VERSION_PATCH}

QMAKE_TARGET_COMPANY = Palliums Inc.
QMAKE_TARGET_PRODUCT = Palliums VPay
QMAKE_TARGET_DESCRIPTION = Palliums VPay
QMAKE_TARGET_COPYRIGHT = Copyright 2020 Palliums Inc. All rights reserved.

DEFINES += "VERSION_MAJOR=$$VERSION_MAJOR"\
       "VERSION_MINOR=$$VERSION_MINOR"\
       "VERSION_PATCH=$$VERSION_PATCH" \
       "VERSION_PRERELEASE=\"$$VERSION_PRERELEASE\"" \
       "VERSION=\"$${VERSION_MAJOR}.$${VERSION_MINOR}.$${VERSION_PATCH}\""

QML_IMPORT_NAME = Palliums.VPay
QML_IMPORT_MAJOR_VERSION = 0
QML_IMPORT_MINOR_VERSION = 1

QT += qml quick quickcontrols2 svg

#CONFIG += c++11 metatypes qmltypes qtquickcompiler
CONFIG += c++11

CONFIG += qzxing_qml qzxing_multimedia enable_decoder_qr_code enable_encoder_qr_code

include(qzxing/src/QZXing-components.pri)

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    src/main.cpp

#HEADERS += \

RESOURCES += assets/assets.qrc qml/qml.qrc

CONFIG += lrelease embed_translations

EXTRA_TRANSLATIONS = $$files($$PWD/i18n/*.ts)

INCLUDEPATH += src/

macos {
    QMAKE_TARGET_BUNDLE_PREFIX = org.palliums
    LIBS += -framework Foundation -framework Cocoa
    ICON = VPay.icns

    QMAKE_POST_LINK += \
        plutil -replace CFBundleDisplayName -string \"Palliums VPay\" $$OUT_PWD/$${TARGET}.app/Contents/Info.plist && \
        plutil -replace NSCameraUsageDescription -string \"We use the camera to scan QR codes\" $$OUT_PWD/$${TARGET}.app/Contents/Info.plist && \
        plutil -remove NOTE $$OUT_PWD/$${TARGET}.app/Contents/Info.plist || true
}

unix:!macos:!android {
    static {
        SOURCES += src/glibc_compat.cpp
        LIBS += -Wl,--wrap=__divmoddi4 -Wl,--wrap=log2f
    } else {
    }
    LIBS += -ludev
}

win32:static {
    # FIXME: the following script appends -lwinpthread at the end so that vpay .rsrc entries are used instead
    QMAKE_LINK=$${PWD}/link.sh
    RC_ICONS = VPay.ico
    LIBS += /usr/x86_64-w64-mingw32/lib/libhid.a /usr/x86_64-w64-mingw32/lib/libsetupapi.a
}
