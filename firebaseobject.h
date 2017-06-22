#ifndef FIREBASEOBJECT_H
#define FIREBASEOBJECT_H

#include <QObject>
#include <QDebug>
#include <QApplication>
#include <QThread>
#include <QString>

#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#include <qpa/qplatformnativeinterface.h>

#include <jni.h>

#include "firebase/app.h"
#include "firebase/auth.h"
#include "firebase/util.h"
#include "firebase/database.h"

using ::firebase::App;
using ::firebase::AppOptions;
using ::firebase::Future;
using ::firebase::FutureBase;
using ::firebase::auth::Auth;
using ::firebase::auth::Credential;
using ::firebase::auth::AuthError;
using ::firebase::auth::kAuthErrorNone;
using ::firebase::auth::kAuthErrorFailure;
using ::firebase::auth::EmailAuthProvider;
using ::firebase::auth::FacebookAuthProvider;
using ::firebase::auth::GitHubAuthProvider;
using ::firebase::auth::GoogleAuthProvider;
using ::firebase::auth::TwitterAuthProvider;
using ::firebase::auth::User;
using ::firebase::auth::UserInfoInterface;

#include "userlogin.h"

class FirebaseObject : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString logMessage READ logMessage WRITE setLogMessage NOTIFY logMessageChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
public:
    explicit FirebaseObject(QObject *parent = 0);

    Q_INVOKABLE bool signIn();
    Q_INVOKABLE bool signOut();
    Q_INVOKABLE bool checkUserSignIn();
    Q_INVOKABLE bool registerUser();

    Q_INVOKABLE bool connectDB();

    QString email() const;
    void setEmail(const QString &email);
    QString password() const;
    void setPassword(const QString &password);
    QString logMessage() const;
    void setLogMessage(const QString &logMessage);

private:
    int WaitForFuture(FutureBase future, const char* fn, AuthError expected_error, bool log_error = true);
    int WaitForSignInFuture(Future<User*> sign_in_future, const char* fn, AuthError expected_error, Auth* auth);

public:
    QAndroidJniEnvironment m_qjniEnv;
    QAndroidJniObject m_act;
    App* m_app;
    Auth* m_auth;
    Auth* m_signed_auth;
    Future<User*> m_result;
    QString m_email;
    QString m_password;
    bool m_signingIn = false;

    UserLogin m_user;
    QString m_logMessage = "Plese sign in...";

    ::firebase::database::Database* m_database;
    firebase::database::DatabaseReference m_dbref;

signals:
    void emailChanged();
    void passwordChanged();
    void logMessageChanged();
public slots:
};

#endif // FIREBASEOBJECT_H
