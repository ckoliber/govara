import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Fluid.Core 1.0 as FluidCore
import Fluid.Controls 1.0 as FluidControls
import Govara 1.0 as Govara
import "dialogs" as GDialogs
import "objects" as GObjects
import "pages" as GPages
/***
Govara Global ID Naming Protocol :
    govara_{file_name}_{component_name}_[description]


Govara Global Objects :
    1. Theme Object
    2.

Govara Window Segments :
    1. Parameters
    2. Globals
    3. Dialogs
    4. Page

Govara Object Parameters:
    1. id
    2. height,width
    3. layout params
    4. color params
    5. text params
    6. source params
    7. other params
    8. listeners
**/

FluidControls.ApplicationWindow {
    property int pageSize: 20
    property var customerFilter: []
    property var serviceFilter: []
    property var instalmentFilter: []
    property var partFilter: []
    function loadCustomer(clear){
        govara_main_connection.all_customer(customerFilter,pageSize,clear);
    }
    function loadService(clear){
        govara_main_connection.all_service(serviceFilter,pageSize,clear);
    }
    function loadInstalment(clear){
        govara_main_connection.all_instalment(instalmentFilter,pageSize,clear);
    }
    function loadPart(clear){
        govara_main_connection.all_part(partFilter,pageSize,clear);
    }

    id: govara_main_applicationwindow
    visible: true
    width: 640
    height: 480
    Material.primary: govara_main_theme.primary
    Component.onCompleted: {
        loadCustomer(true);
        loadService(true);
        loadInstalment(true);
        loadPart(true);
    }


    Govara.Connection{id: govara_main_connection}


    GDialogs.CustomerDialog{id: govara_main_customerdialog}

    GDialogs.CustomerFilter{id: govara_main_customerfilter}

    GDialogs.ServiceDialog{id: govara_main_servicedialog}

    GDialogs.ServiceFilter{id: govara_main_servicefilter}

    GDialogs.ServicePrint{id: govara_main_serviceprint}

    GDialogs.InstalmentDialog{id: govara_main_instalmentdialog}

    GDialogs.InstalmentFilter{id: govara_main_instalmentfilter}

    GDialogs.PartDialog{id: govara_main_partdialog}

    GDialogs.PartFilter{id: govara_main_partfilter}


    GObjects.Theme{id: govara_main_theme}

    GObjects.Global{id: govara_main_global}

    GObjects.DatePicker{id: govara_main_datepicker}

    GObjects.ColorPicker{id:govara_main_colorpicker}

    GObjects.Settings{id: govara_main_settings}

    GObjects.ConfirmDialog{id: govara_main_confirm}

    FluidControls.NavigationDrawer {
        id: govara_main_navigationdrawer
        height: govara_main_applicationwindow.height
        topContent: [
            FluidControls.NoiseBackground {
                color: Material.primary
                width: govara_main_navigationdrawer.width
                height: 150

                Label {
                    anchors{
                        right: parent.right
                        bottom: parent.bottom
                    }
                    padding: 10
                    text: qsTr("گوارا")
                    font.pixelSize: 20
                    font.bold: true
                }
            }
        ]
        actions: [
            FluidControls.Action {
                text: qsTr("تم برنامه")
                toolTip: qsTr("Colors")
                icon.source: FluidControls.Utils.iconUrl("image/color_lens")
                onTriggered: {
                    govara_main_colorpicker.openDialog();
                    govara_main_navigationdrawer.close();
                }
            },
            FluidControls.Action {
                text: qsTr("تنظیمات برنامه")
                toolTip: qsTr("Settings")
                icon.source: FluidControls.Utils.iconUrl("action/settings")
                hoverAnimation: true
                onTriggered: {
                    govara_main_settings.openDialog();
                    govara_main_navigationdrawer.close();
                }
            }
        ]
    }

    initialPage: FluidControls.TabbedPage {
        id: govara_main_tabbedpage
        appBar.maxActionCount: 6
        leftAction: FluidControls.Action {
            text: qsTr("Menu")
            toolTip: qsTr("Menu")
            icon.source: FluidControls.Utils.iconUrl("navigation/menu")
            onTriggered: govara_main_navigationdrawer.open()
        }
        actions: [
            FluidControls.Action {
                text: qsTr("Print")
                toolTip: qsTr("Print")
                icon.source: FluidControls.Utils.iconUrl("action/print")
                visible: govara_main_tabbedpage.currentIndex == 1
                onTriggered: switch(govara_main_tabbedpage.currentIndex){
                    case 0:
//                        govara_main_customerprint.openDialog(govara_main_connection.current(),"","","","","","","")
                        break;
                    case 1:
                        govara_main_serviceprint.openDialog("","","","","","","","","")
                        break;
                    case 2:
//                        govara_main_instalmentdialog.openDialog(govara_main_connection.current(),"","","","","","")
                        break;
                    case 3:
//                        govara_main_partdialog.openDialog(govara_main_connection.current(),"","")
                        break;
                }
            },
            FluidControls.Action {
                text: qsTr("Add")
                toolTip: qsTr("Add")
                icon.source: FluidControls.Utils.iconUrl("content/add")
                onTriggered: switch(govara_main_tabbedpage.currentIndex){
                    case 0:
                        govara_main_customerdialog.openDialog(govara_main_connection.current(),"","","","","","","")
                        break;
                    case 1:
                        govara_main_servicedialog.openDialog(govara_main_connection.current(),"","","","","","","","")
                        break;
                    case 2:
                        govara_main_instalmentdialog.openDialog(govara_main_connection.current(),"","","","","","")
                        break;
                    case 3:
                        govara_main_partdialog.openDialog(govara_main_connection.current(),"","")
                        break;
                }
            }
        ]

        GPages.CustomerTab{}
        GPages.ServiceTab{}
        GPages.InstalmentTab{}
        GPages.PartTab{}
    }
}
