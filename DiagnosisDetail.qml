import QtQuick 2.4
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
Item {
    id: diagnosisDetail
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    property alias diagnosisDetail: diagnosisDetail
    property alias source : preview.source
    property alias textDiseaseType: textDiseaseType
    property alias textDiseaseStage: textDiseaseStage
    property alias textDiseaseLevel: textDiseaseLevel

    property string imageId: ""

    property int imageListIndex: 0

    property int headerFontSize: 18
    property int bodyFontSize: 16
    property int imageSize: 28

    Rectangle{
        color: "#000000"
        anchors{
            fill: parent
        }

    Image {
        id: preview
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: parent.width
        height: parent.height
        fillMode: Image.Stretch
        smooth: true
        visible: true

        Image{
            id: imageDiagnosisDetailBack
            anchors{
                margins: 20
                left: parent.left
                top: parent.top
            }

            source: "/images/ic_arrow_back_white_48dp.png"
            width: imageSize
            height: width
            MouseArea{
                id: mouseAreaDiagnosisDetailBack
                anchors.fill: parent
                onClicked: {
                    //swipeView.interactive = true;
                    controlCenter.visible = true;
                    pageDashboard.pop();
                }
            }

            ToolTip{
                parent: mouseAreaDiagnosisDetailBack
                visible: mouseAreaDiagnosisDetailBack.pressed
                timeout: 3000
                text: "Back to Eucalyptus Disease Diagnosis System Dashboard"
            }
        }


        Column{
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
            Text{
                id: textDiseaseType
                color: "white"
                font.family: fontRegular.name
                font.pixelSize: bodyFontSize
                font.bold: true
            }
            Text{
                id: textDiseaseStage
                color: "white"
                font.family: fontRegular.name
                font.pixelSize: bodyFontSize
            }
            Text{
                id: textDiseaseLevel
                color: "white"
                font.family: fontRegular.name
                font.pixelSize: bodyFontSize
            }
        }

            Image{
                id: imageInfo
                anchors{
                    bottom: parent.bottom
                    bottomMargin: 20
                    left: parent.left
                    leftMargin: parent.width/3
                }

                source: "/images/ic_info_white_48dp.png"
                width: imageSize
                height: width
                MouseArea{
                    id: mouseAreaInfo
                    anchors.fill: parent
                    onClicked: {                        
                        info.visible = true;
                        swipeView.interactive = false;
                        pageDashboard.push(info);
                    }
                }

                ToolTip{
                    parent: mouseAreaDiagnosisDetailBack
                    visible: mouseAreaDiagnosisDetailBack.pressed
                    timeout: 3000
                    text: "Back to Eucalyptus Disease Diagnosis System Dashboard"
                }
            }

            Image{
                id: imageDelete
                anchors{
                    bottom: parent.bottom
                    bottomMargin: 20
                    left: parent.left
                    leftMargin: parent.width*2/3
                }
                source: "/images/ic_delete_white_48dp.png"
                width: imageSize
                height: width
                MouseArea{
                    id: mouseAreaDeleteImage
                    anchors.fill: parent
                    onClicked: {
                        console.log("Deleting file...");
                        messageDialogDeleteFile.open();
                        //myEDDSApi.deleteEucaImage(imageId)
                    }
                }
               }
        }

    }

    MessageDialog {
        id: messageDialogDeleteFile
        x: (Screen.primaryOrientation == Qt.LandscapeOrientation ? 30 : 5)
        y: Screen.desktopAvailableheight / 2 - 40
        width: (Screen.primaryOrientation
                == Qt.LandscapeOrientation ? Screen.desktopAvailableWidth
                                             - 60 : Screen.desktopAvailableWidth - 10)
        height: 240
        title: "Delete image file " + imageId
        text: "This operation will only delete file and its associated info from your device. File and data on server will not be affected. Proceed?"
        standardButtons: StandardButton.No | StandardButton.Yes
        modality: Qt.WindowModal
        icon: StandardIcon.Warning
        onAccepted: {
            messageDialogServerStatus.close()
        }
        Component.onCompleted: {
            visible = false
        }
        onYes: {
            console.log("Clicked YES!");
            myEDDSApi.deleteFile(myEDDSApi.getDefaultHomePath() + "/" + dashboardListView.model.get(imageListIndex).originalfilename);
            myEDDSApi.deleteFile(myEDDSApi.getDefaultHomePath() + "/" + dashboardListView.model.get(imageListIndex).filename);
            myEDDSApi.deleteEucaImage(imageId);
            pageDashboard.fillDashboardModel("*");
            pageDashboard.fillDateListModel("*");
            messageDialogDeleteFile.close();
            //swipeView.interactive = true;
            pageDashboard.pop();
        }
        onNo: {
            messageDialogDeleteFile.close();
        }
    }
}
