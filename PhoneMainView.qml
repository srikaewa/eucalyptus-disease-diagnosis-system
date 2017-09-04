import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    ColumnLayout{
        anchors{
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 80
        }
        spacing: 20

        Rectangle {
            id: firstCard
            width: cardWidth
            height: 240
            Layout.preferredWidth: width
            color: Qt.rgba(1,1,1,0.75)
            Label {
                text: qsTr("I'm a card!")
                anchors.centerIn: parent
            }
        }

        Rectangle {
            id: secondCard
            width: cardWidth
            height: 240
            Layout.preferredWidth: width
            color: Qt.rgba(1,1,1,0.45)
        }
  }



}
