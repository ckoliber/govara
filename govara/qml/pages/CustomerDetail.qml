import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import Fluid.Controls 1.0 as FluidControls

FluidControls.Page {
    property string cid
    property string date
    property string name
    property string refrence
    property string distance
    property string phone
    property string address
    property string explaintion

    header: FluidControls.AppBar{
        maxActionCount: 3
        actions: [
            FluidControls.Action{
                text: qsTr("Edit")
                toolTip: qsTr("Edit")
                icon.source: FluidControls.Utils.iconUrl("editor/mode_edit")
                onTriggered: {
                    govara_main_customerdialog.openDialog(cid,date,name,refrence,distance,phone,address,explaintion);
                }
            },
            FluidControls.Action{
                text: qsTr("Delete")
                toolTip: qsTr("Delete")
                icon.source: FluidControls.Utils.iconUrl("action/delete")
                onTriggered: {
                    govara_main_confirm.openDialog("آیا مشتری مورد نظر حذف شود ؟",function(){
                        govara_main_connection.remove_customer(cid);
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
        contentHeight: govara_customerdetail_column.height

        Column{
            id:govara_customerdetail_column
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
                    text: qsTr("تاریخ ثبت نام")
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
                    text: qsTr("نام مشتری")
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
                    text: qsTr("معرف مشتری")
                }
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: refrence
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
                    text: qsTr("فاصله زمانی سرویس ها")
                }
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: distance ? distance + " روز" : "بدون سرویس"
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
                    text: qsTr("فاصله تا موعد سرویس")
                }
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: distance ? govara_main_connection.gape(date,distance) + " روز" : "بدون سرویس"
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
                    text: qsTr("تلفن")
                }
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: phone
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
                    text: qsTr("آدرس")
                }
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: address
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
