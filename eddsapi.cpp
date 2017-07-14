#include "eddsapi.h"


EDDSApi::EDDSApi(QObject *parent) : QObject(parent)
{
    connectDB();
}

/*void EDDSApi::onOpenGallery()
{
    qDebug() << "Opening Android Gallery...";
    m_selectedFileName = "#";
    QAndroidJniObject::callStaticMethod<void>("com/amin/QtAndroidGallery/QtAndroidGallery",
                                              "openAnImage",
                                              "()V");
    while(m_selectedFileName == "#")
        QCoreApplication::processEvents(QEventLoop::ExcludeUserInputEvents,5000);

    if(QFile(m_selectedFileName).exists())
    {
        qDebug() << "Image location -> " << m_selectedFileName;
    }
}*/

/*void EDDSApi::onOpenGallery()
{
    qDebug() << "Opening Android Gallery...";
    QAndroidJniObject ACTION_PICK = QAndroidJniObject::fromString("android.intent.action.GET_CONTENT");
    QAndroidJniObject intent("android/content/Intent");
    if (ACTION_PICK.isValid() && intent.isValid())
    {
        intent.callObjectMethod("setAction", "(Ljava/lang/String;)Landroid/content/Intent;", ACTION_PICK.object<jstring>());
        intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString("image/*").object<jstring>());
        QtAndroid::startActivity(intent.object<jobject>(), 101, this);
        qDebug() << "OK";
    }
    else
    {
        qDebug() << "ERRO";
    }
}*/

void EDDSApi::buscaImagem()
{
    QAndroidJniObject ACTION_PICK = QAndroidJniObject::getStaticObjectField("android/content/Intent", "ACTION_PICK", "Ljava/lang/String;");
    QAndroidJniObject EXTERNAL_CONTENT_URI = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore$Images$Media", "EXTERNAL_CONTENT_URI", "Landroid/net/Uri;");

    QAndroidJniObject intent=QAndroidJniObject("android/content/Intent", "(Ljava/lang/String;Landroid/net/Uri;)V", ACTION_PICK.object<jstring>(), EXTERNAL_CONTENT_URI.object<jobject>());

    if (ACTION_PICK.isValid() && intent.isValid())
    {
        intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString("image/*").object<jstring>());
        QtAndroid::startActivity(intent.object<jobject>(), 101, this);
        qDebug() << "OK";
    }
    else
    {
        qDebug() << "ERRO";
    }
}

void EDDSApi::handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject &data)
{
    qDebug() << "################### handleActivityResult ###################";
    jint RESULT_OK = QAndroidJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");
    if (receiverRequestCode == 101 && resultCode == RESULT_OK)
    {
        QAndroidJniObject uri = data.callObjectMethod("getData", "()Landroid/net/Uri;");
        QAndroidJniObject dadosAndroid = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore$MediaColumns", "DATA", "Ljava/lang/String;");
        QAndroidJniEnvironment env;
        jobjectArray projecao = (jobjectArray)env->NewObjectArray(1, env->FindClass("java/lang/String"), NULL);
        jobject projacaoDadosAndroid = env->NewStringUTF(dadosAndroid.toString().toStdString().c_str());
        env->SetObjectArrayElement(projecao, 0, projacaoDadosAndroid);
        QAndroidJniObject contentResolver = QtAndroid::androidActivity().callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");
        QAndroidJniObject cursor = contentResolver.callObjectMethod("query", "(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;", uri.object<jobject>(), projecao, NULL, NULL, NULL);
        jint columnIndex = cursor.callMethod<jint>("getColumnIndex", "(Ljava/lang/String;)I", dadosAndroid.object<jstring>());
        cursor.callMethod<jboolean>("moveToFirst", "()Z");
        QAndroidJniObject resultado = cursor.callObjectMethod("getString", "(I)Ljava/lang/String;", columnIndex);
        m_fileNameFromGallery = "file://" + resultado.toString();
        qDebug() << "File selected -> " << m_fileNameFromGallery;
        emit fileNameFromGalleryChanged();
    }
    else
    {
        qDebug() << "Caminho errado";
    }
}

