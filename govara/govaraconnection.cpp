#include "govaraconnection.h"
#include <QDebug>
#include <QDateTime>
#include <qdateconvertor.h>
GovaraConnection::GovaraConnection(QObject *parent) : QObject(parent){
    QDir base_dir(govara_connection_basepath);
    base_dir.mkdir("Govara");
    QDir govara_dir(govara_connection_govarapath);
    govara_dir.mkdir("Backup");
    govara_dir.mkdir("Export");
    govara_dir.mkdir("Print");
    govara_connection_database = QSqlDatabase::addDatabase("QSQLITE","GOVARA");
    govara_connection_database.setDatabaseName(govara_connection_dbpath);
    govara_connection_database.open();
    govara_conection_setting = new QSettings(govara_connection_inipath,QSettings::NativeFormat);
    QSqlQuery init_query(govara_connection_database);
    init_query.exec("CREATE TABLE IF NOT EXISTS customers(cid INTEGER PRIMARY KEY, date INTEGER, name TEXT, refrence TEXT, distance INTEGER, phone TEXT, address TEXT, explaintion TEXT)");
    init_query.exec("CREATE TABLE IF NOT EXISTS services(sid INTEGER PRIMARY KEY, cid INTEGER, date INTEGER, parts TEXT, advanced INTEGER, instalments TEXT, surety INTEGER, explaintion TEXT)");
    init_query.exec("CREATE TABLE IF NOT EXISTS instalments(iid INTEGER PRIMARY KEY, cid INTEGER, sid INTEGER, date INTEGER, amount INTEGER, payment TEXT)");
    init_query.exec("CREATE TABLE IF NOT EXISTS parts(pid INTEGER PRIMARY KEY, name TEXT, price INTEGER)");
    if(!govara_conection_setting->contains("BACKUP_PERIOD")){govara_conection_setting->setValue("BACKUP_PERIOD","5");}
    period_database(govara_conection_setting->value("BACKUP_PERIOD").toString());


    double t = QDateTime::currentMSecsSinceEpoch();
    for(int a = 0 ; a < 1000 ; a++){

        qDebug() << QDateTime::fromMSecsSinceEpoch(t + a * 86400000).toString();
    }
}

