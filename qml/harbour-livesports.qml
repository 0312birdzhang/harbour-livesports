import QtQuick 2.0
import Sailfish.Silica 1.0 //  needed for special SailfishOS components
import io.thp.pyotherside 1.3 // needed for the use of Python in the application. pyotherside installation might be needed
import "pages"

ApplicationWindow
{
    initialPage: Component { Live { } } // initial displayed page. try to change Live to Leagues and see what happens
    cover: Qt.resolvedUrl("cover/CoverPage.qml") // the URL to the cover page
    property string favorite_team: "Sparta Prague" // string to specify the best team, that should be then highlighten in the scores ;)
    property string gamesXml // a variable (can be a string, since XML is a string) that holds XML data when loaded
    property bool loading: true // a boolean that should be set true when the user is waiting for something and to false when the action is done

    Python { // this component represents the python object and can be called from anywhere in the application. pretty much anything that is defined in this (top) file can be called by any other page
        id: py // the id that can be then called

        Component.onCompleted: { // this action is triggered when the loading of this component is finished
            addImportPath(Qt.resolvedUrl('./py')); // adds import path to the directory of the Python script
            py.importModule('lscore', function () { // imports the Python module
                refresh() // this triggered when the import is done
            });
        }
    }
    signal refresh // this is how functions/signals are defined in qml. if you want them to be able to pass arguments, use for example 'signal refresh ( <type> <variable name> ) when <type> is string/boolean/var/... and <variable name> anything you want
    onRefresh: { // this is triggered when the 'refresh' signal is called
        loading = true // tells the app that something is being worked on
        py.call('lscore.parse', [], function(result) { // calling the 'parse' function from the 'lscore' Python module, without any arguments ( [] ) and returning a variable called 'result'
            gamesXml = result.toString() // 'result' is the output of the function and this way it is assigned to the global variable
            loading = false; // tells the app that everything is done
        });
    }

    BusyIndicator { running: loading; anchors.centerIn: parent } // the spinning wheel that indicates user is waiting for something
}