QString EDDSApi::fileNameFromGallery() const
{
    return m_fileNameFromGallery;
}

void EDDSApi::setFileNameFromGallery(const QString &fileNameFromGallery)
{
    if(m_fileNameFromGallery != fileNameFromGallery)
    {
        m_fileNameFromGallery = fileNameFromGallery;
        qDebug() << "fileNameFromGallery changed -> " << m_fileNameFromGallery;
        emit fileNameFromGalleryChanged();
    }
}

int EDDSApi::sendImageFile(QString file_path, QString serverIP)
{
    qDebug() << "Calling sendImageFile(" + file_path + ")...";
    QString bound="----7MA4YWxkTrZu0gW";
    QFile file(file_path);
    QString file_name = file_path.section("/",-1,-1);
    if (!file.open(QIODevice::ReadOnly))
        return -1;
    QByteArray blob = file.readAll();
    QByteArray data;
    QString bb2;
    data.append("--" + bound + "\r\n");
    bb2 = "Content-Disposition: form-data; name=" % QChar('"') % "userPhoto"+QChar('"') % "; filename=" % QChar('"');
    data.append(bb2.toUtf8());
    data.append(file_name);
    data.append("\"\r\n");
    data.append("Content-Type: image/jpeg\r\n\r\n"); //data type
    data.append(blob); //let's read the file
    data.append("\r\n");
    data.append("--" + bound + "--\r\n"); //closing boundary according to rfc 1867
    //qDebug() << "data.length = " + QString::number(data.length()) + " data = " + bb2.toUtf8();
    QString bb;
    for(int i=data.length()-200;i < data.length();i++)
        bb.append(data.at(i));
    //qDebug() << "CheckCheck!!!!!!!!!!!!!! => " + bb;
    QString buff = "multipart/form-data; boundary=" + bound;
    QNetworkAccessManager *am = new QNetworkAccessManager(this);
    qDebug() << "File server IP : http://" + serverIP + ":3009/api/photo";
    QNetworkRequest request(QUrl("http://" + serverIP + ":3009/api/photo"));
    //QNetworkRequest request(QUrl("http://172.31.171.16:3009/api/photo"));
    request.setRawHeader("Content-Type", buff.toStdString().c_str());
    request.setHeader(QNetworkRequest::ContentLengthHeader,data.length());
    //request.setRawHeader("Content-Length", QString::number(data.length()).toStdString().c_str());
    QEventLoop loop;
    connect(am, SIGNAL(finished(QNetworkReply*)),this, SLOT(sendFileReply(QNetworkReply*)));
    QNetworkReply *reply = am->post(request, data); // perform POST request
    loop.exec();
    return 0;
}

void EDDSApi::sendFileReply(QNetworkReply* nr)
{
    //QVariant statusCodeV = nr->attribute(QNetworkRequest::HttpStatusCodeAttribute)
    QVariant statusCodeV = nr->readAll();
    qDebug() << "File upload returning code -> " + statusCodeV.toString();
    QJsonDocument jsonResponse = QJsonDocument::fromJson(statusCodeV.toByteArray());
    QJsonObject jsonObject = jsonResponse.object();
    QJsonValue statusValue = jsonObject.value("status");
    if(statusValue == "201")
    {
        QJsonValue uploadedFilename = jsonObject.value("uploadedFilename");
        qDebug() << "Upload finised with uploadedFilename -> " + uploadedFilename.toString();
        updateEucaImageFileUpload(uploadedFilename.toString(), "true","x");
    }
    else
    {
        qDebug() << "File upload failed...!";
    }
}

