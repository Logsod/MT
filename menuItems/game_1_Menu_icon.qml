import QtQuick 2.0
import QtQuick 2.9
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtQuick.Window 2.11
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.8
Rectangle {
    visible: true
    id:numberBlockGames
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    height: parent.height
    color:"transparent"
    Rectangle{
        width: parent.width
        height: parent.height
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

        Rectangle{
            width: parent.width
            height: parent.height
            scale: 0.95
            color:"transparent"
            Rectangle{
                id:block1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: block2.top
                width: parent.width/3
                height: parent.height / 4
                color: "green"
                scale: 1.2
                z:1
                Text {
                    text: qsTr("1")
                    minimumPointSize: 10
                    font.pointSize: 6000
                    fontSizeMode: Text.Fit
                    width: parent.width
                    height: parent.height
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            Rectangle{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                id:block2
                width: parent.width/3
                height: parent.height / 4
                color: "green"
                z:1
                Text {
                    text: qsTr("3")
                    minimumPointSize: 10
                    font.pointSize: 6000
                    fontSizeMode: Text.Fit
                    width: parent.width
                    height: parent.height
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    opacity: 0.7
                }
            }
            Rectangle{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: block2.bottom
                id:block3
                width: parent.width/3
                height: parent.height / 4
                color: "green"
                scale: 1.2
                z:1
                Text {
                    text: qsTr("2")
                    minimumPointSize: 10
                    font.pointSize: 6000
                    fontSizeMode: Text.Fit
                    width: parent.width
                    height: parent.height
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    opacity: 0.5
                }
            }

            DropShadow {
                anchors.fill: block1
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 17
                color: "#80000000"
                source: block1
                scale: 1.2
                z:0
            }
            DropShadow {
                anchors.fill: block2
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 17
                color: "#80000000"
                source: block2
                scale: 1
                z:0
            }
            DropShadow {
                anchors.fill: block3
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 17
                color: "#80000000"
                source: block3
                scale: 1.2
                z:0
            }
        }
    }
}
