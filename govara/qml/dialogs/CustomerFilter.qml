import Fluid.Controls 1.0 as FluidControls
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2

Dialog{
    property string date_from: ""
    property string date_to: ""
    property string name: ""
    property string refrence: ""
    property string distance_from: ""
    property string distance_to: ""
    property string phone: ""
    property string address: ""
    property string explaintion: ""
    function openDialog(){
        this.date_from = "";
        this.date_to = "";
        this.name = "";
        this.refrence = "";
        this.distance_from = "";
        this.distance_to = "";
        this.phone = "";
        this.address = "";
        this.explaintion = "";
        open()
    }
    function setDialog(){
        var filter = [];
        if(date_from){
            filter[filter.length] = ["date",">=",date_from];
        }
        if(date_to){
            filter[filter.length] = ["date","<=",date_to];
        }
        if(name){
            filter[filter.length] = ["name","~",name];
        }
        if(refrence){
            filter[filter.length] = ["refrence","~",refrence];
        }
        if(distance_from){
            filter[filter.length] = ["distance",">=",distance_from];
        }
        if(distance_to){
            filter[filter.length] = ["distance","<=",distance_to];
        }
        if(phone){
            filter[filter.length] = ["phone","~",phone];
        }
        if(address){
            filter[filter.length] = ["address","~",address];
        }
        if(explaintion){
            filter[filter.length] = ["explaintion","~",explaintion];
        }
        govara_main_applicationwindow.customerFilter = filter;
        govara_main_applicationwindow.loadCustomer(true);
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
            text: "فیلتر مشتری"
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
        contentHeight: govara_customerfilter_column.height

        Column{
            id: govara_customerfilter_column
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

                Row{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    layoutDirection: Qt.RightToLeft
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text: "از تاریخ"
                    }
                    Button{
                        anchors.verticalCenter: parent.verticalCenter
                        scale: 0.7
                        text: govara_main_connection.date(date_from)
                        onClicked: {
                            govara_main_datepicker.openDialog(function(result){
                                date_from = result;
                            });
                        }
                    }
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text:"تا تاریخ"
                    }
                    Button{
                        anchors.verticalCenter: parent.verticalCenter
                        scale: 0.7
                        text: govara_main_connection.date(date_to)
                        onClicked: {
                            govara_main_datepicker.openDialog(function(result){
                                date_to = result;
                            });
                        }
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

                Row{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    layoutDirection: Qt.RightToLeft
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text: "از تعداد روز"
                    }
                    TextField{
                        anchors.verticalCenter: parent.verticalCenter
                        width: 50
                        scale: 0.7
                        validator: RegExpValidator{regExp: /[0-9]+/}
                        placeholderText: qsTr("تعداد روز")
                        text: distance_from
                        onTextChanged: {
                            distance_from = text;
                        }
                    }
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text:"تا تعداد روز"
                    }
                    TextField{
                        anchors.verticalCenter: parent.verticalCenter
                        width: 50
                        scale: 0.7
                        validator: RegExpValidator{regExp: /[0-9]+/}
                        placeholderText: qsTr("تعداد روز")
                        text: distance_to
                        onTextChanged: {
                            distance_to = text;
                        }
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

}
