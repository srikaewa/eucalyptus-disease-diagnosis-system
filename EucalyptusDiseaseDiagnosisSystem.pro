QT += qml quick widgets androidextras gui-private sql

CONFIG += c++11

SOURCES += main.cpp eddsapi.cpp \
    firebaseobject.cpp userlogin.cpp eucaimage.cpp

HEADERS += eddsapi.h \
    firebaseobject.h \
    userlogin.h \
    firebaseobject.h \
    eucaimage.h


RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    images/ic_more_vert_white_48pt.png \
    google-services.json \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/src/ImageFromActivityResult.java

# add static openssl library as Android 6.0+ do not support openssl anymore
contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/../openssl-1.0.2k/libcrypto.so \
        $$PWD/../openssl-1.0.2k/libssl.so
}

deployment.files += edds.sqlite\
                    google-services.json

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

INCLUDEPATH += $$PWD/../firebase_cpp_sdk/libs/android/armeabi-v7a/c++
DEPENDPATH += $$PWD/../firebase_cpp_sdk/libs/android/armeabi-v7a/c++

LIBS += -L$$PWD/../firebase_cpp_sdk/libs/android/armeabi-v7a/c++/ -lauth
LIBS += -L$$PWD/../firebase_cpp_sdk/libs/android/armeabi-v7a/c++/ -ldatabase
LIBS += -L$$PWD/../firebase_cpp_sdk/libs/android/armeabi-v7a/c++/ -lapp
