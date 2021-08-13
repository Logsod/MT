#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QDebug>
#include <QSettings>
#include <QVariant>
#include <QDir>
#include <QGuiApplication>
#include <QLocale>
#include <QtCore>
class Backend : public QObject
{
    Q_OBJECT
public:
    Backend();
    Q_INVOKABLE void setSetting(QVariant key, QVariant val);
    Q_INVOKABLE int getIntSettingValue(QVariant key);
    Q_INVOKABLE bool getBoolSettingValue(QVariant key);
    Q_INVOKABLE void setBoolSettingValue(QVariant key, QVariant value);
    Q_INVOKABLE int getTotalMemPoints(void);
    Q_INVOKABLE void setTotalMemPoints(QVariant point);
    Q_INVOKABLE void addOneMemPoint(void);


private:
    QSettings *settings;
};
#endif // BACKEND_H
