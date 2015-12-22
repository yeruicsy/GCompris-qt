/* GCompris - graph-coloring.qml
 *
 * Copyright (C) 2015 Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *
 * Authors:
 *
 *   Akshat Tandon <akshat.tandon@research.iiit.ac.in> (Qt Quick version)
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1

import "../../core"
import "graph-coloring.js" as Activity
import GCompris 1.0

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/menu/resource/background.svg"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop
        focus: true

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: showChooser(false);
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias colorsRepeater: colorsRepeater
            property alias nodesRepeater: nodesRepeater
            property alias edgesRepeater: edgesRepeater
            property alias chooserGrid: chooserGrid
            property alias dataset: dataset
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Loader {
            id: dataset
            asynchronous: false
        }

        Column {
            id: colorsColumn

            anchors.left: parent.left
            anchors.leftMargin: 5 * ApplicationInfo.ratio
            anchors.top: parent.top
            anchors.topMargin: 5 * ApplicationInfo.ratio

            spacing: 3  * ApplicationInfo.ratio

            //width: guessColumn.guessSize
            //height: guessColumn.guessSize

            add: Transition {
                NumberAnimation { properties: "y"; duration: 1000; easing.type: Easing.OutBounce }
            }

            Repeater {
                id: colorsRepeater

                model: ListModel {}

                delegate:
                    Node {
                    width: 40 * ApplicationInfo.ratio
                    height: 40 * ApplicationInfo.ratio
                    border.width: 2
                    border.color: "white"
                    searchItemIndex: itemIndex
                }
            }
        }

        Rectangle {
            id: graphRect
            color: "transparent"
            anchors.left: parent.left
            anchors.leftMargin: 225 * ApplicationInfo.ratio
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            width: 1000 * ApplicationInfo.ratio
            height: 1000 * ApplicationInfo.ratio
            property int factor: 450

            Repeater {
                id: edgesRepeater
                model: ListModel {}
                delegate: Canvas {
                    id:edgeCanvas
                    anchors.fill:parent
                    onPaint:{
                        var ctx = getContext("2d")
                        ctx.lineWidth = 4
                        ctx.strokeStyle = "black"
                        ctx.beginPath()
                        ctx.moveTo( ((x1 * parent.factor) + 25) * ApplicationInfo.ratio, ((y1 * parent.factor) + 25) * ApplicationInfo.ratio)
                        ctx.lineTo( ((x2 * parent.factor) + 25) * ApplicationInfo.ratio, ((y2 * parent.factor) + 25) * ApplicationInfo.ratio)
                        ctx.stroke()
                    }
                }
            }
            Repeater{
                id: nodesRepeater

                model: ListModel {}

                delegate:
                    Node{
                    id: currentNode
                    x: posX * graphRect.factor * ApplicationInfo.ratio
                    y: posY * graphRect.factor * ApplicationInfo.ratio
                    width: 50 * ApplicationInfo.ratio
                    height: 50 * ApplicationInfo.ratio
                    radius: width/2
                    border.color: "black"
                    searchItemIndex: colIndex

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        enabled: true
                        z: 3
                        hoverEnabled: ApplicationInfo.isMobile ? false : true

                        onClicked:{
                            var obj = items.nodesRepeater.model.get(index);
                            if(chooserTimer.running && chooserGrid.guessIndex === index) {
                                if (mouse.button == Qt.LeftButton)
                                    obj.colIndex = (obj.colIndex ==
                                                    Activity.currentIndeces.length - 1) ? 0 : obj.colIndex + 1;
                                else
                                    obj.colIndex = (obj.colIndex == 0) ?
                                                Activity.currentIndeces.length - 1 : obj.colIndex - 1;
                            }
                            showChooser(true, index, parent);
                        }
                    }
                    states: State {
                        name: "scaled"; when: mouseArea.containsMouse
                        PropertyChanges {
                            target: currentNode
                            scale: 1.1
                        }
                    }
                    transitions: Transition {
                        NumberAnimation { properties: "scale"; easing.type: Easing.OutCubic }
                    }

                }
            }
        }
        function showChooser(visible, guessIndex, item)
        {
            if (!visible) {
                chooserTimer.stop();
                chooser.scale = 0;
                return;
            }
            var modelObj = items.nodesRepeater.model.get(guessIndex);
            var absolute = graphRect.mapToItem(background, item.x, item.y);
            chooserGrid.colIndex = modelObj.colIndex;
            chooserGrid.guessIndex = guessIndex;
            var targetX = absolute.x + item.width;
            var targetY = absolute.y - item.height/2;
            if (targetX < 0) {
                targetX = 0;
            }
            if (targetX > background.width) {
                targetX = background.width - chooser.width - 10;
            }
            if (targetY < 0) {
                targetY = 0;
            }
            if (targetY > background.height) {
                targetY = background.height - chooser.height - 10;
            }
            chooser.x = targetX;
            chooser.y = targetY;
            chooser.scale = 1;
            chooser.visible = true;
            chooserTimer.restart();
            //console.log(" item.x = " + item.x + " item.y" + item.y+" absolute.x" + absolute.x +" absolute.y" + absolute.y)
        }

        Rectangle {
            id: chooser

            width: chooserGrid.width + 10
            height: chooserGrid.height + 10

            color: "darkgray"
            border.width: 0
            border.color: "white"

            opacity: 1
            scale: 0
            visible: false
            z: 10

            GridView {
                id: chooserGrid

                cellWidth: 50 * ApplicationInfo.ratio
                cellHeight: 50 * ApplicationInfo.ratio
                width: Math.ceil(count / 2) * cellWidth
                height: 2 * cellHeight
                anchors.centerIn: parent
                z: 11

                clip: false
                interactive: false
                verticalLayoutDirection: GridView.TopToBottom
                layoutDirection: Qt.LeftToRight
                flow: GridView.FlowLeftToRight

                property int gridCount : count
                property int colIndex: 0
                property int guessIndex: 0

                Timer {
                    id: chooserTimer
                    interval: 5000
                    onTriggered: showChooser(false);
                }

                model: new Array()

                delegate: Node {
                    id: chooserItem
                    width: chooserGrid.cellWidth
                    height: chooserGrid.cellWidth
                    border.width: index == chooserGrid.colIndex ? 3 : 1
                    border.color: index == chooserGrid.colIndex ? "white" : "darkgray"
                    searchItemIndex: modelData
                    radius: 5

                    MouseArea {
                        id: chooserMouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        z: 11
                        hoverEnabled: ApplicationInfo.isMobile ? false : true

                        onClicked: {
                            chooserGrid.colIndex = chooserItem.searchItemIndex;
                            var obj = items.nodesRepeater.model;
                            obj.setProperty(chooserGrid.guessIndex, "colIndex", chooserGrid.colIndex);
                            showChooser(false);
                        }
                    }
                }
            }
        }

        BarButton {
            id: okButton

            anchors.right : graphRect.left
            anchors.verticalCenter: background.verticalCenter
            anchors.verticalCenterOffset: -30
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: 66 * bar.barZoom
            width: 70 * ApplicationInfo.ratio
            height:70 * ApplicationInfo.ratio
            visible: true
            z: 8
            onClicked: {
                showChooser(false);
                Activity.checkGuess();
            }
        }



        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}

