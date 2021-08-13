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
    property variant gameValues: []
    property variant openedBlocks: []
    property variant emptyBlocks: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64]
    property variant notUsedSmiles: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
    property int lastBlockIndexClicked: -1
    property bool gameStarted: false
    property int timeBeforeGameStartedinMS: 2000
    property int cols: gameLoader.game_3_cols
    property int row: gameLoader.game_3_row
    property int emptyBlockArrayRange: (cols * row) - 1
    property int usedBlockCount: 0
    property int blockToFill: 3
    property int minimumBlockToFill: 3
    property int maximumBlockToFill: cols * row
    property int timerTicks: 0
    property int wrongAnsterCounter: 1
    id: mainItem
    Component.onCompleted: {
        for(var i = 0; i < 64; i++)
        {
            openedBlocks[i] = 0
        }
    }


    LinearGradient {
        anchors.fill: parent
        start: Qt.point(0, 0)
        end: Qt.point(0, mainItem.height*1.4)
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#EFAC2C" }
            GradientStop { position: 1.0; color: "#FB5231" }
        }
    }

    Rectangle{
        visible: (gameLoader.noAdsItemIdIsPurchased() === true) ? false : true
        anchors.top: mainItem.top
        anchors.left: mainItem.left
        height: (visible) ? 75 : 0
        width: parent.width
        id:bannerArea
        color:"red"
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
        onHeightChanged: bannerArea.height = adMobBanner.height
    }


    Rectangle{
        id:scoreRectangle
        anchors.left: parent.left
        height: (parent.height / row ) / 2
        width: height
        color:"transparent"
        anchors.top: bannerArea.bottom
        Image {
            id:brainImage
            z:5
            width: parent.width
            height: width
            mipmap: true
            opacity: 0.7
            source: "qrc:/images/brain.png"
        }

        Text {
            id:scoreText
            anchors.horizontalCenter: brainImage.horizontalCenter
            anchors.verticalCenter: brainImage.verticalCenter
            width: brainImage.width /2
            height:brainImage.height/2
            minimumPointSize: 10
            font.pointSize: 6000
            fontSizeMode: Text.Fit
            opacity: 0
            text:"+1"
            color:"white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            z:6
        }
        NumberAnimation{
            id:scoreTextAnimation
            target: scoreText
            property: "opacity"
            from: 1
            to:0
        }
        NumberAnimation{
            id:scoreTextAnimation1
            target: scoreText
            property: "scale"
            from: 1
            to:2
        }
    }

    Item{
        z:5
        anchors.right: parent.right
        anchors.verticalCenter: scoreRectangle.verticalCenter
        width: brainImage.width
        height: brainImage.height
        Image {
            source: "qrc:/images/back.png"
            width: parent.height / 2
            height: parent.height / 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            mipmap: true
            opacity: 0.7
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                gameLoader.setLoaderSource("qrc:/mainMenu.qml")
            }
        }
    }

    Text {
        id:timerTicksText
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color:"white"
        text:timerTicks
        scale: 1
        opacity: 0
        z:4
    }
    NumberAnimation{
        id: timerTicksTextAnimation
        target: timerTicksText
        property: "scale"
        from: 1
        to:20
        duration: 500
    }
    NumberAnimation{
        id: timerTicksTextOpacityAnimation
        target: timerTicksText
        property: "opacity"
        from: 1
        to:0
        duration: 500
    }
    Timer{
        id:showTimerTicksTimer
        interval: 1000
        running: false; repeat: true
        onTriggered: {
            timerTicksTextAnimation.start()
            if(timerTicks > 1)
                timerTicksTextOpacityAnimation.start()
            timerTicks--
            timerTicksText.text = timerTicks
            if(timerTicks === 0) {
                stop()
                gameStarted = true
                //console.log(gameValues)
                return
            }
            timerTicksText.opacity = 1

        }
    }

    property int timePerBlockShowHide: 1000
    property int delayAfterAllBlockToFront: 1000
    Timer {
        id:delayBetweenStartGame
        interval: 600
        repeat: false
        running: false
        onTriggered:{
            gameStarted = true ;
            //console.log(gameValues)
        }
    }

    Timer{
        id:allBlockToFrontTimer
        interval: delayAfterAllBlockToFront
        repeat: false
        running: false
        onTriggered: {
            for(var i = gameValues.length - 1; i >= 0; i--)
            {
                var gridItem = gameGrid.getDelegateInstanceAt(gameValues[i])
                if(gridItem.changeState)
                    gridItem.changeState("showFront")
            }
            delayBetweenStartGame.start()
        }
    }

    Timer{
        id:fillGridTimer
        interval: timePerBlockShowHide
        repeat: false
        running: false
        onTriggered: {
            var rnd = Math.floor(Math.random() * ((cols * row) - usedBlockCount))
            usedBlockCount++
            var item = gameGrid.getDelegateInstanceAt(Number(emptyBlocks[rnd]))
            gameValues.push(emptyBlocks[rnd])
            item.setNewBlockValue(usedBlockCount)
            removeFromEmptyArray(emptyBlocks,emptyBlocks[rnd])
            if(item.changeState)
                item.changeState("showBack")

            if(usedBlockCount < blockToFill)
                start()
            else
            {
                allBlockToFrontTimer.start()
                //console.log(gameValues)
                //startNewGame()
            }
        }
    }
    Timer{
        id:closeAllBlockTimer
        interval: 1000
        repeat: false
        onTriggered: fillGridTimer.start()
    }

    function findInEmptyArray(valueForSeaching)
    {
        for(var i = mainItem.emptyBlocks.length - 1; i >= 0; i--) {
            if(mainItem.emptyBlocks[i] === valueForSeaching) {
                return true
            }
        }
    }
    function removeFromEmptyArray(arrayToRemove, valueToRemove)
    {
        for(var i = arrayToRemove.length - 1; i >= 0; i--) {
            if(arrayToRemove[i] === valueToRemove) {
                arrayToRemove.splice(i, 1);
                return;
            }
        }
    }

    function startNewGame()
    {
        emptyBlocks = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64]
        usedBlockCount = 0
        gameValues = []
        gameStarted = false
        for(var i = 0; i < 64; i++)
            openedBlocks[i] = 0
        for(var i = 0;i < gameGrid.contentItem.children.length; i++)
        {
            var item = gameGrid.getDelegateInstanceAt(i)
            if(item.changeState)
                item.changeState("showFront")
            if(item.setNewBlockValue)
                item.setNewBlockValue(0)
        }
        fillGridTimer.start()
    }

    Timer{
        id:startNewGameWithDelay
        repeat: false
        interval: 1000
        running: false
        onTriggered: {
            startNewGame()
        }
    }

    function restartGame(result)
    {
        gameStarted = false
        if(result === true){
            if(blockToFill < maximumBlockToFill){
                blockToFill++
            }
        }
        else
            blockToFill = 3
        startNewGameWithDelay.start()
    }

    SoundEffect {
        id: rightAnsterSound
        source: "qrc:/tones-wav/pop_drip.wav"
    }
    SoundEffect {
        id: wrongAnsterSound
        source: "qrc:/tones-wav/click_04.wav"
    }

    GridView {
        id: classesListGrid
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        interactive: false
        height: parent.height
        cellHeight: classesListGrid.height / 6
        cellWidth: classesListGrid.width / 4
        clip: true
        model: 24
        delegate: Item {
            width: classesListGrid.cellWidth
            height: classesListGrid.cellHeight
            function getRandomAngle() {return Math.floor(Math.random() * 360)}

            Image {
                id:smileBackgoundSprite
                height: (parent.height < parent.width) ? parent.height : parent.width
                //width: height
                //sourceSize.width: width
                //sourceSize.height: height
                //antialiasing: true
                mipmap: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
                z:2
                opacity: 0.1
                scale: 1.3
                source: "qrc:/smiles/0.png"
                transform: Rotation { origin.x: smileBackgoundSprite.width/2.3; origin.y: smileBackgoundSprite.height/2; axis { x: 0; y: 0; z: 1 }angle: getRandomAngle()}
                Component.onCompleted: {
                    var rnd = Math.round(Math.random() * 16)
                    smileBackgoundSprite.source = "qrc:/smiles/"+rnd+".png"

                }
            }
            Rectangle{
                width: classesListGrid.cellWidth
                height: classesListGrid.cellHeight
                opacity: 0.02
                Component.onCompleted: {
                    var letters = '0123456789ABCDEF';
                    var _color = '#';
                    for (var i = 0; i < 6; i++ ) {
                        _color += letters[Math.floor(Math.random() * 16)];
                    }
                    color = _color
                }
            }
        }
    }

    GridView{
        Component.onCompleted: {
            if(backend.getBoolSettingValue("game_3_startHint_showed") === true)
                fillGridTimer.start()
            //startGameTimer.start()
        }

        //anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: scoreRectangle.bottom
        id:gameGrid
        interactive: false
        width: parent.width * 0.9
        height: (parent.height - scoreRectangle.height * 2) - bannerArea.height
        cellHeight: gameGrid.height / row
        cellWidth: gameGrid.width / cols
        property int totalBlocks: cellHeight * cellWidth
        clip: true
        model: row*cols

        // Uses black magic to hunt for the delegate instance with the given
        // index.  Returns undefined if there's no currently instantiated
        // delegate with that index.
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
            Rectangle{
            scale: 0.9
            color:"transparent"
            property bool opened: false
            property int blockValue: 0
            function setNewBlockValue(v) {blockValue = v}
            function setOpened(o) {opened = o}
            //function logWrite() {console.log("heeeellllloW")}
            function changeState(newState) {block.state = newState}
            function setNewBackImageSource(newSource) { back.source = newSource }
            id:gameGridBlock
            width:gameGrid.cellWidth
            height: gameGrid.cellHeight
            Rectangle{
                property int blockIndex: 0
                antialiasing: true
                smooth: true
                id:block
                width: parent.width
                height: parent.height
                scale: 1
                color:"transparent"
                state: ""
                Rectangle{
                    visible: false
                    color:"white"
                    height: (parent.height < parent.width) ? parent.height : parent.width
                    width: height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    visible: true
                    id:front
                    height: (parent.height < parent.width) ? parent.height : parent.width
                    width: height
                    //width: height
                    //sourceSize.width: width
                    //sourceSize.height: height
                    //antialiasing: true
                    // mipmap: true
                    color:"orange"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    //fillMode: Image.PreserveAspectFit
                    z:2
                    scale: 1
                    //source: "qrc:/images/question.png"
                    Text {
                        visible: false
                        id: frontSideText
                        text: "?"
                        color:"white"
                        minimumPointSize: 10
                        font.pointSize: 6000
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        z:3
                    }
                }

                Rectangle {
                    id:back
                    height: (parent.height < parent.width) ? parent.height : parent.width
                    width: height
                    //sourceSize.width: width
                    //sourceSize.height: height
                    //antialiasing: true
                    //mipmap: true
                    color:"green"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    //fillMode: Image.PreserveAspectFit
                    z:2
                    //scale: 1.3
                    //source: "qrc:/smiles/0.png"
                    Text {
                        id: gameValueText
                        text: (gameGridBlock.blockValue !== 0) ? gameGridBlock.blockValue : ""
                        color:"white"
                        width: parent.width
                        height: parent.height
                        minimumPointSize: 10
                        font.pointSize: 6000
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        z:3
                    }
                }
                DropShadow {
                    id:shadow
                    visible: true
                    anchors.fill: back
                    horizontalOffset: 4
                    verticalOffset: 4
                    radius: 10.0
                    samples: 17
                    color: "#80000000"
                    source: back
                    scale: 0.99
                }
                transform: Rotation {id:blockRotationTransform; origin.x: block.width/2; origin.y: block.height/2; axis { x: 0; y: 1; z: 0 }angle: 0}
                NumberAnimation {
                    id: fromFrontToBackPart1
                    target: blockRotationTransform
                    properties: "angle"
                    from:0
                    to: 90
                    easing {type: Easing.OutExpo; overshoot: 2000}
                    onRunningChanged: {
                        if(!running)
                        {
                            front.opacity = 0;
                            back.opacity = 1
                            gameValueText.opacity = 1
                            frontSideText.opacity = 0
                            fromFrontToBackPart2.start()
                        }
                    }
                }
                NumberAnimation {
                    id: fromFrontToBackPart2
                    target: blockRotationTransform
                    properties: "angle"
                    from:90
                    to: 0
                    easing {type: Easing.OutExpo; overshoot: 2000}
                    onRunningChanged: {
                        if(!running)
                            block.checkAnsfer()
                    }
                }
                NumberAnimation {
                    id: fromBackToFrontPart1
                    target: blockRotationTransform
                    properties: "angle"
                    from:0
                    to: 90
                    easing {type: Easing.OutExpo; overshoot: 2000}
                    onRunningChanged: {
                        if(!running)
                        {
                            front.opacity = 1;
                            back.opacity = 0
                            gameValueText.opacity = 0
                            frontSideText.opacity = 1
                            fromFrontToBackPart2.start()
                        }
                    }
                }
                NumberAnimation {
                    id: fromBackToFrontPart2
                    target: blockRotationTransform
                    properties: "angle"
                    from:90
                    to: 0
                    easing {type: Easing.OutExpo; overshoot: 2000}
                    onRunningChanged: {
                        //if(!running)
                        // block.checkAnsfer()
                    }

                }
                function getRightAfsterCount()
                {
                    var count = 0;
                    for(var i = mainItem.openedBlocks.length - 1; i >= 0; i--)
                        if(mainItem.openedBlocks[i] === 1)
                            count++
                    return count
                }
                function checkAnsfer(){
                    if(!gameStarted) return



                    //console.log("compare:"+gameValues[0] +" "+ index)
                    if(gameValues[0] === index)
                    {
                        removeFromEmptyArray(gameValues,index)
                        block.state = "showBack"
                        openedBlocks[index] = 1
                        //openedBlocks[lastBlockIndexClicked] = 1
                        rightAnsterSound.play()
                        scoreTextAnimation.start()
                        scoreTextAnimation1.start()
                        backend.addOneMemPoint()
                        if(gameValues.length === 0)
                            restartGame(true)
                    }
                    else
                    {
                        restartGame(false)
                        //var item = gameGrid.getDelegateInstanceAt(lastBlockIndexClicked)
                        //item.changeState("showFront")
                        //gameGridBlock.changeState("showFront")
                        wrongAnsterCounter++
                        //if(wrongAnsterCounter % 2 == 0)
                        wrongAnsterSound.play()
                    }

                }

                onStateChanged: {
                    if(block.state === "showBack")
                    {
                        fromFrontToBackPart1.start()
                    }
                    if(block.state === "showFront")
                    {
                        fromBackToFrontPart1.start()
                    }

                }
                Component.onCompleted:{ blockRotationTransform.angle = 0;
                    if(block.state === "showFront" || block.state === "")
                    {
                        front.opacity=1
                        back.opacity=0
                        gameValueText.opacity = 0
                        frontSideText.opacity = 1

                    }
                    else
                    {
                        back.opacity = 1
                        front.opacity = 0
                        gameValueText.opacity = 1
                        frontSideText.opacity = 0
                    }
                }
            }

            function animationProgress() {
                if(fromBackToFrontPart1.running || fromBackToFrontPart2.running || fromFrontToBackPart1.running || fromFrontToBackPart2.running) return true;
            }
            MouseArea {
                anchors.fill: block
                onClicked: {
                    if(!gameStarted) return
                    if(openedBlocks[index] === 1) return

                    for(var i = 0;i < gameGrid.contentItem.children.length; i++)
                    {
                        var item = gameGrid.getDelegateInstanceAt(i)
                        if(item.animationProgress)
                            if(item.animationProgress())
                                return
                    }
                    //console.log("clicked index:"+index)
                    //console.log("clicked value" + mainItem.gameValues[block.blockIndex])


                    if(block.state === "showFront" || block.state === "")
                    {
                        //console.log("showBack")
                        block.state = "showBack"
                    }
                    else
                    {
                        //console.log("showFront")
                        block.state = "showFront"
                    }
                }
            }

            Component.onCompleted: {
                var letters = '0123456789ABCDEF';
                var _color = '#';
                for (var i = 0; i < 6; i++ ) {
                    _color += letters[Math.floor(Math.random() * 16)];
                }
                //color = _color
            }
        }
    }

    Item{
        width: mainItem.width
        height: mainItem.height
        id: okDialog
        visible: !backend.getBoolSettingValue("game_3_startHint_showed")
        Rectangle{
            anchors.fill: parent
            color:"black"
            opacity: 0.3
        }
        Rectangle{
            MouseArea {
                anchors.fill: parent
                z:-1
            }
            property string gameNameForUnlock: ""
            visible: true
            width: parent.width * 0.7
            height: parent.height * 0.25
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Rectangle{
                anchors.fill: parent
                id:okDialogBack
            }

            DropShadow {
                visible: true
                anchors.fill: okDialogBack
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 17
                color: "#80000000"
                source: okDialogBack
                z:-1
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

            Text {
                text: qsTr("Remember and repeat the sequence of blocks with numbers")
                id:messageText
                minimumPointSize: 10
                font.pointSize: 6000
                fontSizeMode: Text.Fit
                width: parent.width * 0.9
                height: parent.height * 0.4
                color: "black"
                elide: Text.ElideMiddle

                wrapMode: TextEdit.WordWrap
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft
                anchors.horizontalCenter: parent.horizontalCenter
                //anchors.top: parent.top
                y: parent.height * 0.1
                font.bold: true
                Component.onCompleted: {
                    switch (Qt.locale().name.substring(0,2)) {
                    case "ru":
                        text = "Запомните и повторите последовательность блоков с цифрами"
                        break;
                    default:
                        text = "Remember and repeat the sequence of blocks with numbers"
                    }
                }
            }

            Text {
                text: qsTr("OK")
                minimumPointSize: 10
                font.pointSize: messageText.fontInfo.pointSize
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
                    onClicked: {
                        okDialog.visible = false
                        backend.setBoolSettingValue("game_3_startHint_showed",true);
                        fillGridTimer.start()
                    }
                }
            }
        }
    }
}
