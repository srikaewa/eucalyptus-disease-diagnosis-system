import QtQuick 2.5
import QtQuick.Controls 2.1
import QtMultimedia 5.8
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import Qt.labs.folderlistmodel 2.1

// "/storage/emulated/0/DCIM/IMG_00000104.jpg"

StackView {
    id: pageMainDiagnosis
    width: 480
    height: 800
    //property alias pageMainDiagnosis: pageMainDiagnosis
    property alias folderModel: folderModel
    property alias imageDelegate: imageDelegate
    property alias imageListView: imageListView
    property alias loaderPhotoPreview: loaderPhotoPreview

    initialItem:  mainView

    Item{
        id: photoPreviewStack
        PhotoPreview{
            id: photoPreview
            visible: false
        }
    }

    Item{
        id: mainView
        Image{
            id: imageDisplay
            anchors{
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 10
            }
            width: parent.width
            height: parent.height - imageListView.height - 24
            //height: (Screen.desktopAvailableWidth > Screen.desktopAvailableHeight ? (Screen.desktopAvailableHeight - headerToolbar.height - imageListView.height) * 0.85 : (Screen.desktopAvailableHeight - headerToolbar.height - imageListView.height) * 0.5)
            sourceSize.width: width
            sourceSize.height: height
            //sourceSize.width: width
            fillMode: Image.PreserveAspectFit

            //MouseArea{
            //    anchors.fill: parent
            //    onClicked: {

                    //photoPreview.submitMode = 1
                    //stillControls.previewAvailable = true
                    //photoPreview.submitPanel = "visible"
                    //cameraUI.state = "PhotoPreview"
                    //textTitle.text = "ปรับแต่งภาพ/ส่งภาพเพื่อประมวลผล/ยกเลิก"
            //    }
            //    ToolTip.text: "แตะปุ่มด้านล่างเพื่อเตรียมส่งรูปไปประมวลผล"
            //    ToolTip.visible: pressed
            //}
            Text {
                id: textSelection
                anchors{
                    top: parent.top
                    topMargin: 10
                    left: parent.left
                    leftMargin: 10
                }
                font.family: fontRegular.name
                font.pixelSize: 18
                //myEDDSApi.getDefaultImagePath()
                color: "white"
            }

            Loader {
                   id: loaderPhotoPreview
                   asynchronous: true
                   visible: status == Loader.Ready
                }

            Image{
                id: publishImage
                anchors{
                    centerIn: parent
                }
                source: "/images/ic_publish_white_48dp.png"
                width: 36
                height: width
                MouseArea{
                    id: mouseAreaPublishImage
                    anchors.fill: parent
                    onClicked: {
                        photoPreview.visible = true;
                        //photoPreview.source = "file://"+myEDDSApi.getDefaultImagePath()+"/"+textSelection.text;
                        photoPreview.source = "file:///storage/emulated/0/DCIM/"+textSelection.text;
                        photoPreview.previewCanvas.clear_canvas();
                        //console.log("File to display -> " + photoPreview.source)
                        swipeView.interactive = false;
                        pageMainDiagnosis.push(photoPreviewStack);
                        //console.log("Stack depth -> " + pageMainDiagnosis.depth)
                    }
                    ToolTip{
                        parent: mouseAreaPublishImage
                        text: "Select image for diagnosis..."
                        visible: mouseAreaPublishImage.pressed
                    }
                }

            }
        }

    ListView {
        id: imageListView
        clip: true
        height: 200
        width: parent.with
        anchors{
            bottom: parent.bottom
            bottomMargin: 5
            left: parent.left
            leftMargin: 5
            right: parent.right
            rightMargin: 5
        }

        Component {
            id: imageDelegate

                Image {
                    id: name
                    //source: "file://"+myEDDSApi.getDefaultImagePath()+"/"+fileName
                    source: "file:///storage/emulated/0/DCIM/"+fileName
                    width: 200
                    height: 200
                    sourceSize.width: width
                    sourceSize.height: height
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true

                    /*Text{
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        text: fileName
                        color: "white"
                        font.family: fontRegular.name
                        font.pixelSize: 16
                    }*/

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            //console.log("File name -> " + fileName);
                            imageListView.currentIndex = index
                        }
                    }
                }
        }

        FolderListModel {
            id: folderModel
            nameFilters: [ "*.jpg", "*.JPG" ]
            //folder: "file://" + myEDDSApi.getDefaultImagePath()
            folder: "file:///storage/emulated/0/DCIM/"
            sortField: FolderListModel.Name
        }

        model: folderModel
        delegate: imageDelegate
        orientation: ListView.Horizontal
        snapMode: ListView.SnapToItem

        onCurrentIndexChanged: {
            //console.log("View currentIndex = "+ currentIndex);
            textSelection.text = folderModel.get(currentIndex,"fileName");
            //imageDisplay.source = "file://"+myEDDSApi.getDefaultImagePath()+"/"+textSelection.text;
            imageDisplay.source = "file:///storage/emulated/0/DCIM/"+textSelection.text;
        }
    }
    }

}
