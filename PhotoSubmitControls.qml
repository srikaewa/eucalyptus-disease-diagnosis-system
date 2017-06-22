/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.7
import QtQuick.Controls 2.1
import QtMultimedia 5.5
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2

FocusScope {
    id : submitControls
    property alias submitControls: submitControls
    property alias panelState: panelSubmit.state
    //property string captureImagePath: captureImagePath

        //anchors.bottom: 500
        //anchors.left: parent.left
        width: parent.width
        height: 64

        Rectangle {
            id: panelSubmit
            anchors {
                //right: parent.Center
                //bottom: parent.bottom
                fill: parent
            }
            color: Qt.rgba(0.08, 0.08, 0.08, 0.35)

            state: "visible"

            states: [
                State {
                    name: "invisible"
                    PropertyChanges { target: panelSubmit; opacity: 0 }
                },

                State {
                    name: "visible"
                    PropertyChanges { target: panelSubmit; opacity: 1.0 }
                }
            ]

            transitions: Transition {
                NumberAnimation { properties: "opacity"; duration: 100 }
            }

            function toggle() {
                if (state == "visible")
                    state = "invisible";
                else
                    state = "visible";
            }

            MessageDialog {
                id: messageDialog
                title: "Operation Error"
                text: "File copied unsuccessfully!"
                onAccepted: {
                    console.log("And of course you could only agree.")
                    messageDialog.close();
                }
            }

            Timer{
                id: timerBusyIndicator
                property int secCount: 0
                interval: 1000
                running: false
                repeat: true
                onTriggered:{
                    secCount = secCount + 1;
                    if(secCount > 3)
                    {
                        switch(photoPreview.submitMode)
                        {
                        case 0:
                            console.log("Capture mode....");
                            if(myEDDSApi.copyFile(camera.imageCapture.capturedImagePath,myEDDSApi.getDefaultHomePath()+"/eucaPhoto-"+Date.now()+".jpg"))
                            {
                                panelSubmit.state = "invisible";
                                imageList.visible = false;
                                cameraUI.state = "PhotoCapture";
                            }
                            else
                            {
                                messageDialog.open();
                            }
                            break;
                        case 1:
                            console.log("Gallery mode....");
                            var str_len = imageList.source.length;
                            var str1 = imageList.source.toString();
                            if(myEDDSApi.copyFile(str1.substring(7,str_len),myEDDSApi.getDefaultHomePath()+"/eucaPhoto-"+Date.now()+".jpg"))
                            {
                                panelSubmit.state = "invisible";
                                imageList.visible = false;
                                cameraUI.state = "PhotoCapture";
                            }
                            else
                            {
                                messageDialog.open();
                            }

                        }
                        photoPreview.busyIndicatorSubmit.running = false;
                        secCount = 0;
                        stop();
                        textTitle.text = "Eucalyptus Disease Diagnosis System"
                    }
                }
            }

            Row{
                anchors{
                    centerIn: parent
                }

                CameraButton {
                    imageFile: "/images/ic_mode_edit_white_48dp.png"
                }

                CameraButton {
                    imageFile: "/images/ic_check_white_48dp.png"
                    onClicked: {
                        //postToEDDS();
                        //postImageToEDDS(camera.imageCapture.capturedImagePath);
                        //request(camera.imageCapture.capturedImagePath);
                        //beginQuoteFileUnquoteUpload(camera.imageCapture.capturedImagePath);
                        //console.log("Capture path -> " + camera.imageCapture.capturedImagePath);
                        myEDDSApi.sendImageFile(myEDDSApi.getImageFilePath2(photoPreview.source));
                        timerBusyIndicator.start();
                        photoPreview.busyIndicatorSubmit.running = true;
                        textTitle.text = "กำลังเชื่อมต่อระบบประมวลผล..."

                        //console.log("Image path : " + camera.imageCapture.capturedImagePath);
                        //postImageToEDDS(camera.imageCapture.capturedImagePath);
                        //beginQuoteFileUnquoteUpload(camera.imageCapture.capturedImagePath);
                        //myEDDSApi.sendImageFile(camera.imageCapture.capturedImagePath);
                        //request(camera.imageCapture.capturedImagePath);                        

                    }
                }

                CameraButton {
                    imageFile: "/images/ic_clear_white_48dp.png"
                    onClicked: {
                        panelSubmit.state = "invisible";
                        cameraUI.state = "PhotoCapture";
                        imageList.visible = false;
                        classificationList.visible = false;
                        textTitle.text = "Eucalyptus Disease Diagnosis System";
                    }
                }
            }

        }

        function postToEDDS(){
            console.log('sending POST to EDDS...');
            var http = new XMLHttpRequest();
            var url = "http://192.168.0.21:3000/eddsapi/euca_images";
            var params = '{"filename":"Test888","diseasetype":"Crypto","submitter":"Me","submit":"Tomorrow","lastedit":"Tomorrow"}';

            http.open("POST", url, true);

            // Send the proper header information along with the request
            //http.setRequestHeader("Content-type", "application/raw");
            //http.setRequestHeader("Content-Length", params.length);// all browser wont support Refused to set unsafe header "Content-Length"
            //http.setRequestHeader("Connection", "close");//Refused to set unsafe header "Connection"

            // Call a function when the state
            http.onreadystatechange = function() {
               if(http.readyState == 4 && http.status == 200) {
                   console.log("POST response -> " + http.responseText);
               }
               else
                   console.log("POST status -> " + http.status);
            }

            http.send(params);
        }

        function request(image_file) {
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                console.log('HEADERS_RECEIVED');
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                //var object = JSON.parse(xhr.responseText.toString());
                console.log("ResponseText -> "+xhr.responseText.toString());
                }
            }
            var body = myEDDSApi.readImageFile(camera.imageCapture.capturedImagePath) + '\r\n'
            xhr.open("POST", "http://192.168.0.21:3000/uploadFile");
            xhr.setRequestHeader(
                "Content-type", "multipart/form-data; boundary="+boundary);
            xhr.send(body);
        }

        function postImageToEDDS(image_file)
        {
            var formData = new FormData();
            //var blob = new Blob(['Lorem ipsum'], { type: 'plain/text' });
            var blob = new Blob([binary], {type: 'image/jpeg'});
            formData.append('userPhoto', blob, image_file);
            var request = new XMLHttpRequest();

            request.open('POST', 'http://192.168.0.21:3009/api/photo');
            request.send(formData);
        }

        function beginQuoteFileUnquoteUpload(image_file)
        {
            console.log("Try POST image file to server......!!");
            var boundary = "----7MA4YWxkTrZu0gW";
            var xhr = new XMLHttpRequest();
            var body = '--' + boundary + '\r\n'
                     // Parameter name is "file" and local filename is "temp.txt"
                     + 'Content-Disposition: form-data; name="userPhoto";'
                     + 'filename="' + myEDDSApi.getImageFileName(image_file) +'"\r\n'
                     //+ 'filename="\/storage\/emulated\/0\/DCIM\/IMG_00000025.jpg"\r\n'
                     + 'Content-type: image/jpeg\r\n\r\n'
                     +  myEDDSApi.readImageFile(image_file) + '\r\n'
                     //+ "abcdefg###################\r\n"
                     + boundary + '--';

            console.log(body);
            xhr.open("POST", "http://192.168.0.21:3009/api/photo", true);
            xhr.setRequestHeader(
                "Content-type", "multipart/form-data; boundary="+boundary);
            xhr.onreadystatechange = function ()
            {
                if (xhr.status == 200)
                    console.log("File uploaded!");
                else
                    console.log("Failed with status = " + xhr.status);
            }
            xhr.send(body);
        }

        function toDataURL(url, callback){
            var xhr = new XMLHttpRequest();
            xhr.open('get', url);
            xhr.responseType = 'blob';
            xhr.onload = function(){
              var fr = new FileReader();
              fr.onload = function(){
                callback(this.result);
                };
              fr.readAsDataURL(xhr.response);
              };
            xhr.send();
        }
 }

