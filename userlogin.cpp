#include "userlogin.h"

UserLogin::UserLogin(QObject *parent) : QObject(parent)
{

}

UserLogin::~UserLogin() {
/*  qDebug() << "Before delete user_";
  if (user_ != nullptr) {
    log_errors_ = false;
    Delete();
  }
  qDebug() << "After delete user_"; */
}

bool UserLogin::Register()
{
    int registerResult;
    qDebug() << "Before register...";    
    Future<User*> register_test_account = auth_->CreateUserWithEmailAndPassword(email(), password());
    registerResult = WaitForFuture(register_test_account, "CreateUserWithEmailAndPassword() to create temp user", kAuthErrorNone, auth_);
    /*user_ = register_test_account.result() ?  *register_test_account.result() : nullptr;
    std::string str;
    if(user_ == nullptr)
    {
        log_message_ = "Can't register new user!";
        return false;
    }
    else
    {
        str = std::string("New ") + email_.c_str() + std::string(" user has been created.");
        log_message_ = str.c_str();
        return true;
     }
    qDebug() << "After register...";*/
    std::string str = std::string("New ") + email_.c_str() + std::string(" user has been created.");
    log_message_ = str.c_str();
    //str = std::string("User ") + email() + std::string(" has been created. Please verify your email before signing in...");
    //log_message_ = str.c_str();
    return true;
}

bool UserLogin::testLogin()
{
    int loginResult;
    Credential email_cred = EmailAuthProvider::GetCredential(email(), password());
    Future<User*> sign_in_cred = auth_->SignInWithCredential(email_cred);
    loginResult = WaitForSignInFuture(sign_in_cred, "Auth::SignInWithCredential() for UserLogin", kAuthErrorNone, auth_);
    if(loginResult == 0)
    {
        return true;
    }
    else
        return false;
}

int UserLogin::Login()
{
    int loginResult;
    Credential email_cred = EmailAuthProvider::GetCredential(email(), password());
    Future<User*> sign_in_cred = auth_->SignInWithCredential(email_cred);
    loginResult = WaitForSignInFuture(sign_in_cred, "Auth::SignInWithCredential() for UserLogin", kAuthErrorNone, auth_);
    if(loginResult == 0)
    {
        if(auth_->current_user()->is_email_verified())
        {
            //const User* const* sign_in_user_ptr = sign_in_cred.result();
            //const User* sign_in_user = sign_in_user_ptr == nullptr ? nullptr : *sign_in_user_ptr;
            //const User* auth_user = auth_->current_user();
            //qDebug() << "user id -> " << sign_in_user->uid().c_str();
            std::string str = std::string("User ") + email_.c_str() + std::string(" signed in successfully!!");
            log_message_ = str.c_str();
            return loginResult;
        }
        else
        {
            auth_->current_user()->SendEmailVerification();
            std::string str = std::string("Please go to email ") + email_.c_str() + std::string(" to activate account!!");
            log_message_ = str.c_str();
            return -1;
        }
    }
    else
    {
        std::string str = std::string("Sign in with ") + email_.c_str() + std::string(" failed. Account does not exists!!!");
        log_message_ = str.c_str();
        return -2;
    }
    //if(loginResult == 0)
    //{
      /*  if(auth_->current_user()->display_name())
        {
            return loginResult;
        }
        else
        {
            log_message_ = "Please verify your provided email before signing in!";
            return 101; // need user verification
        } */
        //Future<User*> result =
        //        auth_->SignInWithEmailAndPasswordLastResult();

        /*if (sign_in_cred.status() == firebase::kFutureStatusComplete) {
              if (sign_in_cred.error() == kAuthErrorNone) {
                  User* user = *sign_in_cred.result();
                if(user != nullptr)
                {
                    qDebug() << "Sign in succeeded for email " << user->email().c_str();
                    return true;
                }
                else
                {
                    qDebug() << "User -> nullptr";
                }
              } else
              {
                qDebug() << "Sign in failed with error " << sign_in_cred.error_message();
                return false;
              }

        }
        else
        {
            qDebug() << "Oh no!!!";
        }*/
    //}
    //return loginResult;
}

void UserLogin::Delete()
{
    if (user_ != nullptr)
    {
      Future<void> delete_future = user_->Delete();
      if (delete_future.status() == ::firebase::kFutureStatusInvalid) {
        Login();
        delete_future = user_->Delete();
      }

      WaitForFuture(delete_future, "User::Delete()", kAuthErrorNone, log_errors_);
    }
    user_ = nullptr;
}

int UserLogin::WaitForFuture(FutureBase future, const char* fn,
                          AuthError expected_error, bool log_error)
{
    // Note if the future has not be started properly.
    if (future.status() == ::firebase::kFutureStatusInvalid)
    {
        qDebug() << "ERROR: Future for " << fn << " is invalid";
        return 2;
    }    
    // Wait for future to complete.
    /*qDebug() << "  Calling ..." << fn;
    int i = 0; */
    while (future.status() == ::firebase::kFutureStatusPending)
    {
        //qDebug() << "Future status -> " << future.status();
        QCoreApplication::processEvents(QEventLoop::ExcludeUserInputEvents,5000);
        /*{
          log_message_ = "Operation time out!";
          qDebug() << log_message_;
          return 3;
        }*/
    }
    std::string str;
    // Log error result.
    if (log_error)
    {
        const AuthError error = static_cast<AuthError>(future.error());
        if (error == expected_error) {
          const char* error_message = future.error_message();

          if (error_message)
          {
            str = std::string("User ") + email_.c_str() + std::string(" has signed in.");
            log_message_ = str.c_str();
            return 0;
          }
          else
          {
            str = std::string(fn) + std::string(" completed as expected, error: ") /*+ error*/ + std::string(" '") + std::string(error_message) + std::string("'");
            log_message_ = str.c_str();
            return 4;
          }
        }
        else
        {
            //str = future.error_message();
            log_message_ = future.error_message();
            return 5;
        }
      }
}

int UserLogin::WaitForSignInFuture(Future<User*> sign_in_future, const char* fn, AuthError expected_error, Auth* auth)
{
    std::string str;
    if (WaitForFuture(sign_in_future, fn, expected_error) == 0)
    {
        return 0;
    }

    const User* const* sign_in_user_ptr = sign_in_future.result();
    const User* sign_in_user = sign_in_user_ptr == nullptr ? nullptr : *sign_in_user_ptr;
    const User* auth_user = auth->current_user();

    if (sign_in_user != auth_user)
    {
        qDebug() << "ERROR: future's user (" << static_cast<int>(reinterpret_cast<intptr_t>(sign_in_user)) << ") and current_user (" << static_cast<int>(reinterpret_cast<intptr_t>(auth_user)) << ") don't match";
    }

    const bool should_be_null = expected_error != kAuthErrorNone;
    const bool is_null = sign_in_user == nullptr;
    if (should_be_null != is_null)
    {
        qDebug() << "ERROR: user pointer (" << static_cast<int>(reinterpret_cast<intptr_t>(auth_user)) << ") is incorrect";
        //str = std::string("Account's email") + email_.c_str() + std::string("is not verified. Please go to your email to verify the account.");
    }
    return -1;
}
