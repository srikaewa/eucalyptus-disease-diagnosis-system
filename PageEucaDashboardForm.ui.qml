import QtQuick 2.4
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Item {
    id: viewEucaDashboard
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    //property alias dashboardEucaModel: dashboardEucaModel

    Component.onCompleted: {
        console.log("Disease List -> " + myEDDSApi.getDiseaseList());
        //fillDashboardEucaModel("*");
    }

    ListView{
        id: dashboardEucaListView
        anchors {
            top: parent.top
            topMargin: rectangleSeachDisease.height + 10
            left: parent.left
            leftMargin: 10
            right: parent.right
            rightMargin: 10
            bottom: parent.bottom
            bottomMargin: 10
        }

        model: myEDDSApi.getDiseaseList()
        layoutDirection: Qt.LeftToRight
        delegate: dashboardEucaDelegate
        clip: true
        Component{
            id: dashboardEucaDelegate
            Text {
                text: modelData
                font.family: fontRegular.name
                font.bold: true
                font.pixelSize: 20
            }
            Grid{

            }
        }
    }

    Rectangle {
        id: rectangleSeachDisease
        width: Screen.desktopAvailableWidth - 16
        height: 56
        anchors {
            left: parent.left
            leftMargin: 8
            top: parent.top
            topMargin: 8
        }
        radius: 2

        ToolButton {
            id: toolbuttonMenu
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            contentItem: ImageButton {
                imageFile: "/images/ic_menu_black_48dp.png"
                //(textFieldSearchDisease.focus ? "/images/ic_arrow_back_black_48dp.png" : "/images/ic_menu_black_48dp.png")
                onClicked: drawer.open()
            }
        }
        TextField {
            id: textFieldSearchDisease
            placeholderText: "Search disease 'cryptos'..."
            font.family: fontRegular.name
            font.pixelSize: 20
            //font.capitalization: Font.Capitalize
            //color: "black"
            color: "black"
            anchors {
                left: toolbuttonMenu.right
                leftMargin: 5
                right: toolbuttonOption.left
                verticalCenter: parent.verticalCenter
            }
        }

        ToolButton {
            id: toolbuttonOption
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            contentItem: ImageButton {
                imageFile: "/images/ic_more_vert_black_48dp.png"
                //(textFieldSearchDisease.focus ? "/images/ic_arrow_back_black_48dp.png" : "/images/ic_menu_black_48dp.png")
                onClicked: optionsMenu.open()
            }
            Menu {
                id: optionsMenu
                x: parent.width - width
                transformOrigin: Menu.TopRight

                MenuItem {
                    text: "Settings"
                    onTriggered: swipeView.setCurrentIndex(2)
                }
                MenuItem {
                    text: "About"
                    onTriggered: aboutDialog.open()
                }
            }
        }
    }
    DropShadow {
        anchors.fill: rectangleSeachDisease
        horizontalOffset: 2
        verticalOffset: 2
        radius: 5
        samples: 17
        color: "#80000000"
        source: rectangleSeachDisease
    }
}
