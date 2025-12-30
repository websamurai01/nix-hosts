import QtQuick
import "../"
import "root:/"

BarBlock {
  id: text
  content: BarText {
    symbolText: `${Datetime.time}`
    
    // --- FONT CONFIGURATION ---
    fontFamily: Theme.get.fontFaceRight
    fontWeight: Theme.get.fontWeightRight
    fontSize: Theme.get.fontSizeRight
    textColor: Theme.get.textColorGlobal
  }
}
