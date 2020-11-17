import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt.labs.settings 1.0
import QtWebView 1.15

ApplicationWindow {
    id: appWindow
    width: 1440
    height: 1024
    minimumWidth: 960
    minimumHeight: 540
    visible: true
    title: qsTr("Desktop Pay Wallet")

    WebView {
        anchors.fill: parent
        url: "http://wallet.violas.io"
    }
}
