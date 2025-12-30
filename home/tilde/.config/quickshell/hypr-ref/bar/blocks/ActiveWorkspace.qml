import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../"
import "root:/"

BarText {
  property int chopLength

  property string activeWindowTitle: Hyprland.activeToplevel 
                                     ? Hyprland.activeToplevel.title 
                                     : ""

  // Font
  fontFamily: Theme.get.fontFaceCenter
  fontWeight: Theme.get.fontWeightCenter
  fontSize: Theme.get.fontSizeCenter
  textColor: Theme.get.textColorCenter

  // Shadow
  shadowEnabled: Theme.get.shadowCenterEnabled
  shadowColor: Theme.get.shadowCenterColor
  shadowX: Theme.get.shadowCenterX
  shadowY: Theme.get.shadowCenterY

  text: {
    var str = activeWindowTitle
    return str.length > chopLength ? str.slice(0, chopLength) + '...' : str;
  }
}
