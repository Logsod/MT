import QtQuick 2.0
import QtQuick.Window 2.2
Window{
    visible: true
    id:loaderWindow
    title: qsTr("Hello World")
    property int backgroundNumber: 1
    visibility: Window.FullScreen
    property int loaderWidth: width
    property int loaderHeight: height
    Loader {
        function setLoaderSource(newSource)
        {
            source = ""
            source = newSource
        }
        id: mainLoader
        property alias loaderWidth: loaderWindow.loaderWidth
        property alias loaderHeight: loaderWindow.loaderHeight
        property variant gameLoader: mainLoader
        property int game_1_block_count: 6
        property int game_2_cols: 2
        property int game_2_row: 3
        property int game_3_cols: 4
        property int game_3_row: 4
        anchors.fill: parent
        source: "qrc:/mainMenu.qml"//"qrc:/mainMenu.qml"

    }
    /*
    MouseArea {
        anchors.fill: parent

        onClicked: {
            background.source = (backgroundNumber ==  1 ? "qrc:/screen_1.qml" : "qrc:/screen_2.qml")
            backgroundNumber = (backgroundNumber == 1 ? 2 : 1)
        }
    }
    */
    Component.onCompleted: {
        //loaderWindow.visible = true
        mainLoader.loaderWidth = loaderWindow.width
        mainLoader.loaderHeight = loaderWindow.height
        //mainLoader.source =  "qrc:/screen_1.qml"
        backend.setSetting("testval", 4)
        var test = backend.getIntSettingValue("testval")
     }
    onWidthChanged: {
    }
}