void GovaraConnection::set_customer(QString cid, QString date, QString name, QString refrence, QString distance, QString phone, QString address, QString explaintion){
    // insert customer
    // add list item
    QSqlQuery set_query(govara_connection_database);
    set_query.prepare("INSERT INTO customers(cid) VALUES(:cid)");
    set_query.bindValue(":cid",cid);
    set_query.exec();
    QSqlQuery update_query(govara_connection_database);
    update_query.prepare("UPDATE customers SET date=(:date) , name=(:name) , refrence=(:refrence) , distance=(:distance) , phone=(:phone) , address=(:address) , explaintion=(:explaintion) WHERE cid=(:cid)");
    update_query.bindValue(":date",date);
    update_query.bindValue(":name",name);
    update_query.bindValue(":refrence",refrence);
    update_query.bindValue(":distance",distance);
    update_query.bindValue(":phone",phone);
    update_query.bindValue(":address",address);
    update_query.bindValue(":explaintion",explaintion);
    update_query.bindValue(":cid",cid);
    update_query.exec();
    emit setCustomer(cid,date,name,refrence,distance);
}
void GovaraConnection::get_customer(QString cid){
    // add detail item
    QSqlQuery get_query(govara_connection_database);
    get_query.prepare("SELECT * FROM customers WHERE cid=(:cid)");
    get_query.bindValue(":cid",cid);
    get_query.exec();
    if(get_query.next()){
        QString date = get_query.value("date").toString();
        QString name = get_query.value("name").toString();
        QString refrence = get_query.value("refrence").toString();
        QString distance = get_query.value("distance").toString();
        QString phone = get_query.value("phone").toString();
        QString address = get_query.value("address").toString();
        QString explaintion = get_query.value("explaintion").toString();
        emit getCustomer(cid,date,name,refrence,distance,phone,address,explaintion);
    }
}
void GovaraConnection::remove_customer(QString cid){
    // remove customer
    // remove list item
    // remove detail item
    QSqlQuery remove_query(govara_connection_database);
    remove_query.prepare("DELETE FROM customers WHERE cid=(:cid)");
    remove_query.bindValue(":cid",cid);
    remove_query.exec();
    emit removeCustomer(cid);
}
void GovaraConnection::all_customer(QVariantList filter, int size, bool clear){
    // filter :
    //      [a,b,c,...]
    //      a :
    //          [name,operate,value]
    //      operator :
    //          = != < > <= >= ~
    // load customer
    // add list item
    if(clear){
        emit clearCustomer();
    }
    int count = 0;
    QString order = "ASC";
    QString query = "";
    for(int cursor = 0 ; cursor < filter.size() ; cursor++){
        QVariantList item = filter.at(cursor).value<QVariantList>();
        QString name = item.at(0).value<QString>();
        QString operate = item.at(1).value<QString>();
        QString value = item.at(2).value<QString>();
        query += name + (operate == "~" ? " LIKE " : operate) + (operate == "~" ? "'%"+value+"%'" : "'"+value+"'") + (cursor == filter.size()-1 ? "" : " AND ");
        if(name == "cid"){
            order = (operate == ">") ? "ASC" : "DESC";
        }
    }
    query = "SELECT * FROM customers" + (query == "" ? "" : " WHERE "+query) + " ORDER BY `cid` "+order+" LIMIT "+QString::number(size);
    QSqlQuery all_query(govara_connection_database);
    all_query.prepare(query);
    all_query.exec();
    while(all_query.next()){
        QString cid = all_query.value("cid").toString();
        QString date = all_query.value("date").toString();
        QString name = all_query.value("name").toString();
        QString refrence = all_query.value("refrence").toString();
        QString distance = all_query.value("distance").toString();
        emit setCustomer(cid,date,name,refrence,distance);
        count++;
    }
    emit endCustomer(count);
}
void GovaraConnection::load_customer(QVariantList filter, int size, QJSValue callback){
    int count = 0;
    QString order = "ASC";
    QString query = "";
    for(int cursor = 0 ; cursor < filter.size() ; cursor++){
        QVariantList item = filter.at(cursor).value<QVariantList>();
        QString name = item.at(0).value<QString>();
        QString operate = item.at(1).value<QString>();
        QString value = item.at(2).value<QString>();
        query += name + (operate == "~" ? " LIKE " : operate) + (operate == "~" ? "'%"+value+"%'" : "'"+value+"'") + (cursor == filter.size()-1 ? "" : " AND ");
        if(name == "cid"){
            order = (operate == ">") ? "ASC" : "DESC";
        }
    }
    query = "SELECT * FROM customers" + (query == "" ? "" : " WHERE "+query) + " ORDER BY `cid` "+order+" LIMIT "+QString::number(size);
    QSqlQuery all_query(govara_connection_database);
    all_query.prepare(query);
    all_query.exec();
    while(all_query.next()){
        QString cid = all_query.value("cid").toString();
        QString date = all_query.value("date").toString();
        QString name = all_query.value("name").toString();
        QString refrence = all_query.value("refrence").toString();
        QString distance = all_query.value("distance").toString();
        QJSValueList args;
        args << cid << date << name << refrence << distance;
        callback.call(args);
        count++;
    }
    QJSValueList args;
    args << count << "" << "" << "" << "";
    callback.call(args);
}

