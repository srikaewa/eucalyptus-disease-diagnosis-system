import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Window 2.0
import QtPositioning 5.8

PageDashboardForm {    
    signal imageIdRecieved(string imageId, string filename)
    signal serverFileRunning(string status)

    property bool pullDown: false

    Component.onCompleted: {
        //fillDashboardModel("*");
        //fillDateListModel("*");
    }

    /*mouseAreaMap.onClicked: {
        console.log("Mouse X:Y ->"+ mouseAreaMap.mouseX + ":" + mouseAreaMap.mouseY);
        hereMap.center = hereMap.toCoordinate(Qt.point(mouseAreaMap.mouseX,mouseAreaMap.mouseY))
    }*/

    /*mouseAreaMap.onDoubleClicked: {
        hereMap.center = QtPositioning.coordinate(gpsPosition.position.coordinate.latitude,gpsPosition.position.coordinate.longitude)
        console.log('Map type -> ' + hereMap.supportedMapTypes[0])
    }*/

    /*dateListView.onContentYChanged: {
        if(pullDown)
        {
            if(dateListView.contentY == 0)
            {
                clearSearchBar();
                pullDown = false;
            }
        }
        else
        {
            if(dateListView.contentY < -50)
            {
                pullDown = true;
            }
        }
    }*/

    function clearSearchBar()
    {
        textFieldSearchDisease.text = "";
        textFieldSearchDisease.focus = false;
        textSearchNotFound.visible = false;
        searchResult = -1;
        fillDateListModel("*");
    }

    textFieldSearchDisease.onTextChanged: {
        //applyFilter(textFieldSearchDisease.text);
        searchString = textFieldSearchDisease.text;
        searchResult = fillDateListModel(searchString);
        if(textFieldSearchDisease.text.length > 0)
        {
            if(searchResult > 0)
            {
                textSearchNotFound.visible = false;
            }
            else
            {
                dateListModel.clear();
                textSearchNotFound.visible = true;
            }
        }
        else
        {
            clearSearchBar();
        }
    }

    textFieldSearchDisease.onAccepted: {
        textFieldSearchDisease.focus = false;
    }

    onImageIdRecieved: {
        myEDDSApi.updateEucaImageId(imageId, filename);
        //fillDashboardModel("*");
        fillDateListModel("*");
    }

    onServerFileRunning: {
        if(status == "200")
        {
            serverFileStatus = true;
            pageSystemSetting.textServerStatus.color = "green"
            pageSystemSetting.textServerStatus.text = "EucaImage server is ready."
        }
        else
        {
            serverFileStatus = false;
            pageSystemSetting.textServerStatus.color = "red"
            pageSystemSetting.textServerStatus.text = "EucaImage server is not reachable!"
        }
        console.log("Check server status return -> " + serverFileStatus);
    }

    controlCenter.cameraButton.onClicked: {
        cameraPreview.visible = true;
        swipeView.interactive = false;
        controlCenter.visible = false;
        pageDashboard.push(cameraPreviewStack);
    }

    cameraPreview.camera.imageCapture.onImageCaptured: {
        photoPreview.visible = true;
        photoPreview.source = preview;
        photoPreview.previewCanvas.clear_canvas();
        swipeView.interactive = false;
        pageDashboard.push(photoPreviewStack);
    }

    cameraPreview.shutterButton.onClicked: {
        cameraPreview.camera.imageCapture.capture();
    }

    fileGallery.onFileNameFromGalleryChanged: {
        console.log("File gallery selected -> " + fileGallery.fileNameFromGallery)
        photoPreview.visible = true;
        photoPreview.source = fileGallery.fileNameFromGallery
        photoPreview.previewCanvas.clear_canvas();
        controlCenter.visible = false;
        swipeView.interactive = false;
        pageDashboard.push(photoPreviewStack);
    }

    function getGridModel(type, date)
    {
        var object = JSON.parse(myEDDSApi.readEucaImage(type, date));
        for(var i = 0; i < object.euca_image.length; i++)
        {
            console.log("Read euca data -> " + object.euca_image[i].imageId + ":" + object.euca_image[i].diseasetype + " with original filename[" + object.euca_image[i].originalfilename + "]");
            gridModel.append(object.euca_image[i]);
        }
        //console.log("Dashboard list model -> " + dashboardListModel)
        return gridModel;
    }

    function fillDashboardModel(type)
    {
        var object = JSON.parse(myEDDSApi.readEucaImage(type));
        dashboardListModel.clear();
        for(var i = 0; i < object.euca_image.length; i++)
        {
            console.log("Read euca data -> " + object.euca_image[i].imageId + ":" + object.euca_image[i].diseasetype + " with original filename[" + object.euca_image[i].originalfilename + "]");
            dashboardListModel.append(object.euca_image[i]);
        }
        //console.log("Dashboard list model -> " + dashboardListModel)
    }

    function fillDateListModel(type)
    {
        var object = JSON.parse(myEDDSApi.getDateList(type));
        if(object.date_list.length > 0)
        {
            dateListModel.clear();
            for(var i = 0; i< object.date_list.length; i++)
            {
                console.log("Date List [" + i + "] -> " + object.date_list[i].datetext + " as " + object.date_list[i].date);
                dateListModel.append(object.date_list[i]);
            }
            return object.date_list.length;
        }
        else
        {
            return 0;
        }
    }

/*    function reload()
    {
        var object = JSON.parse(myEDDSApi.readEucaImage("*"));
        gridviewListModel.clear();
        for(var i = 0; i < object.euca_image.length; i++)
        {
            console.log("Read euca data -> " + object.euca_image[i].imageId + ":" + object.euca_image[i].diseasetype);
            gridviewListModel.append(object.euca_image[i]);
        }
    } */

    function applyFilter(filter)
    {
        console.log("Dashboard list model filter -> " + filter);
        var object = JSON.parse(myEDDSApi.readEucaImage(filter));
        dashboardListModel.clear();
        for(var i = 0; i < object.euca_image.length; i++)
        {
            console.log("Read euca data -> " + object.euca_image[i].imageId + ":" + object.euca_image[i].diseasetype);
            dashboardListModel.append(object.euca_image[i]);
        }
    }


    function postToEDDS(imageId, submitter, lastedit, latitude, longitude){
        console.log('sending POST to EDDS...');
        var http = new XMLHttpRequest();
        var url = "http://" + pageSystemSetting.textFieldServerIPAddress.text + ":3009/eucaImages/" + imageId;
        //var url = "http://172.31.171.16:3000/eddsapi/euca_images";
        var params = '{"submitter":"'+ submitter+ '","lastedit":"' + lastedit + '","latitude":"'+latitude+'","longitude":"'+longitude + '"}';

        console.log('PARAMS: ' + params);

        http.open("PUT", url, true);

        // Send the proper header information along with the request
        //http.setRequestHeader("Content-type", "application/raw");
        //http.setRequestHeader("Content-Length", params.length);// all browser wont support Refused to set unsafe header "Content-Length"
        //http.setRequestHeader("Connection", "close");//Refused to set unsafe header "Connection"

        // Call a function when the state
        http.onreadystatechange = function() {
           if(http.readyState == 4 && http.status == 201) {
               console.log("POST response -> " + http.responseText);
               // return object Id
               var object = JSON.parse(http.responseText);
               console.log("Returned object Id -> " + object.obj._id);
               //photoPreview.imageId = object[0]._id;
               //console.log("Update imageId -> " + photoPreview.imageId);
               imageIdRecieved(object.obj._id, filename);
               return object.obj._id;
           }
           else
           {
               console.log("EDDS POST status -> " + http.status);
               return http.status;
           }
        }

        http.send(params);
    }

    function runClassify(imageId)
    {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function()
        {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED)
            {
                console.log("HEADERS_RECEIVED");
            }
            else
                if(xhr.readyState === XMLHttpRequest.DONE)
                {
                    console.log("runClassify response -> " + xhr.responseText);
                    return xhr.responseText;
                }
        }
        xhr.open("GET", "http://" + pageSystemSetting.textFieldServerIPAddress.text + ":3009/runClassify/" + imageId);
        //xhr.open("GET", "http://172.31.171.16:3000/runClassify/" + imageId);
        xhr.send();
    }

    function getDiseaseType(imageId)
    {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function()
        {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED)
            {
                console.log("HEADERS_RECEIVED");
            }
            else
                if(xhr.readyState === XMLHttpRequest.DONE)
                {
                    console.log("getDiseaseType response -> " + xhr.responseText);
                    var object = JSON.parse(xhr.responseText);
                    console.log("getDiseaseType response -> " + object.imageId);
                    diseaseTypeRecieved(object.imageId, object.diseasetype, object.stage, object.level, object.lastedit, object.elapsetime);
                    return xhr.responseText;
                }
        }
        xhr.open("GET", "http://" + pageSystemSetting.textFieldServerIPAddress.text + ":3009/getDiseaseType/" + imageId);
        //xhr.open("GET", "http://172.31.171.16:3000/getDiseaseType/" + imageId);

        xhr.send();
    }


    function checkFileServer(url)
    {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function()
        {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED)
            {
                console.log("HEADERS_RECEIVED");
            }
            else
                if(xhr.readyState === XMLHttpRequest.DONE)
                {
                    console.log("Get server " + url + " response -> " + xhr.responseText);
                    serverFileRunning(xhr.responseText);
                    return xhr.responseText;
                }
        }
        xhr.open("GET", url);
        xhr.send();
    }
}
