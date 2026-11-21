import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "root:/"
import "../" // Imports WindowTracker and WindowIcon from bar/

RowLayout {
    id: root
    spacing: Theme.get.workspaceInnerSpacing
    property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    visible: repeater.count > 0

    Repeater {
        id: repeater
        model: ScriptModel {
            values: [...Hyprland.workspaces.values]
                .filter(ws => ws.monitor === monitor && ws.id < 0)
                .sort((a, b) => a.id - b.id)
        }

        BarBlock {
            property HyprlandWorkspace thisWorkspace: modelData
            property var myWindows: WindowTracker.getWindows(thisWorkspace.id)
            property bool isActive: Hyprland.focusedMonitor?.activeWorkspace?.id === thisWorkspace.id
            
            visible: myWindows.length > 0

            underline: isActive
            
            Layout.preferredWidth: content.implicitWidth

            onClicked: Hyprland.dispatch(`togglespecialworkspace ${thisWorkspace.name.replace("special:", "")}`)

            content: Row {
                spacing: Theme.get.workspaceInnerSpacing
                anchors.centerIn: parent

                Repeater {
                    model: ScriptModel {
                        values: myWindows
                    }

                    delegate: WindowIcon {
                        client: modelData
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
