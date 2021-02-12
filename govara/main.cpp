#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <govaraconnection.h>

int main(int argc, char *argv[]){
    QCoreApplication::setAttribute(Qt::AA_UseDesktopOpenGL);
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QQuickStyle::setStyle(QLatin1String("Material"));
    QGuiApplication app(argc, argv);
    app.setQuitOnLastWindowClosed(true);
    QQmlApplicationEngine engine;
    qmlRegisterType<GovaraConnection>("Govara",1,0,"Connection");
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
