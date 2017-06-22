#include "firebaseobject.h"

FirebaseObject::FirebaseObject(QObject *parent) : QObject(parent)
{
    // get main activity
    //QPlatformNativeInterface *interface =            QApplication::platformNativeInterface();
    //m_act = (jobject)interface->nativeResourceForIntegration("QtActivity");
    m_act = QtAndroid::androidActivity();
    if(!m_act.isValid())
        qDebug()<<"CLASS NOT VALID!!!!!!!!";
    else{
        qDebug()<<"HURAY!";
        jobject activity = (jobject)m_act.object<jobject>();
        qDebug() << "Start registering user...";
        #if defined(__ANDROID__)
             qDebug() << "Android Firebase!";
             m_app = App::Create(AppOptions(), m_qjniEnv, activity);
             //qDebug() << "Created the Firebase app -> " << m_app->name();
        #else   // !defined(__ANDROID__)
            qDebug() << "Non-Android Firebase!";
            app = App::Create(AppOptions());
        #endif  // !defined(__ANDROID__)
        qDebug() << "Huray!!!";
    }
    //my_jni_env = qjniEnv.operator JNIEnv *;
    //my_activity = (jobject)activity;

    //m_auth->GetAuth(m_app);
    //firebase::Future<firebase::auth::User*> result = m_auth->SignInWithEmailAndPassword("srikaewa@gmail.com", "123456");
    qDebug() << "Get ready for Firebase!";
    //qDebug() << "Authentication result -> "+m_result.status();

}

QString FirebaseObject::email() const
{
    return m_email;
}

void FirebaseObject::setEmail(const QString &email)
{
    if(m_email!=email)
    {
        m_email = email;
        qDebug()<<"FirebaseObject:: Write email...->"<<m_email;
    }
}

QString FirebaseObject::password() const
{
    return m_password;
}

void FirebaseObject::setPassword(const QString &password)
{
    if(m_password!=password)
    {
        m_password = password;
        qDebug()<<"FirebaseObject:: Write password...->"<<m_password;
    }
}

QString FirebaseObject::logMessage() const
{
    return m_logMessage;
}

void FirebaseObject::setLogMessage(const QString &logMessage)
{
    if(m_logMessage!=logMessage)
    {
        m_logMessage = logMessage;
        qDebug()<<"FirebaseObject:: Write log message...->"<<m_logMessage;
    }
}

bool FirebaseObject::signIn()
{
    //qDebug() << "JNIEnv version -> " + m_qjniEnv->GetVersion();
    /*jobject activity = (jobject)m_act.object<jobject>();
    qDebug() << "Start signing in...";
    #if defined(__ANDROID__)
         qDebug() << "Android Firebase!";
         m_app = App::Create(AppOptions(), m_qjniEnv, activity);
         //qDebug() << "Created the Firebase app -> " << m_app->name();
    #else   // !defined(__ANDROID__)
        qDebug() << "Non-Android Firebase!";
        app = App::Create(AppOptions());
    #endif  // !defined(__ANDROID__)

    m_auth = Auth::GetAuth(m_app); */
    m_auth = Auth::GetAuth(m_app);
    qDebug() << "Entered email -> " << m_email;
    qDebug() << "Entered password -> " << m_password;
    const char *kCustomEmail = m_email.toStdString().c_str();
    const char *kCustomPassword = m_password.toStdString().c_str();
    //Future<User*> sign_in_future = m_auth->SignInWithEmailAndPassword(kCustomEmail, kCustomPassword);
    //Future<User*> sign_in_future = m_auth->SignInWithEmailAndPassword("srikaewa@gmail.com","12345678");
    //WaitForSignInFuture(sign_in_future, "Auth::SignInWithEmailAndPassword() existing email and password", kAuthErrorNone, m_auth);
    UserLogin test_user(m_auth, kCustomEmail, kCustomPassword);
    if(test_user.Login() == 0)
    {
        m_logMessage = test_user.get_logMessage();
        m_signingIn = true;
        return true;
    }
    else
    {
        m_logMessage = test_user.get_logMessage();
        m_signingIn = false;
        return false;
    }
        //qDebug() << "Login user -> " << test_user.user()->email().c_str();
    // Test SignOut() after signed in with email and password.
/*    if (sign_in_future.status() == ::firebase::kFutureStatusComplete)
    {
        m_auth->SignOut();
        if (m_auth->current_user() != nullptr)
        {
            qDebug() << "ERROR: current_user() returning " << m_auth->current_user() << "instead of NULL after SignOut()";
        }
     }
*/

}

bool FirebaseObject::signOut()
{
    if (m_auth->current_user() == nullptr) {
      m_logMessage = "No user signed in at creation time.";
    } else {
      m_logMessage = "User " + m_email + " has signed out." ;
      m_auth->SignOut();
      m_signingIn = false;
    }
}

bool FirebaseObject::checkUserSignIn()
{
    qDebug() << "Check user sign in...";
    //Future<User*> sign_in_future = m_auth->SignInWithEmailAndPasswordLastResult();
    //Future<User*> sign_in_future = m_auth->SignInWithEmailAndPassword("edds.eucalyptus.technology@gmail.com","edds@12345678");
    //WaitForSignInFuture(sign_in_future, "Auth::SignInWithEmailAndPassword() existing email and password", kAuthErrorNone, m_auth);
    //const User* const* sign_in_user_ptr = sign_in_future.result();
    //const User* sign_in_user = sign_in_user_ptr == nullptr ? nullptr : *sign_in_user_ptr;
    //QString user_disp_name = sign_in_user->display_name().c_str();
    //const char* str = sign_in_user->display_name().c_str();
    //qDebug() << "Sign in future -> " << sign_in_user;

/*    m_auth = Auth::GetAuth(m_app);
    qDebug() << "Entered email -> " << m_email;
    qDebug() << "Entered password -> " << m_password;
    const char *kCustomEmail = m_email.toStdString().c_str();
    const char *kCustomPassword = m_password.toStdString().c_str();
    // check if the account exists
    UserLogin test_user(m_auth, kCustomEmail, kCustomPassword);

    if(!test_user.testLogin())
    {
        m_logMessage = "Account " + email() + " already signed in...";
        m_signingIn = true;
        return true;
    }
    else
    {
        m_logMessage = "Account " + email() + " not signing in...";
        m_signingIn = false;
        return m_signingIn;
    }*/
    return m_signingIn;
}

bool FirebaseObject::registerUser()
{
    m_auth = Auth::GetAuth(m_app);
    qDebug() << "Entered email -> " << m_email;
    qDebug() << "Entered password -> " << m_password;
    const char *kCustomEmail = m_email.toStdString().c_str();
    const char *kCustomPassword = m_password.toStdString().c_str();
    // check if the account exists
    UserLogin test_user(m_auth, kCustomEmail, kCustomPassword);

    if(test_user.testLogin())
    {
        m_logMessage = "Account " + email() + " already exists...";
        return false;
    }

    qDebug() << "Start registering process...";
    if(test_user.Register() == true)
    {
        m_logMessage = test_user.get_logMessage();
        return true;
    }else
    {
        m_logMessage = test_user.get_logMessage();
        return false;
    }
    return true;
}

bool FirebaseObject::connectDB()
{
    // get firebase database ready
    m_database->GetInstance(m_app);
    m_dbref = m_database->GetReference("eucalyptus-diagnosis-system").PushChild();
    m_dbref.Child("users").Child("user").Child("email").SetValue("edds@gmail.com");
    //m_dbref = m_database->GetReference();
    return true;
}
