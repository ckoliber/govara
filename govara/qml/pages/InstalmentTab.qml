import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Fluid.Core 1.0 as FluidCore
import Fluid.Controls 1.0 as FluidControls
import "../objects" as GObjects

FluidControls.Tab{
    title: "دفتر اقساط"

    Connections{
        target: govara_main_connection
        onSetInstalment:{
            govara_instalmenttab_stackview.clear()
            for(var cursor = 0 ; cursor < govara_instalmenttab_listview.model.count ; cursor++){
                if(govara_instalmenttab_listview.model.get(cursor).iid == iid){
                    govara_instalmenttab_listview.model.set(cursor,{
                                                         "iid":iid,
                                                         "name":name,
                                                         "date":date,
                                                         "amount":amount,
                                                         "payment":payment
                                                     });
                    return;
                }
            }
            govara_instalmenttab_listview.model.insert(((govara_instalmenttab_listview.model.get(0) && iid < govara_instalmenttab_listview.model.get(0).iid) ? 0 : govara_instalmenttab_listview.model.count),{
                                                "iid":iid,
                                                "name":name,
                                                "date":date,
                                                "amount":amount,
                                                "payment":payment
                                            });
        }
        onGetInstalment:{
            govara_instalmenttab_stackview.push("qrc:/qml/pages/InstalmentDetail.qml",{
                                              "iid":iid,
                                              "cid":cid,
                                              "name":name,
                                              "sid":sid,
                                              "date":date,
                                              "amount":amount,
                                              "payment":payment
                                          });
            govara_main_tabbedpage.setCurrentIndex(2);
        }
        onRemoveInstalment:{
            govara_instalmenttab_stackview.clear()
            for(var cursor = 0 ; cursor < govara_instalmenttab_listview.model.count ; cursor++){
                if(govara_instalmenttab_listview.model.get(cursor).iid == iid){
                    govara_instalmenttab_listview.model.remove(cursor);
                }
            }
        }
        onEndInstalment:{
            if(count > 0){
                govara_instalmenttab_listview.endUp();
                govara_instalmenttab_listview.endDown();
            }
            govara_main_tabbedpage.setCurrentIndex(2);
        }
        onClearInstalment:{
            govara_instalmenttab_listview.model.clear();
        }
    }

    FluidControls.Page{
        id: govara_instalmenttab_page
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
                    onTriggered: govara_main_instalmentfilter.openDialog()
                },
                FluidControls.Action{
                    text: qsTr("Refresh")
                    toolTip: qsTr("Refresh")
                    icon.source: FluidControls.Utils.iconUrl("navigation/refresh")
                    onTriggered: {
                        govara_main_applicationwindow.instalmentFilter = [];
                        govara_main_applicationwindow.loadInstalment(true);
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
                    govara_main_applicationwindow.instalmentFilter = [["amount","~",text]];
                    govara_main_applicationwindow.loadInstalment(true);
                }
            }
        }

        GObjects.ListView{
            id: govara_instalmenttab_listview
            anchors.fill: parent
            delegate: FluidControls.ListItem {
                width: parent.width
                height: govara_main_global.dp_to_px(60)
                padding: 5
                text: model.name
                subText: govara_main_connection.price(model.amount) + " ریال"
                valueText: govara_main_connection.date(model.date)
                leftItem: FluidControls.FloatingActionButton{
                    anchors.centerIn: parent
                    mini: true
                    Material.background: {
                        if(!model.payment){
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
                    text: !model.payment ? govara_main_connection.distance(model.date) : "";
                }
                onClicked: {
                    govara_main_connection.get_instalment(model.iid)
                }
            }
            onLoadUp: {
                govara_main_applicationwindow.instalmentFilter = govara_main_applicationwindow.instalmentFilter.filter(function(item){
                    return item[0] != "iid";
                });
                govara_main_applicationwindow.instalmentFilter[govara_main_applicationwindow.instalmentFilter.length] = ["iid","<",govara_instalmenttab_listview.model.get(0).iid];
                govara_main_applicationwindow.loadInstalment(false)
            }
            onLoadDown: {
                govara_main_applicationwindow.instalmentFilter = govara_main_applicationwindow.instalmentFilter.filter(function(item){
                    return item[0] != "iid";
                });
                govara_main_applicationwindow.instalmentFilter[govara_main_applicationwindow.instalmentFilter.length] = ["iid",">",govara_instalmenttab_listview.model.get(govara_instalmenttab_listview.model.count-1).iid];
                govara_main_applicationwindow.loadInstalment(false);
            }
        }
    }

    GObjects.StackView{
        id: govara_instalmenttab_stackview
        backgroundIndex: 3
        anchors {
            left: govara_main_global.px_to_dp(parent.width) < 500 ? parent.left : govara_instalmenttab_page.right
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        visible: govara_main_global.px_to_dp(parent.width) >= 500 || depth > 0
    }

}
