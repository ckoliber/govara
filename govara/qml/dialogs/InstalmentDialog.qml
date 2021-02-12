import Fluid.Controls 1.0 as FluidControls
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import "../objects" as GObjects

Dialog{
    property string iid
    property string cid
    property string sid
    property string date
    property string amount
    property string payment
    function openDialog(iid, cid, sid, date, amount, payment){
        this.iid = iid;
        this.cid = cid;
        this.sid = sid;
        this.date = date;
        this.amount = amount;
        this.payment = payment;
        open()
    }
    function setDialog(){
        if(iid.length <= 0){
            govara_instalmentdialog_infobar.open("لطفا شناسه قسط را وارد کنید !");
            return false;
        }
        if(cid.length <= 0){
            govara_instalmentdialog_infobar.open("لطفا شناسه مشتری را وارد کنید !");
            return false;
        }
        if(sid.length <= 0){
            govara_instalmentdialog_infobar.open("لطفا شناسه سرویس را وارد کنید !");
            return false;
        }
        if(date.length <= 0){
            govara_instalmentdialog_infobar.open("لطفا تاریخ قسط را وارد کنید !");
            return false;
        }
        if(amount.length <= 0){
            govara_instalmentdialog_infobar.open("لطفا مبلغ را وارد کنید !");
            return false;
        }
        if(payment.length <= 0){
//            govara_instalmentdialog_infobar.open("لطفا پرداخت را وارد کنید !");
//            return false;
        }
        govara_main_connection.set_instalment(iid,cid,sid,date,amount,payment);
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
            text: "اطلاعات قسط"
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
        contentHeight: govara_instalmentdialog_column.height

        Column{
            id:govara_instalmentdialog_column
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
                        subText: govara_main_connection.date(model.date)
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
                    text: qsTr("سرویس")
                }
                GObjects.ComboBox{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    enabled: cid
                    displayText: model.get(currentIndex) ? model.get(currentIndex).parts : ""
                    delegate: FluidControls.ListItem{
                        width: parent.width
                        height: 50
                        text: model.parts
                        subText: govara_main_connection.date(model.date)
                    }
                    onLoadBase: {
                        govara_main_connection.load_service([["cid","=",cid],["parts","~",filter]],10,function(sid, name, date, parts){
                            if(date){
                                model.append({
                                                 "sid": sid,
                                                 "name": name,
                                                 "date": date,
                                                 "parts": parts
                                             });
                            }else if(cid > 0){
                                endBase();
                            }
                        });
                    }
                    onLoadUp: {
                        govara_main_connection.load_service([["cid","=",cid],["parts","~",filter],["sid","<",model.get(0).sid]],10,function(sid, name, date, parts){
                            if(date){
                                model.insert(0,{
                                                 "sid": sid,
                                                 "name": name,
                                                 "date": date,
                                                 "parts": parts
                                             });
                            }else if(cid > 0){
                                endUp();
                            }
                        });
                    }
                    onLoadDown: {
                        govara_main_connection.load_service([["cid","=",cid],["parts","~",filter],["sid",">",model.get(model.count-1).sid]],10,function(sid, name, date, parts){
                            if(date){
                                model.append({
                                                 "sid": sid,
                                                 "name": name,
                                                 "date": date,
                                                 "parts": parts
                                             });
                            }else if(cid > 0){
                                endDown();
                            }
                        });
                    }
                    onCurrentIndexChanged: {
                        if(model.get(currentIndex)){
                            sid = model.get(currentIndex).sid;
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
                    text: qsTr("تاریخ قسط")
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
                    text: qsTr("مبلغ")
                }
                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: qsTr("ریال")
                    text: amount
                    onTextChanged: {
                        amount = text
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
                    text: qsTr("پرداخت")
                }
                CheckBox{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    checked: payment == "1"
                    onCheckedChanged: {
                        payment = checked ? "1" : ""
                    }
                }
            }

        }
    }

    FluidControls.InfoBar{id: govara_instalmentdialog_infobar}

}
