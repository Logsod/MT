import QtQuick 2.0
import QtQuick 2.9
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtQuick.Window 2.11
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.8
import VPlayPlugins 1.0

Item {
    visible: true
    width:Screen.width
    height:Screen.height
    id:mainRect
    property variant sprites: []

    property int spriteWidth: 0
    property int spriteHeight: 0
    property int backGroundNumColumn: 5
    property int oneItemMenuCellWidth: (width < height) ?  parent.height * 0.8 / 3 : parent.width * 0.8 / 3
    Timer{
        interval: 160
        repeat: true
        running: false
        onTriggered: {
            for(var i =0;i<sprites.length;i++)
            {
                sprites[i].x += mainRect.width / (spriteWidth) * 0.1
                if(sprites[i].x >= mainRect.width)
                    sprites[i].x= -(spriteWidth)
                sprites[i].y += mainRect.height / (spriteHeight) * 0.1
                if(sprites[i].y >= mainRect.height)
                    sprites[i].y= -(spriteWidth)
            }
        }
    }

    LinearGradient {
        anchors.fill: parent
        start: Qt.point(0, 0)
        end: Qt.point(0, mainRect.height*1.4)
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#EFAC2C" }
            GradientStop { position: 1.0; color: "#FB5231" }
        }
    }
    Rectangle{
        id:animatedBackground
        width: parent.width
        height: parent.height
        color:"transparent"
        opacity: 0.3
        Component.onCompleted: {
            console.log("create sprites"+Screen.width+ " " + Screen.height)
            var numCol = backGroundNumColumn
            var cellWidth = (mainRect.width / numCol)
            var xAt = -cellWidth
            var yAt = -cellWidth
            var numRow = 0
            spriteWidth = mainRect.width / backGroundNumColumn
            var component = Qt.createComponent("qrc:/menuItems/backgroundSprite.qml");
            for(var i = 0; xAt < mainRect.width+cellWidth; i++)
            {
                yAt = -cellWidth
                numRow = 0
                for(var w = 0; yAt < mainRect.height; w++)
                {
                    var sprite = component.createObject(animatedBackground, {
                                                            "x": xAt, "y": yAt,
                                                            "screenW" : mainRect.width, "screenH" : mainRect.height,
                                                            "startX" : xAt, "startY" : xAt,
                                                        });
                    if (sprite === null) {
                        console.log("Error creating object");
                    }
                    sprites.push(sprite)
                    yAt +=cellWidth
                    numRow++;
                }

                xAt +=cellWidth
            }
            spriteHeight = (mainRect.height / numRow)
        }

    }


    Rectangle{
        //anchors.top: menuTitle.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        id:gameChooser
        height: oneItemMenuCellWidth
        width:  parent.width * 0.8
        color: "transparent"
        ListModel{
            id:gameChooserModel
            ListElement{
                gameName:"numberBlock"
                gameSource: ""
                iconSource: "qrc:/menuItems/game_1_Menu_icon.qml"
                modelName: "game1ChooserMode"
            }
            ListElement{
                gameName:"smileBlock"
                gameSource: ""
                iconSource: "qrc:/menuItems/game_2_Menu_icon.qml"
                modelName: "game2ChooserMode"
            }
            ListElement{
                gameName:"numberHideBlock"
                gameSource: ""
                iconSource: "qrc:/menuItems/game_3_Menu_icon.qml"
                modelName: "game3ChooserMode"
            }
        }
        function getModelObjectByName(modelNameString)
        {
            if(modelNameString==="game1ChooserMode")
                return game1ChooserMode;
            if(modelNameString==="game2ChooserMode")
                return game2ChooserMode;
            if(modelNameString==="game3ChooserMode")
                return game3ChooserMode;

        }
        GridView{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            visible: true
            id:gameChooserGrid
            width: parent.width
            height: parent.width / 3
            cellWidth: parent.width / 3
            cellHeight: cellWidth
            model: gameChooserModel
            interactive: false
            delegate:
                Rectangle{
                color: "transparent"
                width: gameChooserGrid.cellWidth
                height: gameChooserGrid.cellHeight
                Loader{
                    width: gameChooserGrid.cellWidth
                    height: gameChooserGrid.cellHeight
                    source:  iconSource

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            chooserGrid.model = gameChooser.getModelObjectByName(modelName)
                            showSubMenu1Animation.start()
                            showSubMenu1Animation1.start()
                        }
                    }
                }
            }
        }
    }



    Item{
        id:menuTitle
        width: parent.width * 0.5
        height: parent.height * 0.2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalAlignment
        anchors.bottom: gameChooser.top
        Text {
            text: qsTr("SELECT GAME")
            id:titleText
            font.bold: true
            minimumPointSize: 10
            font.pointSize: 6000
            fontSizeMode: Text.Fit
            width: parent.width
            height: parent.height
            color: "black"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            Component.onCompleted: {
                switch (Qt.locale().name.substring(0,2)) {
                case "ru":
                    text = "ВЫБЕРИТЕ ИГРУ"
                    break;
                default:
                    text = "SELECT GAME"
                }
            }
        }
        DropShadow {
            anchors.fill: titleText
            source: titleText
            horizontalOffset: 3
            verticalOffset: 3
            color: "#80000000"
            radius: 5
            samples: 15
        }
    }

    Item{

        id:totalPoints
        width: oneItemMenuCellWidth / 2
        height: oneItemMenuCellWidth / 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalAlignment
        anchors.top: gameChooser.bottom
        Item{
            //anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalAlignment
            width: parent.width
            height: parent.height / 1.5
            Image {
                id: name
                source: "qrc:/images/brain.png"
                width: parent.height
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                mipmap: true
                opacity: 0.7
            }
            Text {
                id:currentMemPoint
                anchors.left: name.right
                text: backend.getTotalMemPoints()
                width: parent.width - name.width
                height: parent.height / 3
                minimumPointSize: 6
                font.pointSize: 6000
                fontSizeMode: Text.Fit
                anchors.verticalCenter: name.verticalCenter
            }
        }


        /*
        Text {
            text: qsTr("select game")
            id:titleText
            minimumPointSize: 10
            font.pointSize: 6000
            fontSizeMode: Text.Fit
            width: parent.width
            height: parent.height
            color: "black"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
         }
        DropShadow {
            anchors.fill: titleText
            source: titleText
            horizontalOffset: 3
            verticalOffset: 3
            color: "#80000000"
            radius: 5
            samples: 15
        }
         */
    }

    Rectangle{
        visible: false
        id:subMenu1
        width: gameChooser.width + 6
        height: menuTitle.height + totalPoints.height * 2 + 5
        anchors.top: menuTitle.top
        anchors.horizontalCenter: parent.horizontalCenter
        LinearGradient {
            anchors.fill: subMenu1
            start: Qt.point(0, 0)
            end: Qt.point(0, subMenu1.height*3.4)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#EFAC2C" }
                GradientStop { position: 1.0; color: "#FB5231" }
            }
        }

        transform: Rotation {id:subMenu1Transform; origin.x: subMenu1.width/2; origin.y: subMenu1.height/2; axis { x: 0; y: 1; z: 0 }angle: 90}
        NumberAnimation{
            id:showSubMenu1Animation
            target: subMenu1Transform
            property: "angle"
            from: 90
            to: 0
            duration: 300
            onRunningChanged: if(running) subMenu1.visible = true
        }
        NumberAnimation{
            id:showSubMenu1Animation1
            target: subMenu1
            property: "opacity"
            from: 0
            to: 1
            duration: 200
        }
        NumberAnimation{
            id:hideSubMenu1Animation
            target: subMenu1Transform
            property: "angle"
            from: 0
            to: 90
            duration: 300
            onRunningChanged: if(!running) subMenu1.visible = false
        }
        NumberAnimation{
            id:hideSubMenu1Animation1
            target: subMenu1
            property: "opacity"
            from: 1
            to: 0
            duration: 600
        }

        Item{
            id:subMenu1title
            width: parent.width * 0.5
            height: parent.height * 0.15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalAlignment
            anchors.top: parent.top
            Text {
                text: qsTr("SELECT DIFFICULTY")
                font.bold: true
                styleColor: "orange"
                style: Text.Raised
                id:subMenu1titleText
                minimumPointSize: 10
                font.pointSize: 6000
                fontSizeMode: Text.Fit
                width: parent.width
                height: parent.height * 0.7
                color: "#000000"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                scale: 1
                Component.onCompleted: {
                    switch (Qt.locale().name.substring(0,2)) {
                    case "ru":
                        text = "ВЫБЕРИТЕ СЛОЖНОСТЬ"
                        break;
                    default:
                        text = "SELECT DIFFICULTY"
                    }
                }
            }


        }
        Item{
            id:subMenuMainItem
            width: parent.width * 0.5
            height: parent.height * 0.6
            anchors.top: subMenu1title.bottom
            anchors.horizontalCenter: subMenu1title.horizontalCenter

            ListModel{
                id:game1ChooserMode
                ListElement{
                    difficulty :  1
                    unlocked: true
                    gameQmlSource: "qrc:/game_1.qml"
                    gameName: "g_1_easy_unlock"
                    gameId:1
                    game_1_block_count: 5
                    useLacale: true
                }
                ListElement{
                    difficulty : 2
                    unlocked: false
                    gameQmlSource: "qrc:/game_1.qml"
                    pointCost:1
                    gameName: "g_1_normal_unlock"
                    gameId:1
                    game_1_block_count: 6
                    useLacale: true
                }
                ListElement{
                    difficulty : 3
                    unlocked: false
                    gameQmlSource: "qrc:/game_1.qml"
                    pointCost:1
                    gameName: "g_1_hard_unlock"
                    gameId:1
                    game_1_block_count: 7
                    useLacale: true
                }
                ListElement{
                    difficulty : 4
                    unlocked: false
                    gameQmlSource: "qrc:/game_1.qml"
                    pointCost:1
                    gameName: "g_1_insane_unlock"
                    gameId:1
                    game_1_block_count: 8
                    useLacale: true
                }
            }
            ListModel{
                id:game2ChooserMode
                ListElement{
                    difficulty : "2x3"
                    unlocked: true
                    gameQmlSource: "qrc:/game_2.qml"
                    gameName: "g_2_easy_unlock"
                    gameId:2
                    game_2_cols : 2
                    game_2_row : 3
                    useLacale: true
                }
                ListElement{
                    difficulty : "2x4"
                    unlocked: false
                    gameQmlSource: "qrc:/game_2.qml"
                    pointCost:1
                    gameName: "g_2_normal_unlock"
                    gameId:2
                    game_2_cols : 3
                    game_2_row : 4
                    useLacale: true
                }
                ListElement{
                    difficulty : "5x4"
                    unlocked: false
                    gameQmlSource: "qrc:/game_2.qml"
                    pointCost:1
                    gameName: "g_2_hard_unlock"
                    gameId:2
                    game_2_cols : 5
                    game_2_row : 4
                    useLacale: true
                }
                ListElement{
                    difficulty : "6x5"
                    unlocked: false
                    gameQmlSource: "qrc:/game_2.qml"
                    pointCost:1
                    gameName: "g_2_insane_unlock"
                    gameId:2
                    game_2_cols : 6
                    game_2_row : 5
                    useLacale: true
                }
            }
            ListModel{
                id:game3ChooserMode
                ListElement{
                    difficulty : "2x3"
                    unlocked: true
                    gameQmlSource: "qrc:/game_3.qml"
                    gameName: "g_3_easy_unlock"
                    gameId:3
                    game_3_cols : 2
                    game_3_row : 3
                    useLacale: true
                }
                ListElement{
                    difficulty : "3x3"
                    unlocked: false
                    gameQmlSource: "qrc:/game_3.qml"
                    pointCost:1
                    gameName: "g_3_normal_unlock"
                    gameId:3
                    game_3_cols : 3
                    game_3_row : 3
                    useLacale: true
                }
                ListElement{
                    difficulty : "4x4"
                    unlocked: false
                    gameQmlSource: "qrc:/game_3.qml"
                    pointCost:1
                    gameName: "g_3_hard_unlock"
                    gameId:3
                    game_3_cols : 4
                    game_3_row : 4
                    useLacale: true
                }
                ListElement{
                    difficulty : "5x5"
                    unlocked: false
                    gameQmlSource: "qrc:/game_3.qml"
                    pointCost:1
                    gameName: "g_3_insane_unlock"
                    gameId:3
                    game_3_cols : 5
                    game_3_row : 5
                    useLacale: true
                }
            }

            GridView{
                interactive: false
                id:chooserGrid
                width: parent.width
                height: parent.height
                cellWidth: parent.width
                model: game1ChooserMode
                cellHeight: parent.height / model.count
                function getDelegateInstanceAt(index) {
                    //console.log("D/getDelegateInstanceAt[" + index + "]");

                    var len = contentItem.children.length;
                    //console.log("V/getDelegateInstanceAt: len[" + len + "]");

                    if(len > 0 && index > -1 && index < len) {
                        return contentItem.children[index];
                    } else {
                        console.log("E/getDelegateInstanceAt: index[" + index + "] is invalid w.r.t len[" + len + "]");
                        return undefined;
                    }
                }
                delegate:
                    Item{
                    function say_hello() {console.log("hello")}
                    function getGameName() {return gameName}
                    Component.onCompleted: {
                        unlocked = backend.getBoolSettingValue(gameName)
                    }
                    function setUnlocked(lock)
                    {
                        unlocked = lock
                        backend.setBoolSettingValue(gameName, true)
                    }
                    function unlockThisGame()
                    {
                        unlockGameAnimation1.start()
                        unlockGameAnimation2.start()
                        backend.setTotalMemPoints(backend.getTotalMemPoints() - pointCost)
                        currentMemPoint.text = backend.getTotalMemPoints()
                    }
                    property variant game_name: gameName
                    //property bool lock: unlocked
                    width: chooserGrid.width
                    height: chooserGrid.cellHeight
                    id:gameChooserGridDelegateItem
                    Text {
                        id:difficultyText
                        text: difficulty
                        font.bold: true
                        minimumPointSize: 10
                        font.pointSize: 6000
                        fontSizeMode: Text.Fit
                        width: parent.width
                        height: parent.height
                        color: "black"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        scale: 0.8
                        Component.onCompleted: {
                            if(useLacale === true)
                            {
                                var locale = Qt.locale().name.substring(0,2)
                                switch(difficulty)
                                {
                                case 1:
                                    switch (locale){
                                    case "ru": text = "ЛЕГКО"; break;
                                    default: text = "EASY"
                                    }
                                    break;
                                case 2:
                                    switch (locale){
                                    case "ru": text = "НОРМАЛЬНО" ;break;
                                    default: text = "NORMAL"
                                    }
                                    break;
                                case 3:
                                    switch (locale){
                                    case "ru": text = "СЛОЖНО"; break;
                                    default: text = "HARD"
                                    }
                                    break;
                                case 4:
                                    switch (locale){
                                    case "ru": text = "НЕВОЗМОЖНО"; break;
                                    default: text = "INSANE"
                                    }
                                    break;
                                }
                            }
                        }
                    }
                    PropertyAnimation{
                        id:unlockGameAnimation1
                        target: gameIsLock
                        property: "opacity"
                        from: 1
                        to:0
                        duration: 300
                    }
                    PropertyAnimation{
                        id:unlockGameAnimation2
                        target: gameIsLock1
                        property: "opacity"
                        from: 1
                        to:0
                        duration: 300
                        onRunningChanged: {
                            if(!running)
                                setUnlocked(true)
                        }
                    }

                    Image {
                        id:gameIsLock
                        visible: !unlocked
                        anchors.right: difficultyText.left
                        source: "qrc:/images/lock.png"
                        height: parent.height
                        width: height
                        mipmap: true
                        scale: 0.4
                        verticalAlignment: Image.AlignVCenter
                        horizontalAlignment: Image.AlignHCenter
                        opacity: 1
                    }
                    Rectangle{
                        id:gameIsLock1
                        color:"transparent"
                        visible: !unlocked
                        height: parent.height
                        width: height
                        scale: 0.8
                        anchors.left: gameChooserGridDelegateItem.right
                        Image {
                            id:brainImage
                            source: "qrc:/images/brain.png"
                            height: parent.height
                            width: parent.width
                            mipmap: true
                            scale: 1
                            verticalAlignment: Image.AlignVCenter
                            horizontalAlignment: Image.AlignHCenter
                            opacity: 0.5
                        }
                        Text {
                            text: pointCost
                            font.bold: true
                            minimumPointSize: 10
                            font.pointSize: 6000
                            fontSizeMode: Text.Fit
                            width: parent.width
                            height: parent.height
                            color: "black"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            scale: 0.5
                        }

                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(unlocked)
                            {
                                if(gameId === 1)
                                {
                                    gameLoader.game_1_block_count = game_1_block_count
                                }
                                if(gameId === 2)
                                {
                                    gameLoader.game_2_cols = game_2_cols
                                    gameLoader.game_2_row = game_2_row
                                }
                                if(gameId === 3)
                                {
                                    gameLoader.game_3_cols = game_3_cols
                                    gameLoader.game_3_row = game_3_row
                                }

                                gameLoader.setLoaderSource(gameQmlSource)
                            }
                            else
                            {
                                //unlockGameAnimation1.start()
                                //unlockGameAnimation2.start()
                                if(backend.getTotalMemPoints() >= pointCost)
                                    showUnlockGameDialog(gameName,true,pointCost,difficulty)
                                else
                                    showUnlockGameDialog(gameName,false,pointCost,difficulty)
                                //console.log("game is locked"+pointCost) ;
                                //return
                            }
                        }
                    }
                }
            }
        }

        Item{
            id:closeSubMenu1
            width: parent.width * 0.5
            height: parent.height * 0.2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalAlignment
            anchors.bottom: parent.bottom
            Text {
                text: qsTr("CLOSE")
                font.bold: true
                id:closeSubMenu1Text
                minimumPointSize: 10
                font.pointSize: 6000
                fontSizeMode: Text.Fit
                width: parent.width
                height: parent.height * 0.7
                color: "#270000"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                scale: 0.7
            }
            DropShadow {
                visible: false
                anchors.fill: closeSubMenu1Text
                source: closeSubMenu1Text
                horizontalOffset: 2
                verticalOffset: 2
                color: "#80000000"
                radius: 3
                samples: 15
                scale: 0.7
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    hideSubMenu1Animation.start()
                    hideSubMenu1Animation1.start()
                }
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {}
            z:-1
        }
    }

    function showUnlockGameDialog(fromGameName, showOkCancelDialog,cost,diff)
    {
        okCancelDialog.gameNameForUnlock = fromGameName
        switch (Qt.locale().name.substring(0,2)) {
        case "ru":
            okCancelDialogText.text = "Разблокировать "+diff+" за "+cost+" очков?"
            break;
        default:
            okCancelDialogText.text = "Unlock "+diff+" for "+cost+" points?"
        }

        if(showOkCancelDialog === true)
        {
            okCancelDialog.visible = true
        }
        else
        {
            okDialog.visible = true
        }
    }
    Rectangle{
        property string gameNameForUnlock: ""

        visible: false
        id: okCancelDialog
        width: subMenu1.width
        height: subMenu1.height
        anchors.top: subMenu1.top
        anchors.left: subMenu1.left
        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(0, mainRect.height*1.4)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#EFAC2C" }
                GradientStop { position: 1.0; color: "#FB5231" }
            }
        }
        Text {
            text: qsTr("Unlock for 100 points?")
            id:okCancelDialogText
            minimumPointSize: 10
            font.pointSize: 6000
            fontSizeMode: Text.Fit
            width: parent.width * 0.8
            height: parent.height / 2
            color: "black"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            font.bold: true
        }
        Text {
            text: qsTr("OK")
            id:okDialogText
            minimumPointSize: 10
            font.pointSize: okCancelDialogText.fontInfo.pointSize
            fontSizeMode: Text.Fit
            width: parent.width * 0.5
            height: parent.height / 2
            color: "black"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            font.bold: true
            MouseArea{
                anchors.fill: parent
                onClicked:
                {
                    for(var i = 0 ; i < chooserGrid.contentItem.children.length - 1; i++)
                    {
                        var item = chooserGrid.getDelegateInstanceAt(i);
                        if(item.getGameName !== undefined)
                        {
                            if(okCancelDialog.gameNameForUnlock === chooserGrid.getDelegateInstanceAt(i).getGameName())
                            {
                                item.unlockThisGame()
                                okCancelDialog.visible = false
                            }
                            //console.log(chooserGrid.getDelegateInstanceAt(i).getGameName())
                        }
                        //console.log("click ok"+chooserGrid.getDelegateInstanceAt(i).getGameName())
                    }
                }
            }
        }
        Text {
            text: qsTr("CANCEL")
            id:cancelDialogText
            minimumPointSize: 10
            font.pointSize: okCancelDialogText.fontInfo.pointSize
            fontSizeMode: Text.Fit
            width: parent.width * 0.5
            height: parent.height / 2
            color: "black"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            font.bold: true
            MouseArea{
                anchors.fill: parent
                onClicked: okCancelDialog.visible = false
            }
        }
        MouseArea {
            anchors.fill: parent
            z:-1
        }
    }



    Rectangle{
        property string gameNameForUnlock: ""
        visible: false
        id: okDialog
        width: subMenu1.width
        height: subMenu1.height
        anchors.top: subMenu1.top
        anchors.left: subMenu1.left
        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(0, mainRect.height*1.4)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#EFAC2C" }
                GradientStop { position: 1.0; color: "#FB5231" }
            }
        }
        Text {
            text: qsTr("You need more points to unlock it")
            id:messageText
            minimumPointSize: 10
            font.pointSize: 6000
            fontSizeMode: Text.Fit
            width: parent.width * 0.9
            height: parent.height / 2
            color: "black"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            font.bold: true
            Component.onCompleted: {
                switch (Qt.locale().name.substring(0,2)) {
                case "ru":
                    text = "Вам нужно больше очков..."
                    break;
                default:
                    text = "You need more points to unlock it"
                }
            }
        }

        Text {
            text: qsTr("Got it!")
            minimumPointSize: 10
            font.pointSize: okCancelDialogText.fontInfo.pointSize
            fontSizeMode: Text.Fit
            width: parent.width * 0.5
            height: parent.height / 2
            color: "black"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            font.bold: true
            MouseArea{
                anchors.fill: parent
                onClicked: okDialog.visible = false
            }
            Component.onCompleted: {
                switch (Qt.locale().name.substring(0,2)) {
                case "ru":
                    text = "Ок"
                    break;
                default:
                    text = "Got it!"
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            z:-1
        }
    }

    AdMobBanner {
        visible: (gameLoader.noAdsItemIdIsPurchased() === true) ? false : true
        // AdMob
        readonly property string admobBannerAdUnitId: "ca-app-pub-9155324456588158/9913032020"
        readonly property string admobInterstitialAdUnitId: "ca-app-pub-9155324456588158/9075427220"
        readonly property var admobTestDeviceIds: [ "A46EF61C7EA0E270760A5EC2594DF431" ]
        id: adMobBanner
        adUnitId:"ca-app-pub-3940256099942544/6300978111"// "ca-app-pub-3940256099942544/6300978111"// admobBannerAdUnitId
        banner: AdMobBanner.Smart

        //anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.left:parent.left
        testDeviceIds: admobTestDeviceIds
        onHeightChanged: console.log("console dbg!!!!"+height)
    }



    Rectangle{
        z:10
        id:tectP
        width: parent.width
        height: 50
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color:"transparent"
        opacity: 1
        Rectangle{
            anchors.fill: parent
            color:"orange"
            opacity: 0.75
        }

        Text {
            text: qsTr("")
            font.bold: true
            minimumPointSize: 10
            font.pointSize: 6000
            fontSizeMode: Text.Fit
            width: parent.width
            height: parent.height
            color: "black"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            Component.onCompleted: {
                var tmp
                if(gameLoader.noAdsItemIdIsPurchased())
                {
                    tmp = " (item buyed)"
                }
                else
                {
                    tmp = " (item not buyed)"
                }
                tmp = "";
                switch (Qt.locale().name.substring(0,2)) {
                case "ru":
                    text = "УБРАТЬ РЕКЛАМУ" +tmp
                    break;
                default:
                    text = "REMOVE ADS"+tmp
                }
            }
        }
        MouseArea{
            anchors.fill: parent

            onClicked:{
                return;
                var letters = '0123456789ABCDEF';
                var _color = '#';
                for (var i = 0; i < 6; i++ ) {
                    _color += letters[Math.floor(Math.random() * 16)];
                }
                tectP.color = _color
                gameLoader.startBuyNoAdsItemId()
                console.log("click click");
            }
        }
    }

}

