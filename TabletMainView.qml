import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    Component.onCompleted: {
        console.log("TabletMainView onComplete!!!");
        console.log("Get disease list -> " + viewDashboard.diseaseList);
    }

    property alias cardViewHeight: gridLayoutCardView.height

    GridLayout{
        id: gridLayoutCardView
        anchors{
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 110
        }

        columns: 2
        columnSpacing: 30
        rowSpacing: 20

        Rectangle {
            id: mainCard
            width: cardWidth
            height: 240
            Layout.preferredWidth: width
            radius: cardRadius
            color: cardColor

            Rectangle{
                id: mainCardHeader
                width: parent.width
                height: 50
                color: Qt.rgba(1,1,1,0)

                Image{
                    id: iconHeadMain
                    source: "/images/ic_dashboard_black_48dp.png"
                    width: 20
                    height: 20
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 10
                    }
                }

                Label{
                    id: mainCardHeaderLabel
                    text: "Diagnosis Summary"
                    font.family: fontRegular.name
                    font.pixelSize: bodyFontSize
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: iconHeadMain.right
                        leftMargin: 10
                    }
                }

                Image{
                    source: "/images/ic_more_vert_black_48dp.png"
                    width: 20
                    height: 20
                    anchors{
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 10
                    }
                }

            }


        }

        Repeater{
            model: viewDashboard.diseaseList
            Rectangle {
                id: firstCard
                width: cardWidth
                height: 240
                Layout.preferredWidth: width
                radius: cardRadius
                color: cardColor

                Rectangle{
                    id: firstCardHeader
                    width: parent.width
                    height: 50
                    color: Qt.rgba(1,1,1,0)

                    Image{
                        id: iconHead
                        source: "/images/ic_assessment_black_48dp.png"
                        width: 20
                        height: 20
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 10
                        }
                    }

                    Label{
                        id: firstCardHeaderLabel
                        text: modelData
                        font.family: fontRegular.name
                        font.pixelSize: bodyFontSize
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: iconHead.right
                            leftMargin: 10
                        }
                    }

                    Image{
                        source: "/images/ic_more_vert_black_48dp.png"
                        width: 20
                        height: 20
                        anchors{
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                            rightMargin: 10
                        }
                    }
                }
            }

        }

        /*Rectangle {
            id: secondCard
            width: cardWidth
            height: 240
            Layout.preferredWidth: width
            color: cardColor
            radius: cardRadius
        }*/
  }
}
