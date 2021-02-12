#ifndef QDATECONVERTOR_H
#define QDATECONVERTOR_H

#include <QStringList>
#include <QDate>
#include <QMap>

class QDateConvertor
{
public:
    QDateConvertor();
    bool grgIsLeap(int Year);
    bool hshIsLeap(int Year);
    int WeekDayJalali(QString year, QString month, QString day);
    QStringList ToJalali(QString year, QString month, QString day);
    QStringList ToMiladi(QString year, QString month, QString day);
private:
};

#endif // QDATECONVERTOR_H
