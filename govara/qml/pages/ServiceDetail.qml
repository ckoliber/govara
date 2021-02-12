import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import Fluid.Controls 1.0 as FluidControls

FluidControls.Page {
    property string sid
    property string cid
    property string name
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

    Component.onCompleted: {
        // load instalments and add them to model [iid1,iid2,...] -> [{iid:iid1,date:date1,amount:amount1},....]
        if(parts.length > 0){
            govara_servicedetail_partsmodel.append(JSON.parse(parts));
        }
        if(instalments.length > 0){
            var instalments_array = JSON.parse(instalments);
            Object.keys(instalments_array).forEach(function(key,index){
                govara_main_connection.load_instalment([["iid","=",instalments_array[key]]],1,function(iid, name, date, amount, payment){
                    if(date){
                        govara_servicedetail_instalmentsmodel.append({"iid":iid,"date":date,"amount":amount,"payment":payment});
                    }
                });
            });
        }
    }
    Material.background: Material.color(govara_main_theme.primary,Material.Shade100)
    header: FluidControls.AppBar{
        maxActionCount: 3
        actions: [
            FluidControls.Action{
                text: qsTr("Print")
                toolTip: qsTr("Print")
                icon.source: FluidControls.Utils.iconUrl("action/print")
                onTriggered: {
                    govara_main_serviceprint.openDialog("","","","",name,date,"",parts,"")
                }
            },
            FluidControls.Action{
                text: qsTr("Edit")
                toolTip: qsTr("Edit")
                icon.source: FluidControls.Utils.iconUrl("editor/mode_edit")
                onTriggered: {
                    var result = [];
                    for(var cursor = 0 ; cursor < govara_servicedetail_instalmentsmodel.count ; cursor++){
                        result[cursor] = govara_servicedetail_instalmentsmodel.get(cursor);
                    }
                    instalments = JSON.stringify(result);
                    govara_main_servicedialog.openDialog(sid,cid,date,parts,advanced,instalments,surety,explaintion)
                }
            },
            FluidControls.Action{
                text: qsTr("Delete")
                toolTip: qsTr("Delete")
                icon.source: FluidControls.Utils.iconUrl("action/delete")
                onTriggered: {
                    govara_main_confirm.openDialog("آیا سرویس مورد نظر حذف شود ؟",function(){
                        govara_main_connection.remove_service(sid)
                    })
                }
            }
        ]
        leftAction: FluidControls.Action {
            text: qsTr("Close")
            toolTip: qsTr("Close")
            icon.source: FluidControls.Utils.iconUrl("navigation/close")
            onTriggered: depth > 1 ? pop() : clear()
        }
    }
    leftAction: FluidControls.Action{visible: false}

    Flickable{
        anchors{
            fill: parent
            margins: 10
        }
        contentHeight: govara_servicedetail_column.height

        Column{
            id:govara_servicedetail_column
            width: parent.width
            anchors.centerIn: parent
            spacing: 10

            FluidControls.Card{
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
                Button{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: name
                    onClicked: {
                        govara_main_connection.get_customer(cid);
                    }
                }
            }

            FluidControls.Card{
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
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: govara_main_connection.date(date)
                }
            }

            FluidControls.Card{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: govara_main_global.dp_to_px(70) + govara_servicedetail_partrectangle.height

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
                }

                Rectangle{
                    id: govara_servicedetail_partrectangle
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
                                    rightMargin: 10
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
                            model: ListModel{id: govara_servicedetail_partsmodel}
                            delegate: Rectangle{
                                anchors{
                                    left: parent.left
                                    right: parent.right
                                }
                                height: govara_main_global.dp_to_px(50)
                                color: if(index % 2 == 0 ){ "white" }else{Material.color(Material.Grey,Material.Shade300)}

                                Label{
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        right: parent.right
                                        rightMargin: 10
                                    }
                                    text: model.name
                                }

                                Label{
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        centerIn: parent
                                    }
                                    text: model.number
                                }

                                Label{
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        left: parent.left
                                        leftMargin: 10
                                    }
                                    text: govara_main_connection.price(model.price) + " ریال"
                                }
                            }

                        }
                    }

                }
            }

            FluidControls.Card{
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
                    text: govara_main_connection.price(sum) + " ریال"
                }
            }

            FluidControls.Card{
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
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: advanced ? govara_main_connection.price(advanced) + " ریال" : "بدون پیش پرداخت"
                }
            }

            FluidControls.Card{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: govara_main_global.dp_to_px(70) + govara_servicedetail_instalmentrectangle.height

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
                        icon.source: FluidControls.Utils.iconUrl("action/chrome_reader_mode")
                        onClicked:  {
                            govara_main_applicationwindow.instalmentFilter = [["sid","=",sid],["cid","=",cid]];
                            govara_main_applicationwindow.loadInstalment(true);
                        }
                    }
                }

                Rectangle{
                    id: govara_servicedetail_instalmentrectangle
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
                                    rightMargin: 10
                                }
                                text: qsTr("پرداخت")
                                font.bold: true
                            }

                            Label{
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                    right: parent.right
                                    rightMargin: 100
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
                            model: ListModel{id: govara_servicedetail_instalmentsmodel}
                            delegate: Rectangle{
                                anchors{
                                    left: parent.left
                                    right: parent.right
                                }
                                height: govara_main_global.dp_to_px(50)
                                color: if(index % 2 == 0 ){ "white" }else{Material.color(Material.Grey,Material.Shade300)}

                                CheckBox{
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        right: parent.right
                                        rightMargin: 10
                                    }
                                    checked: model.payment
                                    enabled: false
                                }

                                Label{
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        right: parent.right
                                        rightMargin: 100
                                    }
                                    text: govara_main_connection.date(model.date)
                                }

                                Label{
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        left: parent.left
                                        leftMargin: 10
                                    }
                                    text: govara_main_connection.price(model.amount) + " ریال"
                                }
                            }

                        }
                    }

                }
            }

            FluidControls.Card{
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
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: surety ? surety + " روز" : "بدون گارانتی"
                }
            }

            FluidControls.Card{
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

                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: explaintion
                }
            }
        }
    }
}
