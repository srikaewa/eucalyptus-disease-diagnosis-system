import QtQuick 2.4
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

Item {
    property alias textFieldServerIPAddress: textFieldServerIPAddress
    property alias textServerStatus: textServerStatus

    width: 800
    height: 480

    Settings {
        property alias serverIPAddress: textFieldServerIPAddress.text
    }

    Rectangle {
        id: rectangleSettingHeader
        width: Screen.desktopAvailableWidth - 16
        height: 50
        anchors {
            left: parent.left
            leftMargin: 8
            top: parent.top
            topMargin: 8
        }
        radius: 2

        ToolButton {
            id: toolbuttonSettingBack
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            contentItem: ImageButton {
                imageFile: "/images/ic_arrow_back_black_48dp.png"
                //(textFieldSearchDisease.focus ? "/images/ic_arrow_back_black_48dp.png" : "/images/ic_menu_black_48dp.png")
                onClicked: swipeView.setCurrentIndex(1)
            }
        }

        Label {
            anchors.centerIn: parent
            text: "Settings"
            font.family: fontRegular.name
            font.pixelSize: 20
            font.bold: true
        }
    }
    DropShadow {
        anchors.fill: rectangleSettingHeader
        horizontalOffset: 2
        verticalOffset: 2
        radius: 5
        samples: 17
        color: "#80000000"
        source: rectangleSettingHeader
    }

    Flickable {
        anchors.top: rectangleSettingHeader.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        clip: true

        GridLayout {
            id: gridSetting
            columns: 2
            anchors.fill: parent
            Text {
                text: "Server IP Address "
                font.family: fontRegular.name
                font.pixelSize: 18
                Layout.preferredWidth: 50
            }
            TextField {
                id: textFieldServerIPAddress
                placeholderText: "xx.xx.xx.xx"
                font.family: fontRegular.name
                font.pixelSize: 18
                Layout.preferredWidth: 200
                Layout.alignment: Qt.AlignLeft
            }
            Text {
                text: "Server Port "
                font.family: fontRegular.name
                font.pixelSize: 18
                Layout.preferredWidth: 4
            }
            TextField {
                id: textFieldServerIPPort
                placeholderText: "3009"
                text: "3009"
                font.family: fontRegular.name
                font.pixelSize: 18
                Layout.preferredWidth: 200
                Layout.alignment: Qt.AlignLeft
            }
            Text {
                text: "Server Status "
                font.family: fontRegular.name
                font.pixelSize: 18
                Layout.preferredWidth: 4
            }
            Text {
                id: textServerStatus
                text: ""
                font.family: fontRegular.name
                font.pixelSize: 18
                Layout.preferredWidth: 4
            }
        }
    }
}
