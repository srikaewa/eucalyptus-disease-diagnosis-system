import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

Item {
    id: itemDrawer
    property alias drawer: drawer

    property int headerFontSize: 18
    property int bodyFontSize: 16
    property int imageSize: 48

    //property alias textUserName: textUserName
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    anchors.fill: parent

    Drawer {
        id: drawer
        width: (Screen.primaryOrientation == Qt.LandscapeOrientation ? 0.4 * itemDrawer.width : 0.66 * itemDrawer.width)
        //width: imageFarmDetail.width + textFarmDetail.width + 30
        height: itemDrawer.height
        dragMargin: 0    

    GridLayout{
        columns: 2
        width: drawer.width
        anchors.top: drawer.top
        rowSpacing: 30
        columnSpacing: 30

        Image{
            source: "/images/Eucalyptus.png"
            width: drawer.width
            height: 160
            Layout.preferredWidth: drawer.width
            Layout.preferredHeight: 120
            Layout.columnSpan: 2
            fillMode: Image.PreserveAspectCrop
            Image{
                source: "/images/ic_account_circle_white_48dp.png"
                width: imageSize
                height: imageSize
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text: pageUser.textFieldEmail.text
                    anchors.top: parent.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: fontRegular.name
                    font.pixelSize: bodyFontSize
                    color: "#FFFFFF"
                }

            }
        }

       Image{
           source: "/images/ic_exit_to_app_black_48dp.png"
           width: 28
           height: 28
           Layout.preferredWidth: width
           Layout.preferredHeight: height
           Layout.leftMargin: 20
       }

       Text{
           text: "Sign out"
           font.family: fontRegular.name
           font.pixelSize: bodyFontSize
           color: "#000000"
           Layout.fillWidth: true
           Layout.alignment: Qt.AlignLeft
           MouseArea{
               anchors.fill: parent
               onClicked: {
                   pageUser.signOut();
                   drawer.close();
               }
           }
       }
    }
    }
}

