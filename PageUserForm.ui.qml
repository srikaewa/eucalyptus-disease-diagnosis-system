import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.1
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
//import QtGraphicalEffects 1.0


//import QtGraphicalEffects 1.0
Item {
    id: pageUserForm
    width: 480
    height: 800
    property alias pageUserForm: pageUserForm
    property alias buttonSignIn: buttonSignIn
    property alias buttonSignUp: buttonSignUp
    property alias labelUserLoginStatus: labelUserLoginStatus
    property alias busyIndicatorUserLogin: busyIndicatorUserLogin
    //property alias textFieldFirstName: textFieldFirstName
    //property alias textFieldLastName: textFieldLastName
    //property alias textFieldOrganization: textFieldOrganization
    property alias textFieldEmail: textFieldEmail
    property alias textFieldPassword: textFieldPassword
    property alias buttonRememberSignIn: buttonRememberSignIn

    Settings{
        property alias rememberSignedIn: buttonRememberSignIn.checked
        property alias userEmail: textFieldEmail.text
        property alias userPassword: textFieldPassword.text
        //property alias userFirstName: textFieldFirstName.text
        //property alias userLastName: textFieldLastName.text
        //property alias userOrganization: textFieldOrganization.text
    }

    Rectangle{
        anchors.fill: parent
        color: Qt.rgba(1,1,1,1)

    Flickable{
        id: flickableUserForm
        width: parent.width
        height: parent.height
        flickableDirection: Flickable.VerticalFlick
        contentHeight: columnWrapper.height * 1.2

        ColumnLayout{
            id: columnWrapper
            spacing: 20
            anchors{
                centerIn: parent
            }

            //anchors{
                //horizontalCenter: parent.horizontalCenter
                //verticalCenter: parent.verticalCenter
            //    margins: 20
            //    horizontalCenter: parent.horizontalCenter
            //}

            Row{
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Image{
                    source: "/images/SUANKITTI.png"
                    height: 120
                    width: 240
                    fillMode: Image.PreserveAspectFit
                }
                Image{
                    source: "/images/EUTECH.png"
                    height: 120
                    width: 240
                    fillMode: Image.PreserveAspectFit
                }
            }

            Label {
                id: label
                width: parent.width
                height: 30
                text: qsTr("EUCALYPTUS DISEASE DIAGNOSIS SYSTEM\n")
                font.family: fontRegular.name
                font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
            /*RowLayout{
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Label{
                    text: "First Name "
                    font.family: fontRegular.name
                    font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                    font.bold: true
                }

                TextField {
                    id: textFieldFirstName
                    height: 40
                    text: qsTr("")
                    placeholderText: "กรอกชื่อที่นี่..."
                    font.family: fontRegular.name
                    font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                    Layout.minimumWidth: 380
                }

            }
            RowLayout{
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Label{
                    text: "Last Name "
                    font.family: fontRegular.name
                    font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                    font.bold: true
                }

                TextField {
                    id: textFieldLastName
                    height: 40
                    text: qsTr("")
                    placeholderText: "กรอกนามสกุลที่นี่..."
                    font.family: fontRegular.name
                    font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                    Layout.minimumWidth: 380
                }

            }
            RowLayout{
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Label{
                    text: "Organization "
                    font.family: fontRegular.name
                    font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                    font.bold: true
                }

                TextField {
                    id: textFieldOrganization
                    height: 40
                    text: qsTr("")
                    placeholderText: "กรอกชื่อหน่วยงานที่นี่..."
                    font.family: fontRegular.name
                    font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                    Layout.minimumWidth: 380
                }
            } */

                //Label{
                //    id: labelUsername
                //    text: "Username "
                //    font.family: fontRegular.name
                //    font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                //    font.bold: true
               // }

                RowLayout{
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    Image{
                        id: imageEmail
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        source: "/images/ic_email_black_48dp.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    TextField {
                        id: textFieldEmail
                        width: parent.width
                        height: 40
                        text: qsTr("")
                        placeholderText: "Email"
                        font.family: fontRegular.name
                        font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                        Layout.minimumWidth: 380
                        Layout.fillWidth: true
                    }
                }


                //Label{
                //    text: "Password "
                //    font.family: fontRegular.name
                //    font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                //    font.bold: true
                //}

                RowLayout{
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    Image{
                        id: imageLock
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        source: "/images/ic_lock_black_48dp.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    TextField {
                        id: textFieldPassword
                        width: parent.width
                        height: 40
                        text: qsTr("")
                        placeholderText: "Password..."
                        echoMode: TextInput.Password
                        font.family: fontRegular.name
                        font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                        Layout.minimumWidth: 380
                        Layout.fillWidth: true
                    }
                }

            RowLayout{
                Layout.alignment: Qt.AlignHCenter
                Button {
                    id: buttonSignIn
                    width: 134
                    height: 40
                    text: "Sign In"
                    font.family: fontRegular.name
                    font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                    flat: true
                }

                Label{
                    text: "       "
                }

                Button {
                    id: buttonSignUp
                    width: 134
                    height: 40
                    text: "Sign Up"
                    font.family: fontRegular.name
                    font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                    flat: true
                }
                Label{
                    text: "       "
                }
                Button{
                    id: buttonRememberSignIn
                    width: 134
                    height: 40
                    text: "Remember me"
                    font.family: fontRegular.name
                    font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                    flat: true
                    checkable: true
                    checked: false
                    enabled: false
                }
            }

            Label {
                id: labelUserLoginStatus
                text: "Please sign in to begin using app..."
                font.family: fontRegular.name
                font.italic: true;
                font.pixelSize: (Screen.primaryOrientation == Qt.LandscapeOrientation ? flickableUserForm.height * 0.04 : flickableUserForm.height * 0.02)
                Layout.alignment: Qt.AlignHCenter
            }

            Label{
                text: "\n\n\n\n"
            }
        }
    }
    }
    BusyIndicator {
        id: busyIndicatorUserLogin
        width: parent.height / 8
        height: parent.height / 8
        anchors.centerIn: parent
        running: false
        //visible: false
    }
}
