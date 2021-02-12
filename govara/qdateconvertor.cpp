#include "qdateconvertor.h"

int grgSumOfDays[2][24]={0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365
                         ,0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366};
int hshSumOfDays[2][24]={0, 31, 62, 93, 124, 155, 186, 216, 246, 276, 306, 336, 365,
                         0, 31, 62, 93, 124, 155, 186, 216, 246, 276, 306, 336, 366};

QDateConvertor::QDateConvertor(){}

bool QDateConvertor::grgIsLeap(int Year){
    return ((Year%4) == 0 && ((Year%100) != 0 || (Year%400) == 0));
}

bool QDateConvertor::hshIsLeap(int Year){
    Year = (Year - 474) % 128;
    Year = ((Year >= 30) ? 0 : 29) + Year;
    Year = Year - floor(Year/33.0) - 1;
    return ((Year % 4) == 0);
}

int QDateConvertor::WeekDayJalali(QString year, QString month, QString day){
    int hshYear = year.toInt();
    int hshMonth = month.toInt();
    int hshDay = day.toInt();
    int value = hshYear - 1376 + hshSumOfDays[0][hshMonth-1] + hshDay - 1;
    for (int i=1380; i<hshYear; i++)
        if (hshIsLeap(i)) value++;
    for (int i=hshYear; i<1380; i++)
        if (hshIsLeap(i)) value--;
    value=value%7;
    if (value<0) value=value+7;
    return (value);
}

QStringList QDateConvertor::ToJalali(QString year, QString month,QString day){
    int grgYear = year.toInt();
    int grgMonth = month.toInt();
    int grgDay = day.toInt();


    int hshYear = grgYear-621;
    int hshMonth,hshDay;

    bool grgLeap = grgIsLeap(grgYear);
    bool hshLeap = hshIsLeap(hshYear-1);

    int hshElapsed;
    int grgElapsed = grgSumOfDays[(grgLeap ? 1:0)][grgMonth-1]+grgDay;

    int XmasToNorooz = (hshLeap && grgLeap) ? 80 : 79;

    if (grgElapsed <= XmasToNorooz)
    {
        hshElapsed = grgElapsed+286;
        hshYear--;
        if (hshLeap && !grgLeap)
            hshElapsed++;
    }
    else
    {
        hshElapsed = grgElapsed - XmasToNorooz;
        hshLeap = hshIsLeap (hshYear);
    }

    for (int i=1; i <= 12 ; i++)
    {
        if (hshSumOfDays [(hshLeap ? 1:0)][i] >= hshElapsed)
        {
            hshMonth = i;
            hshDay = hshElapsed - hshSumOfDays [(hshLeap ? 1:0)][i-1];
            break;
        }
    }
    QStringList jalali;
    jalali << QString::number(hshYear) << QString::number(hshMonth)<< QString::number(hshDay);
    return jalali;
}

QStringList QDateConvertor::ToMiladi(QString year, QString month,QString day ){
    int hshYear=year.toInt();
    int hshMonth=month.toInt();
    int hshDay=day.toInt();

    int grgYear = hshYear+621;
    int grgMonth,grgDay;

    bool hshLeap = hshIsLeap(hshYear);
    bool grgLeap = grgIsLeap(grgYear);

    int hshElapsed=hshSumOfDays [hshLeap ? 1:0][hshMonth-1]+hshDay;
    int grgElapsed;

    if (hshMonth > 10 || (hshMonth == 10 && hshElapsed > 286+(grgLeap ? 1:0)))
    {
        grgElapsed = hshElapsed - (286 + (grgLeap ? 1:0));
        grgLeap = grgIsLeap (++grgYear);
    }
    else
    {
        hshLeap = hshIsLeap (hshYear-1);
        grgElapsed = hshElapsed + 79 + (hshLeap ? 1:0) - (grgIsLeap(grgYear-1) ? 1:0);
    }

    for (int i=1; i <= 12; i++)
    {
        if (grgSumOfDays [grgLeap ? 1:0][i] >= grgElapsed)
        {
            grgMonth = i;
            grgDay = grgElapsed - grgSumOfDays [grgLeap ? 1:0][i-1];
            break;
        }
    }

    QStringList mymiladiDate;
    mymiladiDate <<QString::number(grgYear)<<QString::number(grgMonth)<<QString::number(grgDay);
    return mymiladiDate;
}
