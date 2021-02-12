import QtQuick 2.0

ListView {
    property bool loaderUp: true
    property bool loaderDown: true
    signal loadUp();
    signal loadDown();
    function endUp(){loaderUp = true;}
    function endDown(){loaderDown = true;}
    function loadCheck(){
        if(loaderUp && contentY && contentHeight && model.count && contentY < contentHeight/model.count){
            loaderUp = false;
            loadUp();
        }
        if(loaderDown && contentY && contentHeight && model.count && (contentY + height) > contentHeight * (model.count - 1) / model.count){
            loaderDown = false;
            loadDown();
        }
    }

    model: ListModel{}
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
}
