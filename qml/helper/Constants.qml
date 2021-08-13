pragma Singleton

import QtQuick 2.0

Item {

    // AdMob
    readonly property string admobBannerAdUnitId: "ca-app-pub-9155324456588158/9913032020"
    readonly property string admobInterstitialAdUnitId: "ca-app-pub-9155324456588158/9075427220"
    readonly property var admobTestDeviceIds: [ "d17ba18ff075e7c20c5ce081813d9666", "28CA0A7F16015163A1C70EA42709318A" ]

    // Soomla
    property string soomlaSecret: "<your-game-secret>"
    property string soomlaAndroidPublicKey: "<android-public-key>"
    property string creditsCurrencyItemId: "net.vplay.demos.PluginDemo.credits"
    property string creditsPackItemId: "net.vplay.demos.PluginDemo.creditspack"
    property string goodieItemId: "net.vplay.demos.PluginDemo.goodie"
    property string noAdsItemId: "net.vplay.demos.PluginDemo.noads"

}
