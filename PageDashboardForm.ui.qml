import QtQuick 2.7
import QtQuick.Controls 2.1
import QtMultimedia 5.8
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import Qt.labs.folderlistmodel 2.1
import QtQml.Models 2.2
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import QtPositioning 5.8
import QtLocation 5.9

import EucaImage 1.0

StackView {
    id: viewDashboard
    width: 480
    height: 800
    //property alias pageMainDiagnosis: pageMainDiagnosis
    //property alias dashboardFolModel: dashboardFolderModel
    property alias gridviewListModel: gridviewListModel
    property alias dashboardListModel: dashboardListModel
    property alias controlCenter: controlCenter
    property alias fileGallery: controlCenter.fileGallery
    property alias photoPreview: photoPreview
    property alias photoPreviewStack: photoPreviewStack
    property alias cameraPreview: cameraPreview
    property alias cameraPreviewStack: cameraPreviewStack
    property alias textFieldSearchDisease: textFieldSearchDisease
    property alias hereMap: hereMap
    property alias gpsPosition: gpsPosition
    property alias mouseAreaMap: mouseAreaMap
    //property alias timerProcessing: timerProcessing
    property string dt: "x"
    property date todayDate: new Date()

    property bool serverFileStatus: false

    signal diseaseTypeRecieved(string imageId, string dType, string dStage, string dLevel, string dLastedit, string dElapsetime)

    Component.onCompleted: {
        //pageDashboard.checkANNServer("http://" + pageSystemSetting.textFieldServerIPAddress.text + ":9099/checkANNServer")

        //pageDashboard.checkANNServer("http://172.31.171.16:9099/checkANNServer");
        pageDashboard.checkFileServer(
                    "http://" + pageSystemSetting.textFieldServerIPAddress.text
                    + ":3009/checkFileServer")
        //pageDashboard.checkFileServer("http://172.31.171.16:3009/checkFileServer");
    }

    onDiseaseTypeRecieved: {
        console.log("Disease type recieved -> " + dType)
        if (dType != "x" && dType.length > 0) {
            myEDDSApi.updateDiseaseType(imageId, dType, dStage, dLevel,
                                        dLastedit, dElapsetime)
            myEDDSApi.updateEucaImageFileProcess(imageId, "true")
            pageDashboard.fillDashboardModel("*")
        }
    }

    initialItem: mainView

    Item {
        id: photoPreviewStack
        PhotoPreview {
            id: photoPreview
            visible: false
        }
    }

    Item {
        id: cameraPreviewStack
        CameraPreview {
            id: cameraPreview
            visible: false
        }
    }

    Item {
        id: mainView

        Plugin {
            id: mapPlugin
            name: "here"
            PluginParameter {
                name: "here.app_id"
                value: "CD5ZNcUPxSCd4eu9Ipt5"
            }
            PluginParameter {
                name: "here.token"
                value: "80gzJuzovEcRTBGgxXXSKw"
            }
        }

        PositionSource {
            id: gpsPosition
            //preferredPositioningMethods: PositionSource.SatellitePositioningMethods
            preferredPositioningMethods: PositionSource.AllPositioningMethods
            active: true
            updateInterval: 1000 // ms
            onPositionChanged: active = false
        }

        Rectangle {
            id: rectangleMapBody
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Map {
                id: hereMap

                anchors.fill: parent

                copyrightsVisible: false

                plugin: mapPlugin

                center: QtPositioning.coordinate(
                            gpsPosition.position.coordinate.latitude,
                            gpsPosition.position.coordinate.longitude)

                //                latitude: 14.949298
                //                longitude: 102.049343
                //latitude: gpsPosition.position.coordinate.latitude
                //longitude: gpsPosition.position.coordinate.longitude
                //latitude: farmData.latitude
                //longitude: farmData.longitude
                zoomLevel: (hereMap.maximumZoomLevel + hereMap.minimumZoomLevel) / 2

                gesture.enabled: true
                gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture
                gesture.preventStealing: true

                /*MapQuickItem {
                    id: markerCurrentPosition
                    anchorPoint.x: imageCurrentMarker.width / 2
                    anchorPoint.y: imageCurrentMarker.height / 2

                    sourceItem: Image {
                        id: imageCurrentMarker
                        source: "images/currentPositionMarker.png"
                    }

                    coordinate: QtPositioning.coordinate(
                                    gpsPosition.position.coordinate.latitude,
                                    gpsPosition.position.coordinate.longitude)
                }

                MapQuickItem {
                    id: marker
                    anchorPoint.x: imageMarker.width / 2
                    anchorPoint.y: imageMarker.height

                    sourceItem: Image {
                        id: imageMarker
                        source: "/images/red-location-map-pin-icon-5.png"
                    }

                    coordinate: hereMap.center
                }*/
                MouseArea {
                    id: mouseAreaMap
                    anchors.fill: parent
                }

                Rectangle {
                    id: rectangleLatLongLabel
                    //                    objectName: "rectangleLatLongLabelObject"
                    color: "#88ffffff"
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    width: parent.width - 20
                    height: labelLatitude.font.pixelSize * 4
                    Label {
                        id: labelLatitudeCaption
                        text: qsTr("Latitude")
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? availableHeight * 0.022 : availableHeight * 0.012)
                        font.family: fontRegular.name
                    }
                    Label {
                        id: labelLatitude
                        text: gpsPosition.position.coordinate.latitude
                        anchors.verticalCenterOffset: 0
                        anchors.verticalCenter: labelLatitudeCaption.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? availableHeight * 0.022 : availableHeight * 0.012)
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label {
                        id: labelLongitudeCaption
                        text: qsTr("Longitude")
                        anchors.top: labelLatitudeCaption.bottom
                        anchors.topMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? availableHeight * 0.022 : availableHeight * 0.012)
                        font.family: fontRegular.name
                    }

                    Label {
                        id: labelLongitude
                        text: gpsPosition.position.coordinate.longitude
                        anchors.verticalCenterOffset: 0
                        anchors.verticalCenter: labelLongitudeCaption.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? availableHeight * 0.022 : availableHeight * 0.012)
                    }
                }
            }
        }

        Component {
            id: dashboardSectioning
            Rectangle {
                width: parent.width
                height: 50
                color: Qt.rgba(0, 0, 0, 0)
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: (section == 'x' ? 'Diagnosis pending...' : (section == 'u' ? 'Uploading image...' : section))
                          + " (" + myEDDSApi.countDiseaseType(section) + ")"
                    font.family: fontRegular.name
                    font.pixelSize: 18
                    font.bold: true
                }
            }
        }

        ListModel {
            id: gridviewListModel
        }
        ListModel {
            id: dashboardListModel
        }

        ControlCenter {
            id: controlCenter
        }

        Rectangle {
            id: rectangleSeachDisease
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

    MessageDialog {
        id: messageDialogServerStatus
        x: (Screen.primaryOrientation == Qt.LandscapeOrientation ? 30 : 5)
        y: Screen.desktopAvailableheight / 2 - 40
        width: (Screen.primaryOrientation
                == Qt.LandscapeOrientation ? Screen.desktopAvailableWidth
                                             - 60 : Screen.desktopAvailableWidth - 10)
        height: 80
        title: ""
        text: ""
        onAccepted: {
            messageDialogServerStatus.close()
        }
        Component.onCompleted: {
            visible = false
        }
    }
}
