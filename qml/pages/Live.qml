import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0


Page {
    id: page
    property string gametype: 'live' // a variable used to specify which type of event should be displayed by the model. for the defined types, look in the Python file
    onStatusChanged: { // this is called when the page changes (for example when you come back from another page)
        if (status === PageStatus.Active && pageStack.depth === 1) {
            pageStack.pushAttached("Leagues.qml", {}); // this pushes the attached page / menu to the right
        }
    }
    SilicaListView {
        id: listView
        model: liveModel // model which is shown in the list view
        // anchors.fill makes the component fill the other referenced component
        anchors.fill: parent // links to the next component above ('page' in this case)
        header: PageHeader { // page title
            title: qsTr("Live Scores")
        }
        PullDownMenu { // special menu on SailfishOS
            MenuItem {
                text: qsTr("Refresh")
                onClicked: refresh() // refresh action (defined in harbour-livesports.qml) triggered when the menu option is selected
            }
        }
        delegate: GameDelegate {} // delegate of a single list item
        VerticalScrollDecorator {} // the line on the right that expresses the position in the list
        section { // section title, displayed according to the property from the model. in this case, it is the 'league' property
                property: "league"
                criteria: ViewSection.FullString
                delegate: SectionHeader { text: section }
            }
    }

    XmlListModel {
        id: liveModel
        xml: gamesXml // defines the variable where the model reads xml data from
        query: "/leagues/*/games/game[child::status = '"+gametype+"']" // XML XPATH path to find the needed item in the xml file

        XmlRole { name: "fd"; query: "fd/string()" } // defines variables in the model, according to the definitions in the xml file
        XmlRole { name: "fh"; query: "fh/string()" }
        XmlRole { name: "fa"; query: "fa/string()" }
        XmlRole { name: "fs"; query: "fs/string()" }
        XmlRole { name: "fsh"; query: "fsh/string()" }
        XmlRole { name: "fsa"; query: "fsa/string()" }
        XmlRole { name: "league"; query: "league/string()" }
    }
}





