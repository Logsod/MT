import QtQuick 2.9

    Rectangle{
        property int screenW: 0
        property int screenH: 0
        property int startX: 0
        property int startY: 0
        width: parent.width / 5
        height: width
        color:"transparent"
        id:backgroundRectangle
        function getRandomAngle() {return Math.floor(Math.random() * 360)}
        transform: Rotation { origin.x: backgroundRectangle.width/2; origin.y: backgroundRectangle.height/2; axis { x: 0; y: 0; z: 1 }angle: getRandomAngle()}
        Text {
            visible: false
            id:question
            width: parent.width
            height:parent.height
            minimumPointSize: 10
            font.pointSize: 6000
            fontSizeMode: Text.Fit
            opacity: 0.9
            text:"?"
            color:"white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            visible: false
            id:number
            width: parent.width
            height:parent.height
            minimumPointSize: 10
            font.pointSize: 6000
            fontSizeMode: Text.Fit
            opacity: 0.9
            text:""
            color:"white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Component.onCompleted: text = Math.floor(Math.random() * 9)
        }
        Image {
            visible: false
            id:smile
            mipmap: true
            width: parent.width
            height: parent.height
            source: ""
            Component.onCompleted: source = "qrc:/smiles/"+ Math.floor(Math.random() * 16) +".png"
        }

        NumberAnimation {
            id:moveAnimation
            target: backgroundRectangle
            property: "x"
            from : x
            to:x + backgroundRectangle.width
            duration: 20000
            easing.type: Easing.Linear
            onRunningChanged: {
                if(!running) {
                    if(x > screenW)
                    x = -backgroundRectangle.width

                    start()

                }
            }
        }
        NumberAnimation {
            id:moveAnimation1
            target: backgroundRectangle
            property: "y"
            from : y
            to:y + backgroundRectangle.height
            duration: 20000
            easing.type: Easing.Linear
            onRunningChanged: {
                if(!running) {
                    if(y > screenH)
                    y = -backgroundRectangle.height

                    start()

                }
            }
        }


        Component.onCompleted:
        {
            moveAnimation.start()
            moveAnimation1.start()

            var rnd = Math.round(Math.random() * 2)
            if(rnd === 0)
                question.visible = true;
            else if(rnd === 1)
                number.visible = true
            else if(rnd === 2)
                smile.visible = true
            //console.log("rnd is:"+rnd)

        }

    }
