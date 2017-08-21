import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import QtQuick.Window 2.0
//import QtQuick.Controls.Styles 1.4

import EDDSApi 1.0
import FirebaseObject 1.0
import EucaImage 1.0

ApplicationWindow {
    visible: true
    width: 480
    height: 800

    property alias swipeView: swipeView
    //property alias titleLabel: titleLabel.text

    FontLoader {id: fontRegular; source: "qrc:/fonts/SuperspaceRegular.ttf"}
    FontLoader {id: fontItalic; source: "qrc:/fonts/SuperspaceLight.ttf"}

    //color: Qt.rgba(0.9,0.2,0.2,1.0)

    EDDSApi{
        id: myEDDSApi
    }

    FirebaseObject{
        id: firebaseObject
    }

    /*ControlPanel{
        id: controlPanelSlidingMenu
    }*/

    DrawerMenu{
        id: drawerMenu
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        interactive: false
        //currentIndex: tabBar.currentIndex

        PageUser{
            id:pageUser
        }

        //PageEucaDashboard{
        //    id: pageEucaDashboard
        //}

        PageDashboard{
            id: pageDashboard
        }

        //PageMainDiagnosis {
        //    id: pageMainDiagnosis
        //}

        PageSystemSetting {
            id: pageSystemSetting
        }

        onCurrentIndexChanged: {
            switch(swipeView.currentIndex)
            {
                case 0 : //titleLabel.text = "Eucalyptus Disease Diagnosis System"
                    break;
                case 1 : //titleLabel.text = "Eucalyptus Disease Diagnosis Dashboard"
                    break;
                //case 2 : titleLabel.text = "Eucalyptus Image Selection"
                //    break;
                case 2 : //titleLabel.text = "System Setting"
                    break;
            }
        }
    }

    /*PageIndicator {
        count: 3
        currentIndex: swipeView.currentIndex
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
    }*/

/*    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton{
            text: qsTr("Disease Gallery")
        }

        TabButton {
            text: qsTr("Disease Diagnosis")
        }
        TabButton {
            text: qsTr("Settings")
        }
    }*/
}
