import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Window 2.0

PageDashboardForm {    
    signal imageIdRecieved(string imageId, string filename)
    signal serverANNRunning(string status)
    signal serverFileRunning(string status)

    Component.onCompleted: {
        fillDashboardModel("*");
        //applyFilter("Crypto");
    }

    textFieldSearchDisease.onTextChanged: {
        applyFilter(textFieldSearchDisease.text);
    }

    textFieldSearchDisease.onAccepted: {
        textFieldSearchDisease.focus = false;
    }

    onImageIdRecieved: {
        myEDDSApi.updateEucaImageId(imageId, filename);
        fillDashboardModel("*");
    }

    onServerANNRunning: {
        if(status == "200")
            serverANNStatus = true;
        else
            serverANNStatus = false;
        console.log("Check server status return -> " + serverANNStatus);
    }
    onServerFileRunning: {
        if(status == "200")
            serverFileStatus = true;
        else
            serverFileStatus = false;
        console.log("Check server status return -> " + serverFileStatus);
    }

    controlCenter.cameraButton.onClicked: {
        cameraPreview.visible = true;
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
        swipeView.interactive = false;
        pageDashboard.push(photoPreviewStack);
    }

    function fillDashboardModel(type)
    {
        var object = JSON.parse(myEDDSApi.readEucaImage(type));
        dashboardListModel.clear();
        for(var i = 0; i < object.euca_image.length; i++)
        {
            console.log("Read euca data -> " + object.euca_image[i].imageId + ":" + object.euca_image[i].diseasetype);
            dashboardListModel.append(object.euca_image[i]);
        }
        console.log("Dashboard list model -> " + dashboardListModel)
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


    function postToEDDS(filename, uploaded, diseasetype, stage, level, submitter, submit, lastedit, latitude, longitude, elapsetime){
        console.log('sending POST to EDDS...');
        var http = new XMLHttpRequest();
        var url = "http://" + pageSystemSetting.textFieldServerIPAddress.text + ":9099/eddsapi/euca_images";
        //var url = "http://172.31.171.16:3000/eddsapi/euca_images";
        var params = '{"filename":"' +filename+ '","uploaded":'+uploaded +',"diseasetype":"'+ diseasetype + '","stage":"' + stage + '","level":"' + level + '","submitter":"'+ submitter +'","submit":"'+submit+'","lastedit":"' + lastedit + '","latitude":"'+latitude+'","longitude":"'+longitude+'","elapsetime":"' + elapsetime + '"}';

        console.log('PARAMS: ' + params);

        http.open("POST", url, true);

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
        xhr.open("GET", "http://" + pageSystemSetting.textFieldServerIPAddress.text + ":9099/runClassify/" + imageId);
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
        xhr.open("GET", "http://" + pageSystemSetting.textFieldServerIPAddress.text + ":9099/getDiseaseType/" + imageId);
        //xhr.open("GET", "http://172.31.171.16:3000/getDiseaseType/" + imageId);

        xhr.send();
    }

    function checkANNServer(url)
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
                    serverANNRunning(xhr.responseText);
                    return xhr.responseText;
                }
        }
        xhr.open("GET", url);
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
