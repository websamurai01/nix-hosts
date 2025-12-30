import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
// import Qt5Compat.GraphicalEffects
import "root:/" 

Text {
  // --- FONT CONFIG (Defaults) ---
  property string fontFamily: Theme.get.fontFaceCenter
  property int fontWeight: Theme.get.fontWeightCenter
  property int fontSize: Theme.get.fontSizeCenter
  property color textColor: Theme.get.textColorGlobal
  
  // --- SHADOW CONFIG (Defaults) ---
  property bool shadowEnabled: false
  property color shadowColor: "#000000"
  property int shadowX: 1
  property int shadowY: 1
  
  property string symbolFont: Theme.get.fontSymbol
  property int symbolSize: fontSize * 1.37
  property string symbolText
  
  text: wrapSymbols(symbolText)
  anchors.centerIn: parent
  
  color: textColor
  font.family: fontFamily
  font.weight: fontWeight
  font.pointSize: fontSize
  
  textFormat: Text.RichText
  
  // Shadow Source
  Text {
    visible: false
    id: textcopy
    text: parent.text
    textFormat: parent.textFormat
    color: parent.color
    font: parent.font
  }

  MultiEffect {
    anchors.fill: parent
    visible: parent.shadowEnabled
    source: textcopy
    
    shadowEnabled: parent.shadowEnabled
    shadowColor: parent.shadowColor
    shadowHorizontalOffset: parent.shadowX
    shadowVerticalOffset: parent.shadowY
    shadowBlur: 0.0 // Adjust if you want soft shadows
  }

  function wrapSymbols(text) {
    if (!text) return ""

    const isSymbol = (codePoint) =>
        (codePoint >= 0xE000   && codePoint <= 0xF8FF) 
     || (codePoint >= 0xF0000  && codePoint <= 0xFFFFF) 
     || (codePoint >= 0x100000 && codePoint <= 0x10FFFF); 

    return text.replace(/./gu, (c) => isSymbol(c.codePointAt(0))
      ? `<span style='font-family: ${symbolFont}; letter-spacing: -5px; font-size: ${symbolSize}px'>${c}</span>`
      : c);
  }
}
