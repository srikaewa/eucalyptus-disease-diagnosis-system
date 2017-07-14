#include "eucaimage.h"

EucaImage::EucaImage(QObject *parent) : QObject(parent)
{

}

QString EucaImage::imageId() const
{
    return m_imageId;
}

void EucaImage::setImageId(const QString &imageId)
{
    if(m_imageId != imageId)
    {
        m_imageId = imageId;
        qDebug() << "imageId changed -> " << m_imageId;
        emit imageIdChanged();
    }
}

QString EucaImage::fileName() const
{
    return m_fileName;
}

void EucaImage::setFileName(const QString &fileName)
{
    if(m_fileName != fileName)
    {
        m_fileName = fileName;
        qDebug() << "fileName changed -> " << m_fileName;
        emit fileNameChanged();
    }
}

bool EucaImage::upLoaded() const
{
    return m_uploaded;
}

void EucaImage::setUpLoaded(const bool &upLoaded)
{
    if(m_uploaded != upLoaded)
    {
        m_uploaded = upLoaded;
        qDebug() << "upLoaded changed -> " << m_uploaded;
        emit upLoadedChanged();
    }
}

bool EucaImage::processed() const
{
    return m_processed;
}

void EucaImage::setProcessed(const bool &processed)
{
    if(m_processed != processed)
    {
        m_processed = processed;
        qDebug() << "processed changed -> " << m_processed;
        emit processedChanged();
    }
}

QString EucaImage::diseaseType() const
{
    return m_diseasetype;
}

void EucaImage::setDiseaseType(const QString &diseaseType)
{
    if(m_diseasetype != diseaseType)
    {
        m_diseasetype = diseaseType;
        qDebug() << "diseaseType changed -> " << m_diseasetype;
        emit diseaseTypeChanged();
    }
}

QString EucaImage::stage() const
{
    return m_stage;
}

void EucaImage::setStage(const QString &stage)
{
    if(m_stage != stage)
    {
        m_stage = stage;
        qDebug() << "stage changed -> " << m_stage;
        emit stageChanged();
    }
}

QString EucaImage::level() const
{
    return m_level;
}

void EucaImage::setLevel(const QString &level)
{
    if(m_level != level)
    {
        m_level = level;
        qDebug() << "level changed -> " << m_level;
        emit levelChanged();
    }
}

QString EucaImage::submitter() const
{
    return m_submitter;
}

void EucaImage::setSubmitter(const QString &submitter)
{
    if(m_submitter != submitter)
    {
        m_submitter = submitter;
        qDebug()  << "submitter changed -> " << submitter;
        emit submitterChanged();
    }
}

QString EucaImage::submit() const
{
    return m_submit;
}

void EucaImage::setSubmit(const QString &submit)
{
    if(m_submit != submit)
    {
        m_submit = submit;
        qDebug() << "submit changed -> " << m_submit;
        emit submitChanged();
    }
}

QString EucaImage::lastEdit() const
{
    return m_lastedit;
}

void EucaImage::setLastEdit(const QString &lastEdit)
{
    if(m_lastedit != lastEdit)
    {
        m_lastedit = lastEdit;
        qDebug() << "lastEdit changed -> " << m_lastedit;
        emit lastEditChanged();
    }
}

void EucaImage::getProcessingStatus(QString serverIP)
{
    m_processed = false;
    // create custom temporary event loop on stack
    QEventLoop eventLoop;

    // "quit()" the event-loop, when the network request "finished()"
    QNetworkAccessManager mgr;
    QObject::connect(&mgr, SIGNAL(finished(QNetworkReply*)), this, SLOT(processingStatusReply(QNetworkReply*)));

    // the HTTP request
    QNetworkRequest req( QUrl( QString("http://" + serverIP + ":9099/runclassify/" + m_imageId) ) );
    //QNetworkRequest req( QUrl( QString("http://172.31.171.16:3000/runclassify/" + m_imageId) ) );
    QNetworkReply *reply = mgr.get(req);
    eventLoop.exec(); // blocks stack until "finished()" has been called
}

void EucaImage::processingStatusReply(QNetworkReply* nr)
{
    QVariant statusCodeV = nr->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    if(statusCodeV.toString() == "200")
    {
        qDebug() << "Processing euca image finised with returned code -> 200";
        QByteArray str = nr->readAll();
        qDebug() << "Processing reply -> " + str;
        QJsonDocument jsonResponse = QJsonDocument::fromJson(str);
        QJsonObject jsonObject = jsonResponse.array().at(0).toObject();
        //qDebug() << "Disease type of -> " + jsonObject.value("diseasetype").toString();
        m_diseasetype = jsonObject.value("diseasetype").toString();
        m_processed = true;
    }
    else
    {
        qDebug() << "Processing failed...-> " + nr->errorString();
        m_processed = false;
    }
}

void EucaImage::getDiseaseType(QString serverIP)
{
    // create custom temporary event loop on stack
    QEventLoop eventLoop;

    // "quit()" the event-loop, when the network request "finished()"
    QNetworkAccessManager mgr;
    QObject::connect(&mgr, SIGNAL(finished(QNetworkReply*)), this, SLOT(getDiseaseTypeReply(QNetworkReply*)));

    // the HTTP request
    QNetworkRequest req( QUrl( QString("http://" + serverIP + ":9099/getDiseaseType/" + m_imageId) ) );
    //QNetworkRequest req( QUrl( QString("http://172.31.171.16:3000/getDiseaseType/" + m_imageId) ) );
    QNetworkReply *reply = mgr.get(req);
    eventLoop.exec(); // blocks stack until "finished()" has been called
}

void EucaImage::getDiseaseTypeReply(QNetworkReply* nr)
{
    QVariant statusCodeV = nr->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    if(statusCodeV.toString() == "200")
    {
        qDebug() << "Get euca image's disease type finised with returned code -> 200";
        QString str = nr->readAll();
        qDebug() << "Processing reply -> " + str;
        //qDebug() << "Disease type of -> " + jsonObject.value("diseasetype").toString();
        m_diseasetype = str;
        qDebug() << "EucaImage diseasetype -> " + m_diseasetype;
    }
    else
    {
        qDebug() << "Get disease type failed...-> " + nr->errorString();
    }
}

QString EucaImage::_getImageId()
{
    return m_imageId;
}

void EucaImage::_setImageId(QString imageId)
{
    m_imageId = imageId;
}

QString EucaImage::_getDiseaseType()
{
    return m_diseasetype;
}

void EucaImage::_setDiseaseType(QString diseaseType)
{
    m_diseasetype = diseaseType;
}