void GovaraConnection::set_service(QString sid, QString cid, QString date, QString parts, QString advanced, QString instalments, QString surety, QString explaintion){
    // set instalments
    QString old_instalments = "[]";
    {
        QSqlQuery instalments_query(govara_connection_database);
        instalments_query.prepare("SELECT instalments FROM services WHERE sid=(:sid)");
        instalments_query.bindValue(":sid",sid);
        instalments_query.exec();
        if(instalments_query.next()){
            old_instalments = instalments_query.value("instalments").toString();
        }
    }
    QJsonArray instalments_array = QJsonDocument::fromJson(instalments.toUtf8()).array();
    QJsonArray old_instalments_array = QJsonDocument::fromJson(old_instalments.toUtf8()).array();
    QJsonArray result_instalments_array = QJsonDocument::fromJson("[]").array();
    foreach (QJsonValue old_value, old_instalments_array) {
        QString old_iid = old_value.toString();
        foreach(QJsonValue value , instalments_array){
            if(value.toObject().value("iid").toString() == old_iid){
                old_iid == "";
                break;
            }
        }
        if(old_iid != ""){
            remove_instalment(old_iid);
        }
    }
    foreach(QJsonValue value , instalments_array){
        QJsonObject instalment_object = value.toObject();
        result_instalments_array.append(QJsonValue(instalment_object.value("iid").toString()));
        set_instalment(instalment_object.value("iid").toString(),cid,sid,instalment_object.value("date").toString(),instalment_object.value("amount").toString(),"");
    }
    // insert service
    // add list item
    QSqlQuery set_query(govara_connection_database);
    set_query.prepare("INSERT INTO services(sid) VALUES(:sid)");
    set_query.bindValue(":sid",sid);
    set_query.exec();
    QSqlQuery update_query(govara_connection_database);
    update_query.prepare("UPDATE services SET cid=(:cid) , date=(:date) , parts=(:parts) , advanced=(:advanced) , instalments=(:instalments) , surety=(:surety) , explaintion=(:explaintion) WHERE sid=(:sid)");
    update_query.bindValue(":cid",cid);
    update_query.bindValue(":date",date);
    update_query.bindValue(":parts",parts);
    update_query.bindValue(":advanced",advanced);
    update_query.bindValue(":instalments",QString(QJsonDocument(result_instalments_array).toJson()));
    update_query.bindValue(":surety",surety);
    update_query.bindValue(":explaintion",explaintion);
    update_query.bindValue(":sid",sid);
    update_query.exec(); 
    QString name = "";
    {
        QSqlQuery name_query(govara_connection_database);
        name_query.prepare("SELECT name FROM customers WHERE cid=(:cid)");
        name_query.bindValue(":cid",cid);
        name_query.exec();
        if(name_query.next()){
            name = name_query.value("name").toString();
        }
    }
    emit setService(sid,name,date,parts);
}
void GovaraConnection::get_service(QString sid){
    // add detail item
    QSqlQuery get_query(govara_connection_database);
    get_query.prepare("SELECT * FROM services WHERE sid=(:sid)");
    get_query.bindValue(":sid",sid);
    get_query.exec();
    if(get_query.next()){
        QString cid = get_query.value("cid").toString();
        QString date = get_query.value("date").toString();
        QString parts = get_query.value("parts").toString();
        QString advanced = get_query.value("advanced").toString();
        QString instalments = get_query.value("instalments").toString();
        QString surety = get_query.value("surety").toString();
        QString explaintion = get_query.value("explaintion").toString();
        QString name = "";
        {
            QSqlQuery name_query(govara_connection_database);
            name_query.prepare("SELECT name FROM customers WHERE cid=(:cid)");
            name_query.bindValue(":cid",cid);
            name_query.exec();
            if(name_query.next()){
                name = name_query.value("name").toString();
            }
        }
        emit getService(sid,cid,name,date,parts,advanced,instalments,surety,explaintion);
    }
}
void GovaraConnection::remove_service(QString sid){
    // remove instalments
    QString instalments = "[]";
    {
        QSqlQuery instalments_query(govara_connection_database);
        instalments_query.prepare("SELECT instalments FROM services WHERE sid=(:sid)");
        instalments_query.bindValue(":sid",sid);
        instalments_query.exec();
        if(instalments_query.next()){
            instalments = instalments_query.value("instalments").toString();
        }
    }
    QJsonArray instalments_array = QJsonDocument::fromJson(instalments.toUtf8()).array();
    foreach(QJsonValue value , instalments_array){
        remove_instalment(value.toString());
    }
    // remove service
    // remove list item
    // remove detail item
    QSqlQuery remove_query(govara_connection_database);
    remove_query.prepare("DELETE FROM services WHERE sid=(:sid)");
    remove_query.bindValue(":sid",sid);
    remove_query.exec();
    emit removeService(sid);
}
void GovaraConnection::all_service(QVariantList filter, int size, bool clear){
    // filter :
    //      [a,b,c,...]
    //      a :
    //          [name,operate,value]
    //      operator :
    //          = != < > <= >= ~
    // load service
    // add list item
    if(clear){
        emit clearService();
    }
    int count = 0;
    QString order = "ASC";
    QString query = "";
    for(int cursor = 0 ; cursor < filter.size() ; cursor++){
        QVariantList item = filter.at(cursor).value<QVariantList>();
        QString name = item.at(0).value<QString>();
        QString operate = item.at(1).value<QString>();
        QString value = item.at(2).value<QString>();
        query += name + (operate == "~" ? " LIKE " : operate) + (operate == "~" ? "'%"+value+"%'" : "'"+value+"'") + (cursor == filter.size()-1 ? "" : " AND ");
        if(name == "sid"){
            order = (operate == ">") ? "ASC" : "DESC";
        }
    }
    query = "SELECT * FROM services" + (query == "" ? "" : " WHERE "+query) + " ORDER BY `sid` "+order+" LIMIT "+QString::number(size);
    QSqlQuery all_query(govara_connection_database);
    all_query.prepare(query);
    all_query.exec();
    while(all_query.next()){
        QString sid = all_query.value("sid").toString();
        QString cid = all_query.value("cid").toString();
        QString date = all_query.value("date").toString();
        QString parts = all_query.value("parts").toString();
        QString name = "";
        {
            QSqlQuery name_query(govara_connection_database);
            name_query.prepare("SELECT name FROM customers WHERE cid=(:cid)");
            name_query.bindValue(":cid",cid);
            name_query.exec();
            if(name_query.next()){
                name = name_query.value("name").toString();
            }
        }
        emit setService(sid,name,date,parts);
        count++;
    }
    emit endService(count);
}
void GovaraConnection::load_service(QVariantList filter, int size, QJSValue callback){
    int count = 0;
    QString order = "ASC";
    QString query = "";
    for(int cursor = 0 ; cursor < filter.size() ; cursor++){
        QVariantList item = filter.at(cursor).value<QVariantList>();
        QString name = item.at(0).value<QString>();
        QString operate = item.at(1).value<QString>();
        QString value = item.at(2).value<QString>();
        query += name + (operate == "~" ? " LIKE " : operate) + (operate == "~" ? "'%"+value+"%'" : "'"+value+"'") + (cursor == filter.size()-1 ? "" : " AND ");
        if(name == "sid"){
            order = (operate == ">") ? "ASC" : "DESC";
        }
    }
    query = "SELECT * FROM services" + (query == "" ? "" : " WHERE "+query) + " ORDER BY `sid` "+order+" LIMIT "+QString::number(size);
    QSqlQuery all_query(govara_connection_database);
    all_query.prepare(query);
    all_query.exec();
    while(all_query.next()){
        QString sid = all_query.value("sid").toString();
        QString cid = all_query.value("cid").toString();
        QString date = all_query.value("date").toString();
        QString parts = all_query.value("parts").toString();
        QString name = "";
        {
            QSqlQuery name_query(govara_connection_database);
            name_query.prepare("SELECT name FROM customers WHERE cid=(:cid)");
            name_query.bindValue(":cid",cid);
            name_query.exec();
            if(name_query.next()){
                name = name_query.value("name").toString();
            }
        }
        QJSValueList args;
        args << sid << name << date << parts;
        callback.call(args);
        count++;
    }
    QJSValueList args;
    args << count << "" << "" << "";
    callback.call(args);
}
bool GovaraConnection::print_service(QString print_title, QString server_name, QString server_phone, QString server_address, QString customer_name, QString customer_date, QString customer_economical, QVariantList parts, QString costs_tax){
    QDir print_dir(govara_connection_backuppath);
    print_dir.mkdir(customer_name);
    QString date = QString::number(QDateTime::currentMSecsSinceEpoch());
    QString path = govara_connection_backuppath + customer_name + govara_connection_splitter;
    QString name = date + ".pdf";
    GovaraPrinter *printer = new GovaraPrinter;
    QString document = printer->print_service(print_title,server_name,server_phone,server_address,customer_name,customer_date,customer_economical,parts,costs_tax);
    if(!printer->print(document,path,name)){
        return false;
    }
    QFile file(govara_connection_printpath+"print.pdf");
    file.remove();
    QFile::copy(path+name,govara_connection_printpath+"print.pdf");
    QProcess process;
    process.execute("explorer "+govara_connection_printpath);
    return true;
}

