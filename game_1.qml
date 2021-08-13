import QtQuick 2.9
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtQuick.Window 2.11
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.8
import VPlayPlugins 1.0
import VPlay 2.0
Item {
    property variant items: [1,2,3,4,5,6,7,8,9]
    property int blockCount: gameLoader.game_1_block_count
    property int randomRange: 5
    property int firstIndex: 1
    property int lastIndex: blockCount - 2
    property real widthBlockCoef: 0.3
    property real heightBlockCoef: 0.12
    property int yOffset: 50
    property real minimumOpacity: 1
    property int hideBlockCount: 0
    property int gameTimeInSeconds: 60
    property int totalVisibleUserBlock: blockCount - 2
    property int totalScore: 0
    property int rightAnster: 0
    onRightAnsterChanged: {
        if(minimumOpacity > 0) minimumOpacity -= 0.2
        if(rightAnster % 5 == 0) hideBlockCount++
        if(hideBlockCount > totalVisibleUserBlock-1)
            hideBlockCount = totalVisibleUserBlock-1
    }
    visible: true
    width:Screen.width
    height:Screen.height
    id:mainRect
    ListModel{
        id:numModel

    }
    Component.onCompleted: {
        for(var i=0;i<blockCount;i++)
            numModel.append({"value":items[i]});
        containerItem.blocksY =mainRect.height / 2 - background.height / 2
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
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: parent.height
        cellHeight: classesListGrid.height / 5
        cellWidth: classesListGrid.width / 3
        clip: true
        model: 15
        delegate: Item {
            width: classesListGrid.cellWidth
            height: classesListGrid.cellHeight
            function getRandomAngle() {return Math.floor(Math.random() * 360)}
            Text {
                width: parent.width
                height:parent.height
                id: backgroundNumbers
                text: qsTr("text")
                minimumPointSize: 10
                font.pointSize: 6000
                fontSizeMode: Text.Fit
                opacity: 0.05
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                transform: Rotation { origin.x: width/2; origin.y: height/2; axis { x: 0; y: 0; z: 1 }angle: getRandomAngle()}
                Component.onCompleted: {
                    text = Math.floor(Math.random() * 9)

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


    Rectangle{
        visible: (gameLoader.noAdsItemIdIsPurchased() === true) ? false : true
        anchors.top: mainRect.top
        anchors.left: mainRect.left
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
        width: parent.width * 0.2
        height: width
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
            width: parent.height / 2.5
            height: parent.height / 2.5
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
    /*
    Rectangle{
        anchors.right: parent.right
        width: parent.width * 0.1
        height: width
        color:"transparent"
        Text {
            id:gameTimeTimer
            width: parent.width
            height:parent.height
            minimumPointSize: 10
            font.pointSize: 6000
            fontSizeMode: Text.Fit
            opacity: 0.6
            color:"white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {gameTimeInSeconds--; gameTimeTimer.text = gameTimeInSeconds}
    }
    */
    Item{ // blocks Container
        width: parent.width
        height: parent.height
        //anchors.fill: parent
        property int blocksY: 0
        id:containerItem
        Column{
            //y:parent.blocksY
            id:background
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            //anchors.verticalCenterOffset: (- mainRect.width * widthBlockCoef) / 2
            Repeater{
                id:backgroundRepeater
                //model: ["apples", "oranges", "pears"]
                model:blockCount - 2
                delegate:
                    Rectangle{
                    property real rectangleScale : 1
                    property bool showShadow: true
                    property int myY: 0
                    id:backgroundBlock
                    width: (mainRect.width * widthBlockCoef   )
                    height:( mainRect.height * heightBlockCoef)
                    Rectangle{
                        id:backgroundRectangle
                        width: parent.width
                        height: parent.height
                        //Rectangle{anchors.left: parent.left; width: 2; height: parent.height; color:"white"}
                        //Rectangle{anchors.right: parent.right; width: 2; height: parent.height; color:"white"}
                        //Rectangle{anchors.bottom: parent.bottom; width: parent.width; height: 2; color:"white"}
                        color:"green"
                        scale: rectangleScale
                        Component.onCompleted: {myY = y}
                    }
                    Text {
                        id: name
                        color:"white"
                        text: index

                    }
                    DropShadow {
                        id:shadow
                        visible: true
                        anchors.fill: backgroundRectangle
                        horizontalOffset: 3
                        verticalOffset: 3
                        radius: 8.0
                        samples: 17
                        color: "#80000000"
                        source: backgroundRectangle
                        scale: rectangleScale
                    }
                }
            }
            Component.onCompleted: {
                backgroundRepeater.itemAt(0).rectangleScale = 1.1
                backgroundRepeater.itemAt(blockCount - 3).rectangleScale = 1.1
                for(var i = 1 ; i < blockCount - 3; i ++)
                    backgroundRepeater.itemAt(i).z = -1
            }

        }
        Image {
            id:rightAnsterImage
            y:background.y + (mainRect.height * heightBlockCoef) * (blockCount - 3)
            x:background.x
            source: "qrc:/images/check_white.png"
            width: height
            height:  mainRect.height * heightBlockCoef
            sourceSize.width: height
            sourceSize.height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0
            PropertyAnimation {id:rightAnsterImageAnimation; target: rightAnsterImage; property: "opacity"; to: 0; duration: 300; }
            PropertyAnimation {id:rightAnsterImageAnimation1; target: rightAnsterImage; property: "scale"; to: 1.5; duration: 500; }
        }
        Image {
            id:wrongAnsterImage
            y:background.y + (mainRect.height * heightBlockCoef) * (blockCount - 3)
            x:background.x
            source: "qrc:/images/cancel_white.png"
            width: height
            height:  mainRect.height * heightBlockCoef
            sourceSize.width: height
            sourceSize.height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0
            PropertyAnimation {id:wrongAnsterImageAnimation; target:  wrongAnsterImage; property: "opacity"; to: 0; duration: 300; }
            PropertyAnimation {id:wrongAnsterImageAnimation1; target: wrongAnsterImage; property: "scale"; to: 1.5; duration: 500; }
        }
        Rectangle{
            id:greenRectangle
            width:mainRect.width * widthBlockCoef;
            height:(blockCount-2) * (mainRect.height * heightBlockCoef) + 2
            color:"transparent"
            //anchors.verticalCenter:  parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            //anchors.verticalCenterOffset: (- mainRect.width * widthBlockCoef) / 2

            //y:parent.blocksY
            clip:true
            Column{
                y: (-mainRect.height * heightBlockCoef) + 2
                id:gameColumn
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater{
                    id:columnRepeater
                    //model: ["apples", "oranges", "pears"]
                    model:numModel
                    Rectangle{
                        property int blockIndex: index
                        id:blockContaiter
                        width: mainRect.width * widthBlockCoef
                        height: mainRect.height * heightBlockCoef
                        //Rectangle{anchors.left: parent.left; width: 2; height: parent.height; color:"white"}
                        //Rectangle{anchors.right: parent.right; width: 2; height: parent.height; color:"white"}
                        //Rectangle{anchors.bottom: parent.bottom; width: parent.width; height: 2; color:"white"}
                        //border.color:"white"
                        //border.width: 1
                        color:"transparent"

                        Component.onCompleted: {
                            var letters = '0123456789ABCDEF';
                            var _color = '#';
                            for (var i = 0; i < 6; i++ ) {
                                _color += letters[Math.floor(Math.random() * 16)];
                            }
                            //color = _color
                        }
                        Text {
                            font.pixelSize: 45
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            id: blockValue
                            text: value
                            font.bold: true
                            color: "white"
                        }
                        /*
                        Text {
                            id: id
                            text: getOpacity()
                        }
                        */
                        function getOpacity() {return blockValue.opacity}
                        function slide() {animation.start()}
                        function busy() {return animation.running}
                        function resetOpacity() { blockValue.opacity = 1 }
                        PropertyAnimation
                        {
                            id: opacityAnimation
                            target: blockValue
                            property: "opacity"
                            to: ( blockContaiter.blockIndex == blockCount - 1) ? 1 : 1 - (1 - minimumOpacity) / (blockCount - (2+hideBlockCount)) * blockContaiter.blockIndex
                            duration:500
                        }

                        PropertyAnimation {
                            id: animation;
                            target: blockContaiter;
                            property: "y";
                            to: blockContaiter.y + mainRect.height * heightBlockCoef;
                            easing.type: Easing.OutSine;
                            duration: 500
                            onRunningChanged: {
                                // console.log(blockContaiter.y)
                                //resetOpacity()
                                if(!animation.running)
                                {
                                    blockContaiter.blockIndex++
                                    if(blockContaiter.y+10 >= (mainRect.height * heightBlockCoef) * (blockCount))
                                    {
                                        blockContaiter.y -= (mainRect.height * heightBlockCoef) * (blockCount )
                                        //                                        blockContaiter.blockValue.opacity = 1
                                        value = Math.floor(Math.random() * randomRange)
                                        blockContaiter.blockIndex = 0
                                    }
                                }
                                else
                                {
                                    // if(blockContaiter.blockIndex == blockCount)
                                    //                                        blockContaiter.blockValue.opacity = 1
                                    //                                    else
                                    opacityAnimation.start()
                                }

                            }
                        }
                    }
                }
            }
        }
    }
    MouseArea{
        anchors.fill: parent
        onPressed: {
            return
            for (var i = 0; i < columnRepeater.count; i++)
            {
                if(columnRepeater.itemAt(i).busy())
                    return;
            }
            for (var i = 0; i < columnRepeater.count; i++)
            {
                columnRepeater.itemAt(i).slide()
            }
            //console.log(columnRepeater.count);
            firstIndex--
            if(firstIndex < 0)
                firstIndex += blockCount;

            lastIndex--
            if(lastIndex < 0)
                lastIndex += blockCount;

            console.log(firstIndex + ":" + lastIndex + " " + numModel.get(firstIndex).value + ":" + numModel.get(lastIndex).value)

        }
    }
    function slideAllBlock()
    {
        for (var i = 0; i < columnRepeater.count; i++)
        {
            if(columnRepeater.itemAt(i).busy())
                return;
        }
        for (var i = 0; i < columnRepeater.count; i++)
        {
            columnRepeater.itemAt(i).slide()
        }
        //console.log(columnRepeater.count);
        firstIndex--
        if(firstIndex < 0)
            firstIndex += blockCount;

        lastIndex--
        if(lastIndex < 0)
            lastIndex += blockCount;
    }

    function checkAnsfer(result)
    {
        console.log(numModel.get(firstIndex).value + ":" + numModel.get(lastIndex).value)
        var eq = false;
        if(numModel.get(firstIndex).value === numModel.get(lastIndex).value)
            eq = true;
        if(eq === result)
        {
            if(rightAnsterImageAnimation1.running) return
            console.log("right");
            rightAnsterImage.opacity = 1
            rightAnsterImage.scale = 1
            rightAnsterImageAnimation.start()
            rightAnsterImageAnimation1.start()
            rightAnsterSound.play()
            rightAnster++
            if(minimumOpacity <= 0)
            {
                backend.addOneMemPoint()
                scoreTextAnimation.start()
                scoreTextAnimation1.start()
            }
        }
        else
        {
            if(wrongAnsterImageAnimation1.running) return
            console.log("wrong");
            wrongAnsterImage.opacity = 1
            wrongAnsterImage.scale = 1
            wrongAnsterImageAnimation.start()
            wrongAnsterImageAnimation1.start()
            wrongAnsterSound.play()
            minimumOpacity = 1
        }
        slideAllBlock();
    }

    Button{
        width: parent.width * 0.5
        height: parent.height * 0.2
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        onClicked: {
            checkAnsfer(true);
        }
        style: ButtonStyle {
            background:
                Rectangle{
                color:"transparent"
            }
        }
        Image {
            id:checkImage
            source: "qrc:/images/check.png"
            width: height
            height: parent.height
            sourceSize.width: height
            sourceSize.height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
        }
        ColorOverlay {
            id: checkImageOverlay
            anchors.fill: checkImage
            source: checkImage
            color: "#0b6623"
            opacity: 0.8
        }
        onPressedChanged: {
            if(pressed)
                checkImageOverlay.color = "#ffffff"
            else
                checkImageOverlay.color= "#0b6623"
        }
    }
    Button{
        width: parent.width * 0.5
        height: parent.height * 0.2
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        onClicked: {
            checkAnsfer(false);
        }

        style: ButtonStyle {
            background:
                Rectangle{
                color:"transparent"
            }
        }
        Image {
            id:cancelImage
            source: "qrc:/images/cancel.png"
            width: height
            height: parent.height
            sourceSize.width: height
            sourceSize.height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
        }
        ColorOverlay {
            id: cancelImageOverlay
            anchors.fill: cancelImage
            source: cancelImage
            color: "#0b6623"
        }
        onPressedChanged: {
            if(pressed)
                cancelImageOverlay.color = "red"
            else
                cancelImageOverlay.color= "#0b6623"
        }
    }

    Item
    {
        visible: !backend.getBoolSettingValue("game_1_startHint_showed")
        width: mainRect.width
        height: mainRect.height
        id: okDialog
        Rectangle{
            anchors.fill: parent
            color:"black"
            opacity: 0.3
        }
        MouseArea {
            anchors.fill: parent
            z:-1
        }
        Rectangle{
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
                text: qsTr("Remember and compare the numbers on the large blocks, they are equal?")
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
                        text = "Запоминайте и сравнивайте цифры в больших блоках, они равны?"
                        break;
                    default:
                        text = "Remember and compare the numbers on the large blocks, they are equal?"
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
                    onClicked:
                    {
                        okDialog.visible = false
                        backend.setBoolSettingValue("game_1_startHint_showed",true);
                    }
                }
            }
        }
    }
}
