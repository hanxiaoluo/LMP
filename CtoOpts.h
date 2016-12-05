#ifndef CTOOPTS_H
#define CTOOPTS_H

#include <QObject>
#include <QQmlContext>
#include <QQuickItem>
#include <QSettings>
#include <QDebug>
#include <QQmlApplicationEngine>

class ThreadSend;

class CtoOpts : public QObject
{
    Q_OBJECT
public:
    explicit CtoOpts(QQmlApplicationEngine *engine, QObject *parent = 0);
    ~CtoOpts();

signals:
    void update(QString str);

public slots:
    void saveData(int idx, int pos);
    void createPlayList(const QString &text);
    QString fileName(const QString &text);
    QString fmtTime(int val);

public:
    QSettings *m_setter;
private:
    QQmlContext *m_qml;
    QStringList m_nameFilters;
    QStringList m_playList;
    QString m_titleName;
    QQmlApplicationEngine *m_engine;
};

#endif // CTOOPTS_H
