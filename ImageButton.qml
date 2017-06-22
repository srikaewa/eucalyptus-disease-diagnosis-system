import QtQuick 2.0

import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: button

    signal clicked

    property alias mouseRegion: mouseRegion

    property string text
    //property color color: "white"
    property string imageFile

    width : 144
    height: 70
    color: Qt.rgba(0,0,0,0)

    BorderImage {
        id: buttonImage
        source: button.imageFile
        width: 36
        height: 36
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseRegion
        anchors.fill: parent
        onClicked: { button.clicked(); }
    }
    Text {
        id: btnText
        anchors.fill: parent
        anchors.margins: 5
        text: button.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        //elide: Text.ElideRight
        color: "white"
        font.family: fontRegular.name
        font.pixelSize: 17
        font.bold: true
        //style: Text.Raised
        styleColor: "black"
    }
}
