#ifndef GOVARACONNECTION_H
#define GOVARACONNECTION_H

#include <QObject>
#include <QSettings>
#include <QProcess>
#include <QFile>
#include <QDir>
#include <QTextStream>
#include <QJsonObject>
#include <QStringList>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDate>
#include <QDateTime>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QStandardPaths>
#include <QJSValue>
#include <QJSValueList>
#include "govarautils.h"
#include "govaraprinter.h"

class GovaraConnection : public QObject
{
    Q_OBJECT
public:
    explicit GovaraConnection(QObject *parent = nullptr);

    Q_INVOKABLE void set_customer(QString cid, QString date, QString name, QString refrence, QString distance, QString phone, QString address, QString explaintion);
    Q_INVOKABLE void get_customer(QString cid);
    Q_INVOKABLE void remove_customer(QString cid);
    Q_INVOKABLE void all_customer(QVariantList filter, int size, bool clear);
    Q_INVOKABLE void load_customer(QVariantList filter, int size, QJSValue callback);

    Q_INVOKABLE void set_service(QString sid, QString cid, QString date, QString parts, QString advanced, QString instalments, QString surety, QString explaintion);
    Q_INVOKABLE void get_service(QString sid);
    Q_INVOKABLE void remove_service(QString sid);
    Q_INVOKABLE void all_service(QVariantList filter, int size, bool clear);
    Q_INVOKABLE void load_service(QVariantList filter, int size, QJSValue callback);
    Q_INVOKABLE bool print_service(QString print_title, QString server_name, QString server_phone, QString server_address, QString customer_name, QString customer_date, QString customer_economical, QVariantList parts, QString costs_tax);

    Q_INVOKABLE void set_instalment(QString iid, QString cid, QString sid, QString date, QString amount, QString payment);
    Q_INVOKABLE void get_instalment(QString iid);
    Q_INVOKABLE void remove_instalment(QString iid);
    Q_INVOKABLE void all_instalment(QVariantList filter, int size, bool clear);
    Q_INVOKABLE void load_instalment(QVariantList filter, int size, QJSValue callback);

    Q_INVOKABLE void set_part(QString pid, QString name, QString price);
    Q_INVOKABLE void get_part(QString pid);
    Q_INVOKABLE void remove_part(QString pid);
    Q_INVOKABLE void all_part(QVariantList filter, int size, bool clear);
    Q_INVOKABLE void load_part(QVariantList filter, int size, QJSValue callback);

    Q_INVOKABLE QString date(QString date);
    Q_INVOKABLE QString price(QString price);
    Q_INVOKABLE QString current();
    Q_INVOKABLE int gape(QString date, QString distance);
    Q_INVOKABLE int distance(QString date);
    Q_INVOKABLE int weekday_jalali(QVariantList date);
    Q_INVOKABLE QVariantList to_jalali(QVariantList date);
    Q_INVOKABLE QVariantList to_georgian(QVariantList date);

    Q_INVOKABLE QString period_database(QString period);
    Q_INVOKABLE QString date_database();
    Q_INVOKABLE bool clear_database();
    Q_INVOKABLE bool export_database();
    Q_INVOKABLE bool import_database(QString path);

signals:
    void setCustomer(QString cid, QString date, QString name, QString refrence, QString distance);
    void getCustomer(QString cid, QString date, QString name, QString refrence, QString distance, QString phone, QString address, QString explaintion);
    void removeCustomer(QString cid);
    void endCustomer(int count);
    void clearCustomer();

    void setService(QString sid, QString name, QString date, QString parts);
    void getService(QString sid, QString cid, QString name, QString date, QString parts, QString advanced, QString instalments, QString surety, QString explaintion);
    void removeService(QString sid);
    void endService(int count);
    void clearService();

    void setInstalment(QString iid, QString name, QString date, QString amount, QString payment);
    void getInstalment(QString iid, QString cid, QString name, QString sid, QString date, QString amount, QString payment);
    void removeInstalment(QString iid);
    void endInstalment(int count);
    void clearInstalment();

    void setPart(QString pid, QString name, QString price);
    void getPart(QString pid, QString name, QString price);
    void removePart(QString pid);
    void endPart(int count);
    void clearPart();

public slots:


private:
    QString govara_connection_splitter = QDir::separator();
    QString govara_connection_basepath = QDir::toNativeSeparators(QStandardPaths::writableLocation(QStandardPaths::HomeLocation));
    QString govara_connection_govarapath = govara_connection_basepath + govara_connection_splitter + "Govara" + govara_connection_splitter;
    QString govara_connection_dbpath = govara_connection_govarapath + "Govara.db";
    QString govara_connection_inipath = govara_connection_govarapath + "Govara.ini";
    QString govara_connection_backuppath = govara_connection_govarapath + "Backup" + govara_connection_splitter;
    QString govara_connection_exportpath = govara_connection_govarapath + "Export" + govara_connection_splitter;
    QString govara_connection_printpath = govara_connection_govarapath + "Print" + govara_connection_splitter;
    QSqlDatabase govara_connection_database;
    QSettings *govara_conection_setting;
    //"/Govara/govara.db"
};

#endif // GOVARACONNECTION_H
