#ifndef USERLOGIN_H
#define USERLOGIN_H

#include <QObject>
#include <QDebug>
#include <QThread>
#include <QCoreApplication>

#include "firebase/app.h"
#include "firebase/auth.h"

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

class UserLogin : public QObject
{
    Q_OBJECT
public:
    explicit UserLogin(QObject *parent = 0);
    ~UserLogin();
    bool Register();
    int Login();
    bool testLogin();
    void Delete();
    int WaitForFuture(FutureBase future, const char* fn, AuthError expected_error, bool log_error = true);
    int WaitForSignInFuture(Future<User*> sign_in_future, const char* fn, AuthError expected_error, Auth* auth);

    QString email() const { return email_; }
    QString password() const { return password_; }
    User* user() const { return user_; }
    QString get_logMessage() { return log_message_;}
    void set_email(const char* email) { email_ = email; }
    void set_password(const char* password) { password_ = password; }

    UserLogin(Auth* auth, QString email, QString password)
        : auth_(auth),
          email_(email),
          password_(password),
          user_(nullptr),
          log_errors_(true) {}

    explicit UserLogin(Auth* auth) : auth_(auth) {
      email_ = "edds.eucalyptus.technology@gmail.com";
      password_ = "12345678";
    }


     private:
      Auth* auth_;
      QString email_;
      QString password_;
      User* user_;
      bool log_errors_;
      QString log_message_;
signals:

public slots:
};

#endif // USERLOGIN_H
