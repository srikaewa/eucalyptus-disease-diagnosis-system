import QtQuick 2.5
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

Item {
    id: itemDrawer
    property alias drawer: drawer
    width: 480
    height: 800
    anchors.fill: parent

    Drawer {
        id: drawer
        //width: (Screen.primaryOrientation == Qt.LandscapeOrientation ? 0.2 * itemDrawer.width : 0.66 * itemDrawer.width)
        //width: imageFarmDetail.width + textFarmDetail.width + 30
        width: 100
        height: itemDrawer.height
        dragMargin: 0
        edge: Qt.RightEdge

        Rectangle{
            id: controlPanel
            anchors{
                fill: parent
            }

            color: Qt.rgba(0,0,0,0.5)
            Column{
                anchors{
                    centerIn: parent
                }

                ImageButton{
                    id: libraryButton
                    imageFile: "/images/ic_photo_library_white_48dp.png"
                }
                ImageButton{
                    id: cameraButton
                    imageFile: "/images/ic_photo_camera_white_48dp.png"
                }

            }
        }
    }
}

