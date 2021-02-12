import Fluid.Controls 1.0 as FluidControls
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import "../objects" as GObjects

Dialog{
    property string cid
    property string name
    property string date_from
    property string date_to
    property string advanced_from
    property string advanced_to
    property string surety_from
    property string surety_to
    property string explaintion
    function openDialog(){
        this.cid = "";
        this.name = "";
        this.date_from = "";
        this.date_to = "";
        this.advanced_from = "";
        this.advanced_to = "";
        this.surety_from = "";
        this.surety_to = "";
        this.explaintion = "";
        open()
    }
    function setDialog(){
        var filter = [];
        if(cid){
            filter[filter.length] = ["cid","=",cid];
        }
        if(name){
            filter[filter.length] = ["name","~",name];
        }
        if(date_from){
            filter[filter.length] = ["date",">=",date_from];
        }
        if(date_to){
            filter[filter.length] = ["date","<=",date_to];
        }
        if(advanced_from){
            filter[filter.length] = ["advanced",">=",advanced_from];
        }
        if(advanced_to){
            filter[filter.length] = ["advanced","<=",advanced_to];
        }
        if(surety_from){
            filter[filter.length] = ["surety",">=",surety_from];
        }
        if(surety_to){
            filter[filter.length] = ["surety","<=",surety_to];
        }
        if(explaintion){
            filter[filter.length] = ["explaintion","~",explaintion];
        }
        govara_main_applicationwindow.serviceFilter = filter;
        govara_main_applicationwindow.loadService(true);
        return true;
    }

    width: parent.width < 500 ? parent.width : 500
    height: parent.height < 670 ? parent.height : 670
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
            text: "فیلتر سرویس"
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
        contentHeight: govara_servicefilter_column.height

        Column{
            id:govara_servicefilter_column
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
                    text: qsTr("مشتری")
                }
                GObjects.ComboBox{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    displayText: model.get(currentIndex) ? model.get(currentIndex).name : ""
                    delegate: FluidControls.ListItem{
                        width: parent.width
                        height: 50
                        text: model.name
                        subText: model.date
                    }
                    onLoadBase: {
                        govara_main_connection.load_customer([["name","~",filter]],10,function(cid, date, name, refrence, distance){
                            if(date){
                                model.append({
                                                 "cid": cid,
                                                 "date": date,
                                                 "name": name,
                                                 "refrence": refrence,
                                                 "distance": distance
                                             });
                            }else if(cid > 0){
                                endBase();
                            }
                        });
                    }
                    onLoadUp: {
                        govara_main_connection.load_customer([["name","~",filter],["cid","<",model.get(0).cid]],10,function(cid, date, name, refrence, distance){
                            if(date){
                                model.insert(0,{
                                                 "cid": cid,
                                                 "date": date,
                                                 "name": name,
                                                 "refrence": refrence,
                                                 "distance": distance
                                             });
                            }else if(cid > 0){
                                endUp();
                            }
                        });
                    }
                    onLoadDown: {
                        govara_main_connection.load_customer([["name","~",filter],["cid",">",model.get(model.count-1).cid]],10,function(cid, date, name, refrence, distance){
                            if(date){
                                model.append({
                                                 "cid": cid,
                                                 "date": date,
                                                 "name": name,
                                                 "refrence": refrence,
                                                 "distance": distance
                                             });
                            }else if(cid > 0){
                                endDown();
                            }
                        });
                    }
                    onCurrentIndexChanged: {
                        if(model.get(currentIndex)){
                            cid = model.get(currentIndex).cid;
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
                    text: qsTr("تاریخ سرویس")
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
                    text: qsTr("پیش پرداخت")
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
                        text: "از مبلغ"
                    }
                    TextField{
                        anchors.verticalCenter: parent.verticalCenter
                        width: 50
                        scale: 0.7
                        validator: RegExpValidator{regExp: /[0-9]+/}
                        placeholderText: qsTr("ریال")
                        text: advanced_from
                        onTextChanged: {
                            advanced_from = text;
                        }
                    }
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text:"تا مبلغ"
                    }
                    TextField{
                        anchors.verticalCenter: parent.verticalCenter
                        width: 50
                        scale: 0.7
                        validator: RegExpValidator{regExp: /[0-9]+/}
                        placeholderText: qsTr("ریال")
                        text: advanced_to
                        onTextChanged: {
                            advanced_to = text;
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
                    text: qsTr("گارانتی")
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
                        text: surety_from
                        onTextChanged: {
                            surety_from = text;
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
                        text: surety_to
                        onTextChanged: {
                            surety_to = text;
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
