import QtQuick 2.4
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    id: editServer
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    property alias textFieldServerIPAddress: textFieldServerIPAddress
    property alias textFieldServerPort: textFieldServerPort

    property int headerFontSize: 42 / Screen.devicePixelInfo
    property int bodyFontSize: 36 / Screen.devicePixelInfo
    property int imageSize: 28

    Image{
        id: imageEditServerBack
        anchors{
            margins: 20
            left: parent.left
            top: parent.top
        }

        source: "/images/ic_arrow_back_black_48dp.png"
        width: imageSize
        height: width
        MouseArea{
            id: mouseAreaEditServerBack
            anchors.fill: parent
            onClicked: {
                pageSystemSetting.textFieldServerIPAddress.text = textFieldServerIPAddress.text
                pageSystemSetting.textFieldServerPort.text = textFieldServerPort.text
                pageDashboard.checkFileServer("http://" + textFieldServerIPAddress.text + ":" + textFieldServerPort.text + "/checkFileServer")
                //swipeView.interactive = true;
                pageSystemSetting.pop();
            }
        }

        Text {
            anchors{
                left: parent.right
                leftMargin: 20
                verticalCenter: parent.verticalCenter
            }
            font.family: fontRegular.name
            font.pixelSize: headerFontSize
            font.bold: true
            text: "Edit Server"
        }
    }

    ColumnLayout {
        id: serverSetting
        anchors{
            top: imageEditServerBack.bottom
            topMargin: 30
            horizontalCenter: parent.horizontalCenter
        }

        GridLayout{
            columns: 2
            Text {
                text: "IP Address "
                font.family: fontRegular.name
                font.pixelSize: 18
            }
            TextField {
                id: textFieldServerIPAddress
                text: "192.168.0.21"
                placeholderText: "xx.xx.xx.xx"
                font.family: fontRegular.name
                font.pixelSize: 16
                color: "#5d99c6"
            }

            Text {
                text: "Port "
                font.family: fontRegular.name
                font.pixelSize: 18

            }
            TextField {
                id: textFieldServerPort
                placeholderText: "3009"
                text: "3009"
                font.family: fontRegular.name
                font.pixelSize: 16
                color: "#5d99c6"
            }
        }
    }
}
