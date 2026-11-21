import QtQuick
import Quickshell
import Quickshell.Io
import "root:/"
import "../"

BarBlock {
    id: root

    // --- EMOJIS ---
    property string icoClear:     "☀️"
    property string icoPartCloud: "⛅"
    property string icoCloudy:    "☁️"
    property string icoFog:       "🌫️"
    property string icoRain:      "🌧️"
    property string icoSnow:      "❄️"
    property string icoThunder:   "⛈️"
    property string icoUnknown:   "✨"

    // --- DATA ---
    property string currentTemp: ""
    property string currentDesc: "Loading..."
    property string currentIcon: "⌛"

    // --- VISUALS ---
    content: BarText {
        symbolText: root.currentTemp === "" 
                    ? `${root.currentIcon} ${root.currentDesc}`
                    : `${root.currentIcon} ${root.currentDesc}, ${root.currentTemp}°C`
        
        fontFamily: Theme.get.fontFaceRight
        fontWeight: Theme.get.fontWeightRight
        fontSize: Theme.get.fontSizeRight
        textColor: Theme.get.textColorGlobal

        shadowEnabled: Theme.get.shadowRightEnabled
        shadowColor: Theme.get.shadowRightColor
        shadowX: Theme.get.shadowRightX
        shadowY: Theme.get.shadowRightY
    }

    // --- PROCESS (Shell + JQ) ---
    Process {
        id: weatherProc
        
        // We spawn a shell so pipes (|) work.
        // 1. Curl the JSON
        // 2. Pipe to JQ to extract exactly "Temp|Desc|Code"
        command: [
            "sh", "-c", 
            "curl -s 'wttr.in/60.04976,30.21584?format=j1' | jq -r '.current_condition[0] | \"\\(.temp_C)|\\(.weatherDesc[0].value)|\\(.weatherCode)\"'"
        ]
        
        // Output will be a single line: "2|Overcast|122"
        stdout: SplitParser {
            onRead: (data) => root.parseData(data)
        }
        
        stderr: StdioCollector {
            onStreamFinished: (err) => { if(err) console.error("[Weather Error] " + err) }
        }
    }

    function parseData(line) {
        // console.log("[Weather] Raw: " + line); // Debug
        
        if (!line || line.trim() === "") return;

        var parts = line.split("|");
        if (parts.length < 3) return;

        root.currentTemp = parts[0];
        root.currentDesc = parts[1];
        
        var code = parseInt(parts[2]);
        root.currentIcon = getEmoji(code);
    }

    function getEmoji(c) {
        if (c === 113) return icoClear;
        if (c === 116) return icoPartCloud;
        if (c === 119 || c === 122) return icoCloudy;
        if ([143, 248, 260].includes(c)) return icoFog;
        if ([176, 263, 266, 281, 284, 293, 296, 299, 302, 305, 308, 311, 314, 350, 353, 356, 359, 362, 365].includes(c)) return icoRain;
        if ([179, 182, 185, 227, 230, 317, 320, 323, 326, 329, 332, 335, 338, 350, 368, 371, 374, 377].includes(c)) return icoSnow;
        if ([200, 386, 389, 392, 395].includes(c)) return icoThunder;
        return icoUnknown;
    }

    // --- TIMER ---
    Component.onCompleted: updateAndSchedule()

    Timer {
        id: syncTimer
        repeat: true
        onTriggered: updateAndSchedule()
    }

    function updateAndSchedule() {
        if (weatherProc.running) return;
        weatherProc.running = true;

        var now = new Date();
        var min = now.getMinutes();
        var sec = now.getSeconds();
        var targetMin = (min < 30) ? 30 : 60;
        var diffMin = targetMin - min;
        var delayMs = ((diffMin * 60) - sec) * 1000;
        
        if (delayMs <= 2000) delayMs = 30 * 60 * 1000;

        syncTimer.interval = delayMs;
        syncTimer.start();
    }
}
