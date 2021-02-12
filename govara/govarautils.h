#ifndef GOVARAUTILS_H
#define GOVARAUTILS_H

#include <QVariant>
#include <QVariantList>
#include <QString>
#include <QDate>
#include <QDateTime>
#include <qdateconvertor.h>

class GovaraUtils
{
public:
    GovaraUtils();
    QString date(QString date);
    QString price(QString price);
    QString string(QString price);
    QString current();
    int gape(QString date, QString distance);
    int distance(QString date);
    int weekday_jalali(QVariantList date);
    QVariantList to_jalali(QVariantList date);
    QVariantList to_georgian(QVariantList date);
};

#endif // GOVARAUTILS_H
