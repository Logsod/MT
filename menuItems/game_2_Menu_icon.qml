import QtQuick 2.0
import QtQuick 2.9
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtQuick.Window 2.11
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.8

Rectangle {
    visible: true
    id:smileBlockGames
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    height: parent.height
    color:"transparent"
    Rectangle{
        width: parent.width
        height: parent.height
        color:"transparent"
        scale: 0.95
        Rectangle{
            id:back
            width: parent.width
            height: parent.height
            LinearGradient {
                anchors.fill: back
                start: Qt.point(0, 0)
                end: Qt.point(0, back.height*3.4)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#EFAC2C" }
                    GradientStop { position: 1.0; color: "#FB5231" }
                }
            }
        }

        DropShadow {
            anchors.fill: back
            horizontalOffset: 3
            verticalOffset: 3
            radius: 5.0
            samples: 15
            color: "#80000000"
            source: back
            scale: 1
        }
        ListModel{
            id: smileMenuGameModel
            ListElement{ image:""; number : 1 }
            ListElement{ image:"qrc:/smiles/13.png"; number : 0 }
            ListElement{ image:"qrc:/smiles/12.png"; number : 0 }
            ListElement{ image:""; number : 1 }
            ListElement{ image:"qrc:/smiles/4.png"; number : 0 }
            ListElement{ image:""; number : 1 }
            ListElement{ image:"qrc:/smiles/12.png"; number : 0 }
            ListElement{ image:"qrc:/smiles/13.png"; number : 0 }
            ListElement{ image:""; number : 1 }
        }
        clip: false
        GridView{
            interactive: false
            scale: 1
            id: smileMenuGameGrid
            width: parent.width
            height: parent.height
            cellHeight: smileMenuGameGrid.height / 3
            cellWidth:  smileMenuGameGrid.width / 3
            anchors.horizontalCenter: parent.horizontalCenter
            model: smileMenuGameModel
            delegate:
                Rectangle{
                color:"transparent"
                width: smileMenuGameGrid.cellWidth
                height: smileMenuGameGrid.cellHeight
                Text {
                    width: parent.width
                    height: parent.height
                    minimumPointSize: 10
                    font.pointSize: 6000
                    fontSizeMode: Text.Fit
                    text: (number === 1) ? "?" : ""
                    visible: (number === 0) ? 0 : 1
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    scale: 0.9
                    color:"white"
                }
                Image {
                    width: parent.width
                    height: parent.height
                    mipmap: true
                    source: (number === 0) ? image : ""
                    visible:(number === 0) ? 1 : 0
                }

            }
        }
    }
}
