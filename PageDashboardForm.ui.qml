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
                color: Qt.rgba(0,0,0,1)

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

            ListView {
                id: dashboardListView
                anchors {
                    top: parent.top
                    topMargin: rectangleSeachDisease.height + 5
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    //fill: parent
                }

                model: dashboardListModel
                //orientation: Qt.Horizontal
                layoutDirection: Qt.LeftToRight
                section {
                    property: "diseasetype"
                    delegate: dashboardSectioning
                }
                delegate: dashboardDelegate
                clip: true

                Component {
                    id: dashboardDelegate

                    /*EucaImage{
                            id: eucaImage
                            imageId: imageId
                            fileName: fileName
                            diseaseType: diseaseType
                            submitter: submitter
                            submit: submit
                            lastEdit: lastEdit
                        }*/
                    RowLayout {
                        spacing: 10
                        Image {
                            source: "file://" + myEDDSApi.getDefaultHomePath(
                                        ) + "/" + filename
                            width: 200
                            height: 200
                            sourceSize.width: width
                            sourceSize.height: height
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            Layout.leftMargin: 5
                            Layout.bottomMargin: 5

                            MouseArea {
                                anchors {
                                    fill: parent
                                }
                                onClicked: {


                                    //myEDDSApi.getProcessingStatus(imageId);
                                }
                            }

                            EucaImage {
                                id: eucaImage
                            }

                            Timer {
                                id: timerGetDiseaseType
                                interval: 5000
                                repeat: true
                                triggeredOnStart: true
                                running: ((myEDDSApi.readDiseaseType(
                                               imageId) == 'x')
                                          && (serverFileStatus == true) ? true : false)
                                //running: false
                                onTriggered: {
                                    if (serverFileStatus) {
                                        var _filename = myEDDSApi.getImageFileName(
                                                    filename)
                                        if (myEDDSApi.isFileUploaded(_filename)
                                                && (myEDDSApi.readEucaImageIdFromFile(
                                                        _filename) == "xxxxxxxxxxxxxxxxx")) {
                                            postToEDDS(_filename, true,
                                                       'x', '-', '-',
                                                       pageUser.textFieldEmail.text,
                                                       todayDate, todayDate,
                                                       latitude, longitude, '-')
                                        } else {
                                            var count = myEDDSApi.readRunClassifyCount(
                                                        imageId)
                                            console.log("Counting diseasetype of x = " + count)
                                            if (count == 0) {
                                                busyIndicatorProcessing.running = true
                                                myEDDSApi.setRunClassifyCount(
                                                            imageId, "1")
                                                runClassify(imageId)
                                            } else {
                                                if (count < 10) {
                                                    console.log("Call getDiseaseType from server")
                                                    pageDashboard.getDiseaseType(
                                                                imageId)
                                                    count = count + 1
                                                    myEDDSApi.setRunClassifyCount(
                                                                imageId,
                                                                count.toString())
                                                    busyIndicatorProcessing.running = true
                                                } else {
                                                    timerGetDiseaseType.stop()
                                                    busyIndicatorProcessing.running = false
                                                    imageRefresh.visible = true
                                                }
                                            }
                                        }
                                    } else {
                                        messageDialogServerStatus.text
                                                = "Can't connect to ANN server...!"
                                        messageDialogServerStatus.open()
                                        busyIndicatorProcessing.running = false
                                        timerGetDiseaseType.stop()
                                    }
                                }
                            }

                            Timer {
                                id: timerSendFile
                                interval: 4000
                                repeat: true
                                running: (!myEDDSApi.isFileUploaded(
                                              filename) ? true : false)
                                triggeredOnStart: true
                                onTriggered: {
                                    if (serverFileStatus) {
                                        var _filename = myEDDSApi.getImageFileName(
                                                    filename)
                                        var count = myEDDSApi.readSendFileCount(
                                                    _filename)
                                        if (count == 0) {
                                            busyIndicatorFileUploading.running = true
                                            myEDDSApi.setSendFileCount(_filename,
                                                                       "1")
                                            //myEDDSApi.sendImageFile("file://" + myEDDSApi.getDefaultHomePath() + "/" + filename);
                                            myEDDSApi.sendImageFile(_filename, pageSystemSetting.textFieldServerIPAddress.text)
                                        } else {

                                            if (count < 8) {
                                                console.log("Is file " + _filename + " uploaded??")
                                                if (myEDDSApi.isFileUploaded(
                                                            _filename)) {
                                                    console.log("File " + _filename
                                                                + " has been uploaded already...")
                                                    //console.log("Check status of computation...");
                                                    var todayDate = new Date()
                                                    myEDDSApi.updateDiseaseType2Filename(
                                                                _filename,
                                                                "x", "-", "-","-");
                                                    pageDashboard.fillDashboardModel(
                                                                "*")
                                                    busyIndicatorFileUploading.running = false
                                                    timerSendFile.stop()
                                                } else {
                                                    console.log("Uploading file " + _filename)
                                                    busyIndicatorFileUploading.running = true
                                                    count++
                                                    myEDDSApi.setSendFileCount(
                                                                _filename,
                                                                count.toString())
                                                    console.log("Setting sendFileCount of file "
                                                                + _filename + " -> " + count)
                                                }
                                            } else {
                                                console.log("Uploading file " + _filename
                                                            + " failed!!!!!")
                                                busyIndicatorFileUploading.running = false
                                                timerSendFile.stop()
                                            }
                                        }
                                    } else {
                                        messageDialogServerStatus.text
                                                = "Can't connect to file server...!"
                                        messageDialogServerStatus.open()
                                        busyIndicatorFileUploading.running = false
                                        timerSendFile.stop()
                                    }
                                }
                            }

                            BusyIndicator {
                                id: busyIndicatorProcessing
                                anchors {
                                    centerIn: parent
                                }
                                height: ((parent.width
                                          > parent.height) ? parent.height / 4 : parent.width / 4)
                                width: height
                                running: false
                                //running: (((myEDDSApi.readDiseaseType(imageId) == 'x') && (requestDiseaseTypeCount < 10)) ? true : false)
                            }

                            BusyIndicator {
                                id: busyIndicatorFileUploading
                                anchors {
                                    centerIn: parent
                                }
                                height: ((parent.width
                                          > parent.height) ? parent.height / 4 : parent.width / 4)
                                width: height
                                running: false
                            }

                            Image {
                                id: imageRefresh
                                anchors {
                                    centerIn: parent
                                }
                                width: ((parent.width
                                         > parent.height) ? parent.height / 4 : parent.width / 4)
                                height: width
                                source: "/images/ic_refresh_white_48dp.png"
                                visible: (busyIndicatorProcessing.running == false)
                                         && (myEDDSApi.isFileProcessed(
                                                 myEDDSApi.getImageFileName(
                                                     filename)) == false)
                                         && (myEDDSApi.isFileUploaded(
                                                 myEDDSApi.getImageFileName(
                                                     filename)) == true)

                                MouseArea {
                                    anchors {
                                        fill: parent
                                    }
                                    onClicked: {
                                        myEDDSApi.setRunClassifyCount(imageId, "0")
                                        timerGetDiseaseType.start()
                                        pageDashboard.checkFileServer("http://" + pageSystemSetting.textFieldServerIPAddress.text + ":9099/checkANNServer")
                                        //pageDashboard.checkANNServer("http://172.31.171.16:9099/checkANNServer")
                                    }
                                }
                            }

                            Image {
                                id: imagePublish
                                anchors {
                                    centerIn: parent
                                }
                                width: ((parent.width
                                         > parent.height) ? parent.height / 4 : parent.width / 4)
                                height: width
                                source: "/images/ic_publish_white_48dp.png"
                                visible: (myEDDSApi.isFileUploaded(
                                              myEDDSApi.getImageFileName(
                                                  filename)) == false)
                                         && (busyIndicatorFileUploading.running == false)

                                MouseArea {
                                    anchors {
                                        fill: parent
                                    }
                                    onClicked: {
                                        myEDDSApi.setSendFileCount(filename, "0")
                                        timerSendFile.start()
                                        pageDashboard.checkFileServer("http://" + pageSystemSetting.textFieldServerIPAddress.text + ":3009/checkFileServer")
                                    }
                                }
                            }
                        }

                        Text {
                            text: "ID: " + imageId + "\n" + myEDDSApi.getImageFileName(filename)
                                  + "\n" + "Latitude: " + latitude + " \nLongitude: "
                                  + longitude + "\nSubmited: " + submit + "\nLast edit: " + lastedit + "\nDisease Type: "
                                  + diseasetype + "\nStage: " + stage + "\nLevel: "
                                  + level + "\nElapsed Time: " + elapsetime
                            font.family: fontRegular.name
                            font.pixelSize: 16
                            MouseArea {
                                anchors {
                                    fill: parent
                                }
                                onClicked: {
                                    pageDashboard.getDiseaseType(imageId)
                                }
                            }
                        }
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
