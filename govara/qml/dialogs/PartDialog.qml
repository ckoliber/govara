import Fluid.Controls 1.0 as FluidControls
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2

Dialog{
    property string pid
    property string name
    property string price
    function openDialog(pid, name, price){
        this.pid = pid;
        this.name = name
        this.price = price;
        open()
    }
    function setDialog(){
        if(pid.length <= 0){
            govara_partdialog_infobar.open("لطفا شناسه قطعه را وارد کنید !");
            return false;
        }
        if(name.length <= 0){
            govara_partdialog_infobar.open("لطفا نام قطعه را وارد کنید !");
            return false;
        }
        if(price.length <= 0){
//            govara_partdialog_infobar.open("لطفا قیمت پیشفرض را وارد کنید !");
//            return false;
        }
        govara_main_connection.set_part(pid,name,price);
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
            text: "اطلاعات قطعه"
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
        contentHeight: govara_partdialog_column.height

        Column{
            id:govara_partdialog_column
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
                    text: qsTr("نام قطعه")
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
                    text: qsTr("قیمت پیشفرض")
                }
                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: qsTr("ریال")
                    text: price
                    onTextChanged: {
                        price = text
                    }
                }
            }

        }
    }

    FluidControls.InfoBar{id: govara_partdialog_infobar}

}
