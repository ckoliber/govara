import Fluid.Controls 1.0 as FluidControls
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2

Dialog{
    property string cid
    property string date
    property string name
    property string refrence
    property string distance
    property string phone
    property string address
    property string explaintion
    function openDialog(cid, date, name, refrence, distance, phone, address, explaintion){
        this.cid = cid;
        this.date = date;
        this.name = name;
        this.refrence = refrence;
        this.distance = distance;
        this.phone = phone;
        this.address = address;
        this.explaintion = explaintion;
        open()
    }
    function setDialog(){
        if(cid.length <= 0){
            govara_customerdialog_infobar.open("لطفا شناسه مشتری را وارد کنید !");
            return false;
        }
        if(date.length <= 0){
            govara_customerdialog_infobar.open("لطفا تاریخ ثبت نام را وارد کنید !");
            return false;
        }
        if(name.length <= 0){
            govara_customerdialog_infobar.open("لطفا نام مشتری را وارد کنید !");
            return false;
        }
        if(refrence.length <= 0){
//            govara_customerdialog_infobar.open("لطفا معرف مشتری را وارد کنید !");
//            return false;
        }
        if(distance.length <= 0){
//            govara_customerdialog_infobar.open("لطفا فاصله زمانی سرویس ها را وارد کنید !");
//            return false;
        }
        if(phone.length <= 0){
//            govara_customerdialog_infobar.open("لطفا تلفن را وارد کنید !");
//            return false;
        }
        if(address.length <= 0){
//            govara_customerdialog_infobar.open("لطفا آدرس را وارد کنید !");
//            return false;
        }
        if(explaintion.length <= 0){
//            govara_customerdialog_infobar.open("لطفا توضیحات را وارد کنید !");
//            return false;
        }
        govara_main_connection.set_customer(cid,date,name,refrence,distance,phone,address,explaintion);
        return true;
    }

    width: parent.width < 500 ? parent.width : 500
    height: parent.height < 510 ? parent.height : 510
    clip: true
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    focus: true
    modal: true
    header: FluidControls.AppBar{
        actions: [
            FluidControls.Action{
                text: qsTr("Check")
                toolTip: qsTr("Check")
                icon.source: FluidControls.Utils.iconUrl("navigation/check")
                onTriggered: {
                    if(setDialog()){
                        close()
                    }
                }
            }
        ]
        leftAction: FluidControls.Action {
            text: qsTr("Close")
            toolTip: qsTr("Close")
            icon.source: FluidControls.Utils.iconUrl("navigation/close")
            onTriggered: close()
        }
        Text{
            text: "اطلاعات مشتری"
            color: "white"
            font.pixelSize: 15
            anchors{
                fill: parent
                rightMargin: 50
                leftMargin: 50
            }
            verticalAlignment: Text.AlignVCenter
        }
    }

    Flickable{
        anchors.fill: parent
        contentHeight: govara_customerdialog_column.height

        Column{
            id:govara_customerdialog_column
            width: parent.width
            anchors.centerIn: parent
            spacing: 10

            Rectangle{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: govara_main_global.dp_to_px(50)

                Label{
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    font.bold: true
                    text: qsTr("تاریخ ثبت نام")
                }
                Button{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: govara_main_connection.date(date)
                    onClicked: {
                        govara_main_datepicker.openDialog(function(result){
                            date = result;
                        });
                    }
                }
            }

            Rectangle{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: govara_main_global.dp_to_px(50)

                Label{
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    font.bold: true
                    text: qsTr("نام مشتری")
                }
                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    placeholderText: qsTr("نام")
                    text: name
                    onTextChanged: {
                        name = text
                    }
                }
            }

            Rectangle{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: govara_main_global.dp_to_px(50)

                Label{
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    font.bold: true
                    text: qsTr("معرف مشتری")
                }
                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    placeholderText: qsTr("معرف")
                    text: refrence
                    onTextChanged: {
                        refrence = text
                    }
                }
            }

            Rectangle{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: govara_main_global.dp_to_px(50)

                Label{
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    font.bold: true
                    text: qsTr("فاصله زمانی سرویس ها")
                }
                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: qsTr("تعداد روز")
                    text: distance
                    onTextChanged: {
                        distance = text
                    }
                }
            }

            Rectangle{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: govara_main_global.dp_to_px(50)

                Label{
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    font.bold: true
                    text: qsTr("تلفن")
                }
                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: qsTr("تلفن")
                    text: phone
                    onTextChanged: {
                        phone = text
                    }
                }
            }

            Rectangle{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: govara_main_global.dp_to_px(50)

                Label{
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    font.bold: true
                    text: qsTr("آدرس")
                }
                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    placeholderText: qsTr("آدرس")
                    text: address
                    onTextChanged: {
                        address = text
                    }
                }
            }

            Rectangle{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: govara_main_global.dp_to_px(50)

                Label{
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    font.bold: true
                    text: qsTr("توضیحات")
                }
                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    placeholderText: qsTr("توضیحات")
                    text: explaintion
                    onTextChanged: {
                        explaintion = text
                    }
                }
            }

        }
    }

    FluidControls.InfoBar{id: govara_customerdialog_infobar}

}
