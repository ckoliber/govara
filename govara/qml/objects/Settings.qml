import Fluid.Controls 1.0 as FluidControls
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Dialogs 1.2 as Dialogs

Dialog{
    function openDialog(){
        open()
    }

    width: parent.width < 500 ? parent.width : 500
    height: parent.height < 380 ? parent.height : 380
    clip: true
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    focus: true
    modal: true
    header: FluidControls.AppBar{
        leftAction: FluidControls.Action {
            text: qsTr("Close")
            toolTip: qsTr("Close")
            icon.source: FluidControls.Utils.iconUrl("navigation/close")
            onTriggered: close()
        }
        Text{
            text: "تنظیمات"
            color: "white"
            font.pixelSize: 15
            anchors{
                fill: parent
                rightMargin: 20
                leftMargin: 50
            }
            verticalAlignment: Text.AlignVCenter
        }
    }

    Flickable{
        anchors.fill: parent
        contentHeight: govara_settings_column.height

        Column{
            id:govara_settings_column
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
                    text: qsTr("فاصله زمانی بکاپ ها")
                }
                TextField{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    } 
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: qsTr("تعداد روز")
                    text: govara_main_connection.period_database("")
                    onTextChanged: {
                        if(text > 0){
                            govara_main_connection.period_database(text)
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
                    text: qsTr("تاریخ آخرین بکاپ")
                }
                Label{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: govara_main_connection.date(govara_main_connection.date_database())
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
                    text: qsTr("وارد کردن پایگاه داده")
                }
                Button{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: qsTr("انتخاب فایل")
                    onClicked: {
                        govara_settings_filedialog.openDialog(function(path){
                            govara_main_confirm.openDialog("آیا پایگاه داده وارد شود ؟",function(){
                                if(govara_main_connection.import_database(path)){
                                    govara_settings_infobar.open("پایگاه داده وارد شد !");
                                }else{
                                    govara_settings_infobar.open("متاسفانه مشکلی بوجود آمد !");
                                }
                            });
                        })
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
                    text: qsTr("خارج کردن پایگاه داده")
                }
                Button{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: qsTr("خارج کردن")
                    onClicked: {
                        if(govara_main_connection.export_database()){
                            govara_settings_infobar.open("پایگاه داده خارج شد !");
                        }else{
                            govara_settings_infobar.open("متاسفانه مشکلی بوجود آمد !");
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
                    text: qsTr("خالی کردن پایگاه داده")
                }
                Button{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    text: qsTr("خالی کردن")
                    onClicked: {
                        govara_main_confirm.openDialog("آیا پایگاه داده خالی شود ؟",function(){
                            if(govara_main_connection.clear_database()){
                                govara_settings_infobar.open("پایگاه داده خالی شد !");
                            }else{
                                govara_settings_infobar.open("متاسفانه مشکلی بوجود آمد !");
                            }
                        });
                    }
                }
            }

        }
    }

    FluidControls.InfoBar{id: govara_settings_infobar}

    Dialogs.FileDialog{
        property var handler
        function openDialog(handler){
            this.handler = handler;
            open();
        }
        id: govara_settings_filedialog
        title: "فایل مورد نظر را انتخاب کنید"
        nameFilters: ["Database files (*.db)"]
        onAccepted: {
            if(handler){
                handler(fileUrl)
            }
        }
    }

}
