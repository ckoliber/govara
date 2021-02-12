import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import Fluid.Controls 1.0 as FluidControls

FluidControls.Page {
    property string iid
    property string cid
    property string name
    property string sid
    property string date
    property string amount
    property string payment

    header: FluidControls.AppBar{
        maxActionCount: 3
        actions: [
            FluidControls.Action{
                text: qsTr("Edit")
                toolTip: qsTr("Edit")
                icon.source: FluidControls.Utils.iconUrl("editor/mode_edit")
                onTriggered: {
                    govara_main_instalmentdialog.openDialog(iid,cid,sid,date,amount,payment)
                }
            },
            FluidControls.Action{
                text: qsTr("Delete")
                toolTip: qsTr("Delete")
                icon.source: FluidControls.Utils.iconUrl("action/delete")
                onTriggered: {
                    govara_main_confirm.openDialog("آیا قسط مورد نظر حذف شود ؟",function(){
                        govara_main_connection.remove_instalment(iid)
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
    Material.background: Material.color(govara_main_theme.primary,Material.Shade100)

    Flickable{
        anchors{
            fill: parent
            margins: 10
        }
        contentHeight: govara_instalmentdetail_column.height

        Column{
            id:govara_instalmentdetail_column
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
                        govara_main_connection.get_customer(cid)
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
                    text: qsTr("سرویس")
                }
                Button{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: qsTr("نمایش")
                    onClicked: {
                        govara_main_connection.get_service(sid)
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
                    text: qsTr("تاریخ قسط")
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
                height: govara_main_global.dp_to_px(50)

                Label{
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    font.bold: true
                    text: qsTr("فاصله تا موعد قسط")
                }
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: govara_main_connection.distance(date) + " روز"
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
                    text: qsTr("مبلغ قسظ")
                }
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: govara_main_connection.price(amount) + " ریال"
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
                    text: qsTr("پرداخت")
                }
                CheckBox{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    checked: payment == "1"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            payment = payment == "1" ? "" : "1";
                            govara_main_connection.set_instalment(iid,cid,sid,date,amount,payment);
                        }
                    }
                }
            }
        }
    }
}
