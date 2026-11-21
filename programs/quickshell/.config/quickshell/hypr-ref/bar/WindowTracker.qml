pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

QtObject {
    id: root
    property var windowsMap: ({})

    function getWindows(workspaceId) {
        var key = workspaceId.toString();
        return root.windowsMap[key] || [];
    }

    property Timer _debounce: Timer {
        interval: 10
        repeat: false
        onTriggered: {
            if (root._proc.running) root._proc.running = false
            root._proc.running = true
        }
    }

    property Process _proc: Process {
        command: ["hyprctl", "clients", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.length > 0) root._parse(text)
            }
        }
    }

    function _parse(jsonStr) {
        try {
            var clients = JSON.parse(jsonStr);
            var map = {};
            
            clients.forEach(c => {
                if (c.workspace && c.workspace.id !== undefined) {
                    var wsId = c.workspace.id;
                    var key = wsId.toString();
                    if (!map[key]) map[key] = [];
                    map[key].push(c);
                }
            });

            for (var key in map) {
                map[key].sort((a, b) => a.at[0] - b.at[0]);
            }
            
            root.windowsMap = map;
        } catch (e) { 
            console.error("[WindowTracker] JSON Parse Error:", e); 
        }
    }

    property Connections _conn: Connections {
        target: Hyprland
        function onRawEvent(event) {
            // Added 'activewindow' and 'workspace' to ensure we catch all state changes
            if (["openwindow", "closewindow", "movewindow", "windowtitle", "activewindow", "workspace"].includes(event.name)) {
                root._debounce.restart();
            }
        }
    }

    Component.onCompleted: _debounce.restart()
}

