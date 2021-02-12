#include "govaraprinter.h"

GovaraPrinter::GovaraPrinter(){

}

bool GovaraPrinter::print(QString document, QString path, QString name){
    QFile *file = new QFile(path+name+".html");
    file->remove();
    file->open(QIODevice::ReadWrite);
    QTextStream *writer = new QTextStream(file);
    writer->setCodec("UTF-8");
    writer->setGenerateByteOrderMark(true);
    *writer << document;
    file->close();
    QProcess process;
    QString wkhtmltopdf = QDir::toNativeSeparators(QCoreApplication::applicationDirPath()) + QDir::separator() + "wkhtmltopdf.exe ";
    process.setWorkingDirectory(path);
    process.start(wkhtmltopdf + name + ".html " + name);
    process.waitForFinished();
    return true;
}

QString GovaraPrinter::print_service(QString print_title, QString server_name, QString server_phone, QString server_address, QString customer_name, QString customer_date, QString customer_economical, QVariantList parts, QString costs_tax){
    GovaraUtils *utils = new GovaraUtils;
    QString document = QString::fromUtf8(R"(
               <!DOCTYPE html>
               <html lang="fa">
               <head>
                   <meta charset="UTF-8">
                   <title>Title</title>
               </head>
               <body dir="rtl">
               <style>
                   html, body {
                       font-family:Arial;
                       width: 100%;
                       padding-top: 1cm;
                       padding-left: 1cm;
                   }
                   table{
                       margin: 0 auto 0;
                   }
                   table, th, td {
                       padding: 5px;
                       border: 2px solid black;
                       border-collapse: collapse;
                   }
                   td{text-align: center;}
                   .bold {font-weight: bold;}
                   .big {font-size: 22px;}
               </style>
               <div class="space-top"></div>
                                         <table>
                                             <tr>
                                                 <td colspan="10" class="bold big">
                                                     %print_title
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td colspan="10" class="bold big">
                                                     مشخصات سرویس دهنده
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td colspan="5">
                                                     <span class="bold">
                                                         سرویس دهنده :
                                                     </span>
                                                     <span>
                                                         %server_name
                                                     </span>
                                                 </td>
                                                 <td colspan="5">
                                                     <span class="bold">
                                                         تلفن تماس :
                                                     </span>
                                                     <span>
                                                         %server_phone
                                                     </span>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td colspan="10">
                                                     <span class="bold">
                                                         آدرس :
                                                     </span>
                                                     <span>
                                                         %server_address
                                                     </span>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td colspan="10" class="bold big">
                                                     مشخصات مشتری
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td colspan="4">
                                                     <span class="bold">
                                                         نام مشتری :
                                                     </span>
                                                     <span>
                                                         %customer_name
                                                     </span>
                                                 </td>
                                                 <td colspan="3">
                                                     <span class="bold">
                                                         تاریخ سرویس :
                                                     </span>
                                                     <span>
                                                         %customer_date
                                                     </span>
                                                 </td>
                                                 <td colspan="3">
                                                     <span class="bold">
                                                         شماره اقتصادی :
                                                     </span>
                                                     <span>
                                                         %customer_economical
                                                     </span>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td colspan="10" class="bold big">
                                                     مشخصات کالا ها
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td colspan="1">
                                                     ردیف
                                                 </td>
                                                 <td colspan="2">
                                                     شرح کالا
                                                 </td>
                                                 <td colspan="1">
                                                     تعداد
                                                 </td>
                                                 <td colspan="3">
                                                     مبلغ واحد
                                                 </td>
                                                 <td colspan="3">
                                                     مبلغ کل
                                                 </td>
                                             </tr>
                                             %parts
                                             <tr>
                                                 <td colspan="10" class="bold big">
                                                     صورت حساب
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td colspan="8">
                                                     جمع کل
                                                 </td>
                                                 <td colspan="2">
                                                     %costs_sum
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td colspan="8">
                                                     مالیات بر ارزش افزوده ( %costs_tax_percent )
                                                 </td>
                                                 <td colspan="2">
                                                     %costs_tax_price
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td colspan="8">
                                                     جمع کل به عدد
                                                 </td>
                                                 <td colspan="2">
                                                     %costs_final_number
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td colspan="8">
                                                     جمع کل به حروف
                                                 </td>
                                                 <td colspan="2">
                                                     %costs_final_string
                                                 </td>
                                             </tr>
                                         </table>
               </body>
               </html>
               )");
    document = document.replace("%print_title",print_title);
    document = document.replace("%server_name",server_name);
    document = document.replace("%server_phone",server_phone);
    document = document.replace("%server_address",server_address);
    document = document.replace("%customer_name",customer_name);
    document = document.replace("%customer_date",utils->date(customer_date));
    document = document.replace("%customer_economical",customer_economical);
    double parts_sum = 0;
    QString parts_result = "";
    for(int cursor = 0 ; cursor < parts.size() ; cursor++){
        QVariantMap value = parts.at(cursor).value<QVariantMap>();
        QString part_result = R"(
                       <tr>
                           <td colspan="1">
                               %part_index
                           </td>
                           <td colspan="2">
                               %part_name
                           </td>
                           <td colspan="1">
                               %part_number
                           </td>
                           <td colspan="3">
                               %part_price
                           </td>
                           <td colspan="3">
                               %part_sum
                           </td>
                       </tr>
                       )";
        double part_sum = value.value("number").toDouble()*value.value("price").toDouble();
        part_result.replace("%part_index",QString::number(cursor+1,'g',10));
        part_result.replace("%part_name",value.value("name").toString());
        part_result.replace("%part_number",value.value("number").toString());
        part_result.replace("%part_price",utils->price(value.value("price").toString()) + " ریال");
        part_result.replace("%part_sum",utils->price(QString::number(part_sum,'g',10)) + " ریال");
        parts_sum += part_sum;
        parts_result += part_result;
    }
    document = document.replace("%parts",parts_result);
    document = document.replace("%costs_sum",utils->price(QString::number(parts_sum,'g',10)) + " ریال");
    document = document.replace("%costs_tax_percent","%"+costs_tax);
    document = document.replace("%costs_tax_price",utils->price(QString::number(((int) parts_sum * costs_tax.toInt() / 100),'g',10)) + " ریال");
    document = document.replace("%costs_final_number",utils->price(QString::number(((int) parts_sum * (100 + costs_tax.toInt()) / 100),'g',10)) + " ریال");
    document = document.replace("%costs_final_string",utils->string(QString::number(((int) parts_sum * (100 + costs_tax.toInt()) / 100),'g',10)) + " ریال");
    return document;
}
