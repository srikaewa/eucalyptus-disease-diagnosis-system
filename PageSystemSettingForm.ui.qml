import QtQuick 2.4
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

StackView {
    property alias textFieldServerIPAddress: textFieldServerIPAddress
    property alias textFieldServerPort: textFieldServerPort
    property alias textServerStatus: textServerStatus
    property alias flickableSetting: flickableSetting

    property alias deviceScreenWidth: textScreenWidth.text
    property alias deviceScreenHeight: textScreenHeight.text
    property alias devicePixelRatio: textDevicePixelRatio.text

    width: Screen.availableDesktopWidth * Screen.devicePixelRatio
    height: Screen.availableDesktopHeight * Screen.devicePixelRatio

    Settings {
        property alias serverIPAddress: textFieldServerIPAddress.text
        property alias serverIPPort: textFieldServerPort.text
    }

    initialItem: mainView

    Item {
        id: editServerStack
        EditServer {
            id: editServer
            visible: false
        }
    }

    Item {
        id: mainView

        Rectangle {
            id: rectangleSettingHeader
            width: parent.width - 16
            height: 50
            anchors {
                left: parent.left
                leftMargin: 8
                top: parent.top
                topMargin: 8
            }
            radius: 2

            ToolButton {
                id: toolbuttonSettingBack
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                contentItem: ImageButton {
                    imageFile: "/images/ic_arrow_back_black_48dp.png"
                    //(textFieldSearchDisease.focus ? "/images/ic_arrow_back_black_48dp.png" : "/images/ic_menu_black_48dp.png")
                    onClicked: swipeView.setCurrentIndex(1)
                }
            }

            Label {
                anchors.centerIn: parent
                text: "Settings"
                font.family: fontRegular.name
                font.pixelSize: 20
                font.bold: true
            }
        }
        DropShadow {
            anchors.fill: rectangleSettingHeader
            horizontalOffset: 2
            verticalOffset: 2
            radius: 5
            samples: 17
            color: "#80000000"
            source: rectangleSettingHeader
        }

        Flickable {
            id: flickableSetting
            anchors.top: rectangleSettingHeader.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            contentHeight: serverSetting.height + screenSetting.height + 30
            clip: true

            ColumnLayout {
                id: serverSetting
                Text {
                    text: "Server"
                    font.family: fontRegular.name
                    font.pixelSize: 18
                    font.bold: true
                }
                ColumnLayout {
                    spacing: 22
                    Text {
                        text: "IP address "
                        font.family: fontRegular.name
                        font.pixelSize: 18
                        Text {
                            id: textFieldServerIPAddress
                            anchors {
                                top: parent.bottom
                            }
                            text: "192.168.0.21"
                            //placeholderText: "xx.xx.xx.xx"
                            font.family: fontRegular.name
                            font.pixelSize: 16
                            color: "#5d99c6"
                        }
                        MouseArea {
                            id: mouseAreaEditServer
                            anchors.fill: parent
                            onClicked: {
                                swipeView.interactive = false
                                editServer.textFieldServerIPAddress.text
                                        = textFieldServerIPAddress.text
                                editServer.textFieldServerPort.text = textFieldServerPort.text
                                pageSystemSetting.push(editServer)
                            }
                        }
                    }

                    Text {
                        text: "Port "
                        font.family: fontRegular.name
                        font.pixelSize: 18
                        Text {
                            id: textFieldServerPort
                            anchors {
                                top: parent.bottom
                            }
                            //placeholderText: "3009"
                            text: "3009"
                            font.family: fontRegular.name
                            font.pixelSize: 16
                            color: "#5d99c6"
                        }
                        MouseArea {
                            id: mouseAreaEditServerPort
                            anchors.fill: parent
                            onClicked: {
                                swipeView.interactive = false
                                editServer.textFieldServerIPAddress.text
                                        = textFieldServerIPAddress.text
                                editServer.textFieldServerPort.text = textFieldServerPort.text
                                pageSystemSetting.push(editServer)
                            }
                        }
                    }

                    Text {
                        text: "Status "
                        font.family: fontRegular.name
                        font.pixelSize: 18
                        Text {
                            anchors {
                                top: parent.bottom
                            }
                            id: textServerStatus
                            text: ""
                            font.family: fontRegular.name
                            font.pixelSize: 16
                        }
                    }
                }
            }

            ColumnLayout {
                id: screenSetting
                anchors.top: serverSetting.bottom
                anchors.topMargin: 30
                Text {
                    text: "Screen"
                    font.family: fontRegular.name
                    font.pixelSize: 18
                    font.bold: true
                }
                ColumnLayout {
                    spacing: 22
                    Text {
                        text: "Resolution"
                        font.family: fontRegular.name
                        font.pixelSize: 18
                        Text {
                            anchors {
                                top: parent.bottom
                            }
                            text: Screen.width + "x" + Screen.height
                            font.family: fontRegular.name
                            font.pixelSize: 16
                            color: "#757575"
                        }
                    }

                    Text {
                        text: "Orientation"
                        font.family: fontRegular.name
                        font.pixelSize: 18
                        Text {
                            anchors {
                                top: parent.bottom
                            }
                            color: "#757575"
                            text: (Screen.primaryOrientation
                                   == Qt.LandscapeOrientation ? "Landscape" : "Portrait")
                            font.family: fontRegular.name
                            font.pixelSize: 16
                        }
                    }

                    Text {
                        text: "Actual Resolution"
                        font.family: fontRegular.name
                        font.pixelSize: 18
                        Text {
                            id: textScreenWidth
                            anchors {
                                top: parent.bottom
                            }
                            color: "#757575"
                            text: screenPixelWidth + "x" + screenPixelHeight
                            font.family: fontRegular.name
                            font.pixelSize: 16
                        }
                    }

                    Text {
                        text: "Physical Dimension"
                        font.family: fontRegular.name
                        font.pixelSize: 18
                        Text {
                            id: textScreenHeight
                            anchors {
                                top: parent.bottom
                            }
                            color: "#757575"
                            text: screenInchWidth.toFixed(1) + "x" + screenInchHeight.toFixed(1) + " (inch x inch)"
                            font.family: fontRegular.name
                            font.pixelSize: 16
                        }
                    }

                    Text {
                        id: textDevicePixelRatio
                        text: "Pixel ratio"
                        font.family: fontRegular.name
                        font.pixelSize: 18
                        Text {
                            anchors {
                                top: parent.bottom
                            }
                            color: "#757575"
                            text: Screen.devicePixelRatio
                            font.family: fontRegular.name
                            font.pixelSize: 16
                        }
                    }

                    Text {
                        text: "Pixel density"
                        font.family: fontRegular.name
                        font.pixelSize: 18
                        Text {
                            id: textPixelDensity
                            anchors {
                                top: parent.bottom
                            }
                            color: "#757575"
                            text: Screen.pixelDensity
                            font.family: fontRegular.name
                            font.pixelSize: 16
                        }
                    }

                    Text {
                        text: "Diagonal"
                        font.family: fontRegular.name
                        font.pixelSize: 18
                        Text {
                            id: textDiagonal
                            anchors {
                                top: parent.bottom
                            }
                            color: "#757575"
                            text: screenDiagonal.toFixed(1) + " (inch)"
                            font.family: fontRegular.name
                            font.pixelSize: 16
                        }
                    }
                }
            }

            ColumnLayout {
                id: softwareSetting
                anchors.top: screenSetting.bottom
                anchors.topMargin: 30
                Text {
                    text: "Software"
                    font.family: fontRegular.name
                    font.pixelSize: 18
                    font.bold: true
                }
                ColumnLayout {
                    spacing: 22
                    Text {
                        text: "Build number"
                        font.family: fontRegular.name
                        font.pixelSize: 18
                        Text {
                            anchors {
                                top: parent.bottom
                            }
                            text: myEDDSApi.getBuildNumber();
                            font.family: fontRegular.name
                            font.pixelSize: 16
                            color: "#757575"
                        }
                    }
               }
            }

        }
    }
}
