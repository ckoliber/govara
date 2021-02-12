import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Fluid.Core 1.0 as FluidCore
import Fluid.Controls 1.0 as FluidControls

FluidControls.AlertDialog{
    property var handler
    function openDialog(text,handler){
        this.text = text;
        this.handler = handler;
        open();
    }
    title: qsTr("توجه")
    padding: 10
    Row{
        spacing: 5
        Button{
            text: "بله"
            Material.background: Material.Green
            onClicked: {
                if(handler){
                    handler();
                }
                close();
            }
        }

        Button{
            text: "خیر"
            Material.background: Material.Red
            onClicked: close()
        }
    }
}
