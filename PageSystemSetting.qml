import QtQuick 2.4
import QtQuick.Controls 2.2

PageSystemSettingForm {
    property bool pullDown: false

    /*textFieldServerIPAddress.onAccepted: {
        console.log("IP address changed -> " + textFieldServerIPAddress.text)
        pageDashboard.checkFileServer("http://" + textFieldServerIPAddress.text + ":3009/checkFileServer")
    }*/

    Component.onCompleted: {
        pageDashboard.checkFileServer("http://" + textFieldServerIPAddress.text + ":" + textFieldServerPort.text + "/checkFileServer")
    }

    flickableSetting.onContentYChanged:
    {
        //console.log("flickable content y change -> " + flickableSetting.contentY);

        if(pullDown)
        {
            if(flickableSetting.contentY == 0)
            {
                pageDashboard.checkFileServer("http://" + textFieldServerIPAddress.text + ":" + textFieldServerPort.text + "/checkFileServer")
                pullDown = false;
            }
        }
        else
        {
            if(flickableSetting.contentY < -50)
            {
                pullDown = true;
            }
        }
    }

}

