import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Fluid.Core 1.0 as FluidCore
import Fluid.Controls 1.0 as FluidControls
import "../objects" as GObjects

FluidControls.Tab{
    title: "دفتر سرویس ها"

    Connections{
        target: govara_main_connection
        onSetService:{
            govara_servicetab_stackview.clear()
            for(var cursor = 0 ; cursor < govara_servicetab_listview.model.count ; cursor++){
                if(govara_servicetab_listview.model.get(cursor).sid == sid){
                    govara_servicetab_listview.model.set(cursor,{
                                                         "sid":sid,
                                                         "name":name,
                                                         "date":date,
                                                         "parts":parts
                                                     });
                    return;
                }
            }
            govara_servicetab_listview.model.insert(((govara_servicetab_listview.model.get(0) && sid < govara_servicetab_listview.model.get(0).sid) ? 0 : govara_servicetab_listview.model.count),{
                                                "sid":sid,
                                                "name":name,
                                                "date":date,
                                                "parts":parts
                                            });
        }
        onGetService:{
            govara_servicetab_stackview.push("qrc:/qml/pages/ServiceDetail.qml",{
                                              "sid":sid,
                                              "cid":cid,
                                              "name":name,
                                              "date":date,
                                              "parts":parts,
                                              "advanced":advanced,
                                              "instalments":instalments,
                                              "surety":surety,
                                              "explaintion":explaintion
                                          });
            govara_main_tabbedpage.setCurrentIndex(1);
        }
        onRemoveService:{
            govara_servicetab_stackview.clear()
            for(var cursor = 0 ; cursor < govara_servicetab_listview.model.count ; cursor++){
                if(govara_servicetab_listview.model.get(cursor).sid == sid){
                    govara_servicetab_listview.model.remove(cursor);
                }
            }
        }
        onEndService:{
            if(count > 0){
                govara_servicetab_listview.endUp();
                govara_servicetab_listview.endDown();
            }
            govara_main_tabbedpage.setCurrentIndex(1);
        }
        onClearService:{
            govara_servicetab_listview.model.clear();
        }
    }

    FluidControls.Page{
        id: govara_servicetab_page
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
                    onTriggered: govara_main_servicefilter.openDialog()
                },
                FluidControls.Action{
                    text: qsTr("Refresh")
                    toolTip: qsTr("Refresh")
                    icon.source: FluidControls.Utils.iconUrl("navigation/refresh")
                    onTriggered: {
                        govara_main_applicationwindow.serviceFilter = [];
                        govara_main_applicationwindow.loadService(true);
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
                    govara_main_applicationwindow.serviceFilter = [["parts","~",text]];
                    govara_main_applicationwindow.loadService(true);
                }
            }
        }

        GObjects.ListView{
            id: govara_servicetab_listview
            anchors.fill: parent
            delegate: FluidControls.ListItem {
                width: parent.width
                height: govara_main_global.dp_to_px(60)
                padding: 5
                text: model.name
                subText: model.parts
                valueText: govara_main_connection.date(model.date)
                onClicked: {
                    govara_main_connection.get_service(model.sid)
                }
            }
            onLoadUp: {
                govara_main_applicationwindow.serviceFilter = govara_main_applicationwindow.serviceFilter.filter(function(item){
                    return item[0] != "sid";
                });
                govara_main_applicationwindow.serviceFilter[govara_main_applicationwindow.serviceFilter.length] = ["sid","<",govara_servicetab_listview.model.get(0).sid];
                govara_main_applicationwindow.loadService(false);
            }
            onLoadDown: {
                govara_main_applicationwindow.serviceFilter = govara_main_applicationwindow.serviceFilter.filter(function(item){
                    return item[0] != "sid";
                });
                govara_main_applicationwindow.serviceFilter[govara_main_applicationwindow.serviceFilter.length] = ["sid",">",govara_servicetab_listview.model.get(govara_servicetab_listview.model.count-1).sid];
                govara_main_applicationwindow.loadService(false);
            }
        }
    }

    GObjects.StackView{
        id: govara_servicetab_stackview
        backgroundIndex: 2
        anchors {
            left: govara_main_global.px_to_dp(parent.width) < 500 ? parent.left : govara_servicetab_page.right
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        visible: govara_main_global.px_to_dp(parent.width) >= 500 || depth > 0
    }

}
