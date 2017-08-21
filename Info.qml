import QtQuick 2.4
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtPositioning 5.8
import QtLocation 5.9

Item {
    id: infoPage
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    property alias infoPage: infoPage
    property alias textLastedit: textLastedit
    property alias textFilename: textFilename
    property alias textDescription: textDescription
    property alias textInfoLatitude: textInfoLatitude
    property alias textInfoLongitude: textInfoLongitude
    property alias textServerInfo: textServerInfo
    property alias textElapseTime: textElapseTime
    property alias imageOriginalSource: imageOriginal.source
    property alias imageDiseaseMaskSource: imageDiseaseMask.source

    property int headerFontSize: 18
    property int bodyFontSize: 16
    property int imageSize: 28
    property int imagePreviewSize: 160

    Image{
        id: imageInfoBack
        anchors{
            margins: 20
            left: parent.left
            top: parent.top
        }

        source: "/images/ic_arrow_back_black_48dp.png"
        width: imageSize
        height: width
        MouseArea{
            id: mouseAreaInfoBack
            anchors.fill: parent
            onClicked: {
                pageDashboard.pop();
            }
        }

        Text {
            anchors{
                left: parent.right
                leftMargin: 20
                verticalCenter: parent.verticalCenter
            }
            font.family: fontRegular.name
            font.pixelSize: headerFontSize
            text: "Disease Info"
        }

/*        ToolTip{
            parent: mouseAreaInfoBack
            visible: mouseAreaInfoBack.pressed
            timeout: 3000
            text: "Back to Eucalyptus Disease Diagnosis System Dashboard"
        } */
    }

    /*Plugin {
        id: mapInfoPlugin
        name: "here"
        PluginParameter {
            name: "here.app_id"
            value: "CD5ZNcUPxSCd4eu9Ipt5"
        }
        PluginParameter {
            name: "here.token"
            value: "80gzJuzovEcRTBGgxXXSKw"
        }
    }*/

    Flickable {
        boundsBehavior: Flickable.DragAndOvershootBounds
        clip: true
        anchors{
            top: parent.top
            topMargin: 60
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentWidth: parent.width
        contentHeight: gridLayoutInfo.height

        GridLayout{
            id: gridLayoutInfo
            columns: 2
            columnSpacing: 30
            rowSpacing: 20

            Text{
                id: textOriginalFilename
                anchors{
                    left: parent.left
                    leftMargin: 20
                }

                font.family: fontRegular.name
                font.pixelSize: bodyFontSize
                text: "Images"
                color: "#757575"
                Layout.columnSpan: 2
            }
            RowLayout
            {
                Layout.columnSpan: 2
                Layout.leftMargin: 30
                Image{
                    id: imageOriginal
                    width: imagePreviewSize
                    height: imagePreviewSize
                    sourceSize.width: width
                    sourceSize.height: height
                    fillMode: Image.PreserveAspectCrop
                    Layout.preferredWidth: imagePreviewSize
                    Layout.preferredHeight: imagePreviewSize
                    asynchronous: true
                    smooth: true
                    visible: true
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            diagnosisDetail.source = imageOriginal.source;
                            pageDashboard.pop();
                        }
                    }
                }
                Image{
                    id: imageDiseaseMask
                    width: imagePreviewSize
                    height: imagePreviewSize
                    sourceSize.width: width
                    sourceSize.height: height
                    fillMode: Image.PreserveAspectCrop
                    Layout.preferredWidth: imagePreviewSize
                    Layout.preferredHeight: imagePreviewSize
                    asynchronous: true
                    smooth: true
                    visible: true
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            diagnosisDetail.source = imageDiseaseMask.source;
                            pageDashboard.pop();
                        }
                    }
                }
            }
            Text{
                id: textDetails
                anchors{
                    left: parent.left
                    leftMargin: 15
                }

                font.family: fontRegular.name
                font.pixelSize: bodyFontSize
                text: "Details"
                color: "#757575"
                Layout.columnSpan: 2
            }

            Image{
                    source: "/images/ic_description_black_48dp.png"
                    width: imageSize
                    height: width
                    Layout.preferredWidth: imageSize
                    Layout.preferredHeight: imageSize
                    Layout.alignment: Qt.AlignCenter
                    Layout.leftMargin: 30
                }
            Text{
                    id: textDescription
                    font.family: fontRegular.name
                    font.pixelSize: bodyFontSize
                    color: "#757575"
                    Layout.fillWidth: true
                }

            Image{
                    source: "/images/ic_today_black_48dp.png"
                    width: imageSize
                    height: width
                    Layout.preferredWidth: imageSize
                    Layout.preferredHeight: imageSize
                    Layout.alignment: Qt.AlignCenter
                    Layout.leftMargin: 30
                }
            Text{
                    id: textLastedit
                    font.family: fontRegular.name
                    font.pixelSize: bodyFontSize
                    color: "#757575"
                    Layout.fillWidth: true
                }

            Image{
                    source: "/images/ic_image_black_48dp.png"
                    width: imageSize
                    height: width
                    Layout.preferredWidth: imageSize
                    Layout.preferredHeight: imageSize
                    Layout.alignment: Qt.AlignCenter
                    Layout.leftMargin: 30
                }
            Text{
                    id: textFilename
                    font.family: fontRegular.name
                    font.pixelSize: bodyFontSize
                    color: "#757575"
                    Layout.fillWidth: true                    
                }

            Image{
                    source: "/images/ic_satellite_black_48dp.png"
                    width: imageSize
                    height: width
                    Layout.preferredWidth: imageSize
                    Layout.preferredHeight: imageSize
                    Layout.alignment: Qt.AlignCenter
                    Layout.leftMargin: 30
                }
            Text{
                    id: textServerInfo
                    font.family: fontRegular.name
                    font.pixelSize: bodyFontSize
                    color: "#757575"
                    Layout.fillWidth: true
                }
            Image{
                    source: "/images/ic_update_black_48dp.png"
                    width: imageSize
                    height: width
                    Layout.preferredWidth: imageSize
                    Layout.preferredHeight: imageSize
                    Layout.alignment: Qt.AlignCenter
                    Layout.leftMargin: 30
                }
            Text{
                    id: textElapseTime
                    font.family: fontRegular.name
                    font.pixelSize: bodyFontSize
                    color: "#757575"
                    Layout.fillWidth: true
                }

            Image{
                    id: imageInfoLocation
                    source: "/images/ic_place_black_48dp.png"
                    width: imageSize
                    height: width

                    Layout.preferredWidth: imageSize
                    Layout.preferredHeight: imageSize
                    Layout.alignment: Qt.AlignCenter
                    Layout.leftMargin: 30
                }
            RowLayout{
                Layout.fillWidth: true
                Text{
                        id: textInfoLatitude
                        font.family: fontRegular.name
                        font.pixelSize: bodyFontSize
                        color: "#757575"
                    }
                Text{
                    font.family: fontRegular.name
                    font.pixelSize: bodyFontSize
                    color: "#757575"
                    text: ", "
                }
                Text{
                        id: textInfoLongitude
                        font.family: fontRegular.name
                        font.pixelSize: bodyFontSize
                        color: "#757575"
                    }
            }

            Map {
                id: hereInfoMap

                width: Screen.desktopAvailableWidth
                height: Screen.desktopAvailableHeight

                Layout.columnSpan: 2
                Layout.fillWidth: true

                //color: Qt.rgba(0, 0, 0, 1)

                copyrightsVisible: true
                activeMapType: supportedMapTypes[8]
                visible: true

                plugin: mapPlugin

                center: QtPositioning.coordinate(textInfoLatitude.text, textInfoLongitude.text)

                zoomLevel: (hereInfoMap.maximumZoomLevel + hereInfoMap.minimumZoomLevel) / 2

                gesture.enabled: false
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

                    coordinate: QtPositioning.coordinate(textInfoLatitude.text, textInfoLongitude.text)
                } */

                MapQuickItem {
                    id: marker
                    anchorPoint.x: imageMarker.width / 2
                    anchorPoint.y: imageMarker.height

                    sourceItem: Image {
                        id: imageMarker
                        source: "/images/red-location-map-pin-icon-5.png"
                    }

                    coordinate: hereInfoMap.center
                }
                MouseArea {
                    id: mouseAreaInfoMap
                    anchors.fill: parent
                }

            }

            }
    }
}
