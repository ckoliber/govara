import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Fluid.Core 1.0 as FluidCore
import Fluid.Controls 1.0 as FluidControls
import "../objects" as GObjects

FluidControls.Tab{
    title: "دفتر قطعات"

    Connections{
        target: govara_main_connection
        onSetPart:{
            govara_parttab_stackview.clear()
            for(var cursor = 0 ; cursor < govara_parttab_listview.model.count ; cursor++){
                if(govara_parttab_listview.model.get(cursor).pid == pid){
                    govara_parttab_listview.model.set(cursor,{
                                                         "pid":pid,
                                                         "name":name,
                                                         "price":price
                                                     });
                    return;
                }
            }
            govara_parttab_listview.model.insert(((govara_parttab_listview.model.get(0) && pid < govara_parttab_listview.model.get(0).pid) ? 0 : govara_parttab_listview.model.count),{
                                                "pid":pid,
                                                "name":name,
                                                "price":price
                                            });
        }
        onGetPart:{
            govara_parttab_stackview.push("qrc:/qml/pages/PartDetail.qml",{
                                              "pid":pid,
                                              "name":name,
                                              "price":price
                                          });
            govara_main_tabbedpage.setCurrentIndex(3);
        }
        onRemovePart:{
            govara_parttab_stackview.clear()
            for(var cursor = 0 ; cursor < govara_parttab_listview.model.count ; cursor++){
                if(govara_parttab_listview.model.get(cursor).pid == pid){
                    govara_parttab_listview.model.remove(cursor);
                }
            }
        }
        onEndPart:{
            if(count > 0){
                govara_parttab_listview.endUp();
                govara_parttab_listview.endDown();
            }
            govara_main_tabbedpage.setCurrentIndex(3);
        }
        onClearPart:{
            govara_parttab_listview.model.clear()
        }
    }

    FluidControls.Page{
        id: govara_parttab_page
        width: govara_main_global.px_to_dp(parent.width) < 500 ? parent.width : 250
        anchors{
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        header: FluidControls.AppBar{
            actions: [
                FluidControls.Action{
                    text: qsTr("Filter")
                    toolTip: qsTr("Filter")
                    icon.source: FluidControls.Utils.iconUrl("content/filter_list")
                    onTriggered: govara_main_partfilter.openDialog()
                },
                FluidControls.Action{
                    text: qsTr("Refresh")
                    toolTip: qsTr("Refresh")
                    icon.source: FluidControls.Utils.iconUrl("navigation/refresh")
                    onTriggered: {
                        govara_main_applicationwindow.partFilter = [];
                        govara_main_applicationwindow.loadPart(true);
                    }
                }
            ]
            leftAction: FluidControls.Action {visible: false}
            TextField{
                anchors{
                    fill: parent
                    leftMargin: 10
                    rightMargin: 100
                }
                placeholderText: qsTr("‌جستوجو...")
                onTextChanged: {
                    govara_main_applicationwindow.partFilter = [["name","~",text]];
                    govara_main_applicationwindow.loadPart(true);
                }
            }
        }

        GObjects.ListView{
            id: govara_parttab_listview
            anchors.fill: parent
            delegate: FluidControls.ListItem {
                width: parent.width
                height: govara_main_global.dp_to_px(60)
                padding: 5
                text: model.name
                subText: model.price ? govara_main_connection.price(model.price) + " ریال" : ""
                onClicked: {
                    govara_main_connection.get_part(model.pid)
                }
            }
            onLoadUp: {
                govara_main_applicationwindow.partFilter = govara_main_applicationwindow.partFilter.filter(function(item){
                    return item[0] != "pid";
                });
                govara_main_applicationwindow.partFilter[govara_main_applicationwindow.partFilter.length] = ["pid","<",govara_parttab_listview.model.get(0).pid];
                govara_main_applicationwindow.loadPart(false);
            }
            onLoadDown: {
                govara_main_applicationwindow.partFilter = govara_main_applicationwindow.partFilter.filter(function(item){
                    return item[0] != "pid";
                });
                govara_main_applicationwindow.partFilter[govara_main_applicationwindow.partFilter.length] = ["pid",">",govara_parttab_listview.model.get(govara_parttab_listview.model.count-1).pid];
                govara_main_applicationwindow.loadPart(false);
            }
        }
    }

    GObjects.StackView{
        id: govara_parttab_stackview
        backgroundIndex: 4
        anchors {
            left: govara_main_global.px_to_dp(parent.width) < 500 ? parent.left : govara_parttab_page.right
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        visible: govara_main_global.px_to_dp(parent.width) >= 500 || depth > 0
    }

}
