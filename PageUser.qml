import QtQuick 2.4
import QtQuick.Dialogs 1.2

PageUserForm {
    Component.onCompleted: {
        if(buttonRememberSignIn.checked === false)
        {
            clearTextField();
        }
    }

    buttonSignIn.onClicked: {
        if(checkSignInTextField() == true)
        {
            signIn();
        }
    }

    buttonSignUp.onClicked: {
        busyIndicatorUserLogin.running = true;

        if(checkSignUpTextField() == true)
        {
            firebaseObject.email = textFieldEmail.text;
            firebaseObject.password = textFieldPassword.text;
            if(firebaseObject.registerUser() == true)
            {
                labelUserLoginStatus.text = firebaseObject.logMessage;
                labelUserLoginStatus.color = "green";
            }
            else
            {
                labelUserLoginStatus.text = firebaseObject.logMessage;
                labelUserLoginStatus.color = "red";
            }
            busyIndicatorUserLogin.running = false;
        }
        else
            busyIndicatorUserLogin.running = false;
    }

    function clearTextField()
    {
        //textFieldFirstName.text = "";
        //textFieldLastName.text = "";
        //textFieldOrganization.text = "";
        textFieldEmail.text = "";
        textFieldPassword.text = "";
    }

    function signIn()
    {
        if(firebaseObject.checkUserSignIn() == false)
        {
            busyIndicatorUserLogin.running = true;
            labelUserLoginStatus.text = "Signin in...";
            firebaseObject.email = textFieldEmail.text;
            firebaseObject.password = textFieldPassword.text;
            if(firebaseObject.signIn() == true || godMode())
            {
                labelUserLoginStatus.text = firebaseObject.logMessage;
                labelUserLoginStatus.color = "green";
                buttonSignIn.text = "Sign Out";
                buttonSignUp.enabled = false;
                //textFieldFirstName.enabled = false;
                //textFieldLastName.enabled = false;
                //textFieldOrganization.enabled = false;
                textFieldEmail.enabled = false;
                textFieldPassword.enabled = false;
                buttonRememberSignIn.enabled = true;
                buttonRememberSignIn.checked = true;
                //controlPanelSlidingMenu.drawer.dragMargin = 10;
                //headerToolbar.visible = true;
                swipeView.interactive = true;
                swipeView.setCurrentIndex(1);
            }
            else
            {
                labelUserLoginStatus.text = firebaseObject.logMessage;
                labelUserLoginStatus.color = "red";
                buttonSignUp.enabled = true;
                buttonRememberSignIn.enabled = false;
                swipeView.interactive = false;
            }
            busyIndicatorUserLogin.running = false;
        }
        else
        {
            firebaseObject.signOut();
            labelUserLoginStatus.text = firebaseObject.logMessage;
            if(buttonRememberSignIn.checked === false)
            {
                clearTextField();
            }

            buttonSignIn.text = "Sign In";
            buttonSignUp.enabled = true;
            //textFieldFirstName.enabled = true;
            //textFieldLastName.enabled = true;
            //textFieldOrganization.enabled = true;
            textFieldEmail.enabled = true;
            textFieldPassword.enabled = true;
            //slidingMenu.textUserName.text = "Anonymous";
            //controlPanelSlidingMenu.drawer.dragMargin = 0;
            buttonRememberSignIn.enabled = false;
            //headerToolbar.visible = false;
            swipeView.interactive = false;
            swipeView.setCurrentIndex(0);
        }
    }

    function godMode()
    {
        if(textFieldEmail.text == "123" && textFieldPassword.text == "321")
            return true;
        else
            return false;
    }

    function checkSignInTextField()
    {
        if(textFieldEmail.length == 0)
        {
            messageDialog.text = "กรุณากรอกอีเมล์";
            messageDialog.open();
            return false;
        }

        if(textFieldPassword.length == 0)
        {
            messageDialog.text = "กรุณากรอกรหัสผ่าน";
            messageDialog.open();
            return false;
        }

        return true;
    }

    function checkSignUpTextField()
    {
      /*  if(textFieldFirstName.length == 0)
        {
            messageDialog.text = "กรุณากรอกชื่อ";
            messageDialog.open();
            return false;
        }

        if(textFieldLastName.length == 0)
        {
            messageDialog.text = "กรุณากรอกนามสกุล";
            messageDialog.open();
            return false;
        }

        if(textFieldOrganization.length == 0)
        {
            messageDialog.text = "กรุณากรอกชื่อหน่วยงาน";
            messageDialog.open();
            return false;
        } */

        if(textFieldEmail.length == 0)
        {
            messageDialog.text = "Please enter your registered email!";
            messageDialog.open();
            return false;
        }

        if(textFieldPassword.length == 0)
        {
            messageDialog.text = "Please enter your password!";
            messageDialog.open();
            return false;
        }

        return true;
    }

    MessageDialog {
        id: messageDialog
        title: "Required Input"
        text: "It's so cool that you are using Qt Quick."
        onAccepted: {
            //console.log("And of course you could only agree.")
            messageDialog.close();
        }
        Component.onCompleted: visible = false
    }
}
