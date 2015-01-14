import QtQuick 2.0
import Sailfish.Silica 1.0 //  needed for special SailfishOS components
// this is a custom QML component. we could put this thing inside every list we want to use it in, but it is easier to make this component and then just reference it from there. it can read all the variables from the page it is inserted in

ListItem {
    id: delegate
    height: column.height + 2*Theme.paddingLarge // column.height references the 'column' component and its 'height' property. try pressing Ctrl and clicking on 'column' here. Theme.paddingLarge should be used instead of pixels. see https://sailfishos.org/sailfish-silica/qml-sailfishsilica-theme.html
    property int scoreStatus: (fsh > fsa) ? 1 : ((fsh < fsa) ? 2 : 0 ) // standard decision mechanism in QML (question) ? (if true) : (if false). this returns 0 if teams tie, 1 if home team is winning and 2 if the away team is winning
    property bool favorite: (fh === favorite_team || fs === favorite_team) // is true if your favorite team is playing in this game
    Column { // column defines, that all components inside it should be arranges below each other. therefore you cannot use any positioning such as anchors.top
        id: column
        spacing: Theme.paddingMedium // this defines the gap between child elements.
        width: parent.width // has the same width as its parent component ('delegate' in this case)

        Item { // item is a generic component
            width: parent.width
            height: Math.max(fhLabel.paintedHeight, faLabel.paintedHeight) + 2*Theme.paddingLarge // the Math.max function picks the greater number of two inserted ones
            anchors.horizontalCenter: parent.horizontalCenter // puts the item in the horizontal center of its parent ('column' in this case)
            Label {
                id: fhLabel
                x: Theme.paddingLarge // how far it is from the left edge
                width: (delegate.width / 3)
                text: fh //  references a variable from the model
                anchors {
                    margins: Theme.paddingLarge // defines how far it should be from the edges
                    left: parent.left // defines that its left edge should be aligned with the left edge of the parent item (Item, unnamed, in this case)
                    top: parent.top // defines that its top edge should be aligned with the top edge of the parent item (Item, unnamed, in this case)
                }
                color: delegate.highlighted ? Theme.highlightColor : Theme.secondaryColor // this is important not to forget - changes color if used presses the list item
                wrapMode: Text.Wrap // text can be wrapped
            }
            Label {
                id: scoreLabel
                x: Theme.paddingLarge
                text: fs
                anchors.centerIn: parent
                font.pixelSize: Theme.fontSizeExtraLarge
                color: delegate.highlighted ? Theme.highlightColor : [Theme.primaryColor, "green", "blue"][scoreStatus]
                onTextChanged: console.log("Score changed")
            }

            Label {
                id: faLabel
                x: Theme.paddingLarge
                width: (delegate.width / 3)
                text: fa
                anchors {
                    margins: Theme.paddingLarge
                    right: parent.right
                    top: parent.top
                }
                color: delegate.highlighted ? Theme.highlightColor : Theme.secondaryColor
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}
