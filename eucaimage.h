#ifndef EUCAIMAGE_H
#define EUCAIMAGE_H

#include <QObject>
#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QHttpPart>
#include <QEventLoop>
#include <QByteArray>
#include <QJsonDocument>
#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>

class EucaImage : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString imageId READ imageId WRITE setImageId NOTIFY imageIdChanged)
    Q_PROPERTY(QString fileName READ fileName WRITE setFileName NOTIFY fileNameChanged)
    Q_PROPERTY(bool upLoaded READ upLoaded WRITE setUpLoaded NOTIFY upLoadedChanged)
    Q_PROPERTY(bool processed READ processed WRITE setProcessed NOTIFY processedChanged)
    Q_PROPERTY(QString diseaseType READ diseaseType WRITE setDiseaseType NOTIFY diseaseTypeChanged)
    Q_PROPERTY(QString stage READ stage WRITE setStage NOTIFY stageChanged)
    Q_PROPERTY(QString level READ level WRITE setLevel NOTIFY levelChanged)
    Q_PROPERTY(QString submitter READ submitter WRITE setSubmitter NOTIFY submitterChanged)
    Q_PROPERTY(QString submit READ submit WRITE setSubmit NOTIFY submitChanged)
    Q_PROPERTY(QString lastEdit READ lastEdit WRITE setLastEdit NOTIFY lastEditChanged)
public:
    explicit EucaImage(QObject *parent = 0);

    Q_INVOKABLE void getProcessingStatus();
    Q_INVOKABLE void getDiseaseType();

    Q_INVOKABLE QString _getImageId();
    Q_INVOKABLE void _setImageId(QString imageId);
    Q_INVOKABLE QString _getDiseaseType();
    Q_INVOKABLE void _setDiseaseType(QString diseaseType);

    QString imageId() const;
    void setImageId(const QString &imageId);

    QString fileName() const;
    void setFileName(const QString &fileName);

    bool upLoaded() const;
    void setUpLoaded(const bool &upLoaded);

    bool processed() const;
    void setProcessed(const bool &processed);

    QString diseaseType() const;
    void setDiseaseType(const QString &diseaseType);

    QString stage() const;
    void setStage(const QString &stage);

    QString level() const;
    void setLevel(const QString &level);

    QString submitter() const;
    void setSubmitter(const QString &submitter);

    QString submit() const;
    void setSubmit(const QString &submit);

    QString lastEdit() const;
    void setLastEdit(const QString &lastEdit);

private:
    QString m_imageId;
    QString m_fileName;
    bool m_uploaded = false;
    bool m_processed = false;
    QString m_diseasetype = "x";
    QString m_stage = "0";
    QString m_level = "0";
    QString m_submitter;
    QString m_submit;
    QString m_lastedit;

signals:
    void imageIdChanged();
    void fileNameChanged();
    void upLoadedChanged();
    void processedChanged();
    void diseaseTypeChanged();
    void stageChanged();
    void levelChanged();
    void submitterChanged();
    void submitChanged();
    void lastEditChanged();

public slots:
    void processingStatusReply(QNetworkReply* nr);
    void getDiseaseTypeReply(QNetworkReply* nr);
};

#endif // EUCAIMAGE_H
