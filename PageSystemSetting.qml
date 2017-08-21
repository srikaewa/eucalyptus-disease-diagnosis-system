import QtQuick 2.4
import QtQuick.Controls 2.2

PageSystemSettingForm {

    /*textFieldServerIPAddress.onAccepted: {
        console.log("IP address changed -> " + textFieldServerIPAddress.text)
        pageDashboard.checkFileServer("http://" + textFieldServerIPAddress.text + ":3009/checkFileServer")
    }*/

    Component.onCompleted: {
        pageDashboard.checkFileServer("http://" + textFieldServerIPAddress.text + ":" + textFieldServerPort.text + "/checkFileServer")
    }

    flickableSetting.onContentYChanged:
    {
        //console.log("flickable content y change -> " + flickableToday.contentY);
        if(flickableSetting.contentY < -100)
        {
            //busyIndicatorWateringUpdate.running = true;
            pageDashboard.checkFileServer("http://" + textFieldServerIPAddress.text + ":" + textFieldServerPort.text + "/checkFileServer")
            //busyIndicatorWateringUpdate.running = false;
            //console.log("Today page updated!");
        }
    }

}

