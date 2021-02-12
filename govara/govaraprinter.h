#ifndef GOVARAPRINTER_H
#define GOVARAPRINTER_H

#include <QTextStream>
#include <QFile>
#include <QDir>
#include <QProcess>
#include <QString>
#include <QVariant>
#include <QVariantList>
#include <QVariantMap>
#include <QCoreApplication>
#include "govarautils.h"

class GovaraPrinter
{
public:
    GovaraPrinter();
    bool print(QString document, QString path, QString name);
    QString print_service(QString print_title, QString server_name, QString server_phone, QString server_address, QString customer_name, QString customer_date, QString customer_economical, QVariantList parts, QString costs_tax);

private:
};

#endif // GOVARAPRINTER_H
