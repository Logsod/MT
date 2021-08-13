import VPlay 2.0
import QtQuick 2.0
import QtQuick.Window 2.2
//import "pages"
//import "helper"

/*/////////////////////////////////////
  NOTE:
  Additional integration steps are needed to use V-Play Plugins, for example to add and link required libraries for Android and iOS.
  Please follow the integration steps described in the plugin documentation of your chosen plugins:
  - AdMob: https://v-play.net/doc/plugin-admob/
  - Soomla: https://v-play.net/doc/plugin-soomla/

  To open the documentation of a plugin item in Qt Creator, place your cursor on the item in your QML code and press F1.
  This allows to view the properties, methods and signals of V-Play Plugins directly in Qt Creator.

/////////////////////////////////////*/
import VPlayPlugins 1.0
Window{
    visible: true
    id:loaderWindow
    title: qsTr("Hello")
    property int backgroundNumber: 1
    property int loaderWidth: width
    property int loaderHeight: height
    visibility: Window.FullScreen
    width:Screen.width
    height:Screen.height

    //width:480
    //height:854


    // Soomla
    property string soomlaSecret: "game_1_2_3_secret1231"
    property string soomlaAndroidPublicKey: "111FBFEE92A53E3E6E10179247BB5D497C826F5ECBD3DD82B96A84726DD0E7706BCFCD23A075DDFDB880BF706961F4FD9A6DFDE91B214AD146A182DF39F323A8D78109BCA860AD060C6856391ECEDA6586D348A63D8BEF72A311D8532269566D996D671C7FF1F793937F65419E8C83F12F7FBA02871B15F336DF854C22C7DFF357D25613A995875BB44643F8A5164FA56715D49005DAB2A4EC113D8BA2F9C2C928582F33CAB0EC3BAAB5B9C029ACFA4A15774EDE158FE949C5761CCFCB014239B6336E8C74163667CB81DC8A97867FD8D8DEA52A8C5F762B73542F1C2434C95CBE5E62BFCBB90EA1293B1A1ADC11310D5D5FF917A6D7D4D0B919EBBC1B58484ADEC40A847B30C74560D5FE970D667CBDACE17ECEFC72E86F0C88E2377107B918F7CCA9629DA518D84819DF2EC81AAEAEB411963CC6D7C8E083FB6DC4E6E91033CC2A7E003EF29ED510A9C40B2FE1D296C97EF9ADEBF3ADF137877C08BC6450852D021B9553681D36E7461A2CD0A8F904"
    property string creditsCurrencyItemId: "net.vplay.demos.PluginDemo.credits"
    property string creditsPackItemId: "net.vplay.demos.PluginDemo.creditspack"
    property string goodieItemId: "net.vplay.demos.PluginDemo.goodie"
    property string noAdsItemId: "mem.train.remove.ads1"



    GameWindowItem {
        licenseKey: "707415DFC43E40D3F1E744050D98C85EFCF5C82567FBDD14CF3F53834E80739D63EF1FC1EC3691AE14A95284B382DAF6F9BD245A89929A8FB2793768E2F224A53B91BFFF9ACD0EF7D776D5B8E9D9AFC0C0DFACF0D82D45C2312E8BD09B5FC6475ED1446561489B683C7CD8FA47FEB57184DAB9AC21E7CD0D4C5A4DF8443757DBB7BD7AB0C87FBAFE25243A7C19DC9E884CEDAB393BB3D9C08B3BA1A569BE31FDD264EBCF7213FA5E3A39B6C7F3D89A73D56E6971002CE0ED4AFABC8A291C42493C50D364BE779BE239FA7B4B2BEFE49EFFA1E1E982C3E542F2B20076FD42A0A754CDDDBDD99ADB779B581EA0A594BFDAD3D49D01E1169608B3208339E156ECA51FEDD113531349603F21338631602D15096F4B5C8DB25567012350194DAD8E332250A78FC6FA4F30501E7E61B8ADE770A47A9FC2A899572DF3C9C371AAC313645E42F498FF7EA3578E109A12464220CC022257DAC7835B26A239991C8A7913D51800E151AE56C87970E2DF3B8336EC73"
        anchors.fill: parent
        id: gameWindow
        fullscreen: false
        maximized: true

        Store {
            id: store

            version: 1
            secret: soomlaSecret
            androidPublicKey: soomlaAndroidPublicKey

            /*
            // Virtual currencies within the game
            currencies: [
                Currency {
                    id: creditsCurrency
                    itemId: creditsCurrencyItemId
                    name: "Credits"
                }
            ]

            // Purchasable credit packs
            currencyPacks: [
                CurrencyPack {
                    id: creditsPack
                    itemId: creditsPackItemId
                    name: "10 Credits"
                    description: "Buy 10 Credits"
                    currencyId: creditsCurrency.itemId
                    currencyAmount: 10
                    purchaseType:  StorePurchase { id: gold10Purchase; productId: creditsPack.itemId; price: 0.99 }
                }
            ]
    */
            // Goods contain either single-use, single-use-pack or lifetime goods
            goods: [
                /*
                // A goodie costs 3 credits (virtual currency that can be purschased with an in-app purchase)
                SingleUseGood {
                    id: goodieGood
                    itemId: goodieItemId
                    name: "Goodie"
                    description: "A tasty goodie"
                    purchaseType: VirtualPurchase { itemId: creditsCurrency.itemId; amount: 3; }
                },
                */
                // Life-time goods can be restored from the store
                LifetimeGood {
                    id: noadsGood
                    itemId: noAdsItemId
                    name: "No Ads"
                    description: "Buy this item to remove the app banner"
                    purchaseType: StorePurchase { id: noAdPurchase; productId: noadsGood.itemId; price: 2.99; }
                }
            ]

            onItemPurchased: {
                console.debug("Purchases item:", itemId)
                NativeDialog.confirm("Info", "Successfully bought: " + itemId, null, false)
            }

            onInsufficientFundsError: {
                console.debug("Insufficient funds for purchasing item")
                NativeDialog.confirm("Error",
                                     "Insufficient credits for buying a goodie, get more credits now?",
                                     function(ok) {
                                         if (ok) {
                                             // Trigger credits purchase right from dialog
                                             store.buyItem(creditsPack.itemId)
                                         }
                                     },
                                     true)
            }

            onRestoreAllTransactionsFinished: {
                console.debug("Purchases restored with success:", success)
            }
        }


        //onInitTheme: {
        //    Theme.colors.statusBarStyle = Theme.colors.statusBarStyleHidden
        //    Theme.navigationBar.backgroundColor = Theme.isAndroid ? "blue" : "red"
        //}
        // You get free licenseKeys from https://v-play.net/licenseKey
        // With a licenseKey you can:
        //  * Publish your games & apps for the app stores
        //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
        //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
        //licenseKey: "<generate one from https://v-play.net/licenseKey>"
        //licenseKey: "3C617EF54E3EB8926B5F36F0913EBAA6BBDB57A11A5B1A2C6200E3B2EBE5B9F583B92C4617781E6FCF29EE1698230381D64E18DA1175A4604F4179D5EE6F3460851BF55B0121D4229A776D74ECC70E30CEFD6063037A573F223D16AD55129D930F86B0E42A2530DFD0BEDB673861AD07AD439FE7420C4D863415FAEF5016C718C88027C72D3C93BB4FFE4774750C203F062A4265A12B66D101FF7525C1F48149564F3E8259C34F03A5CC0053A67A0BE1E53B427FA59F520B7E38A8E1B8FFD42F03464D42AF6CF5981B2007A6EF1D3023B849BEB7BDFF63F131A95F7FD2450502274CF5818FE96D7C11B6026DD2DF775016079C313D8F2B1A401FF3B63A6922125260657DD62DCA9C6AFFAE4AD4D5FC3D32BE3DCB1ED8BF9485B9D7BA65452DF7F0647CA76ADF98035B55EFC90CDF7DBAB67E94CA0DBA94202F307AD742400A4CBA2B0C2C219406E341ECEAAF104564C0B7377BB1066424F2356C8572778244933F568A1263BC75AB92598E6086A20D66"

        // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
        // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
        // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
        // this resolution is for iPhone 4 & iPhone 4S
        // screenWidth: Screen.width
        // screenHeight: Screen.height



            // the "logical size" - the scene content is auto-scaled to match the GameWindow size
            //width: 320
            //height: 480

            // This item contains example code for the chosen V-Play Plugins
            // It is hidden by default and will overlay the QML items below if shown
            Rectangle {
                id: rectangle
                anchors.fill: parent
                color: "grey"
                Loader{

                    function setLoaderSource(newSource)
                    {
                        source = ""
                        source = newSource
                    }
                    function noAdsItemIdIsPurchased()
                    {
                        if(noadsGood.purchased === true)
                            return true
                        else
                            return false
                    }
                    function startBuyNoAdsItemId()
                    {
                        store.buyItem(noadsGood.itemId)
                    }
                    id:myLoader
                    anchors.fill: parent
                    // width: gameWindow.landscape ? scene.dp(120) : 0
                    //        // fill the whole screen height
                    //        anchors.top: scene.gameWindowAnchorItem.top
                    //        height: scene.gameWindowAnchorItem.height
                    //        anchors.left: scene.gameWindowAnchorItem.left
                    property alias gameStore: store
                    property alias loaderWidth: rectangle.width
                    property alias loaderHeight: rectangle.height
                    property variant gameLoader: myLoader
                    property int game_1_block_count: 6
                    property int game_2_cols: 2
                    property int game_2_row: 3
                    property int game_3_cols: 4
                    property int game_3_row: 4
                    source: "qrc:/mainMenu.qml"
                }
        }
    }
}
