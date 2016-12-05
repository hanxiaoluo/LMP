#include "ctoopts.h"
#include <QFileInfo>
#include <QDir>

#define log(x) qDebug() << __FILE__ << __LINE__ << #x": " << x

CtoOpts::CtoOpts(QQmlApplicationEngine *engine, QObject *parent) :
    QObject(parent), m_qml(engine->rootContext()), m_engine(engine)
{
    m_setter = new QSettings("./config.ini", QSettings::IniFormat);
    m_qml->setContextProperty("CtoOpts", this);
    m_qml->setContextProperty("playListModel", m_playList = m_setter->value("config/playList", QStringList()).toStringList());
    m_qml->setContextProperty("titleName", m_titleName = m_setter->value("config/titleName", "").toString());

    m_nameFilters << "*.mp4" << "*.mkv" << "*.rm" << "*.rmvb" << "*.avi" << "*.flv" << "*.wmv" << "*.mov";

}

CtoOpts::~CtoOpts()
{
}

void CtoOpts::saveData(int idx, int pos)
{
    m_setter->setValue("config/idx", idx);
    m_setter->setValue("config/pos", pos);
    m_setter->setValue("config/titleName", m_titleName);
    m_setter->setValue("config/playList", m_playList);
}

void CtoOpts::createPlayList(const QString &text)
{
    QString tem = text;
    tem.remove("file:///");
    QString name = tem.split(",", QString::SkipEmptyParts).first();
    QFileInfo fi(name);
    if (fi.isFile())
        name = fi.path();

    m_titleName = name.split("/", QString::SkipEmptyParts).last();
    m_qml->setContextProperty("titleName", m_titleName);

    QDir d(name);
    d.setNameFilters(m_nameFilters);
    m_playList = d.entryList(QDir::Files, QDir::Name);
    for (int i = 0; i < m_playList.size(); i++)
        m_playList[i] = "file:///" + name + "/" + m_playList[i];
    //m_qml->setContextProperty("playListModel", QStringList());
    m_qml->setContextProperty("playListModel", m_playList);

    if (fi.isFile())
        QMetaObject::invokeMethod(m_engine->rootObjects().first(), "playIdx", Q_ARG(QVariant, m_playList.indexOf(text)));
}

QString CtoOpts::fileName(const QString &text)
{
    QFileInfo fi(text);
    return fi.fileName();
}

QString CtoOpts::fmtTime(int val)
{
    return QString().sprintf("%02d:%02d:%02d", val/3600, val%3600/60, val%60);
}
