pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root
  property var get: root

  // --- SCREENSAVER SETTINGS ---
  property bool screensaverActive: false
  property int screensaverFadeTime: 300 

  // --- DIMENSIONS & SPACING ---
  property int barHeight: 26
  property int iconSize: 18
  property int workspaceSpacing: 12
  property int workspaceInnerSpacing: 4
  property int sectionSpacingLeft: 12
  property int sectionSpacingRight: 32
  property int barMarginTop: 0        
  property int barMarginLeft: 0       
  property int barMarginRight: 0      
  property int barMarginBottom: 0
  property int barPaddingX: 12

  // --- BAR STYLING ---
  property string barBgColor: "#FF242424"
  property bool onTop: true

  // --- COLORS ---
  property string activeColor: "#40FFFFFF"
  property string inactiveColor: "transparent"
  property string hoverColor: "#60FFFFFF"
  
  property color textColorGlobal: "#B7B7B7"
  property color textColorCenter: "#B7B7B7"

  // --- WORKSPACE COLORS ---
  property color workspaceColorActive: "#B7B7B7"
  property color workspaceColorInactive: "#7A7A7A"

  // --- FONTS ---
  property string fontFaceWorkspaces: "CommitMono Nerd Font"
  property int fontWeightWorkspaces: Font.Bold
  property int fontSizeWorkspaces: 11
  property string fontFaceCenter: "CommitMono Nerd Font"
  property int fontWeightCenter: Font.Normal
  property int fontSizeCenter: 11
  property string fontFaceRight: "CommitMono Nerd Font"
  property int fontWeightRight: Font.Bold
  property int fontSizeRight: 11
  property string fontSymbol: "CommitMono Nerd Font"

  // --- SHADOWS ---
  property bool shadowWorkspacesEnabled: false
  property bool shadowCenterEnabled: false
  property bool shadowRightEnabled: false
}