void GovaraConnection::set_instalment(QString iid, QString cid, QString sid, QString date, QString amount, QString payment){
    // update service
    QString instalments = "[]";
    {
        QSqlQuery instalments_query(govara_connection_database);
        instalments_query.prepare("SELECT instalments FROM services WHERE sid=(:sid)");
        instalments_query.bindValue(":sid",sid);
        instalments_query.exec();
        if(instalments_query.next()){
            instalments = instalments_query.value("instalments").toString();
        }
    }
    QJsonArray instalments_array = QJsonDocument::fromJson(instalments.toUtf8()).array();
    if(!instalments_array.contains(QJsonValue(iid))){
        instalments_array.append(QJsonValue(iid));
    }
    {
        QSqlQuery instalments_query(govara_connection_database);
        instalments_query.prepare("UPDATE services SET instalments=(:instalments) WHERE sid=(:sid)");
        instalments_query.bindValue(":instalments",QString(QJsonDocument(instalments_array).toJson()));
        instalments_query.bindValue(":sid",sid);
        instalments_query.exec();
    }
    // insert instalment
    // add list item
    QSqlQuery set_query(govara_connection_database);
    set_query.prepare("INSERT INTO instalments(iid) VALUES(:iid)");
    set_query.bindValue(":iid",iid);
    set_query.exec();
    QSqlQuery update_query(govara_connection_database);
    update_query.prepare("UPDATE instalments SET cid=(:cid) , sid=(:sid) , date=(:date) , amount=(:amount) , payment=(:payment) WHERE iid=(:iid)");
    update_query.bindValue(":cid",cid);
    update_query.bindValue(":sid",sid);
    update_query.bindValue(":date",date);
    update_query.bindValue(":amount",amount);
    update_query.bindValue(":payment",payment);
    update_query.bindValue(":iid",iid);
    update_query.exec();
    QString name = "";
    {
        QSqlQuery name_query(govara_connection_database);
        name_query.prepare("SELECT name FROM customers WHERE cid=(:cid)");
        name_query.bindValue(":cid",cid);
        name_query.exec();
        if(name_query.next()){
            name = name_query.value("name").toString();
        }
    }
    emit setInstalment(iid,name,date,amount,payment);
}
void GovaraConnection::get_instalment(QString iid){
    // add detail item
    QSqlQuery get_query(govara_connection_database);
    get_query.prepare("SELECT * FROM instalments WHERE iid=(:iid)");
    get_query.bindValue(":iid",iid);
    get_query.exec();
    if(get_query.next()){
        QString iid = get_query.value("iid").toString();
        QString cid = get_query.value("cid").toString();
        QString sid = get_query.value("sid").toString();
        QString date = get_query.value("date").toString();
        QString amount = get_query.value("amount").toString();
        QString payment = get_query.value("payment").toString();
        QString name = "";
        {
            QSqlQuery name_query(govara_connection_database);
            name_query.prepare("SELECT name FROM customers WHERE cid=(:cid)");
            name_query.bindValue(":cid",cid);
            name_query.exec();
            if(name_query.next()){
                name = name_query.value("name").toString();
            }
        }
        emit getInstalment(iid,cid,name,sid,date,amount,payment);
    }
}
void GovaraConnection::remove_instalment(QString iid){
    // remove from service
    QString sid = "";
    {
        QSqlQuery sid_query(govara_connection_database);
        sid_query.prepare("SELECT sid FROM instalments WHERE iid=(:iid)");
        sid_query.bindValue(":iid",iid);
        sid_query.exec();
        if(sid_query.next()){
            sid = sid_query.value("sid").toString();
        }
    }
    QString instalments = "[]";
    {
        QSqlQuery instalments_query(govara_connection_database);
        instalments_query.prepare("SELECT instalments FROM services WHERE sid=(:sid)");
        instalments_query.bindValue(":sid",sid);
        instalments_query.exec();
        if(instalments_query.next()){
            instalments = instalments_query.value("instalments").toString();
        }
    }
    QJsonArray instalments_array = QJsonDocument::fromJson(instalments.toUtf8()).array();
    for (int cursor = 0 ; cursor < instalments_array.size() ; cursor++){
        if(instalments_array.at(cursor).toString() == iid){
            instalments_array.removeAt(cursor);
        }
    }
    {
        QSqlQuery instalments_query(govara_connection_database);
        instalments_query.prepare("UPDATE services SET instalments=(:instalments) WHERE sid=(:sid)");
        instalments_query.bindValue(":instalments",QString(QJsonDocument(instalments_array).toJson()));
        instalments_query.bindValue(":sid",sid);
        instalments_query.exec();
    }
    // remove instalment
    // remove list item
    // remove detail item
    QSqlQuery remove_query(govara_connection_database);
    remove_query.prepare("DELETE FROM instalments WHERE iid=(:iid)");
    remove_query.bindValue(":iid",iid);
    remove_query.exec();
    emit removeInstalment(iid);
}
void GovaraConnection::all_instalment(QVariantList filter, int size, bool clear){
    // filter :
    //      [a,b,c,...]
    //      a :
    //          [name,operate,value]
    //      operator :
    //          = != < > <= >= ~
    // load instalment
    // add list item
    if(clear){
        emit clearInstalment();
    }
    int count = 0;
    QString order = "ASC";
    QString query = "";
    for(int cursor = 0 ; cursor < filter.size() ; cursor++){
        QVariantList item = filter.at(cursor).value<QVariantList>();
        QString name = item.at(0).value<QString>();
        QString operate = item.at(1).value<QString>();
        QString value = item.at(2).value<QString>();
        query += name + (operate == "~" ? " LIKE " : operate) + (operate == "~" ? "'%"+value+"%'" : "'"+value+"'") + (cursor == filter.size()-1 ? "" : " AND ");
        if(name == "iid"){
            order = (operate == ">") ? "ASC" : "DESC";
        }
    }
    query = "SELECT * FROM instalments" + (query == "" ? "" : " WHERE "+query) + " ORDER BY `iid` "+order+" LIMIT "+QString::number(size);
    QSqlQuery all_query(govara_connection_database);
    all_query.prepare(query);
    all_query.exec();
    while(all_query.next()){
        QString iid = all_query.value("iid").toString();
        QString cid = all_query.value("cid").toString();
        QString date = all_query.value("date").toString();
        QString amount = all_query.value("amount").toString();
        QString payment = all_query.value("payment").toString();
        QString name = "";
        {
            QSqlQuery name_query(govara_connection_database);
            name_query.prepare("SELECT name FROM customers WHERE cid=(:cid)");
            name_query.bindValue(":cid",cid);
            name_query.exec();
            if(name_query.next()){
                name = name_query.value("name").toString();
            }
        }
        emit setInstalment(iid,name,date,amount,payment);
        count++;
    }
    emit endInstalment(count);
}
void GovaraConnection::load_instalment(QVariantList filter, int size, QJSValue callback){
    int count = 0;
    QString order = "ASC";
    QString query = "";
    for(int cursor = 0 ; cursor < filter.size() ; cursor++){
        QVariantList item = filter.at(cursor).value<QVariantList>();
        QString name = item.at(0).value<QString>();
        QString operate = item.at(1).value<QString>();
        QString value = item.at(2).value<QString>();
        query += name + (operate == "~" ? " LIKE " : operate) + (operate == "~" ? "'%"+value+"%'" : "'"+value+"'") + (cursor == filter.size()-1 ? "" : " AND ");
        if(name == "iid"){
            order = (operate == ">") ? "ASC" : "DESC";
        }
    }
    query = "SELECT * FROM instalments" + (query == "" ? "" : " WHERE "+query) + " ORDER BY `iid` "+order+" LIMIT "+QString::number(size);
    QSqlQuery all_query(govara_connection_database);
    all_query.prepare(query);
    all_query.exec();
    while(all_query.next()){
        QString iid = all_query.value("iid").toString();
        QString cid = all_query.value("cid").toString();
        QString date = all_query.value("date").toString();
        QString amount = all_query.value("amount").toString();
        QString payment = all_query.value("payment").toString();
        QString name = "";
        {
            QSqlQuery name_query(govara_connection_database);
            name_query.prepare("SELECT name FROM customers WHERE cid=(:cid)");
            name_query.bindValue(":cid",cid);
            name_query.exec();
            if(name_query.next()){
                name = name_query.value("name").toString();
            }
        }
        QJSValueList args;
        args << iid << name << date << amount << payment;
        callback.call(args);
        count++;
    }
    QJSValueList args;
    args << count << "" << "" << "" << "";
    callback.call(args);
}

