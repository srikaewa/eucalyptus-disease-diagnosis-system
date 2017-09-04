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
import QtQuick.Controls.Material 2.2

import EucaImage 1.0

StackView {
    id: viewDashboard
    width: Screen.availableDesktopWidth
    height: Screen.availableDesktopHeight
    //property alias pageMainDiagnosis: pageMainDiagnosis
    //property alias dashboardFolModel: dashboardFolderModel
    //property alias gridviewListModel: gridviewListModel
    property alias dateListView: dateListView
    property alias dashboardListModel: dashboardListModel
    property alias dateListModel: dateListModel
    property alias controlCenter: controlCenter
    property alias fileGallery: controlCenter.fileGallery
    property alias photoPreview: photoPreview
    property alias photoPreviewStack: photoPreviewStack
    property alias cameraPreview: cameraPreview
    property alias cameraPreviewStack: cameraPreviewStack
    property alias diagnosisDetail: diagnosisDetail
    property alias diagnosisDetailStack: diagnosisDetailStack
    property alias info: info
    property alias infoStack: infoStack
    property alias textFieldSearchDisease: textFieldSearchDisease
    property alias textSearchNotFound: textSearchNotFound
    //property alias mouseAreaMap: mouseAreaMap
    //property alias timerProcessing: timerProcessing
    property string dt: "x"
    property string searchString: "*"
    property int searchResult: -1
    property date todayDate: new Date()

    property int headerFontSize: 18
    property int bodyFontSize: 16
    property int imageSize: 28

    property int gridSize: (Screen.width < Screen.height) ? Screen.width / 5 : Screen.width / 8

    property bool serverFileStatus: false

    property var diseaseList: []
    property var dateList: []

    signal diseaseTypeRecieved(string imageId, string dType, string dStage, string dLevel, string dLastedit, string dElapsetime)

    Component.onCompleted: {
        pageDashboard.checkFileServer(
                    "http://" + pageSystemSetting.textFieldServerIPAddress.text
                    + ":3009/checkFileServer")
        diseaseList = myEDDSApi.getDiseaseList()
        dateList = myEDDSApi.getDateList("*")
        console.log("Get disease list -> " + diseaseList)
        /*if(mobileScreen)
        {
            console.log("Screen pixel width -> " + screenPixelWidth);
            if(Screen.width < Screen.height)
            {
                gridSize = Screen.width / 5;
            }
            else
            {
                gridSize = Screen.width / 8;
            }
        }else
        {
            if(Screen.width < Screen.height)
            {
                gridSize = Screen.width / 5;
            }
            else
            {
                gridSize = Screen.width / 8;
            }
        }*/
    }

    function gridRowHeight(im_num) {
        if (mobileScreen) {
            if (Screen.width < Screen.height) {
                return Math.ceil(im_num / 5) * gridSize
            } else {
                return Math.ceil(im_num / 8) * gridSize
            }
        } else {
            if (Screen.width < Screen.height) {
                return Math.ceil(im_num / 5) * gridSize
            } else {
                return Math.ceil(im_num / 8) * gridSize
            }
        }
    }

    onDiseaseTypeRecieved: {
        console.log("Disease type recieved -> " + dType)
        if (dType != "x" && dType.length > 0) {
            myEDDSApi.updateDiseaseType(imageId, dType, dStage, dLevel,
                                        dLastedit, dElapsetime)
            myEDDSApi.updateEucaImageFileProcess(imageId, "true")
            //pageDashboard.fillDashboardModel("*")
            pageDashboard.fillDateListModel("*")
        }
    }

    initialItem: gridView

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
        id: diagnosisDetailStack
        DiagnosisDetail {
            id: diagnosisDetail
            visible: false
        }
    }

    Item {
        id: infoStack
        Info {
            id: info
            visible: false
        }
    }


    /*    Item {
        id: cardView

        anchors.fill: parent

        visible: false

        Image{
            source: "/images/euca_background_01.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop

            onWidthChanged: {
                if(mobileScreen)
                {
                    if(Screen.width < Screen.height)
                    {
                        cardWidth = Screen.width * 0.9;
                    }
                    else
                    {
                        cardWidth = Screen.height * 0.75;
                    }
                }else
                {
                    if(Screen.width < Screen.height)
                    {
                        cardWidth = Screen.width * 0.45;
                    }
                    else
                    {
                        cardWidth = Screen.height * 0.45;
                    }
                }

                console.log("viewDashboard ->" + viewDashboard.width + ", cardWidth -> " + cardWidth);

        }

        Flickable{
            anchors.fill: parent
            boundsBehavior: Flickable.DragAndOvershootBounds
            flickableDirection: Flickable.VerticalFlick
            contentHeight: cardViewLoader.cardViewHeight
            clip: true

            Loader{
                 id: cardViewLoader
                 anchors.fill: parent
            }
        }
    }
    } */
    Item {
        id: gridView
        ListView {
            id: dateListView
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: parent.top
                bottomMargin: 70
            }
            anchors.fill: parent
            spacing: 20
            model: dateListModel
            delegate: dateListDelegate

            Component {
                id: dateListDelegate

                Column {
                    //anchors.topMargin: (index == 0) ? 1000 : 20
                    topPadding: (index == 0) ? 80 : 0
                    leftPadding: 2
                    Label {
                        text: datetext
                        font.family: fontRegular.name
                        font.pixelSize: bodyFontSize
                        font.bold: true
                        leftPadding: 20
                        bottomPadding: 10
                        //Layout.topMargin: (index == 0) ? 100 : 20
                        //Layout.leftMargin: 20
                    }

                    GridView {
                        id: gridImageView
                        width: dateListView.width
                        //height: gridSize * gridViewModel.count
                        cellWidth: gridSize
                        cellHeight: gridSize
                        model: gridViewModel
                        delegate: gridViewDelegate

                        Component.onCompleted: {
                            var object = JSON.parse(myEDDSApi.readEucaImage(
                                                        searchString, date))
                            for (var i = 0; i < object.euca_image.length; i++) {
                                //console.log("Read euca data -> " + object.euca_image[i].imageId + ":" + object.euca_image[i].diseasetype + " with original filename[" + object.euca_image[i].originalfilename + "]");
                                gridViewModel.append(object.euca_image[i])
                            }
                            gridImageView.height = gridRowHeight(
                                        gridViewModel.count)
                            console.log("GridView initialized -> " + index + ", width -> "
                                        + gridImageView.width + ", height -> "
                                        + gridImageView.height + ", gridSize -> " + gridSize
                                        + ", modelCount -> " + gridViewModel.count)
                        }

                        ListModel {
                            id: gridViewModel
                        }

                        Component {
                            id: gridViewDelegate

                            //RowLayout {
                            //    spacing: 10
                            Image {
                                id: imageDiseaseSegmented
                                source: "file://" + myEDDSApi.getDefaultHomePath(
                                            ) + "/" + displayfilename
                                x: 2
                                y: 2
                                width: gridImageView.cellWidth - 4
                                height: gridImageView.cellHeight - 4
                                sourceSize.width: width
                                sourceSize.height: height
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true

                                MouseArea {
                                    anchors {
                                        fill: imageDiseaseSegmented
                                    }
                                    onClicked: {
                                        console.log("ListView index selection -> " + index)
                                        diagnosisDetail.imageListIndex = index
                                        diagnosisDetail.visible = true
                                        diagnosisDetail.source = "file://"
                                                + myEDDSApi.getDefaultHomePath(
                                                    ) + "/" + displayfilename
                                        diagnosisDetail.textDiseaseType.text = diseasetype
                                        diagnosisDetail.textDiseaseStage.text = "Stage: " + stage
                                        diagnosisDetail.textDiseaseLevel.text = "Level: " + level
                                        diagnosisDetail.imageId = imageId

                                        var s = new Date(submit)
                                        var d = new Date(lastedit)
                                        console.log("Select date -> " + d.toLocaleDateString(
                                                        ))
                                        info.imageOriginalSource = "file://"
                                                + myEDDSApi.getDefaultHomePath(
                                                    ) + "/" + originalfilename
                                        info.imageDiseaseMaskSource = "file://"
                                                + myEDDSApi.getDefaultHomePath(
                                                    ) + "/" + displayfilename
                                        console.log("Original image file -> "
                                                    + info.imageOriginalSource)
                                        info.textDescription.text = "Diagnosis Info\n" + diseasetype
                                                + " - Stage: " + stage + ", Level: " + level
                                        info.textSubmit.text = "Submitted time\n"
                                                + s.toLocaleDateString(
                                                    ) + " - " + s.toLocaleTimeString()
                                        info.textLastedit.text = "Last edited time\n"
                                                + d.toLocaleDateString(
                                                    ) + " - " + d.toLocaleTimeString()
                                        info.textFilename.text = +"Original image: "
                                                + originalfilename
                                                + "\nDisplaying image: " + displayfilename
                                                + "\nProcessing image: " + filename
                                        info.textServerInfo.text = "Image ID\n" + imageId
                                        info.textElapseTime.text = "Processed time\n"
                                                + elapsetime + " s"
                                        info.textInfoLatitude.text = latitude
                                        info.textInfoLongitude.text = longitude
                                        controlCenter.visible = false
                                        swipeView.interactive = false
                                        pageDashboard.push(diagnosisDetailStack)
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
                                    running: ((serverFileStatus == true)
                                              && (myEDDSApi.readDiseaseType(
                                                      imageId) == 'x') ? true : false)
                                    //running: false
                                    onTriggered: {
                                        if (serverFileStatus) {
                                            var _filename = myEDDSApi.getImageFileName(
                                                        filename)
                                            todayDate = new Date()

                                            var count = myEDDSApi.readRunClassifyCount(
                                                        imageId)
                                            console.log("Counting diseasetype of x = " + count)
                                            if (count == 0) {
                                                busyIndicatorProcessing.running = true
                                                myEDDSApi.setRunClassifyCount(
                                                            imageId, "1")
                                                runClassify(imageId)
                                            } else {
                                                if (count < 20) {
                                                    console.log("Call getDiseaseType from server")
                                                    pageDashboard.getDiseaseType(
                                                                imageId)
                                                    count = count + 1
                                                    myEDDSApi.setRunClassifyCount(
                                                                imageId,
                                                                count.toString(
                                                                    ))
                                                    busyIndicatorProcessing.running = true
                                                } else {
                                                    timerGetDiseaseType.stop()
                                                    busyIndicatorProcessing.running = false
                                                    imageRefresh.visible = true
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
                                                myEDDSApi.setSendFileCount(
                                                            _filename, "1")
                                                myEDDSApi.sendImageFile(
                                                            _filename,
                                                            pageUser.textFieldEmail.text,
                                                            latitude,
                                                            longitude,
                                                            pageSystemSetting.textFieldServerIPAddress.text)
                                            } else {
                                                if (count < 20) {
                                                    console.log("Is file " + _filename
                                                                + " uploaded??")
                                                    if (myEDDSApi.isFileUploaded(
                                                                _filename)) {
                                                        console.log("File " + _filename + " has been uploaded already...")
                                                        //console.log("Check status of computation...");
                                                        var todayDate = new Date()
                                                        myEDDSApi.updateDiseaseType2Filename(
                                                                    _filename,
                                                                    "x", "-",
                                                                    "-", "-")
                                                        //pageDashboard.fillDashboardModel("*")
                                                        pageDashboard.fillDateListModel(
                                                                    "*")
                                                        busyIndicatorFileUploading.running = false
                                                        timerSendFile.stop()
                                                    } else {
                                                        console.log("Uploading file " + _filename)
                                                        busyIndicatorFileUploading.running = true
                                                        count++
                                                        myEDDSApi.setSendFileCount(
                                                                    _filename,
                                                                    count.toString(
                                                                        ))
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
                                    height: ((parent.width > parent.height) ? parent.height / 3 : parent.width / 3)
                                    width: height
                                    running: false
                                    //running: (((myEDDSApi.readDiseaseType(imageId) == 'x') && (requestDiseaseTypeCount < 10)) ? true : false)
                                    onRunningChanged: {
                                        if (running) {
                                            imageStatus.text = "Processing..."
                                        }
                                    }
                                }

                                BusyIndicator {
                                    id: busyIndicatorFileUploading
                                    anchors {
                                        centerIn: parent
                                    }
                                    height: ((parent.width > parent.height) ? parent.height / 3 : parent.width / 3)
                                    width: height
                                    running: false
                                    onRunningChanged: {
                                        if (running) {
                                            imageStatus.text = "Uploading..."
                                        }
                                    }
                                }

                                Image {
                                    id: imageRefresh
                                    anchors {
                                        centerIn: parent
                                    }
                                    width: ((parent.width > parent.height) ? parent.height / 4 : parent.width / 4)
                                    height: width
                                    source: "/images/ic_refresh_white_48dp.png"
                                    visible: (busyIndicatorProcessing.running == false)
                                             && (myEDDSApi.isFileProcessed(
                                                     myEDDSApi.getImageFileName(
                                                         filename)) == false)
                                             && (myEDDSApi.isFileUploaded(
                                                     myEDDSApi.getImageFileName(
                                                         filename)) == true)

                                    onVisibleChanged: {
                                        if (visible) {
                                            imageStatus.text = ""
                                        }
                                    }

                                    MouseArea {
                                        anchors {
                                            fill: parent
                                        }
                                        onClicked: {
                                            imageRefresh.visible = false
                                            myEDDSApi.setRunClassifyCount(
                                                        imageId, "0")
                                            timerGetDiseaseType.start()
                                            pageDashboard.checkFileServer(
                                                        "http://" + pageSystemSetting.textFieldServerIPAddress.text + ":3009/checkFileServer")
                                        }
                                    }
                                }

                                Image {
                                    id: imagePublish
                                    anchors {
                                        centerIn: parent
                                    }
                                    width: ((parent.width > parent.height) ? parent.height / 4 : parent.width / 4)
                                    height: width
                                    source: "/images/ic_publish_white_48dp.png"
                                    visible: (myEDDSApi.isFileUploaded(
                                                  myEDDSApi.getImageFileName(
                                                      filename)) == false)
                                             && (busyIndicatorFileUploading.running == false)

                                    onVisibleChanged: {
                                        if (visible) {
                                            imageStatus.text = "Upload failed!"
                                        }
                                    }

                                    MouseArea {
                                        anchors {
                                            fill: parent
                                        }
                                        onClicked: {
                                            myEDDSApi.setSendFileCount(
                                                        filename, "0")
                                            timerSendFile.start()
                                            pageDashboard.checkFileServer(
                                                        "http://" + pageSystemSetting.textFieldServerIPAddress.text + ":3009/checkFileServer")
                                        }
                                    }
                                }

                                Text {
                                    id: imageStatus
                                    text: diseasetype
                                    font.family: fontRegular.name
                                    font.pixelSize: bodyFontSize
                                    color: "white"
                                    anchors {
                                        horizontalCenter: parent.horizontalCenter
                                        bottom: parent.bottom
                                        bottomMargin: 10
                                    }
                                }
                            }

                            //}
                        }
                    }
                }
            }
        }


        /** search bar **/
        Text {
            id: textSearchNotFound
            font.family: fontRegular.name
            font.pixelSize: bodyFontSize
            visible: false
            text: "Search found no result..."
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 80
            }
        }

        Rectangle {
            id: rectangleSeachDisease
            height: 50
            anchors {
                top: parent.top
                topMargin: 8
                left: parent.left
                leftMargin: 8
                right: parent.right
                rightMargin: 8
            }
            radius: cardRadius
            //color: "#97b498"
            ToolButton {
                id: toolbuttonMenu
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                contentItem: ImageButton {
                    imageFile: (searchResult >= 0) ? "/images/ic_arrow_back_black_48dp.png" : "/images/ic_menu_black_48dp.png"
                    //(textFieldSearchDisease.focus ? "/images/ic_arrow_back_black_48dp.png" : "/images/ic_menu_black_48dp.png")
                    onClicked: (searchResult > 0) ? clearSearchBar() : drawerMenu.drawer.open()
                }
            }

            TextField {
                id: textFieldSearchDisease
                placeholderText: "Search disease 'cryptos'..."
                font.family: fontRegular.name
                font.pixelSize: bodyFontSize
                //font.capitalization: Font.Capitalize
                //color: "black"
                color: "black"
                anchors {
                    left: toolbuttonMenu.right
                    leftMargin: 10
                    right: imageSearch.left
                    rightMargin: 5
                    verticalCenter: parent.verticalCenter
                }
            }

            Image {
                id: imageSearch
                source: "/images/ic_search_black_48dp.png"
                width: 28
                height: 28
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 5
                }
            }
        }
        DropShadow {
            anchors.fill: rectangleSeachDisease
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8
            samples: 17
            color: "#757575"
            source: rectangleSeachDisease
        }

        visible: true
    }

    ControlCenter {
        id: controlCenter
    }

    ListModel {
        id: dashboardListModel
    }

    ListModel {
        id: dateListModel
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
