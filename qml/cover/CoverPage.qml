import QtQuick 2.0
import Sailfish.Silica 1.0 //  needed for special SailfishOS components

CoverBackground {
    Label { // text label
        id: label
        anchors.centerIn: parent // centered inside the parent item
        text: qsTr("My Cover")
    }

    CoverActionList { // list of (up to two) actions on the app's cover
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh" // a source path of the icon. can be a local file as well, but then without the 'image://' path
            onTriggered: refresh() // this is triggered when you do this action (refresh() is defined in harbour-livesports.qml)
        }
    }
}


