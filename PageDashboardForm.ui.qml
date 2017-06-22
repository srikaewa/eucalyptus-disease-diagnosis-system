import QtQuick 2.5
import QtQuick.Controls 2.1
import QtMultimedia 5.8
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import Qt.labs.folderlistmodel 2.1
import QtQml.Models 2.2
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

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
    //property alias timerProcessing: timerProcessing
    property string dt: "x"
    property date todayDate: new Date()

    property bool serverANNStatus: false
    property bool serverFileStatus: false

    signal diseaseTypeRecieved(string imageId, string dType)

    Component.onCompleted: {
        pageDashboard.checkANNServer("http://192.168.0.21:3000/checkANNServer");
        //pageDashboard.checkANNServer("http://172.31.171.16:3000/checkANNServer");

        pageDashboard.checkFileServer("http://192.168.0.21:3009/checkFileServer");
        //pageDashboard.checkFileServer("http://172.31.171.16:3009/checkFileServer");
    }

    onDiseaseTypeRecieved: {
        console.log("Disease type recieved -> " + dType);
        if (dType != "x" && dType.length > 0) {
            myEDDSApi.updateDiseaseType(imageId, dType);
            myEDDSApi.updateEucaImageFileProcess(imageId, "true");
            pageDashboard.fillDashboardModel("*");
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

    Item{
        id: cameraPreviewStack
        CameraPreview{
            id: cameraPreview
            visible: false
        }
    }

    Item {
        id: mainView

        Rectangle{
            id: rectangleSeachDisease
            width: Screen.desktopAvailableWidth - 10
            height: 50
            anchors{
                left: parent.left
                leftMargin: 5
                top: parent.top
                topMargin: 5
            }

            ToolButton {
                id: toolbuttonMenu
                anchors.left: parent.left
                anchors.leftMargin: 5
                contentItem: ImageButton {
                    imageFile: "/images/ic_menu_black_48dp.png"
                }
                onClicked: drawer.open()
            }
            TextField {
                            id: textFieldSearchDisease
                            placeholderText: "Search disease 'cryptos'..."
                            font.family: fontRegular.name
                            font.pixelSize: 20
                            font.capitalization: Font.Capitalize
                            //color: "black"
                            color: "black"
                            anchors{
                                left: toolbuttonMenu.right
                                leftMargin: 5
                                right: toolbuttonOption.left
                                rightMargin: 5
                            }
                        }


            ToolButton {
                id: toolbuttonOption
                anchors.right: parent.right
                anchors.rightMargin: 5
                contentItem: ImageButton {
                    imageFile: "/images/ic_more_vert_black_48dp.png"
                }
                onClicked: optionsMenu.open()


                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: "Settings"
                        onTriggered: settingsPopup.open()
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

        ListView {
            id: dashboardListView
            anchors{
                top: rectangleSeachDisease.bottom
                topMargin: 5
                left: parent.left
                right: parent.right
                bottom: parent.bottom
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
                            running: ((myEDDSApi.readDiseaseType(imageId) == 'x') && (serverANNStatus==true) ? true : false)
                            //running: false
                            onTriggered: {
                                if (serverANNStatus) {
                                    var _filename = myEDDSApi.getImageFileName(filename);
                                    if(myEDDSApi.isFileUploaded(_filename) && (myEDDSApi.readEucaImageIdFromFile(_filename)=="xxxxxxxxxxxxxxxxx"))
                                    {
                                        postToEDDS(_filename,
                                                   true, 'x',
                                                   pageUser.textFieldEmail.text,
                                                   todayDate, todayDate,
                                                   latitude,longitude);
                                    }
                                    else
                                    {
                                        var count = myEDDSApi.readRunClassifyCount(imageId);
                                        console.log("Counting diseasetype of x = " + count);
                                        if (count == 0) {
                                            busyIndicatorProcessing.running = true;
                                            myEDDSApi.setRunClassifyCount(imageId, "1");
                                            runClassify(imageId);
                                        } else {
                                            if (count < 10) {
                                                console.log("Call getDiseaseType from server");
                                                pageDashboard.getDiseaseType(imageId);
                                                count = count + 1;
                                                myEDDSApi.setRunClassifyCount(imageId,count.toString());
                                                busyIndicatorProcessing.running = true;
                                            } else {
                                                timerGetDiseaseType.stop();
                                                busyIndicatorProcessing.running = false;
                                                imageRefresh.visible = true;
                                            }
                                        }
                                    }
                                } else {
                                    messageDialogServerStatus.text = "Can't connect to ANN server...!";
                                    messageDialogServerStatus.open();
                                    busyIndicatorProcessing.running = false;
                                    timerGetDiseaseType.stop();
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
                                                filename);
                                    var count = myEDDSApi.readSendFileCount(
                                                _filename);
                                    if (count == 0) {
                                        busyIndicatorFileUploading.running = true
                                        myEDDSApi.setSendFileCount(_filename,
                                                                   "1")
                                        //myEDDSApi.sendImageFile("file://" + myEDDSApi.getDefaultHomePath() + "/" + filename);
                                        myEDDSApi.sendImageFile(_filename)
                                    } else {

                                        if (count < 8) {
                                            console.log("Is file " + _filename + " uploaded??");
                                            if (myEDDSApi.isFileUploaded(
                                                        _filename)) {
                                                console.log("File " + _filename
                                                            + " has been uploaded already...");
                                                //console.log("Check status of computation...");
                                                var todayDate = new Date();
                                                myEDDSApi.updateDiseaseType2Filename(_filename,"x");
                                                pageDashboard.fillDashboardModel("*");
                                                busyIndicatorFileUploading.running = false;
                                                timerSendFile.stop();
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
                            visible: (busyIndicatorProcessing.running == false) && (myEDDSApi.isFileProcessed(myEDDSApi.getImageFileName(filename)) == false) && (myEDDSApi.isFileUploaded(myEDDSApi.getImageFileName(filename))==true)

                            MouseArea {
                                anchors {
                                    fill: parent
                                }
                                onClicked: {
                                    myEDDSApi.setRunClassifyCount(imageId, "0")
                                    timerGetDiseaseType.start()
                                    pageDashboard.checkANNServer("http://192.168.0.21:3000/checkANNServer")
                                    //pageDashboard.checkANNServer("http://172.31.171.16:3000/checkANNServer")
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
                            visible: (myEDDSApi.isFileUploaded(myEDDSApi.getImageFileName(filename))==false) && (busyIndicatorFileUploading.running==false)

                            MouseArea {
                                anchors {
                                    fill: parent
                                }
                                onClicked: {
                                    myEDDSApi.setSendFileCount(filename, "0")
                                    timerSendFile.start()
                                    //pageDashboard.checkFileServer("http://192.168.0.21:3009/checkFileServer")
                                    pageDashboard.checkFileServer("http://172.31.171.16:3009/checkFileServer")

                                }
                            }
                        }
                    }

                    Text {
                        text: "ID: " + imageId + "\n" + myEDDSApi.getImageFileName(
                                  filename) + "\n" + "Latitude: " + latitude + " \nLongitude: " + longitude + "\nLast edit: "
                              + lastedit + "\nDisease Type: " + diseasetype
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
