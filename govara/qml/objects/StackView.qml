import QtQuick 2.0
import Fluid.Controls 1.0 as FluidControls

FluidControls.PageStack {
    property int backgroundIndex: 1
    background: Image{
        source: "qrc:/data/"+backgroundIndex+".jpg"
    }
}
