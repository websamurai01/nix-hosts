import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import "root:/"

Scope {
    property string wallpaperPath: ""

    Process {
        id: getWall
        command: ["sh", "-c", "swww query | awk -F 'image: ' '/image:/{print $2; exit}'"]
        stdout: StdioCollector {
            id: wallOutput
            onStreamFinished: wallpaperPath = wallOutput.text.trim()
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: screensaverWindow
            property var modelData
            screen: modelData
            
            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true
            
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusiveZone: -1 
            WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
            
            color: "transparent"
            visible: false

            Item {
                id: container
                anchors.fill: parent
                opacity: 0
                focus: screensaverWindow.visible

                Behavior on opacity { 
                    NumberAnimation { duration: Theme.get.screensaverFadeTime } 
                }

                Rectangle {
                    anchors.fill: parent
                    color: "black"
                }

                Image {
                    anchors.fill: parent
                    source: wallpaperPath ? "file://" + wallpaperPath : ""
                    fillMode: Image.PreserveAspectCrop
                }

                Keys.onPressed: (event) => exitLogic.trigger()
            }

            MouseArea {
                anchors.fill: parent
                onPressed: exitLogic.trigger()
            }

            QtObject {
                id: exitLogic
                function trigger() {
                    Theme.get.screensaverActive = false;
                    container.opacity = 0;
                    cleanupTimer.start();
                }
            }

            Timer {
                id: cleanupTimer
                interval: Theme.get.screensaverFadeTime
                onTriggered: screensaverWindow.visible = false
            }

            IpcHandler {
                target: "screensaver"
                function activate(): void {
                    getWall.running = true;
                    screensaverWindow.visible = true;
                    container.opacity = 1;
                    container.forceActiveFocus();
                    Theme.get.screensaverActive = true;
                }
            }
        }
    }
}