void GovaraConnection::set_part(QString pid, QString name, QString price){
    // insert part
    // add list item
    QSqlQuery set_query(govara_connection_database);
    set_query.prepare("INSERT INTO parts(pid) VALUES(:pid)");
    set_query.bindValue(":pid",pid);
    set_query.exec();
    QSqlQuery update_query(govara_connection_database);
    update_query.prepare("UPDATE parts SET name=(:name) , price=(:price) WHERE pid=(:pid)");
    update_query.bindValue(":name",name);
    update_query.bindValue(":price",price);
    update_query.bindValue(":pid",pid);
    update_query.exec();
    emit setPart(pid,name,price);
}
void GovaraConnection::get_part(QString pid){
    // add detail item
    QSqlQuery get_query(govara_connection_database);
    get_query.prepare("SELECT * FROM parts WHERE pid=(:pid)");
    get_query.bindValue(":pid",pid);
    get_query.exec();
    if(get_query.next()){
        QString name = get_query.value("name").toString();
        QString price = get_query.value("price").toString();
        emit getPart(pid,name,price);
    }
}
void GovaraConnection::remove_part(QString pid){
    // remove instalment
    // remove list item
    // remove detail item
    QSqlQuery remove_query(govara_connection_database);
    remove_query.prepare("DELETE FROM parts WHERE pid=(:pid)");
    remove_query.bindValue(":pid",pid);
    remove_query.exec();
    emit removePart(pid);
}
void GovaraConnection::all_part(QVariantList filter, int size, bool clear){
    // filter :
    //      [a,b,c,...]
    //      a :
    //          [name,operate,value]
    //      operator :
    //          = != < > <= >= ~
    // load instalment
    // add list item
    if(clear){
        emit clearPart();
    }
    int count = 0;
    QString order = "ASC";
    QString query = "";
    for(int cursor = 0 ; cursor < filter.size() ; cursor++){
        QVariantList item = filter.at(cursor).value<QVariantList>();
        QString name = item.at(0).value<QString>();
        QString operate = item.at(1).value<QString>();
        QString value = item.at(2).value<QString>();
        query += name + (operate == "~" ? " LIKE " : operate) + (operate == "~" ? "'%"+value+"%'" : "'"+value+"'") + (cursor == filter.size()-1 ? "" : " AND ");
        if(name == "pid"){
            order = (operate == ">") ? "ASC" : "DESC";
        }
    }
    query = "SELECT * FROM parts" + (query == "" ? "" : " WHERE "+query) + " ORDER BY `pid` "+order+" LIMIT "+QString::number(size);
    QSqlQuery all_query(govara_connection_database);
    all_query.prepare(query);
    all_query.exec();
    while(all_query.next()){
        QString pid = all_query.value("pid").toString();
        QString name = all_query.value("name").toString();
        QString price = all_query.value("price").toString();
        emit setPart(pid,name,price);
        count++;
    }
    emit endPart(count);
}
void GovaraConnection::load_part(QVariantList filter, int size, QJSValue callback){
    int count = 0;
    QString order = "ASC";
    QString query = "";
    for(int cursor = 0 ; cursor < filter.size() ; cursor++){
        QVariantList item = filter.at(cursor).value<QVariantList>();
        QString name = item.at(0).value<QString>();
        QString operate = item.at(1).value<QString>();
        QString value = item.at(2).value<QString>();
        query += name + (operate == "~" ? " LIKE " : operate) + (operate == "~" ? "'%"+value+"%'" : "'"+value+"'") + (cursor == filter.size()-1 ? "" : " AND ");
        if(name == "pid"){
            order = (operate == ">") ? "ASC" : "DESC";
        }
    }
    query = "SELECT * FROM parts" + (query == "" ? "" : " WHERE "+query) + " ORDER BY `pid` "+order+" LIMIT "+QString::number(size);
    QSqlQuery all_query(govara_connection_database);
    all_query.prepare(query);
    all_query.exec();
    while(all_query.next()){
        QString pid = all_query.value("pid").toString();
        QString name = all_query.value("name").toString();
        QString price = all_query.value("price").toString();
        QJSValueList args;
        args << pid << name << price;
        callback.call(args);
        count++;
    }
    QJSValueList args;
    args << count << "" << "";
    callback.call(args);
}

