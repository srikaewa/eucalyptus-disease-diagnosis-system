import QtQuick 2.4

PageEucaDashboardForm {

    function getDashboardEucaModel(type)
    {
        var object = JSON.parse(myEDDSApi.readEucaImage(type));
        dashboardEucaModel.clear();
        for(var i = 0; i < object.euca_image.length; i++)
        {
            console.log("Read euca data -> " + object.euca_image[i].imageId + ":" + object.euca_image[i].diseasetype);
            dashboardEucaModel.append(object.euca_image[i]);
        }
        console.log("Dashboard euca model -> " + dashboardEucaModel)
    }

}
