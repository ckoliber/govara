import Fluid.Controls 1.0 as FluidControls
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2

Dialog{
    property string name
    property string price_from
    property string price_to
    function openDialog(){
        this.name = "";
        this.price_from = "";
        this.price_to = "";
        open()
    }
    function setDialog(){
        var filter = [];
        if(name){
            filter[filter.length] = ["name","~",name];
        }
        if(price_from){
            filter[filter.length] = ["price",">=",price_from];
        }
        if(price_to){
            filter[filter.length] = ["price","<=",price_to];
        }
        govara_main_applicationwindow.partFilter = filter;
        govara_main_applicationwindow.loadPart(true);
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
            text: "فیلتر قطعه"
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
        contentHeight: govara_partfilter_column.height

        Column{
            id:govara_partfilter_column
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
                    text: qsTr("نام قطعه")
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
                    text: qsTr("قیمت پیشفرض")
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
                        text: "از قیمت"
                    }
                    TextField{
                        anchors.verticalCenter: parent.verticalCenter
                        width: 50
                        scale: 0.7
                        validator: RegExpValidator{regExp: /[0-9]+/}
                        placeholderText: qsTr("ریال")
                        text: price_from
                        onTextChanged: {
                            price_from = text;
                        }
                    }
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text:"تا قیمت"
                    }
                    TextField{
                        anchors.verticalCenter: parent.verticalCenter
                        width: 50
                        scale: 0.7
                        validator: RegExpValidator{regExp: /[0-9]+/}
                        placeholderText: qsTr("ریال")
                        text: price_to
                        onTextChanged: {
                            price_to = text;
                        }
                    }
                }
            }
        }
    }
}
