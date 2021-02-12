import QtQuick 2.10
import QtQuick.Window 2.10

QtObject{

    property int dpi: Screen.pixelDensity * 25.4

    function dp_to_px(dp){
        if(dpi < 120) {
            return dp;
        } else {
            return dp*(dpi/160);
        }
    }

    function px_to_dp(px){
        if(dpi < 120) {
            return px;
        } else {
            return px*(160/dpi);
        }
    }

}
