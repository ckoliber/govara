import Fluid.Controls 1.0 as FluidControls
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2

ComboBox {
    property string filter: ""
    property bool loaderBase: true
    property bool loaderUp: true
    property bool loaderDown: true
    signal loadBase(var filter);
    signal loadUp(var filter);
    signal loadDown(var filter);
    function endBase(){loaderBase = true;}
    function endUp(){loaderUp = true;}
    function endDown(){loaderDown = true;}
    function loadCheck(){
        if(loaderUp && listview.contentY && listview.contentHeight && listview.model.count && listview.contentY < listview.contentHeight/listview.model.count){
            loaderUp = false;
            loadUp(filter);
        }
        if(loaderDown && listview.contentY && listview.contentHeight && listview.model.count && (listview.contentY + listview.height) > listview.contentHeight * (listview.model.count - 1) / listview.model.count){
            loaderDown = false;
            loadDown(filter);
        }
    }

    id: control
    model: ListModel{}
    popup: Popup {
        y: control.height
        implicitWidth: control.width
        implicitHeight: Math.min(listview.contentHeight,200)
        padding: 0
        margins: 0
        contentItem: ListView {
            anchors.margins: 0
            id: listview
            clip: true
            model: control.popup.visible ? control.delegateModel : null
            delegate: control.popup.visible ? control.delegate : null
            add: Transition {
                 NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 500 }
                 NumberAnimation { property: "scale"; easing.type: Easing.OutBounce; from: 0; to: 1.0; duration: 750 }
            }
            addDisplaced: Transition {
                NumberAnimation { properties: "y"; duration: 600; easing.type: Easing.InBack }
            }
            remove: Transition {
                NumberAnimation { property: "scale"; from: 1.0; to: 0; duration: 200 }
                NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 200 }
            }
            removeDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 500; easing.type: Easing.OutBack }
            }
            move: Transition {
                id: moveTrans
                SequentialAnimation {
                    ColorAnimation { property: "color"; to: "yellow"; duration: 400 }
                    NumberAnimation { properties: "x,y"; duration: 800; easing.type: Easing.OutBack }
                    ScriptAction { script: moveTrans.ViewTransition.item.color = "lightsteelblue" }
                }
            }
            displaced: Transition {
                    NumberAnimation { properties: "opacity"; to: 1.0; duration: 1000 * (1 - from)}
            }
            onContentYChanged: loadCheck()
            onHeightChanged: loadCheck()
            ScrollIndicator.vertical: ScrollIndicator {}
        }
        onOpened: {
            model.clear();
            filter = "";
            loaderBase = false;
            loadBase(filter);
        }
    }
    Keys.onPressed: {
        if(event.text){
            if(event.key == Qt.Key_Backspace){
                filter = filter.substring(0,filter.length-1);
            }else{
                filter += event.text;
            }
            if(filter){
                filterpopup.open();
            }else{
                filterpopup.close();
            }
            if(loaderBase){
                model.clear();
                loaderBase = false;
                loadBase(filter);
            }
        }
    }

    Popup{
        id: filterpopup
        x: parent.x
        y: parent.y
        width: parent.width
        height: parent.height
        Label{
            anchors.fill: parent
            clip: true
            text: filter
        }
    }
}
