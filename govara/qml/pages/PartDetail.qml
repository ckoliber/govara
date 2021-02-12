import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import Fluid.Controls 1.0 as FluidControls

FluidControls.Page {
    property string pid
    property string name
    property string price

    header: FluidControls.AppBar{
        maxActionCount: 3
        actions: [
            FluidControls.Action{
                text: qsTr("Edit")
                toolTip: qsTr("Edit")
                icon.source: FluidControls.Utils.iconUrl("editor/mode_edit")
                onTriggered: {
                    govara_main_partdialog.openDialog(pid,name,price)
                }
            },
            FluidControls.Action{
                text: qsTr("Delete")
                toolTip: qsTr("Delete")
                icon.source: FluidControls.Utils.iconUrl("action/delete")
                onTriggered: {
                    govara_main_confirm.openDialog("آیا قطعه مورد نظر حذف شود ؟",function(){
                        govara_main_connection.remove_part(pid)
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
        contentHeight: govara_partdetail_column.height

        Column{
            id:govara_partdetail_column
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
                    text: qsTr("نام قطعه")
                }
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: name
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
                    text: qsTr("قیمت پیشفرض")
                }
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: price ? govara_main_connection.price(price) + " ریال" : ""
                }
            }
        }
    }
}
