//#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QtAndroidExtras>


#include <eddsapi.h>
#include <firebaseobject.h>
#include <eucaimage.h>


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    /**** register FirebaseObject class ****/
    qmlRegisterType<EDDSApi>("EDDSApi", 1, 0, "EDDSApi");
    /*********************************/

    /**** register FirebaseObject class ****/
    qmlRegisterType<FirebaseObject>("FirebaseObject", 1, 0, "FirebaseObject");
    /*********************************/

    /**** register EucaImage class ****/
    qmlRegisterType<EucaImage>("EucaImage", 1, 0, "EucaImage");
    /*********************************/


    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}


