import QtQuick 2.0
import QtMultimedia 5.5
import QtQuick.Controls 2.1
import QtPositioning 5.8
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3

Item {
    property alias shutterButton: shutterButton
    property alias camera: camera

    property int headerFontSize: 18
    property int bodyFontSize: 16
    property int imageSize: 28

    anchors.fill: parent

    PositionSource {
        id: gpsCameraPosition
        //preferredPositioningMethods: PositionSource.SatellitePositioningMethods
        preferredPositioningMethods: PositionSource.AllPositioningMethods
        active: true
        updateInterval: 2000 // ms
    }

    Camera{
        id: camera
        captureMode: Camera.CaptureStillImage
    }

    VideoOutput {
        id: viewFinder
        source: camera
        anchors.fill: parent
        focus : visible // to receive focus and capture key events when visible
        fillMode: VideoOutput.Stretch
        autoOrientation: true
    }

    Image{
        id: imageCameraPreviewBack
        anchors{
            margins: 20
            left: parent.left
            top: parent.top
        }

        source: "/images/ic_arrow_back_white_48dp.png"
        width: imageSize
        height: width
        MouseArea{
            id: mouseAreaCameraPreviewBack
            anchors.fill: parent
            onClicked: {
                //swipeView.interactive = true;
                pageDashboard.pop();
            }
        }

        ToolTip{
            parent: mouseAreaCameraPreviewBack
            visible: mouseAreaCameraPreviewBack.pressed
            text: "Back to Eucalyptus Disease Diagnosis Dashboard"
        }
    }

    GridLayout{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        columns: 2
        Text{
            text: "Latitude: "
            color: "white"
            font.family: fontRegular.name
            font.pixelSize: bodyFontSize
        }

        Text{
            id: textLatitude
            text: gpsCameraPosition.position.coordinate.latitude
            color: "white"
            font.family: fontRegular.name
            font.pixelSize: bodyFontSize
        }
        Text{
            text: "Longitude: "
            color: "white"
            font.family: fontRegular.name
            font.pixelSize: bodyFontSize
        }
        Text{
            id: textLongitude
            text: gpsCameraPosition.position.coordinate.longitude
            color: "white"
            font.family: fontRegular.name
            font.pixelSize: bodyFontSize
        }

    }

    ImageButton{
        id: shutterButton
        anchors{
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 30
        }

        imageFile: "/images/ic_camera_white_48dp.png"
    }
}
