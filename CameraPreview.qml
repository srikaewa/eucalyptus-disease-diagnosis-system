import QtQuick 2.0
import QtMultimedia 5.5
import QtQuick.Controls 2.1


Item {
    property alias shutterButton: shutterButton
    property alias camera: camera

    anchors.fill: parent

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
            margins: 10
            left: parent.left
            top: parent.top
        }

        source: "/images/ic_arrow_back_white_48dp.png"
        width: 36
        height: width
        MouseArea{
            id: mouseAreaCameraPreviewBack
            anchors.fill: parent
            onClicked: {
                pageDashboard.pop();
            }
        }

        ToolTip{
            parent: mouseAreaCameraPreviewBack
            visible: mouseAreaCameraPreviewBack.pressed
            text: "Back to Eucalyptus Disease Diagnosis Dashboard"
        }
    }

    ImageButton{
        id: shutterButton
        anchors{
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 70
        }

        imageFile: "/images/ic_camera_white_48dp.png"
    }
}