QString GovaraConnection::date(QString date){
    GovaraUtils *utils = new GovaraUtils;
    return utils->date(date);
}
QString GovaraConnection::price(QString price){
    GovaraUtils *utils = new GovaraUtils;
    return utils->price(price);
}
QString GovaraConnection::current(){
    GovaraUtils *utils = new GovaraUtils;
    return utils->current();
}
int GovaraConnection::gape(QString date, QString distance){
    GovaraUtils *utils = new GovaraUtils;
    return utils->gape(date,distance);
}
int GovaraConnection::distance(QString date){
    GovaraUtils *utils = new GovaraUtils;
    return utils->distance(date);
}
int GovaraConnection::weekday_jalali(QVariantList date){
    GovaraUtils *utils = new GovaraUtils;
    return utils->weekday_jalali(date);
}
QVariantList GovaraConnection::to_jalali(QVariantList date){
    GovaraUtils *utils = new GovaraUtils;
    return utils->to_jalali(date);
}
QVariantList GovaraConnection::to_georgian(QVariantList date){
    GovaraUtils *utils = new GovaraUtils;
    return utils->to_georgian(date);
}

QString GovaraConnection::period_database(QString period){
    if(period.length() > 0){
        govara_conection_setting->setValue("BACKUP_PERIOD",period);
    }
    if(gape(govara_conection_setting->value("BACKUP_DATE").toString(),govara_conection_setting->value("BACKUP_PERIOD").toString()) == 0){
        QString date = QString::number(QDateTime::currentMSecsSinceEpoch());
        QFile::copy(govara_connection_dbpath,govara_connection_backuppath+date+".db");
        govara_conection_setting->setValue("BACKUP_DATE",date);
    }
    return govara_conection_setting->value("BACKUP_PERIOD").toString();
}
QString GovaraConnection::date_database(){
    return govara_conection_setting->value("BACKUP_DATE").toString();
}
bool GovaraConnection::clear_database(){
    QSqlQuery clear_query(govara_connection_database);
    clear_query.exec("DELETE FROM customers");
    clear_query.exec("DELETE FROM services");
    clear_query.exec("DELETE FROM instalments");
    clear_query.exec("DELETE FROM parts");
    return true;
}
bool GovaraConnection::export_database(){
    QString date = QString::number(QDateTime::currentMSecsSinceEpoch());
    govara_conection_setting->setValue("BACKUP_DATE",date);
    QFile::copy(govara_connection_dbpath,govara_connection_backuppath+date+".db");
    QFile file(govara_connection_exportpath+"export.db");
    file.remove();
    QFile::copy(govara_connection_dbpath,govara_connection_exportpath+"export.db");
    QProcess process;
    process.execute("explorer "+govara_connection_exportpath);
    return true;
}
bool GovaraConnection::import_database(QString path){
    QSqlDatabase import_database = QSqlDatabase::addDatabase("QSQLITE","IMPORTER");
    import_database.setDatabaseName(path.replace("file:///","/"));
    if(!import_database.open()){
        return false;
    }
    QSqlQuery import_query(import_database);
    QSqlQuery insert_query(govara_connection_database);
    import_query.exec("SELECT * FROM customers");
    while(import_query.next()){
        QString cid = import_query.value("cid").toString();
        QString date = import_query.value("date").toString();
        QString name = import_query.value("name").toString();
        QString refrence = import_query.value("refrence").toString();
        QString distance = import_query.value("distance").toString();
        QString phone = import_query.value("phone").toString();
        QString address = import_query.value("address").toString();
        QString explaintion = import_query.value("explaintion").toString();
        insert_query.prepare("INSERT INTO customers(cid,date,name,refrence,distance,phone,address,explaintion) VALUES(:cid,:date,:name,:refrence,:distance,:phone,:address,:explaintion)");
        insert_query.bindValue(":cid",cid);
        insert_query.bindValue(":date",date);
        insert_query.bindValue(":name",name);
        insert_query.bindValue(":refrence",refrence);
        insert_query.bindValue(":distance",distance);
        insert_query.bindValue(":phone",phone);
        insert_query.bindValue(":address",address);
        insert_query.bindValue(":explaintion",explaintion);
        insert_query.exec();
    }
    import_query.exec("SELECT * FROM services");
    while(import_query.next()){
        QString sid = import_query.value("sid").toString();
        QString cid = import_query.value("cid").toString();
        QString date = import_query.value("date").toString();
        QString parts = import_query.value("parts").toString();
        QString advanced = import_query.value("advanced").toString();
        QString instalments = import_query.value("instalments").toString();
        QString surety = import_query.value("surety").toString();
        QString explaintion = import_query.value("explaintion").toString();
        insert_query.prepare("INSERT INTO services(sid,cid,date,parts,advanced,instalments,surety,explaintion) VALUES(:sid,:cid,:date,:parts,:advanced,:instalments,:surety,:explaintion)");
        insert_query.bindValue(":sid",sid);
        insert_query.bindValue(":cid",cid);
        insert_query.bindValue(":date",date);
        insert_query.bindValue(":parts",parts);
        insert_query.bindValue(":advanced",advanced);
        insert_query.bindValue(":instalments",instalments);
        insert_query.bindValue(":surety",surety);
        insert_query.bindValue(":explaintion",explaintion);
        insert_query.exec();
    }
    import_query.exec("SELECT * FROM instalments");
    while(import_query.next()){
        QString iid = import_query.value("iid").toString();
        QString cid = import_query.value("cid").toString();
        QString sid = import_query.value("sid").toString();
        QString date = import_query.value("date").toString();
        QString amount = import_query.value("amount").toString();
        QString payment = import_query.value("payment").toString();
        insert_query.prepare("INSERT INTO instalments(iid,cid,sid,date,amount,payment) VALUES(:iid,:cid,:sid,:date,:amount,:payment)");
        insert_query.bindValue(":iid",iid);
        insert_query.bindValue(":cid",cid);
        insert_query.bindValue(":sid",sid);
        insert_query.bindValue(":date",date);
        insert_query.bindValue(":amount",amount);
        insert_query.bindValue(":payment",payment);
        insert_query.exec();
    }
    import_query.exec("SELECT * FROM parts");
    while(import_query.next()){
        QString pid = import_query.value("pid").toString();
        QString name = import_query.value("name").toString();
        QString price = import_query.value("price").toString();
        insert_query.prepare("INSERT INTO parts(pid,name,price) VALUES(:pid,:name,:price)");
        insert_query.bindValue(":pid",pid);
        insert_query.bindValue(":name",name);
        insert_query.bindValue(":price",price);
        insert_query.exec();
    }
    return true;
}
