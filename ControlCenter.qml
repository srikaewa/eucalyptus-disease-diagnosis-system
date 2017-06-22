import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Window 2.0

import EDDSApi 1.0

Item {
    property alias fileGallery: fileGallery
    property alias cameraButton: cameraButton
    width: 90
    height: parent.height
    anchors{
        right: parent.right
    }

    EDDSApi{
        id: fileGallery
    }

    Rectangle{
        id: controlPanel
        anchors{
            fill: parent
        }

        color: Qt.rgba(0,0,0,0)
        Column{
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

}
