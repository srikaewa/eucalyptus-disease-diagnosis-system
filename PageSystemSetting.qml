import QtQuick 2.4
import QtQuick.Controls 2.2

PageSystemSettingForm {

    textFieldServerIPAddress.onAccepted: {
        console.log("IP address changed -> " + textFieldServerIPAddress.text)
        pageDashboard.checkFileServer("http://" + textFieldServerIPAddress.text + ":3009/checkFileServer")
    }

}
