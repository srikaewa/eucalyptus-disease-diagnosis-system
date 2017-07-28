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

import QtQuick 2.0
import QtQuick.Controls 2.1
import QtMultimedia 5.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtPositioning 5.3

Item {
    id: photoPreview
    property alias photoPreview: photoPreview
    property alias source : preview.source
    //property alias submitPanel: submitControls.panelState
    property alias busyIndicatorSubmit: busyIndicatorSubmit
    property alias textFileName: textFileName
    property alias textLatitude: textLatitude
    property alias textLongitude: textLongitude
    property alias previewCanvas: previewCanvas

    property int submitMode: 0
    property string imageId: ""
    property date todayDate: new Date()
    property string filename: ""
    property string eucaFileName: myEDDSApi.getDefaultHomePath()+"/eucaPhoto-"+pageUser.textFieldEmail.text+'-';


    property bool mouseReleased : false
    property bool mouseFirstPressed: true
    property bool drawImage: false

    property var pointList: [Qt.point(0,0)]
    property int pointIndex: 0

    signal closed


    anchors.fill: parent

    PositionSource {
        id: gpsPosition
        //preferredPositioningMethods: PositionSource.SatellitePositioningMethods
        preferredPositioningMethods: PositionSource.AllPositioningMethods
        active: true
        updateInterval: 2000 // ms
    }

    Image {
        id: preview
        anchors{
            fill: parent
        }

        fillMode: Image.Stretch
        width: parent.width
        height: parent.height
        smooth: true
        visible: true
    }

    Canvas{
        id: previewCanvas
        anchors{
            fill: preview
        }

        property real firstX
        property real firstY
        property real lastX
        property real lastY
        property color colorRed: Qt.rgba(1,0,0,0.5)
        property color colorGreen: Qt.rgba(0,1,0,0.5)
        //property string filenameCanvas: textFileName.text
        //property bool drawImage: false
        //property color paintColor: "#33B5E5"
        Component.onCompleted: {
            console.log("Canvas: Loading image -> " + textFileName.text)
        }

        onPaint: {
            var ctx = getContext('2d')
            ctx.lineWidth = 10
            ctx.strokeStyle = previewCanvas.colorRed
            ctx.beginPath()
            ctx.moveTo(lastX, lastY)
            lastX = area.mouseX
            lastY = area.mouseY
            ctx.lineTo(lastX, lastY)
            ctx.stroke()
  /*          if(!drawImage)
            {
                console.log("Canvas: drawing image..." + textFileName.text)
                console.log("Preview width:height = " + preview.width + ":" + preview.height + ", Canvas width:heigh = " + previewCanvas.width + ":" + previewCanvas.height);
                ctx.drawImage(preview.source, 0, 0, preview.width,preview.height, 0,0,previewCanvas.width, previewCanvas.height);
                drawImage = true;
            } */
            pointList[pointIndex++] = Qt.point(lastX, lastY)
            //console.log("Canvas: pointList[" + pointIndex + "] = (" + pointList[pointIndex].x + "," + pointList[pointIndex].y + ")" )
        }

        function clear_canvas()
        {
            var ctx = getContext('2d')
            ctx.reset()
            previewCanvas.requestPaint()
        }

        MouseArea {
        id: area
        anchors.fill: parent
        onPressed: {
            if(mouseFirstPressed)
            {
                previewCanvas.clear_canvas()
                previewCanvas.firstX = mouseX
                previewCanvas.firstY = mouseY
                mouseFirstPressed = false
                pointIndex = 0
                pointList = []
                //pointList[pointIndex] = Qt.point(mouseX,mouseY)
                //console.log("Canvas: pointList[" + pointIndex + "] = (" + pointList[pointIndex].x + "," + pointList[pointIndex].y + "]" )
            }
            previewCanvas.lastX = mouseX
            previewCanvas.lastY = mouseY
        }

        onPositionChanged: {
            previewCanvas.requestPaint()
            }

        onReleased: {
            //var ctx = getContext('2d')
            //ctx.closePath()
            //previewCanvas.requestPaint()
            console.log("Mouse released!")
            mouseReleased = true
            mouseFirstPressed = false
            previewCanvas.clear_canvas();
            var ctx = previewCanvas.getContext('2d');
            //ctx.lineWidth = 10;
            //ctx.strokeStyle = previewCanvas.colorGreen;
            //ctx.strokeStyle = previewCanvas.colorRed;
            ctx.fillStyle = Qt.rgba(0,0,0,0.65);
            //console.log("Preview canvas width -> "+previewCanvas.width + ", height -> " + previewCanvas.height);
            ctx.fillRect(0,0,previewCanvas.width,preview.height);
            ctx.beginPath();
            ctx.moveTo(pointList[0].x, pointList[0].y);
            console.log("Canvas: Clip pointList[0] = (" + pointList[0].x + "," + pointList[0].y + ")" )
            for(var i=1; i< pointList.length; i++)
            {
                ctx.lineTo(pointList[i].x, pointList[i].y);
                //console.log("Canvas: Clip pointList[" + i + "] = (" + pointList[i].x + "," + pointList[i].y + ")" )
            }
            ctx.closePath()
            ctx.clip()
            //preview.visible = false
            ctx.drawImage(preview.source, 0,0,previewCanvas.width, previewCanvas.height);
            //ctx.stroke()

            previewCanvas.requestPaint()
            mouseFirstPressed = true
        }
        }

        Image{
            id: imagePhotoPreviewBack
            anchors{
                margins: 10
                left: parent.left
                top: parent.top
            }

            source: "/images/ic_arrow_back_white_48dp.png"
            width: 36
            height: width
            MouseArea{
                id: mouseAreaPhotoPreviewBack
                anchors.fill: parent
                onClicked: {
                    //photoPreview.visible = false;
                    swipeView.interactive = true;
                    previewCanvas.clear_canvas();
                    mouseReleased = false;
                    mouseFirstPressed = true;
                    pageDashboard.pop();
                }
            }

            ToolTip{
                parent: mouseAreaPhotoPreviewBack
                visible: mouseAreaPhotoPreviewBack.pressed
                text: "Back to Eucalyptus Image Selection without any diagnosis"
            }
        }

        Column{
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 20
            width: Screen.desktopAvailableWidth * 0.25
            Text{
                id: textFileName
                text: myEDDSApi.getImageFileName(preview.source)
                color: "white"
                font.family: fontRegular.name
                font.pixelSize: 20
            }
            Text{
                id: textFilePath
                text: myEDDSApi.getImageFilePath2(preview.source, textFileName.text)
                color: "white"
                font.family: fontRegular.name
                font.pixelSize: 18
            }
            Text{
                id: textLatitude
                text: "Latitude: " + gpsPosition.position.coordinate.latitude
                color: "white"
                font.family: fontRegular.name
                font.pixelSize: 18
            }
            Text{
                id: textLongitude
                text: "longitude: " + +gpsPosition.position.coordinate.longitude
                color: "white"
                font.family: fontRegular.name
                font.pixelSize: 18
            }

        }
    }

    BusyIndicator{
        id: busyIndicatorSubmit
        width: parent.height/8
        height: parent.height/8
        anchors.centerIn: parent
        running: false
    }

    Rectangle{
        width: parent.width
        height: 50
        anchors{
            bottom: parent.bottom
        }
        color: Qt.rgba(0.08, 0.08, 0.08, 0.35)
        Row{
            anchors{
                centerIn: parent
            }
            /*Image{
                anchors{
                    margins: 10
                }
                source: "/images/ic_mode_edit_white_48dp.png"
                width: 36
                height: 36
                MouseArea{
                    anchors.fill: parent
                    onClicked: {

                    }
                }
            }
            Rectangle{
                width: 100
                height: 1
                color: Qt.rgba(0,0,0,0)
            }*/

            Image{
                source: "/images/ic_check_white_48dp.png"
                anchors{
                    margins: 10
                }
                width: 36
                height: 36
                MouseArea{
                    id: mouseAreaCheck
                    anchors.fill: parent
                    onClicked: {
                        swipeView.interactive = true;
                        pageDashboard.pop();
                        todayDate = new Date();
                        var timeNow = Date.now()
                        filename = eucaFileName+timeNow+".jpg";
                        /**** copy file to app home directory and format filename ***/
                        console.log("Submitting file -> "+filename);                        
                        //myEDDSApi.copyFile(myEDDSApi.getImageFilePath(preview.source), eucaFileName+timeNow+".jpg");
                        previewCanvas.save(filename);
                        previewCanvas.clear_canvas();
                        myEDDSApi.saveEucaImage("xxxxxxxxxxxxxxxxxxxxxxxx", myEDDSApi.getImageFileName(filename), "false", 'u', firebaseObject.email, todayDate, todayDate, gpsPosition.position.coordinate.latitude, gpsPosition.position.coordinate.longitude);
                        pageDashboard.fillDashboardModel("*");
                    }
                    ToolTip{
                        parent: mouseAreaCheck
                        text: "Processing selected area. Please check out the diagnosis in dashboard page."
                        visible: mouseAreaCheck.pressed
                        timeout: 3000
                    }
                }
            }
            Rectangle{
                width: 100
                height: 1
                color: Qt.rgba(0,0,0,0)
            }
            Image{
                source: "/images/ic_clear_white_48dp.png"
                width: 36
                height: 36
                MouseArea{
                    id: mouseAreaClear
                    anchors.fill: parent
                    onClicked: {
                        previewCanvas.clear_canvas();
                        mouseReleased = false;
                        mouseFirstPressed = true;
                    }
                    ToolTip{
                        parent: mouseAreaClear
                        text: "Clear selection"
                        visible: mouseAreaClear.pressed
                    }
                }
            }
         }
    }


}

