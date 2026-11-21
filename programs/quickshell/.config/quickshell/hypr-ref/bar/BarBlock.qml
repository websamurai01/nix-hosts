import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/"

Rectangle {
  id: root
  
  // 1. Dynamic Width: Fits content, but at least iconSize
  Layout.preferredWidth: Math.max(Theme.get.iconSize, (content ? content.implicitWidth : 0) + 0)
  
  // 2. Full Height: Fills the bar vertical space
  // This ensures the block structure (hover, underlines) fills the bar,
  // while the contentContainer below handles centering the icon.
  Layout.preferredHeight: Theme.get.barHeight

  property Item content
  property Item mouseArea: mouseArea

  property string text
  property bool dim: false
  property bool underline
  
  signal clicked() 

  color: "transparent"
  border.width: 0

  Behavior on color {
    ColorAnimation { duration: 200 }
  }

  // 3. Content Centering
  // Since 'root' is now 32px (barHeight) and content is 24px (iconSize),
  // this item will automatically position the content with equal top/bottom padding.
  Item {
    id: contentContainer
    implicitWidth:  content.implicitWidth
    implicitHeight: content.implicitHeight
    anchors.centerIn: parent
    children: content
  }

  MouseArea {
    id: mouseArea
    anchors.fill: root
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    onClicked: root.clicked()
  }

  Rectangle {
    id: wsLine
    height: 0 
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 0 
    radius: root.radius 

    color: {
      if (parent.underline)
        return "white";
      return "transparent";
    }
  }
}