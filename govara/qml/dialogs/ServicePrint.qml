import Fluid.Controls 1.0 as FluidControls
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import "../objects" as GObjects

Dialog{
    property string print_title_default: "پیش فاکتور"
    property string server_name_default: "نعمتی"
    property string server_phone_default: "6356158739"
    property string server_address_default: "بندر امام - خ جهاد - روبروی داروخانه شبانه روزی - تصفیه گستر گوارا"
    property string customer_name_default: ""
    property string customer_date_default: ""
    property string customer_economical_default: ""
    property string parts_default: "[]"
    property string costs_tax_default: "0"

    property string print_title
    property string server_name
    property string server_phone
    property string server_address
    property string customer_name
    property string customer_date
    property string customer_economical
    property string parts
    property string costs_tax
    function openDialog(print_title, server_name, server_phone, server_address, customer_name, customer_date, customer_economical, parts, costs_tax){
        this.print_title = print_title ? print_title : print_title_default;
        this.server_name = server_name ? server_name : server_name_default;
        this.server_phone = server_phone ? server_phone : server_phone_default;
        this.server_address = server_address ? server_address : server_address_default;
        this.customer_name = customer_name ? customer_name : customer_name_default;
        this.customer_date = customer_date ? customer_date : customer_date_default;
        this.customer_economical = customer_economical ? customer_economical : customer_economical_default;
        this.parts = parts ? parts : parts_default;
        this.costs_tax = costs_tax ? costs_tax : costs_tax_default;
        govara_serviceprint_partmodel.clear();
        if(parts.length > 0){
            govara_serviceprint_partmodel.append(JSON.parse(parts));
        }
        open();
    }
    function setDialog(){
        if(print_title.length <= 0){
            govara_serviceprint_infobar.open("لطفا عنوان را وارد کنید !");
            return false;
        }
        if(server_name.length <= 0){
            govara_serviceprint_infobar.open("لطفا نام سرویس دهنده را وارد کنید !");
            return false;
        }
        if(server_phone.length <= 0){
            govara_serviceprint_infobar.open("لطفا تلفن سرویس دهنده را وارد کنید !");
            return false;
        }
        if(server_address.length <= 0){
            govara_serviceprint_infobar.open("لطفا آدرس سرویس دهنده را وارد کنید !");
            return false;
        }
        if(customer_name.length <= 0){
            govara_serviceprint_infobar.open("لطفا نام مشتری را وارد کنید !");
            return false;
        }
        if(customer_date.length <= 0){
            govara_serviceprint_infobar.open("لطفا تاریخ سرویس مشتری را وارد کنید !");
            return false;
        }
//        if(customer_economical.length <= 0){
//            govara_serviceprint_infobar.open("لطفا کد اقتصادی مشتری را وارد کنید !");
//            return false;
//        }
//        if(parts.length <= 0){
//            govara_serviceprint_infobar.open("لطفا قطعات را وارد کنید !");
//            return false;
//        }
        if(costs_tax.length <= 0){
            govara_serviceprint_infobar.open("لطفا مالیات بر ارزش افزوده را وارد کنید !");
            return false;
        }
        if(!govara_main_connection.print_service(print_title,server_name,server_phone,server_address,customer_name,customer_date,customer_economical,JSON.parse(parts),costs_tax)){
            govara_serviceprint_infobar.open("متاسفانه مشکلی در چاپ رخ داد دوباره سعی کنید !");
            return false;
        }
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
                text: qsTr("Print")
                toolTip: qsTr("Print")
                icon.source: FluidControls.Utils.iconUrl("action/print")
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
            text: "پرینت سرویس"
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
        contentHeight: govara_serviceprint_column.height

        Column{
            id:govara_serviceprint_column
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
                    text: qsTr("عنوان")
                }

                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    placeholderText: qsTr("عنوان")
                    text: print_title
                    onTextChanged: {
                        print_title = text
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
                    text: qsTr("نام سرویس دهنده")
                }

                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    placeholderText: qsTr("نام")
                    text: server_name
                    onTextChanged: {
                        server_name = text
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
                    text: qsTr("تلفن سرویس دهنده")
                }

                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: qsTr("تلفن")
                    text: server_phone
                    onTextChanged: {
                        server_phone = text
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
                    text: qsTr("آدرس سرویس دهنده")
                }

                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    placeholderText: qsTr("آدرس")
                    text: server_address
                    onTextChanged: {
                        server_address = text
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
                    text: customer_name
                    onTextChanged: {
                        customer_name = text
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
                    text: qsTr("تاریخ سرویس مشتری")
                }

                Button{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: govara_main_connection.date(customer_date)
                    onClicked: {
                        govara_main_datepicker.openDialog(function(result){
                            customer_date = result;
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
                    text: qsTr("کد اقتصادی مشتری")
                }

                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: qsTr("کد")
                    text: customer_economical
                    onTextChanged: {
                        customer_economical = text
                    }
                }
            }

            Rectangle{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: govara_main_global.dp_to_px(70) + govara_serviceprint_partrectangle.height

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
                        onClicked: govara_serviceprint_partmodel.append({"name":"","number":"","price":""})
                    }
                }

                Rectangle{
                    id: govara_serviceprint_partrectangle
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
                                id: govara_serviceprint_partmodel
                                onDataChanged: {
                                    var result = []
                                    for(var cursor = 0 ; cursor < govara_serviceprint_partmodel.count ; cursor++){
                                        result[cursor] = govara_serviceprint_partmodel.get(cursor);
                                    }
                                    parts = JSON.stringify(result);
                                }
                                onRowsInserted: {
                                    var result = []
                                    for(var cursor = 0 ; cursor < govara_serviceprint_partmodel.count ; cursor++){
                                        result[cursor] = govara_serviceprint_partmodel.get(cursor);
                                    }
                                    parts = JSON.stringify(result);
                                }
                                onRowsRemoved: {
                                    var result = []
                                    for(var cursor = 0 ; cursor < govara_serviceprint_partmodel.count ; cursor++){
                                        result[cursor] = govara_serviceprint_partmodel.get(cursor);
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
                                        govara_serviceprint_partmodel.remove(index)
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
                                            govara_serviceprint_partmodel.get(index).name = model.get(currentIndex).name;
                                            govara_serviceprint_partmodel.get(index).number = model.get(currentIndex).number;
                                            govara_serviceprint_partmodel.get(index).price = model.get(currentIndex).price;
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
                    text: qsTr("درصد مالیات بر ارزش افزوده")
                }

                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: qsTr("درصد")
                    text: costs_tax
                    onTextChanged: {
                        costs_tax = text
                    }
                }
            }
        }
    }

    FluidControls.InfoBar{id: govara_serviceprint_infobar}

}
