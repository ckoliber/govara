import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Fluid.Core 1.0 as FluidCore
import Fluid.Controls 1.0 as FluidControls
import "../objects" as GObjects

FluidControls.Tab{
    title: "دفتر مشتریان"

    Connections{
        target: govara_main_connection
        onSetCustomer:{
            govara_customertab_stackview.clear()
            for(var cursor = 0 ; cursor < govara_customertab_listview.model.count ; cursor++){
                if(govara_customertab_listview.model.get(cursor).cid == cid){
                    govara_customertab_listview.model.set(cursor,{
                                                         "cid":cid,
                                                         "date":date,
                                                         "name":name,
                                                         "refrence":refrence,
                                                         "distance":distance
                                                     });
                    return;
                }
            }
            govara_customertab_listview.model.insert(((govara_customertab_listview.model.get(0) && date < govara_customertab_listview.model.get(0).date) ? 0 : govara_customertab_listview.model.count),{
                                                "cid":cid,
                                                "date":date,
                                                "name":name,
                                                "refrence":refrence,
                                                "distance":distance
                                            });
        }
        onGetCustomer:{
            govara_customertab_stackview.push("qrc:/qml/pages/CustomerDetail.qml",{
                                              "cid":cid,
                                              "date":date,
                                              "name":name,
                                              "refrence":refrence,
                                              "distance":distance,
                                              "phone":phone,
                                              "address":address,
                                              "explaintion":explaintion
                                          });
            govara_main_tabbedpage.setCurrentIndex(0);
        }
        onRemoveCustomer:{
            govara_customertab_stackview.clear()
            for(var cursor = 0 ; cursor < govara_customertab_listview.model.count ; cursor++){
                if(govara_customertab_listview.model.get(cursor).cid == cid){
                    govara_customertab_listview.model.remove(cursor)
                }
            }
        }
        onEndCustomer:{
            if(count > 0){
                govara_customertab_listview.endUp();
                govara_customertab_listview.endDown();
            }
            govara_main_tabbedpage.setCurrentIndex(0);
        }
        onClearCustomer:{
            govara_customertab_listview.model.clear()
        }
    }

    FluidControls.Page{
        id: govara_customertab_page
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
                    onTriggered: govara_main_customerfilter.openDialog()
                },
                FluidControls.Action{
                    text: qsTr("Refresh")
                    toolTip: qsTr("Refresh")
                    icon.source: FluidControls.Utils.iconUrl("navigation/refresh")
                    onTriggered: {
                        govara_main_applicationwindow.customerFilter = [];
                        govara_main_applicationwindow.loadCustomer(true);
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
                    govara_main_applicationwindow.customerFilter = [["name","~",text]];
                    govara_main_applicationwindow.loadCustomer(true);
                }
            }
        }

        GObjects.ListView{
            id: govara_customertab_listview
            anchors.fill: parent
            delegate: FluidControls.ListItem {
                width: parent.width
                height: govara_main_global.dp_to_px(60)
                padding: 5
                text: model.name
                subText: model.refrence
                valueText: govara_main_connection.date(model.date)
                leftItem: FluidControls.FloatingActionButton{
                    anchors.centerIn: parent
                    mini: true
                    Material.background: {
                        if(text){
                            if(text < 3){
                                Material.Red;
                            }else if(text < 10){
                                Material.Orange;
                            }else{
                                Material.Green;
                            }
                        }else{
                            "#ccc";
                        }
                    }
                    text: {
                        var gape = govara_main_connection.gape(model.date,model.distance);
                        gape >= 0 ? gape : "";
                    }
                }
                onClicked: {
                    govara_main_connection.get_customer(model.cid)
                }
            }
            onLoadUp: {
                govara_main_applicationwindow.customerFilter = govara_main_applicationwindow.customerFilter.filter(function(item){
                    return item[0] != "cid";
                });
                govara_main_applicationwindow.customerFilter[govara_main_applicationwindow.customerFilter.length] = ["cid","<",govara_customertab_listview.model.get(0).cid];
                govara_main_applicationwindow.loadCustomer(false);
            }
            onLoadDown: {
                govara_main_applicationwindow.customerFilter = govara_main_applicationwindow.customerFilter.filter(function(item){
                    return item[0] != "cid";
                });
                govara_main_applicationwindow.customerFilter[govara_main_applicationwindow.customerFilter.length] = ["cid",">",govara_customertab_listview.model.get(govara_customertab_listview.model.count-1).cid];
                govara_main_applicationwindow.loadCustomer(false);
            }
        }
    }

    GObjects.StackView{
        id: govara_customertab_stackview
        backgroundIndex: 1
        anchors {
            left: govara_main_global.px_to_dp(parent.width) < 500 ? parent.left : govara_customertab_page.right
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        visible: govara_main_global.px_to_dp(parent.width) >= 500 || depth > 0
    }

}
