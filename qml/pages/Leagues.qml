/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
// this page is very similar to Games.qml and Live.qml, so one has to figure out the documentation for herself/himself

Page {
    id: page
    SilicaListView {
        id: listView
        model: leaguesModel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Leagues")
        }
        PullDownMenu {
            MenuItem {
                text: qsTr("Refresh")
                onClicked: refresh()
            }
        }
        delegate: BackgroundItem {
            id: delegate

            Label {
                x: Theme.paddingLarge
                text: name
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: pageStack.push(Qt.resolvedUrl("Games.qml"), { league: Id }) // this pushes another page, a Games.qml page, with an arguments 'Id' of the league, so it can open the right league
        }
        VerticalScrollDecorator {}
        section {
                property: "country"
                criteria: ViewSection.FullString
                delegate: SectionHeader { text: section }
            }
    }

    XmlListModel {
        property string searchString: '' // this is not used yet, but can be used for filtering data
        id: leaguesModel
        xml: gamesXml
        query: "/leagues/league[contains(lower-case(child::name),lower-case('"+searchString+"'))]"

        XmlRole { name: "name"; query: "name/string()" }
        XmlRole { name: "country"; query: "country/string()" }
        XmlRole { name: "date"; query: "date/string()" }
        XmlRole { name: "Id"; query: "id/string()" }
    }
}
