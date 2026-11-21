import QtQuick
import "root:/"

Item {
    id: root
    
    // Size determined by Theme
    width: Theme.get.iconSize
    height: Theme.get.iconSize

    implicitWidth: Theme.get.iconSize
    implicitHeight: Theme.get.iconSize

    property var client: null
    property bool isValid: client !== null && client !== undefined && client["class"] !== undefined

    property string appClass: {
        if (!isValid) return "";
        var c = (client["class"] || "").toString();
        if (c === "") c = (client.initialClass || "").toString();
        if (c === "") c = (client.title || "").toString();
        return c;
    }
    
    property string cleanName: appClass.toLowerCase()
    property string currentExt: "svg"
    
    onCleanNameChanged: root.currentExt = "svg"
    visible: isValid

    Image {
        id: icon
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        mipmap: true
        smooth: true
        antialiasing: true
        
        // Use Theme values for texture loading to ensure correct scaling/resolution
        sourceSize.width: Theme.get.iconSize
        sourceSize.height: Theme.get.iconSize
        
        source: root.cleanName 
                ? `root:/assets/icons/${root.cleanName}.${root.currentExt}` 
                : ""

        onStatusChanged: {
            if (status === Image.Error && root.currentExt === "svg") {
                root.currentExt = "png";
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: (icon.status === Image.Error || icon.status === Image.Null) && root.cleanName !== ""
        color: "#AA0000"
        radius: 3
        Text {
            anchors.centerIn: parent
            text: root.appClass.length > 0 ? root.appClass.charAt(0).toUpperCase() : "?"
            color: "white"
            font.pixelSize: 10
            font.bold: true
        }
    }
}
