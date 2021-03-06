/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2017 UTKARSH TIWARI <iamutkarshtiwari@kde.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "bargame/Bargame.qml"
  difficulty: 1
  icon: "bargame/bargame.svg"
  author: "Utkarsh Tiwari &lt;iamutkarshtiwari@kde.org&gt;"
  //: Activity title
  title: qsTr("Bargame (against Tux)")
  //: Help title
  description: qsTr("Select the number of balls you wish to place in the holes and then click on the OK button. The winner is the one who hasn't put a ball in the red hole.")
  // intro: "Select the number of balls you wish to place in the holes and then click on the OK button. The winner is the one who hasn't put a ball in the red hole."
  //: Help goal
  goal: qsTr("Don't put the ball in the last hole.")
  //: Help prerequisite
  prerequisite: qsTr("Ability to count.")
  //: Help manual
  manual: qsTr("Click on the ball icon to select a number of balls, then click on the OK button to place the balls in the holes. You win if the computer has to place the last ball. If you want Tux to begin, just click on him.")
  credit: ""
  section: "strategy"
  createdInVersion: 8000
}
