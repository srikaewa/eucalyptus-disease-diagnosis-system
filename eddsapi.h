#ifndef EDDSAPI_H
#define EDDSAPI_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QHttpPart>
#include <QEventLoop>
#include <QFile>
#include <QStringBuilder>
#include <QStandardPaths>
#include <QtSql>
#include <QtAndroidExtras>

class EDDSApi : public QObject, QAndroidActivityResultReceiver
{
    Q_OBJECT
    Q_PROPERTY(QString fileNameFromGallery READ fileNameFromGallery WRITE setFileNameFromGallery NOTIFY fileNameFromGalleryChanged)
public:
    explicit EDDSApi(QObject *parent = 0);

    QString fileNameFromGallery() const;
    void setFileNameFromGallery(const QString &fileNameFromGallery);

    Q_INVOKABLE int sendImageFile(QString file_path, QString submitter, QString latitude, QString longitude, QString serverIP);
    Q_INVOKABLE int sendImageFile2(QString file_path, QString submitter, QString serverIP);
    Q_INVOKABLE QByteArray readImageFile(QString file_path);
    Q_INVOKABLE QString getImageFileName(QString file_path);
    Q_INVOKABLE QString getImageFilePath(QString file_path);
    Q_INVOKABLE QString getImageFilePath2(QString file_path, QString file_name);
    Q_INVOKABLE QString getDefaultImagePath();
    Q_INVOKABLE QString getDefaultHomePath();
    Q_INVOKABLE QString getFileExtension(QString file_path);
    QByteArray buildUploadString(QString file_path);
    Q_INVOKABLE bool copyFile(QString original_file_path, QString destination_directory);
    Q_INVOKABLE bool deleteFile(QString filename);
    Q_INVOKABLE int postData(QString json_str);

    Q_INVOKABLE bool isFileUploaded(QString filename);
    Q_INVOKABLE bool isFileProcessed(QString filename);

    Q_INVOKABLE QString getDiseaseType(QString imageId);
    Q_INVOKABLE QStringList getDiseaseList();
    Q_INVOKABLE int getDiseaseTypeNumber();
    Q_INVOKABLE QString getDateList(QString type);

    void connectDB();

    Q_INVOKABLE bool saveEucaImage(QString imageId, QString filename, QString originalfilename, QString displayfilename, QString uploaded, QString diseasetytpe,QString submitter, QString submit, QString lastedit, QString latitude, QString longitude);
    Q_INVOKABLE bool deleteEucaImage(QString imageId);
    Q_INVOKABLE bool updateEucaImageId(QString imageId, QString fileName);
    Q_INVOKABLE bool updateEucaImageFileUpload(QString filename, QString uploaded, QString diseasetype);
    Q_INVOKABLE bool updateEucaImageFileProcess(QString imageId, QString processed);
    Q_INVOKABLE QString readEucaImageIdFromFile(QString filename);
    Q_INVOKABLE QString readEucaImage(QString type);
    Q_INVOKABLE QString readEucaImage(QString type, QString fdate);
    Q_INVOKABLE bool updateDiseaseType2Filename(QString filename, QString diseaseType, QString stage, QString level, QString elapsetime);
    Q_INVOKABLE bool updateDiseaseType(QString imageId, QString diseaseType, QString stage, QString level, QString lastedit, QString elapsetime);
    Q_INVOKABLE QString readDiseaseType(QString imageId);
    Q_INVOKABLE int countDiseaseType(QString diseaseType);
    Q_INVOKABLE int readSendFileCount(QString filename);
    Q_INVOKABLE bool setSendFileCount(QString filename, QString count);
    Q_INVOKABLE int readRunClassifyCount(QString imageId);
    Q_INVOKABLE bool setRunClassifyCount(QString imageId, QString count);
    Q_INVOKABLE void setSubmitter(QString submitter);

    Q_INVOKABLE QString getBuildNumber();

    Q_INVOKABLE void buscaImagem();
    QString m_fileNameFromGallery;

    virtual void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data);

    QSqlDatabase m_db;
    bool m_dbstatus;

    bool m_fileUploaded = false;
    bool m_fileProcessed = false;
    QString m_diseaseType = "x";
    QList<QString> m_diseaseList;
    QList<QString> m_dateList;
    int m_diseaseTypeNumber;
    QString m_submitter;

    QString m_buildNumber = "201708201109";

//    QString m_selectedFileName = "#";


signals:
    void onGalleryFileNameReceived(QString);
    void fileNameFromGalleryChanged();


public slots:
    void sendFileReply(QNetworkReply* nr);

};

#endif // EDDSAPI_H
