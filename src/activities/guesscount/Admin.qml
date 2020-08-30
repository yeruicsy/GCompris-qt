/* GCompris - Admin.qml
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import "../../core"
import "guesscount.js" as Activity

Row {
    id: admin
    spacing: 20
    property int level
    Rectangle {
        id: operator
        width: parent.width*0.23
        height: parent.height
        radius: 10.0;
        color: "red"
        state: "selected"
        GCText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: smallSize
            text: qsTr("Level %1").arg(level+1)
        }
    }
    Repeater {
        model: ['+','-','*','/']
        delegate: Rectangle {
            id: tile
            width: parent.width*0.1
            height: parent.height
            radius: 20
            opacity: 0.7
            state: Activity.check(modelData, activityConfiguration.adminLevelArr[level]) ? "selected" : "notselected"
            GCText {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: modelData
                fontSize: smallSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(tile.state == "selected") {
                        if(activityConfiguration.adminLevelArr[level].length > 1) {
                            tile.state = "notselected"
                            activityConfiguration.adminLevelArr[level].splice(activityConfiguration.adminLevelArr[level].indexOf(modelData), 1)
                        }
                    }
                    else {
                        tile.state = "selected"
                        activityConfiguration.adminLevelArr[level].push(modelData)
                    }
                }
            }
            states: [
                State {
                    name: "selected"
                    PropertyChanges { target: tile; color: "green" }
                },
                State {
                    name: "notselected"
                    PropertyChanges { target: tile; color: "red" }
                }
            ]
        }
    }
}
