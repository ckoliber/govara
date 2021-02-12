import Fluid.Controls 1.0 as FluidControls
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import "../objects" as GObjects

Dialog{
    property string sid
    property string cid
    property string date
    property string parts
    property string sum: {
        var result = 0;
        if(parts.length > 0){
            var parts_json = JSON.parse(parts);
            Object.keys(parts_json).forEach(function(key,index){
                if(parts_json[key].number.length > 0 && parts_json[key].price.length > 0){
                    result += parts_json[key].number * parts_json[key].price;
                }
            });
        }
        result;
    }
    property string advanced
    property string instalments
    property string surety
    property string explaintion
    function openDialog(sid, cid, date, parts, advanced, instalments, surety, explaintion){
        this.sid = sid;
        this.cid = cid;
        this.date = date;
        this.parts = parts;
        this.advanced = advanced;
        this.instalments = instalments;
        this.surety = surety;
        this.explaintion = explaintion;
        govara_servicedialog_partmodel.clear();
        if(parts.length > 0){
            govara_servicedialog_partmodel.append(JSON.parse(parts));
        }
        govara_servicedialog_instalmentmodel.clear();
        if(instalments.length > 0){
            govara_servicedialog_instalmentmodel.append(JSON.parse(instalments));
        }
        open();
    }
    function setDialog(){
        if(sid.length <= 0){
            govara_servicedialog_infobar.open("لطفا شناسه سرویس را وارد کنید !");
            return false;
        }
        if(cid.length <= 0){
            govara_servicedialog_infobar.open("لطفا شناسه مشتری را وارد کنید !");
            return false;
        }
        if(date.length <= 0){
            govara_servicedialog_infobar.open("لطفا تاریخ سرویس را وارد کنید !");
            return false;
        }
        if(parts.length > 0){
            var parts_json = JSON.parse(parts);
            for(var cursor = 0 ; cursor < parts_json.length ; cursor++){
                if(parts_json[cursor].name.length <= 0){
                    govara_servicedialog_infobar.open(" لطفا نام قطعه در ردیف "+(cursor+1)+" را وارد کنید !");
                    return false;
                }
                if(parts_json[cursor].number.length <= 0){
                    govara_servicedialog_infobar.open(" لطفا تعداد قطعه در ردیف "+(cursor+1)+" را وارد کنید !");
                    return false;
                }
                if(parts_json[cursor].price.length <= 0){
                    govara_servicedialog_infobar.open(" لطفا قیمت واحد قطعه در ردیف "+(cursor+1)+" را وارد کنید !");
                    return false;
                }
            }
        }
        if(advanced.length <= 0){
//            govara_servicedialog_infobar.open("لطفا پیش پرداخت را وارد کنید !");
//            return false;
        }
        if(instalments.length > 0){
            var instalments_json = JSON.parse(instalments);
            for(var cursor = 0 ; cursor < instalments_json.length ; cursor++){
                if(!instalments_json[cursor].date){
                    govara_servicedialog_infobar.open(" لطفا تاریخ قسط در ردیف "+(cursor+1)+" را وارد کنید !");
                    return false;
                }
                if(!instalments_json[cursor].amount){
                    govara_servicedialog_infobar.open(" لطفا مبلغ قسط در ردیف "+(cursor+1)+" را وارد کنید !");
                    return false;
                }
            }
        }
        if(surety.length <= 0){
//            govara_servicedialog_infobar.open("لطفا گارانتی را وارد کنید !");
//            return false;
        }
        if(explaintion.length <= 0){
//            govara_servicedialog_infobar.open("لطفا توضیحات را وارد کنید !");
//            return false;
        }
        var money = parseInt(advanced) || 0;
        if(instalments.length > 0){
            var money_json = JSON.parse(instalments);
            Object.keys(money_json).forEach(function(key,index){
                if(instalments_json[key].amount.length > 0){
                    money += parseInt(instalments_json[key].amount) || 0;
                }
            });
        }
        if(money != sum){
            govara_servicedialog_infobar.open("لطفا جمع قطعات و پیش پرداخت و اقساط را بررسی کنید !");
            return false;
        }
        govara_main_connection.set_service(sid,cid,date,parts,advanced,instalments,surety,explaintion);
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
            text: "اطلاعات سرویس"
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
        contentHeight: govara_servicedialog_column.height

        Column{
            id:govara_servicedialog_column
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
                    text: qsTr("تاریخ سرویس")
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
                height: govara_main_global.dp_to_px(70) + govara_servicedialog_partrectangle.height

                Rectangle{
                    anchors{
                        left: parent.left
                        right: parent.right
                        margins: 5
                    }
                    height: govara_main_global.dp_to_px(50)
                    Label{
                        anchors{
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            margins: 5
                        }
                        font.bold: true
                        text: qsTr("قطعات")
                    }
                    FluidControls.FloatingActionButton{
                        anchors{
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            margins: 5
                        }
                        mini: true
                        icon.source: FluidControls.Utils.iconUrl("content/add")
                        onClicked: govara_servicedialog_partmodel.append({"name":"","number":"","price":""})
                    }
                }

                Rectangle{
                    id: govara_servicedialog_partrectangle
                    anchors{
                        top: parent.children[0].bottom
                        left: parent.left
                        right: parent.right
                        margins: 5
                    }
                    height: children[0].height

                    Column{
                        width: parent.width

                        Rectangle{
                            anchors{
                                left: parent.left
                                right: parent.right
                            }
                            height: govara_main_global.dp_to_px(50)
                            color: Material.color(Material.Grey,Material.Shade300)

                            Label{
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                    right: parent.right
                                    rightMargin: 60
                                }
                                text: qsTr("نام قطعه")
                                font.bold: true
                            }

                            Label{
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                    centerIn: parent
                                }
                                text: qsTr("تعداد قطعه")
                                font.bold: true
                            }

                            Label{
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                    left: parent.left
                                    leftMargin: 10
                                }
                                text: qsTr("قیمت واحد")
                                font.bold: true
                            }
                        }

                        Repeater{
                            anchors{
                                left: parent.left
                                right: parent.right
                            }
                            model: ListModel{
                                id: govara_servicedialog_partmodel
                                onDataChanged: {
                                    var result = []
                                    for(var cursor = 0 ; cursor < govara_servicedialog_partmodel.count ; cursor++){
                                        result[cursor] = govara_servicedialog_partmodel.get(cursor);
                                    }
                                    parts = JSON.stringify(result);
                                }
                                onRowsInserted: {
                                    var result = []
                                    for(var cursor = 0 ; cursor < govara_servicedialog_partmodel.count ; cursor++){
                                        result[cursor] = govara_servicedialog_partmodel.get(cursor);
                                    }
                                    parts = JSON.stringify(result);
                                }
                                onRowsRemoved: {
                                    var result = []
                                    for(var cursor = 0 ; cursor < govara_servicedialog_partmodel.count ; cursor++){
                                        result[cursor] = govara_servicedialog_partmodel.get(cursor);
                                    }
                                    parts = JSON.stringify(result);
                                }
                            }
                            delegate: Rectangle{
                                anchors{
                                    left: parent.left
                                    right: parent.right
                                }
                                height: govara_main_global.dp_to_px(50)
                                color: if(index % 2 == 0 ){ "white" }else{Material.color(Material.Grey,Material.Shade300)}

                                FluidControls.FloatingActionButton{
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        right: parent.right
                                    }
                                    mini: true
                                    icon.source: FluidControls.Utils.iconUrl("navigation/close")
                                    onClicked: {
                                        govara_servicedialog_partmodel.remove(index)
                                    }
                                }

                                GObjects.ComboBox{
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        right: parent.right
                                        rightMargin: 60
                                    }
                                    displayText: model.get(currentIndex) ? model.get(currentIndex).name : ""
                                    delegate: FluidControls.ListItem{
                                        width: parent.width
                                        height: 50
                                        text: model.name
                                        subText: model.price ? govara_main_connection.price(model.price) + " ریال" : ""
                                    }
                                    onLoadBase: {
                                        govara_main_connection.load_part([["name","~",filter]],10,function(pid, name, price){
                                            if(name){
                                                model.append({
                                                                 "pid": pid,
                                                                 "name": name,
                                                                 "number": "1",
                                                                 "price": price
                                                             });
                                            }else if(cid > 0){
                                                endBase();
                                            }
                                        });
                                    }
                                    onLoadUp: {
                                        govara_main_connection.load_part([["name","~",filter],["pid","<",model.get(0).pid]],10,function(pid, name, price){
                                            if(name){
                                                model.insert(0,{
                                                                 "pid": pid,
                                                                 "name": name,
                                                                 "number": "1",
                                                                 "price": price
                                                             });
                                            }else if(cid > 0){
                                                endUp();
                                            }
                                        });
                                    }
                                    onLoadDown: {
                                        govara_main_connection.load_part([["name","~",filter],["pid",">",model.get(model.count-1).pid]],10,function(pid, name, price){
                                            if(name){
                                                model.append({
                                                                 "pid": pid,
                                                                 "name": name,
                                                                 "number": "1",
                                                                 "price": price
                                                             });
                                            }else if(cid > 0){
                                                endDown();
                                            }
                                        });
                                    }
                                    onCurrentIndexChanged: {
                                        if(model.get(currentIndex)){
                                            govara_servicedialog_partmodel.get(index).name = model.get(currentIndex).name;
                                            govara_servicedialog_partmodel.get(index).number = model.get(currentIndex).number;
                                            govara_servicedialog_partmodel.get(index).price = model.get(currentIndex).price;
                                        }
                                    }
                                }

                                TextField{
                                    width: 40
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        centerIn: parent
                                    }
                                    validator: RegExpValidator{regExp: /[0-9]+/}
                                    placeholderText: qsTr("تعداد")
                                    text: model.number
                                    onTextChanged: {
                                        model.number = text
                                    }
                                }

                                TextField{
                                    width: 90
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        left: parent.left
                                        leftMargin: 10
                                    }
                                    validator: RegExpValidator{regExp: /[0-9]+/}
                                    placeholderText: qsTr("ریال")
                                    text: model.price
                                    onTextChanged: {
                                        model.price = text
                                    }
                                }
                            }

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
                    text: qsTr("جمع کل")
                }
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: sum
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
                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: qsTr("ریال")
                    text: advanced
                    onTextChanged: {
                        advanced = text
                    }
                }
            }

            Rectangle{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: govara_main_global.dp_to_px(70) + govara_servicedialog_instalmentrectangle.height

                Rectangle{
                    anchors{
                        left: parent.left
                        right: parent.right
                        margins: 5
                    }
                    height: govara_main_global.dp_to_px(50)
                    Label{
                        anchors{
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            margins: 5
                        }
                        font.bold: true
                        text: qsTr("اقساط")
                    }
                    FluidControls.FloatingActionButton{
                        anchors{
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            margins: 5
                        }
                        mini: true
                        icon.source: FluidControls.Utils.iconUrl("content/add")
                        onClicked: govara_servicedialog_instalmentmodel.append({"iid":govara_main_connection.current(),"date":"","amount":""})
                    }
                }

                Rectangle{
                    id: govara_servicedialog_instalmentrectangle
                    anchors{
                        top: parent.children[0].bottom
                        left: parent.left
                        right: parent.right
                        margins: 5
                    }
                    height: children[0].height

                    Column{
                        width: parent.width

                        Rectangle{
                            anchors{
                                left: parent.left
                                right: parent.right
                            }
                            height: govara_main_global.dp_to_px(50)
                            color: Material.color(Material.Grey,Material.Shade300)

                            Label{
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                    right: parent.right
                                    rightMargin: 60
                                }
                                text: qsTr("تاریخ قسط")
                                font.bold: true
                            }

                            Label{
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                    left: parent.left
                                    leftMargin: 10
                                }
                                text: qsTr("مبلغ قسط")
                                font.bold: true
                            }
                        }

                        Repeater{
                            anchors{
                                left: parent.left
                                right: parent.right
                            }
                            model: ListModel{
                                id: govara_servicedialog_instalmentmodel
                                onDataChanged: {
                                    var result = []
                                    for(var cursor = 0 ; cursor < govara_servicedialog_instalmentmodel.count ; cursor++){
                                        result[cursor] = govara_servicedialog_instalmentmodel.get(cursor);
                                    }
                                    instalments = JSON.stringify(result);
                                }
                                onRowsInserted: {
                                    var result = []
                                    for(var cursor = 0 ; cursor < govara_servicedialog_instalmentmodel.count ; cursor++){
                                        result[cursor] = govara_servicedialog_instalmentmodel.get(cursor);
                                    }
                                    instalments = JSON.stringify(result);
                                }
                                onRowsRemoved: {
                                    var result = []
                                    for(var cursor = 0 ; cursor < govara_servicedialog_instalmentmodel.count ; cursor++){
                                        result[cursor] = govara_servicedialog_instalmentmodel.get(cursor);
                                    }
                                    instalments = JSON.stringify(result);
                                }
                            }
                            delegate: Rectangle{
                                anchors{
                                    left: parent.left
                                    right: parent.right
                                }
                                height: govara_main_global.dp_to_px(50)
                                color: if(index % 2 == 0 ){ "white" }else{Material.color(Material.Grey,Material.Shade300)}

                                FluidControls.FloatingActionButton{
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        right: parent.right
                                    }
                                    mini: true
                                    icon.source: FluidControls.Utils.iconUrl("navigation/close")
                                    onClicked: {
                                        govara_servicedialog_instalmentmodel.remove(index)
                                    }
                                }

                                Button{
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        right: parent.right
                                        rightMargin: 60
                                    }
                                    text: govara_main_connection.date(model.date)
                                    onClicked: {
                                        govara_main_datepicker.openDialog(function(result){
                                            model.date = result;
                                        });
                                    }
                                }

                                TextField{
                                    width: 60
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        left: parent.left
                                        leftMargin: 10
                                    }
                                    validator: RegExpValidator{regExp: /[0-9]+/}
                                    placeholderText: qsTr("ریال")
                                    text: model.amount
                                    onTextChanged: {
                                        model.amount = text
                                    }
                                }
                            }

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

                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: qsTr("تعداد روز")
                    text: surety
                    onTextChanged: {
                        surety = text
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

    FluidControls.InfoBar{id: govara_servicedialog_infobar}

}
