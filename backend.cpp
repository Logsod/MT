#include "backend.h"



Backend::Backend()
{
    settings = new QSettings("memoryTrain.ini", QSettings::IniFormat);
    if(!settings->contains("g_1_easy_unlock"))
        settings->setValue("g_1_easy_unlock",true);
    if(!settings->contains("g_2_easy_unlock"))
        settings->setValue("g_2_easy_unlock",true);
    if(!settings->contains("g_3_easy_unlock"))
        settings->setValue("g_3_easy_unlock",true);

    //qDebug () << QDir(QCoreApplication::applicationFilePath());
}

void Backend::setSetting(QVariant key, QVariant val)
{
    settings->setValue(key.toString(),val);
    settings->sync();
}

int Backend::getIntSettingValue(QVariant key)
{
    return settings->value(key.toString(),-1).toInt();
}

bool Backend::getBoolSettingValue(QVariant key)
{
    if(!settings->contains(key.toString()))
        return false;
    return settings->value(key.toString(),false).toBool();
}

void Backend::setBoolSettingValue(QVariant key, QVariant value)
{
    settings->setValue(key.toString(), value.toBool());
    settings->sync();
}

int Backend::getTotalMemPoints()
{
    if(!settings->contains("memPoints"))
        return 0;
    return settings->value("memPoints").toInt();
}

void Backend::setTotalMemPoints(QVariant point)
{
    settings->setValue("memPoints",point.toInt());
    settings->sync();
}

void Backend::addOneMemPoint()
{
    if(settings->contains("memPoints"))
    {
        int currentPoint = settings->value("memPoints").toInt();
        settings->setValue("memPoints",currentPoint +1);
    }
    else
    {
        settings->setValue("memPoints", 1);
    }
    settings->sync();
}
