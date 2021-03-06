/* GCompris - NandGate.qml
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
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
import GCompris 1.0

ElectricalComponent {
    id: nandGate
    terminalSize: 0.5
    noOfInputs: 2
    noOfOutputs: 1
    property var inputTerminalPosY: [0.2, 0.8]

    information: qsTr("A NAND gate outputs the opposite of an AND gate. " +
                      "If all the inputs are 1, the output is equal to 0 and as soon as one input is equal to 0 it gives a 1:")

    truthTable: [['A','B',qsTr("NOT (A AND B)")],
                 ['0','0','1'],
                 ['0','1','1'],
                 ['1','0','1'],
                 ['1','1','0']]

    property alias inputTerminals: inputTerminals
    property alias outputTerminals: outputTerminals

    Repeater {
        id: inputTerminals
        model: 2
        delegate: inputTerminal
        Component {
            id: inputTerminal
            TerminalPoint {
                posX: 0.04
                posY: inputTerminalPosY[index]
                type: "In"
            }
        }
    }

    Repeater {
        id: outputTerminals
        model: 1
        delegate: outputTerminal
        Component {
            id: outputTerminal
            TerminalPoint {
                posX: 0.96
                posY: 0.5
                type: "Out"
            }
        }
    }

    function updateOutput(wireVisited) {
        var terminal = outputTerminals.itemAt(0)
        /* Keep the output value == 0 if only one of the input terminals is connected */
        terminal.value = (inputTerminals.itemAt(0).wires.length != 0 && inputTerminals.itemAt(1).wires.length != 0) ? !(inputTerminals.itemAt(0).value & inputTerminals.itemAt(1).value) : 0
        for(var i = 0 ; i < terminal.wires.length ; ++i)
            terminal.wires[i].to.value = terminal.value

        var componentVisited = []
        for(var i = 0 ; i < terminal.wires.length ; ++i) {
            var wire = terminal.wires[i]
            var component = wire.to.parent
            componentVisited[component] = true
            wireVisited[wire] = true
            component.updateOutput(wireVisited)
        }
    }
}
