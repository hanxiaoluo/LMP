#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "CtoOpts.h"
#include <QQuickView>
CtoOpts *ctoOpts;
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    ctoOpts = new CtoOpts(&engine);
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    QMetaObject::invokeMethod(engine.rootObjects().first(), "playBack", Q_ARG(QVariant, ctoOpts->m_setter->value("config/idx", -1)), Q_ARG(QVariant, ctoOpts->m_setter->value("config/pos", -1)));

    int ret = app.exec();
    ctoOpts->deleteLater();
    return ret;
}
