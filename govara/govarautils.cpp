#include "govarautils.h"

GovaraUtils::GovaraUtils(){}

QString GovaraUtils::date(QString date){
    if(date.length() <= 0){
        return "";
    }
    QDateConvertor *convertor = new QDateConvertor();
    QDateTime datetime = QDateTime::fromTime_t(date.toDouble()/1000);
    QStringList list = convertor->ToJalali(QString::number(datetime.date().year()),QString::number(datetime.date().month()),QString::number(datetime.date().day()));
    return list.at(0)+"/"+list.at(1)+"/"+list.at(2);
}
QString GovaraUtils::price(QString price){
    QString result = "";
    for(int cursor = price.length() - 1 ; cursor >= 0 ; cursor--){
        if((price.length() - cursor) % 3 == 1 && cursor < price.length() - 1){
            result = "," + result;
        }
        result = price.at(cursor) + result;
    }
    return result;
}
QString GovaraUtils::string(QString price){
    auto stepsString = [](QString step) {
        return " " + step + " ";
    };

    QString strAnd = QString::fromUtf8(" و ");
    QString units[] = {"صفر", "یک", "دو", "سه", "چهار", "پنج", "شش", "هفت", "هشت", "نه","ده", "یازده", "دوازده", "سیزده", "چهارده", "پانزده", "شانزده", "هفده", "هجده", "نوزده"};
    QString dahgan[] = {"", "", "بیست", "سی", "چهل", "پنجاه", "شصت", "هفتاد", "هشتاد", "نود"};
    QString sadghan[] = {"", "یکصد", "دویست", "سیصد", "چهارصد", "پانصد", "ششصد", "هفتصد", "هشتصد", "نهصد"};
    QString steps[] = {"هزار", "میلیون", "میلیارد", "تریلیون", "کادریلیون", "کوینتریلیون","سکستریلیون", "سپتریلیون", "اکتریلیون", "نونیلیون", "دسیلیون"};

    int i = price.toInt();
    if (i < 20){
        return units[(int) i];
    }
    if (i < 100){
        return dahgan[(int) (i / 10)] + ((i % 10 > 0) ? strAnd + string(QString::number(i % 10)) : "");
    }
    if (i < 1000){
        return sadghan[(int) (i / 100)] + ((i % 100 > 0) ? strAnd + string(QString::number(i % 100)) : "");
    }
    if (i < 1000000){
       return string(QString::number(i / 1000)) + stepsString(steps[0]) + ((i % 1000 > 0) ? strAnd + string(QString::number(i % 1000)) : "");
    }
    if (i < 1000000000){
       return string(QString::number(i / 1000000)) + stepsString(steps[1]) + ((i % 1000000 > 0) ? strAnd + string(QString::number(i % 1000000)) : "");
    }
    return string(QString::number(i / 1000000000)) + stepsString(steps[2]) + ((i % 1000000000 > 0) ? strAnd + string(QString::number(i % 1000000000)) : "");
}
QString GovaraUtils::current(){
    return QString::number(QDateTime::currentMSecsSinceEpoch());
}
int GovaraUtils::gape(QString date, QString distance){
    if(date.length() <= 0 || distance.length() <= 0){
        return -1;
    }
    int days = (QDateTime(QDate::currentDate()).toMSecsSinceEpoch() - date.toDouble()) / 86400000;
    return distance.toInt() - (days % distance.toInt());
}
int GovaraUtils::distance(QString date){
    if(date.length() <= 0){
        return -1;
    }
    return (date.toDouble() - QDateTime(QDate::currentDate()).toMSecsSinceEpoch()) / 86400000;
}
int GovaraUtils::weekday_jalali(QVariantList date){
    QDateConvertor *convertor = new QDateConvertor();
    return convertor->WeekDayJalali(date.at(0).value<QString>(),date.at(1).value<QString>(),date.at(2).value<QString>());
}
QVariantList GovaraUtils::to_jalali(QVariantList date){
    QDateConvertor *convertor = new QDateConvertor();
    QStringList list = convertor->ToJalali(date.at(0).value<QString>(),date.at(1).value<QString>(),date.at(2).value<QString>());
    QVariantList result;
    result.append(list.at(0));
    result.append(list.at(1));
    result.append(list.at(2));
    return result;
}
QVariantList GovaraUtils::to_georgian(QVariantList date){
    QDateConvertor *convertor = new QDateConvertor();
    QStringList list = convertor->ToMiladi(date.at(0).value<QString>(),date.at(1).value<QString>(),date.at(2).value<QString>());
    QVariantList result;
    result.append(list.at(0));
    result.append(list.at(1));
    result.append(list.at(2));
    return result;
}
