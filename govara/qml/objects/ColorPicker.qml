import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Fluid.Core 1.0 as FluidCore
import Fluid.Controls 1.0 as FluidControls
import Fluid.Layouts 1.0 as FluidLayouts

Dialog {
    function openDialog(){
        open();
    }
    width: parent.width < 200 ? parent.width : 200
    height: parent.height < 260 ? parent.height : 260
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
            text: "تم"
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
        contentHeight: govara_colorpicker_column.height

        Column{
            id:govara_colorpicker_column
            width: parent.width
            anchors.centerIn: parent

            FluidLayouts.AutomaticGrid{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                cellWidth: 30
                cellHeight: 30
                model: ListModel {
                    ListElement {
                        paletteIndex: Material.Red
                        name: "Red"
                    }
                    ListElement {
                        paletteIndex: Material.Pink
                        name: "Pink"
                    }
                    ListElement {
                        paletteIndex: Material.Purple
                        name: "Purple"
                    }
                    ListElement {
                        paletteIndex: Material.DeepPurple
                        name: "DeepPurple"
                    }
                    ListElement {
                        paletteIndex: Material.Indigo
                        name: "Indigo"
                    }
                    ListElement {
                        paletteIndex: Material.Blue
                        name: "Blue"
                    }
                    ListElement {
                        paletteIndex: Material.LightBlue
                        name: "LightBlue"
                    }
                    ListElement {
                        paletteIndex: Material.Cyan
                        name: "Cyan"
                    }
                    ListElement {
                        paletteIndex: Material.Teal
                        name: "Teal"
                    }
                    ListElement {
                        paletteIndex: Material.Green
                        name: "Green"
                    }
                    ListElement {
                        paletteIndex: Material.LightGreen
                        name: "LightGreen"
                    }
                    ListElement {
                        paletteIndex: Material.Lime
                        name: "Lime"
                    }
                    ListElement {
                        paletteIndex: Material.Yellow
                        name: "Yellow"
                    }
                    ListElement {
                        paletteIndex: Material.Amber
                        name: "Amber"
                    }
                    ListElement {
                        paletteIndex: Material.Orange
                        name: "Orange"
                    }
                    ListElement {
                        paletteIndex: Material.DeepOrange
                        name: "DeepOrange"
                    }
                    ListElement {
                        paletteIndex: Material.Grey
                        name: "Grey"
                    }
                    ListElement {
                        paletteIndex: Material.BlueGrey
                        name: "BlueGrey"
                    }
                    ListElement {
                        paletteIndex: Material.Brown
                        name: "Brown"
                    }
                }
                delegate: FluidControls.Card{
                    width: 30
                    height: 30
                    Material.background: Material.color(model.paletteIndex, Material.Shade500)
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            govara_main_theme.primary = model.paletteIndex
                        }
                    }
                }
            }
        }
    }
}
