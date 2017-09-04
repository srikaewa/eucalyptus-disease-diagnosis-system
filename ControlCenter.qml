import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

import EDDSApi 1.0

Item {
    property alias fileGallery: fileGallery
    property alias cameraButton: cameraButton
    width: parent.width
    height: 70
    anchors{
        bottom: parent.bottom
    }

    EDDSApi{
        id: fileGallery
    }

    Rectangle{
        id: controlPanel
        anchors{
            fill: parent
        }

        color: "white"
        Row{
            anchors{
                centerIn: parent
            }

            ImageButton{
                id: libraryButton
                imageFile: "/images/ic_photo_library_black_48dp.png"
                onClicked: {
                    fileGallery.buscaImagem()
                }
                ToolTip{
                    parent: libraryButton
                    text: "Select image for diagnosis..."
                    visible: libraryButton.mouseRegion.pressed
                    timeout: 3000
                }
            }
            ImageButton{
                id: cameraButton
                imageFile: "/images/ic_photo_camera_black_48dp.png"
            }

        }
    }
    DropShadow {
        anchors.fill: controlPanel
        horizontalOffset: 0
        verticalOffset: 1
        radius: 8
        samples: 17
        color: "#757575"
        source: controlPanel
    }

}
