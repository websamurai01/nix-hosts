import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "root:/"
import "../" 

RowLayout {
    spacing: Theme.get.workspaceSpacing
    property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    Repeater {
        model: ScriptModel {
            values: [...Hyprland.workspaces.values]
                .filter(ws => ws.monitor === monitor && ws.id > 0)
                .sort((a, b) => a.id - b.id)
        }

        BarBlock {
            property HyprlandWorkspace thisWorkspace: modelData
            property var myWindows: WindowTracker.getWindows(thisWorkspace.id)
            property bool isActive: Hyprland.focusedMonitor?.activeWorkspace?.id === thisWorkspace.id
            
            underline: isActive
            
            Layout.preferredWidth: Math.max(Theme.get.barHeight, content.implicitWidth)

            onClicked: Hyprland.dispatch(`workspace ${thisWorkspace.id}`)

            content: Row {
                // Now uses the theme setting
                spacing: Theme.get.workspaceInnerSpacing
                leftPadding: 0
                
                Item {
                    width: numText.implicitWidth
                    height: numText.implicitHeight
                    anchors.verticalCenter: parent.verticalCenter
                    
                    BarText { 
                        id: numText
                        text: thisWorkspace.id
                        
                        // Font
                        fontFamily: Theme.get.fontFaceWorkspaces
                        fontWeight: Theme.get.fontWeightWorkspaces
                        fontSize: Theme.get.fontSizeWorkspaces
                        textColor: isActive ? Theme.get.workspaceColorActive : Theme.get.workspaceColorInactive
                        
                        // Shadow
                        shadowEnabled: Theme.get.shadowWorkspacesEnabled
                        shadowColor: Theme.get.shadowWorkspacesColor
                        shadowX: Theme.get.shadowWorkspacesX
                        shadowY: Theme.get.shadowWorkspacesY

                        anchors.centerIn: parent
                    }
                }

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