bool EDDSApi::isFileUploaded(QString filename)
{
    qDebug()  << "EDDSApi:: Reading uploaded status of " + filename + " from database...";
    QSqlQuery qry;
    if(qry.prepare("SELECT uploaded FROM euca_images WHERE filename = :filename")){
        qry.bindValue(":filename", filename);
        if(qry.exec())
        {
            bool res;
            while(qry.next())
            {
                //qDebug() << "imageId: " + eucaTemp.value(0);
                res = qry.value(qry.record().indexOf("uploaded")).toBool();
                QString str = (res ? "true": "false");
                qDebug() << "EDDSApi:: read uploaded = " + str + " successfully...";
            }
            return res;
        }
        else
        {
            qDebug() << "EDDSApi:: read uploaded failed!";
            return false;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: read uploaded query broken!";
        return false;
    }
}

int EDDSApi::readSendFileCount(QString filename)
{
    qDebug()  << "EDDSApi:: Reading sendFileCount of " + filename + " from database...";
    QSqlQuery qry;
    if(qry.prepare("SELECT sendFileCount FROM euca_images WHERE filename = :filename")){
        qry.bindValue(":filename", filename);
        if(qry.exec())
        {
            int res;
            while(qry.next())
            {
                //qDebug() << "imageId: " + eucaTemp.value(0);
                res = qry.value(qry.record().indexOf("sendFileCount")).toInt();
                qDebug() << "EDDSApi:: read sendFileCount = " + QString::number(res) + " successfully...";
            }
            return res;
        }
        else
        {
            qDebug() << "EDDSApi:: read sendFileCount failed!";
            return -1;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: read sendFileCount query broken!";
        return -2;
    }
}

bool EDDSApi::setSendFileCount(QString filename, QString count)
{
    qDebug()  << "EDDSApi:: start updating file ::" +filename+ ":: with sendFileCount ::" + count + ":: to database...";
    QSqlQuery qry;
    if(qry.prepare("UPDATE euca_images SET sendFileCount = :sendFileCount WHERE filename = :filename")){
        qry.bindValue(":sendFileCount", count);
        qry.bindValue(":filename", filename);
        if(qry.exec())
        {
            qDebug() << "EDDSApi:: Update sendFileCount to file " + filename + " successfully...";
            return true;
        }
        else
        {
            qDebug() << "EDDSApi:: Update sendFileCount to file " + filename + " failed!";
            return false;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: Update sendFileCount to file " + filename + " query broken!";
        return false;
    }
}

int EDDSApi::readRunClassifyCount(QString imageId)
{
    qDebug()  << "EDDSApi:: Reading runClassifyCount of " + imageId + " from database...";
    QSqlQuery qry;
    if(qry.prepare("SELECT runClassifyCount FROM euca_images WHERE imageId = :imageId")){
        qry.bindValue(":imageId", imageId);
        if(qry.exec())
        {
            int res;
            while(qry.next())
            {
                res = qry.value(qry.record().indexOf("runClassifyCount")).toInt();
                qDebug() << "EDDSApi:: read runClassifyCount = " + QString::number(res) + " successfully...";
            }
            return res;
        }
        else
        {
            qDebug() << "EDDSApi:: read runClassifyCount failed!";
            return -1;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: read runClassifyCount query broken!";
        return -2;
    }
}

bool EDDSApi::setRunClassifyCount(QString imageId, QString count)
{
    qDebug()  << "EDDSApi:: start updating imageId::" +imageId+":: with runClassifyCount::" + count + ":: to database...";
    QSqlQuery qry;
    if(qry.prepare("UPDATE euca_images SET runClassifyCount = :runClassifyCount WHERE imageId = :imageId")){
        qry.bindValue(":runClassifyCount", count);
        qry.bindValue(":imageId", imageId);
        if(qry.exec())
        {
            qDebug() << "EDDSApi:: Update runClassifyCount to image " + imageId + " successfully...";
            return true;
        }
        else
        {
            qDebug() << "EDDSApi:: Update runClassifyCount to image " + imageId + " failed!";
            return false;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: Update runClassifyCount to image " + imageId + " query broken!";
        return false;
    }
}

bool EDDSApi::isFileProcessed(QString filename)
{
    qDebug()  << "EDDSApi:: Reading processed status of " + filename + " from database...";
    QSqlQuery qry;
    if(qry.prepare("SELECT processed FROM euca_images WHERE filename = :filename")){
        qry.bindValue(":filename", filename);
        if(qry.exec())
        {
            bool res;
            while(qry.next())
            {
                res = qry.value(qry.record().indexOf("processed")).toBool();
                QString str = (res ? "true": "false");
                qDebug() << "EDDSApi:: read processed = " + str + " successfully...";
            }
            return res;
        }
        else
        {
            qDebug() << "EDDSApi:: read processed failed!";
            return false;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: read processed query broken!";
        return false;
    }}

QString EDDSApi::getDiseaseType(QString imageId)
{
    return m_diseaseType;
}

int EDDSApi::postData(QString json_str)
{
        return 0;
}

QByteArray EDDSApi::buildUploadString(QString file_path)
{
    QString bound="7MA4YWxkTrZu0gW";
    QByteArray data;
    data.append("--" + bound + "\r\n");
    data.append("Content-Disposition: form-data; name=\"userPhoto\"; filename=\"");
    data.append(getImageFileName(file_path));
    data.append("\"\r\n");
    data.append("Content-Type: image/jpeg\r\n\r\n"); //data type

    QFile file(file_path);
        if (!file.open(QIODevice::ReadOnly)){
            qDebug() << "QFile Error: File not found!";
            return data;
        } else { qDebug() << "File found, proceed as planned"; }
    data.append(file.readAll().toBase64());
    data.append("\r\n");
    data.append("--" + bound + "--\r\n");  //closing boundary according to rfc 1867

    file.close();

    return data;
}

QString EDDSApi::getImageFilePath(QString file_path)
{
    return file_path.remove(0,7);
}

QString EDDSApi::getImageFilePath2(QString file_path, QString file_name)
{
    return file_path.remove(file_name).remove(0,7);
}


QString EDDSApi::getImageFileName(QString file_path)
{
    return file_path.section("/",-1,-1);
}

QByteArray EDDSApi::readImageFile(QString file_path)
{
    QFile file(file_path);
    file.open(QIODevice::ReadOnly);
    QByteArray blob = file.readAll().toBase64();
    return blob;
}

QString EDDSApi::getDefaultImagePath()
{
    return QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
}

QString EDDSApi::getDefaultHomePath()
{
    return QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
}

bool EDDSApi::copyFile(QString original_file_path, QString destination_file_path)
{
    QFile org_file(original_file_path);
    qDebug() << "Original file -> " + original_file_path;
    if(!org_file.open(QIODevice::ReadOnly))
        return false;
    qDebug() << "Destination file -> " + destination_file_path;
    if(org_file.copy(destination_file_path))
        return true;
    else
        return false;
}

bool EDDSApi::deleteFile(QString filename)
{
    QFile org_file(filename);
    if(!org_file.remove())
    {
        qDebug() << "Delete file " + filename + " failed!!!!!";
        return false;
    }
    else
    {
        qDebug() << "Delete file " + filename + " successfully...";
        return true;
    }
}

void EDDSApi::connectDB()
{
    QString homeLocation = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    qDebug() << "Writable location :" + homeLocation;
    QString dbFilePath = homeLocation + "/dbf.sqlite";

    QFile dfile(":/edds.sqlite");
    QFile tfile(dbFilePath);

    if (!tfile.exists())
    {
        QFileInfo info1(":/edds.sqlite");
        qDebug() << "Absolute file path -> " + info1.absoluteFilePath();   // returns "/home/bob/bin/untabify"
        qDebug() << "File size -> " + QString::number(info1.size());

        if(dfile.copy(dbFilePath))
        {
            QFile::setPermissions(dbFilePath,QFile::WriteOwner | QFile::ReadOwner);
            QFileInfo info2(dbFilePath);
            qDebug() << "Absolute file path -> " + info2.absoluteFilePath();   // returns "/home/bob/bin/untabify"
            qDebug() << "File size -> " + QString::number(info2.size());               // returns 56201
            qDebug() << "EDDSApi::connectDB -> Copy database file successfully...";
            m_db = QSqlDatabase::addDatabase("QSQLITE");
            m_db.setDatabaseName(dbFilePath);
            if(!m_db.open())
            {
                qCritical() << "EDDSApi:: Failed to open database!";
                m_dbstatus = false;
            }
              else
            {
                m_db.open();
                qDebug() << "EDDSApi:: Database connected...";
                dfile.close();
                tfile.close();
                m_dbstatus = true;
            }
        }
        else
        {
            qDebug() << "EDDSApi:: Copy file failed!";
        }
    }
    else
    {
        qDebug() << "EDDSApi::connectDB -> Database file '"+ dbFilePath +"' exists...";
        m_db = QSqlDatabase::addDatabase("QSQLITE");
        m_db.setDatabaseName(dbFilePath);
        if(!m_db.open())
        {
            qCritical() << "EDDSApi:: Failed to open database!";
            m_dbstatus = false;
        }
          else
        {
            m_db.open();
            qDebug() << "EDDSApi:: Database connected...";
            dfile.close();
            tfile.close();
            m_dbstatus = true;
        }
    }
}

bool EDDSApi::saveEucaImage(QString imageId, QString filename, QString uploaded, QString diseasetype,QString submitter, QString submit, QString lastedit, QString latitude, QString longitude)
{
    qDebug()  << "EDDSApi:: start saving image " + imageId + " with filename " + filename + " to database...";
    QSqlQuery qry;
    if(qry.prepare("INSERT INTO euca_images (imageId, filename, diseasetype, submitter, submit, lastedit, latitude, longitude) VALUES (:imageId, :filename, :diseasetype, :submitter, :submit, :lastedit, :latitude, :longitude)")){
        qry.bindValue(":imageId", imageId);
        qry.bindValue(":filename", filename);
        qry.bindValue("uploaded:", uploaded);
        qry.bindValue(":diseasetype", diseasetype);
        qry.bindValue(":submitter", submitter);
        qry.bindValue(":submit", submit);
        qry.bindValue(":lastedit", lastedit);
        qry.bindValue(":latitude", latitude);
        qry.bindValue(":longitude", longitude);
        if(qry.exec())
        {
            qDebug() << "EDDSApi:: Insert euca data successfully...";
            return true;
        }
        else
        {
            qDebug() << "EDDSApi:: Insert euca data failed!";
            return false;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: Insert euca data query broken!";
        return false;
    }
}

bool EDDSApi::updateEucaImageFileUpload(QString filename, QString uploaded, QString diseasetype)
{
    qDebug()  << "EDDSApi:: start updating file ::" +filename+ ":: with uploaded ::" + uploaded + ":: and diseasetype ::"+diseasetype+":: to database...";
    QSqlQuery qry;
    if(qry.prepare("UPDATE euca_images SET uploaded = :uploaded, diseasetype=:diseasetype WHERE filename = :filename")){
        qry.bindValue(":uploaded", uploaded);
        qry.bindValue(":diseasetype", diseasetype);
        qry.bindValue(":filename", filename);
        if(qry.exec())
        {
            qDebug() << "EDDSApi:: Update uploaded file " + filename + " successfully...";
            return true;
        }
        else
        {
            qDebug() << "EDDSApi:: Update uploaded file " + filename + " failed!";
            return false;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: Update uploaded file " + filename + " query broken!";
        return false;
    }
}

bool EDDSApi::updateEucaImageFileProcess(QString imageId, QString processed)
{
    qDebug()  << "EDDSApi:: start updating image ::" +imageId+ ":: with processed ::" + processed + ":: to database...";
    QSqlQuery qry;
    if(qry.prepare("UPDATE euca_images SET processed = :processed WHERE imageId = :imageId")){
        qry.bindValue(":processed", processed);
        qry.bindValue(":imageId", imageId);
        if(qry.exec())
        {
            qDebug() << "EDDSApi:: Update processed image " + imageId + " successfully...";
            return true;
        }
        else
        {
            qDebug() << "EDDSApi:: Update processed image " + imageId + " failed!";
            return false;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: Update processed image " + imageId + " query broken!";
        return false;
    }
}


bool EDDSApi::updateEucaImageId(QString imageId, QString filename)
{
    qDebug()  << "EDDSApi:: start updating imageId ::" +imageId+ ":: with filename ::" + filename + ":: to database...";
    QSqlQuery qry;
    if(qry.prepare("UPDATE euca_images SET imageId = :imageId WHERE filename = :filename")){
        qry.bindValue(":imageId", imageId);
        qry.bindValue(":filename", filename);
        if(qry.exec())
        {
            qDebug() << "EDDSApi:: Update euca " + imageId + " data successfully...";
            return true;
        }
        else
        {
            qDebug() << "EDDSApi:: Update euca " + imageId + " data failed!";
            return false;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: Update euca " + imageId + " data query broken!";
        return false;
    }
}

bool EDDSApi::updateDiseaseType(QString imageId, QString diseasetype, QString stage, QString level, QString lastedit, QString elapsetime)
{
    qDebug()  << "EDDSApi:: updating disease type of [" + imageId + ": " + diseasetype + "] to database...";
    QSqlQuery qry;
    if(qry.prepare("UPDATE euca_images SET diseasetype = :diseasetype, stage = :stage, level = :level, lastedit = :lastedit, elapsetime = :elapsetime WHERE imageId = :imageId")){
        qry.bindValue(":imageId", imageId);
        qry.bindValue(":diseasetype", diseasetype);
        qry.bindValue(":stage", stage);
        qry.bindValue(":level", level);
        qry.bindValue(":lastedit", lastedit);
        qry.bindValue(":elapsetime", elapsetime);
        if(qry.exec())
        {
            qDebug() << "EDDSApi:: update diseasetype successfully...";
            return true;
        }
        else
        {
            qDebug() << "EDDSApi:: update diseasetype failed!";
            return false;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: update diseasetype query broken!";
        return false;
    }
}

bool EDDSApi::updateDiseaseType2Filename(QString filename, QString diseasetype, QString stage, QString level, QString elapsetime)
{
    qDebug()  << "EDDSApi:: updating disease type of [" + filename + ": " + diseasetype + "] to database...";
    QSqlQuery qry;
    if(qry.prepare("UPDATE euca_images SET diseasetype = :diseasetype, stage = :stage, level = :level, elapsetime = :elapsetime WHERE filename = :filename")){
        qry.bindValue(":filename", filename);
        qry.bindValue(":diseasetype", diseasetype);
        qry.bindValue(":stage", stage);
        qry.bindValue(":level", level);
        qry.bindValue(":elapsetime", elapsetime);
        if(qry.exec())
        {
            qDebug() << "EDDSApi:: update diseasetype successfully...";
            return true;
        }
        else
        {
            qDebug() << "EDDSApi:: update diseasetype failed!";
            return false;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: update diseasetype query broken!";
        return false;
    }
}

QString EDDSApi::readDiseaseType(QString imageId)
{
    qDebug()  << "EDDSApi:: Reading disease type of " + imageId + " from database...";
    QSqlQuery qry;
    if(qry.prepare("SELECT diseasetype FROM euca_images WHERE imageId = :imageId")){
        qry.bindValue(":imageId", imageId);
        if(qry.exec())
        {
            QString str;
            while(qry.next())
            {
                //qDebug() << "imageId: " + eucaTemp.value(0);
                str = qry.value(qry.record().indexOf("diseasetype")).toString();
                qDebug() << "EDDSApi:: read diseasetype: [" + str + "] successfully...";
            }
            return str;
        }
        else
        {
            qDebug() << "EDDSApi:: read diseasetype failed!";
            return "x";
        }
    }
    else
    {
        qDebug() << "EDDSApi:: read diseasetype query broken!";
        return "x";
    }
}

QString EDDSApi::readEucaImageIdFromFile(QString filename)
{
    qDebug()  << "EDDSApi:: Reading imageId of " + filename + " from database...";
    QSqlQuery qry;
    if(qry.prepare("SELECT imageId FROM euca_images WHERE filename = :filename")){
        qry.bindValue(":filename", filename);
        if(qry.exec())
        {
            QString str;
            while(qry.next())
            {
                str = qry.value(qry.record().indexOf("imageId")).toString();
                qDebug() << "EDDSApi:: read imageId: [" + str + "] successfully...";
            }
            return str;
        }
        else
        {
            qDebug() << "EDDSApi:: read imageId failed!";
            return "xxxxxxxxxxxxxxxxx";
        }
    }
    else
    {
        qDebug() << "EDDSApi:: read imageId query broken!";
        return "xxxxxxxxxxxxxxxxx";
    }
}

QString EDDSApi::readEucaImage(QString type)
{
    //QVector <QVector <QString>> eucaImage;
    QJsonObject eucaObject;
    QJsonObject recordObject;
    QJsonArray recordsArray;
    // read data from database file
    QSqlQuery qry;
    QString qry_expression;
    if(type == "*")
    {
        qry_expression = "SELECT * FROM euca_images ORDER BY diseasetype ASC, datetime(lastedit) ASC";
    }
    else
    {
        qry_expression = "SELECT * FROM euca_images WHERE diseasetype LIKE :diseasetype || '%' ORDER BY datetime(lastedit) ASC";
        qDebug() << "ApplyFilter -> " + qry_expression;
    }
    if(qry.prepare(qry_expression)){
        qry.bindValue(":diseasetype", type);
        if(qry.exec())
        {
            qDebug() << "EDDSApi:: Select euca data successfully...";
            int i=0;
            while(qry.next())
            {
                recordObject.insert("imageId", qry.value(qry.record().indexOf("imageId")).toString());
                //qDebug() << "imageId: " + eucaTemp.value(0);
                recordObject.insert("filename", qry.value(qry.record().indexOf("filename")).toString());
                //qDebug() << "filename: " + eucaTemp.value(1);
                recordObject.insert("diseasetype", qry.value(qry.record().indexOf("diseasetype")).toString());
                //qDebug() << "diseasetype: " + eucaTemp.value(2);
                recordObject.insert("stage", qry.value(qry.record().indexOf("stage")).toString());
                recordObject.insert("level", qry.value(qry.record().indexOf("level")).toString());
                recordObject.insert("submitter", qry.value(qry.record().indexOf("submitter")).toString());
                //qDebug() << "submitter: " + eucaTemp.value(3);
                recordObject.insert("submit", qry.value(qry.record().indexOf("submit")).toString());
                //qDebug() << "submit: " + eucaTemp.value(4);
                recordObject.insert("lastedit", qry.value(qry.record().indexOf("lastedit")).toString());
                recordObject.insert("latitude", qry.value(qry.record().indexOf("latitude")).toString());
                recordObject.insert("longitude", qry.value(qry.record().indexOf("longitude")).toString());
                recordObject.insert("elapsetime", qry.value(qry.record().indexOf("elapsetime")).toString());
                //qDebug() << "lastedit: " + eucaTemp.value(5);
                //eucaObject.insert("euca_image", recordObject);
                recordsArray.push_back(recordObject);
                i++;
            }
            eucaObject.insert("euca_image", recordsArray);
            QJsonDocument doc(eucaObject);
            //qDebug() << doc.toJson();
            return doc.toJson();
        }
        else
        {
            qDebug() << "EDDSApi:: Select euca data failed!";
            return "";
        }
    }
    else
    {
        qDebug() << "EDDSApi:: Select euca data query broken!";
        return "";
    }
}

int EDDSApi::countDiseaseType(QString diseaseType)
{
    qDebug()  << "EDDSApi:: Counting disease type of " + diseaseType + " from database...";
    QSqlQuery qry;
    if(qry.prepare("SELECT count(*) FROM euca_images WHERE diseasetype = :diseaseType")){
        qry.bindValue(":diseaseType", diseaseType);
        if(qry.exec())
        {
            int cnt = 0;
            qry.first();
            cnt = qry.value(0).toInt();
            qDebug() << "EDDSApi:: Number of diseasetype: " + cnt;
            return cnt;
        }
        else
        {
            qDebug() << "EDDSApi:: count diseasetype failed!";
            return -1;
        }
    }
    else
    {
        qDebug() << "EDDSApi:: count diseasetype query broken!";
        return -100;
    }
}
