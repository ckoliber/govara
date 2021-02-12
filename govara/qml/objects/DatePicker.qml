import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Fluid.Core 1.0 as FluidCore
import Fluid.Controls 1.0 as FluidControls
import Fluid.Layouts 1.0 as FluidLayouts

Dialog {
    property var days : ["یک شنبه","دو شنبه","سه شنبه","چهار شنبه","پنج شنبه","جمعه","شنبه"]
    property var months : ["فروردین","اردیبهشت","خرداد","تیر","مرداد","شهریور","مهر","آبان","آذر","دی","بهمن","اسفند"]
    property var loaddate: ["1","1","1"] // jalali [year,month,day] yek mah
    property var current: ["1","1","1"] // selected [year,month,day] int jalali
    property var handler
    function openDialog(handler){
        this.handler = handler;
        open();
        loadDialog(0);
    }
    function loadDialog(type){

        console.log("AAA");

        var d = new Date();
        for(var a = 0 ; a < 1000 ; a++){
            console.log(new Date(d + a*86400000));
        }

        if(type < 0){
            loaddate = parseInt(loaddate[1]) <= 0 ? [(parseInt(loaddate[0])-1)+"","11",loaddate[2]] : [loaddate[0],(parseInt(loaddate[1])-1)+"",loaddate[2]]
        }else if(type === 0){
            var date = new Date();
            loaddate = current = govara_main_connection.to_jalali([date.getFullYear(),date.getMonth(),date.getDate()]);
            loaddate = [loaddate[0],loaddate[1],"1"]
        }else{
            loaddate = parseInt(loaddate[1]) >= 11 ? [(parseInt(loaddate[0])+1)+"","0",loaddate[2]] : [loaddate[0],(parseInt(loaddate[1])+1)+"",loaddate[2]]
        }
        govara_colorpicker_model.clear();
        for(var cursor = 0 ; cursor < (govara_main_connection.weekday_jalali(loaddate)+1)%7 ; cursor++){
            govara_colorpicker_model.append({"year":"","month":"","day":""});
        }
        for(var cursor = 0 ; cursor < [31,31,31,31,31,31,30,30,30,30,30,29][loaddate[1]] ; cursor++){
            govara_colorpicker_model.append({"year":loaddate[0]+"","month":loaddate[1]+"","day":(cursor+1)+""});
        }
        govara_colorpicker_columnflow.reEvalColumns();
    }

    width: parent.width < 300 ? parent.width : 300
    height: parent.height < 380 ? parent.height : 380
    clip: true
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    focus: true
    modal: true
    padding: 0
    topPadding: 0
    header: FluidControls.AppBar{
        actions: [
            FluidControls.Action {
                text: qsTr("Current")
                toolTip: qsTr("Current")
                icon.source: FluidControls.Utils.iconUrl("device/access_time")
                onTriggered: {
                    loadDialog(0)
                }
            },
            FluidControls.Action{
                text: qsTr("Select")
                toolTip: qsTr("Select")
                icon.source: FluidControls.Utils.iconUrl("navigation/check")
                onTriggered: {
                    if(current){
                        var gdate = govara_main_connection.to_georgian(current);
                        var date = new Date(gdate[0],gdate[1],gdate[2]);
                        handler(date.getTime().toString());
                    }
                    close();
                }
            }
        ]
        leftAction: FluidControls.Action {
            text: qsTr("Close")
            toolTip: qsTr("Close")
            icon.source: FluidControls.Utils.iconUrl("navigation/close")
            onTriggered: close()
        }
    }

    Flickable{
        anchors.fill: parent
        contentHeight: govara_colorpicker_column.height

        Column{
            padding: 0
            id:govara_colorpicker_column
            width: parent.width
            anchors.centerIn: parent

            FluidControls.Card{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: govara_main_global.dp_to_px(140)
                Material.background: Material.color(govara_main_theme.primary,Material.Shade100)

                FluidControls.FloatingActionButton{
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    mini: true
                    icon.source: FluidControls.Utils.iconUrl("navigation/chevron_left")
                    onClicked: loadDialog(-1)
                }
                FluidControls.FloatingActionButton{
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    mini: true
                    icon.source: FluidControls.Utils.iconUrl("navigation/chevron_right")
                    onClicked: loadDialog(1)
                }

                TextField{
                    id:govara_datepicker_year
                    width: 60
                    anchors{
                        left: parent.left
                        top: parent.top
                        margins: 5
                        leftMargin: 15
                    }
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: "سال"
                    text: current[0]
                    onTextChanged: {
                        current[0] = text;
                    }
                }
                TextField{
                    id:govara_datepicker_month
                    width: 60
                    anchors{
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        margins: 5
                    }
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: "ماه"
                    text: (parseInt(current[1]) + 1)+""
                    onTextChanged: {
                        current[1] = (parseInt(text) - 1)+"";
                    }
                }
                TextField{
                    id:govara_datepicker_day
                    width: 60
                    anchors{
                        right: parent.right
                        top: parent.top
                        margins: 5
                        rightMargin: 15
                    }
                    validator: RegExpValidator{regExp: /[0-9]+/}
                    placeholderText: "روز"
                    text: current[2]
                    onTextChanged: {
                        current[2] = text;
                    }
                }

                Column{
                    anchors{
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        margins: 10
                    }
                    spacing: 10
                    Label{
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                        }
                        font.pixelSize: 20
                        text: days[govara_main_connection.weekday_jalali(current)]
                    }
                    Label{
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                        }
                        font.pixelSize: 20
                        font.bold: true
                        text: months[loaddate[1]]
                    }
                }
            }

            FluidLayouts.ColumnFlow{
                id: govara_colorpicker_columnflow
                anchors{
                    left: parent.left
                    right: parent.right
                }
                columns: 7
                model: ListModel{id: govara_colorpicker_model}
                delegate: FluidControls.Card{
                    id: govara_colorpicker_daycard
                    width: 30
                    height: 30
                    states: [
                        State {
                            name: "none"
                            when: model.day && !govara_colorpicker_daymousearea.containsMouse && (model.year != current[0] || model.month != current[1] || model.day != current[2])
                            PropertyChanges {
                                target: govara_colorpicker_daycard
                                Material.background: "white"
                            }
                        },
                        State {
                            name: "select"
                            when: model.day && !govara_colorpicker_daymousearea.containsMouse && (model.year == current[0] && model.month == current[1] && model.day == current[2])
                            PropertyChanges {
                                target: govara_colorpicker_daycard
                                Material.background: Material.Red
                            }
                        },
                        State {
                            name: "hover"
                            when: model.day && govara_colorpicker_daymousearea.containsMouse
                            PropertyChanges {
                                target: govara_colorpicker_daycard
                                Material.background: Material.Green
                            }
                        }
                    ]

                    Label{
                        anchors.centerIn: parent
                        text: model.day
                    }
                    MouseArea{
                        id: govara_colorpicker_daymousearea
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: current = [model.year,model.month,model.day]
                    }
                }
            }
        }
    }
}
