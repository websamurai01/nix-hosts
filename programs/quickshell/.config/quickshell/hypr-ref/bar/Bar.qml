import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "blocks" as Blocks
import "root:/"

Scope {
  Variants {
    model: Quickshell.screens
  
    PanelWindow {
      id: bar
      property var modelData
      screen: modelData

      color: "transparent"
      implicitHeight: Theme.get.barHeight
      visible: true 

      Item {
        id: barContainer
        anchors.fill: parent
        
        opacity: Theme.get.screensaverActive ? 0 : 1

        Behavior on opacity {
          NumberAnimation { 
            duration: Theme.get.screensaverFadeTime
            easing.type: Easing.InOutCubic
          }
        }

        Rectangle {
          anchors.fill: parent
          color: Theme.get.barBgColor
        }

        RowLayout {
          id: allBlocks
          anchors.fill: parent
          spacing: 0
          anchors.leftMargin: Theme.get.barPaddingX
          anchors.rightMargin: Theme.get.barPaddingX
    
          Row {
            id: leftBlocks
            spacing: Theme.get.sectionSpacingLeft
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Blocks.SpecialWorkspaces {}
            Blocks.Workspaces {}
          }

          Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
          }
    
          RowLayout {
            id: rightBlocks
            spacing: Theme.get.sectionSpacingRight
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Blocks.Date {}
            Blocks.Time {}
          }
        }

        Blocks.ActiveWorkspace {
          id: activeWorkspace
          anchors.centerIn: parent
          chopLength: {
              var occupied = rightBlocks.implicitWidth + leftBlocks.implicitWidth
              var available = bar.width - occupied - (Theme.get.barPaddingX * 2) - 20
              var chars = Math.floor(available / 10)
              return Math.max(10, chars)
          }
        }
      }

      IpcHandler {
        target: "bar"
        function toggleVis(): void { barContainer.opacity = barContainer.opacity > 0 ? 0 : 1; }
      }
    
      anchors {
        top: Theme.get.onTop
        bottom: !Theme.get.onTop
        left: true
        right: true
      }

      margins {
        left: Theme.get.barMarginLeft
        right: Theme.get.barMarginRight
        top: Theme.get.onTop ? Theme.get.barMarginTop : 0
        bottom: !Theme.get.onTop ? Theme.get.barMarginBottom : 0
      }
    }
  }
}
