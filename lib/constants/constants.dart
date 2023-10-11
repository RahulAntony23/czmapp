import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showMessage(String message) => Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0);

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Builder(builder: (context) {
      return SizedBox(
        width: 100,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color.fromARGB(255, 0, 191, 83),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text(
                "Please wait....",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }),
  );

  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

String getMessageFromErrorCode(String errorCode) {
  switch (errorCode) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
      return "Email already used. Go to login page.";
    case "account-exists-with-different-credential":
      return "Email already used. Go to login page.";
    case "email-already-in-use":
      return "Email already used. Go to login page.";
    case "ERROR_WRONG_PASSWORD":
      return "Wrong Password ";
    case "wrong-password":
      return "Wrong Password ";
    case "ERROR_USER_NOT_FOUND":
      return "No user found with this email.";
    case "user-not-found":
      return "No user found with this email.";
    case "ERROR_USER_DISABLED":
      return "User disabled.";
    case "user-disabled":
      return "User disabled.";
    case "ERROR_TOO_MANY_REQUESTS":
      return "Too many requests to log into this account.";
    case "operation-noltallowed":
      return "Too many requests to log into this account.";
    case "ERROR_OPERATION_NOT_ALLOWED":
      return "Too many requests to log into this account.";
    case "ERROR_INVALID_ENAIL":
      return "Email address is invalid.";
    case "invalid-email":
      return "Email address is invalid.";
    case "ERROR_USER_NOT_FOUND":
      return "No account found with this email.";
    default:
      return "An undefined Error happened.";
  }
}

bool loginValidation({required String email, required String password}) {
  if (email.isEmpty && password.isEmpty) {
    showMessage("Please enter email and password");
    return false;
  } else if (email.isEmpty) {
    showMessage("Please enter email");
    return false;
  } else if (password.isEmpty) {
    showMessage("Please enter password");
    return false;
  } else {
    return true;
  }
}

bool signUpValidation(
    {required String name, required String email, required String password}) {
  if (name.isEmpty && email.isEmpty && password.isEmpty) {
    showMessage("Please enter name, email and password");
    return false;
  } else if (name.isEmpty && email.isEmpty) {
    showMessage("Please enter name and email");
    return false;
  } else if (name.isEmpty && password.isEmpty) {
    showMessage("Please enter name and password");
    return false;
  } else if (email.isEmpty && password.isEmpty) {
    showMessage("Please enter email and password");
    return false;
  } else if (name.isEmpty) {
    showMessage("Please enter name");
    return false;
  } else if (email.isEmpty) {
    showMessage("Please enter email");
    return false;
  } else if (password.isEmpty) {
    showMessage("Please enter password");
    return false;
  } else {
    return true;
  }
}
