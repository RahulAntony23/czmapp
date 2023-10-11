import 'dart:convert';

import 'package:czmapp/signup.dart';
import 'package:czmapp/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants/constants.dart';
import 'constants/routes.dart';
import 'home.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late User user1;

  void login(String email, password) async {
    try {
      bool isEmailValid = loginValidation(
          email: emailController.text, password: passwordController.text);

      if (isEmailValid) {
        var reqBody = {
          "email": emailController.text,
          "password": passwordController.text
        };

        var response = await http.post(Uri.parse('http://10.0.2.2:8080/login'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(reqBody));

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body.toString());
          user1 = User(
              id: data['id'],
              name: data['name'],
              email: data['email'],
              password: data['password']);
          Routes.instance.push(
              widget: Home(
                user: user1,
              ),
              context: context);
          showMessage("User Logged In Successfully");
        } else {
          print('failed');
          showMessage("User Logged In Failed");
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Image.asset("assets/images/Logo.png"),
            SizedBox(height: 100),
            Text(
              'Login',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(hintText: 'Password'),
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                login(emailController.text.toString(),
                    passwordController.text.toString());
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text('Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Routes.instance.push(widget: const SignUp(), context: context);
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
