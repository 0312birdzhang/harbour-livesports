import QtQuick 2.0
import Sailfish.Silica 1.0 //  needed for special SailfishOS components
import QtQuick.XmlListModel 2.0 // needed for the use of XmlListModel


Page {
    id: page // id of the component, that can be referenced from other components
    property string league: '' // an input argument to open the right league
    SilicaListView {
        id: listView
        model: leaguesModel // model which is shown in the list view
        // anchors.fill makes the component fill the other referenced component
        anchors.fill: parent // links to the next component above ('page' in this case)
        header: PageHeader { // page title
            title: qsTr("Games")
        }
        PullDownMenu { // special menu on SailfishOS
            MenuItem {
                text: qsTr("Refresh")
                onClicked: refresh() // refresh action (defined in harbour-livesports.qml) triggered when the menu option is selected
            }
        }
        delegate: GameDelegate {} // delegate of a single list item
        VerticalScrollDecorator {} // the line on the right that expresses the position in the list
    }

    XmlListModel {
        id: leaguesModel
        xml: gamesXml // defines the variable where the model reads xml data from
        query: "/leagues/league[contains(lower-case(child::id),lower-case('"+league+"'))]/games/game" // XML XPATH path to find the needed item in the xml file

        XmlRole { name: "fd"; query: "fd/string()" } // defines variables in the model, according to the definitions in the xml file
        XmlRole { name: "fh"; query: "fh/string()" }
        XmlRole { name: "fa"; query: "fa/string()" }
        XmlRole { name: "fs"; query: "fs/string()" }
        XmlRole { name: "fsh"; query: "fsh/string()" }
        XmlRole { name: "fsa"; query: "fsa/string()" }
    }
}





