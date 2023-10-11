import 'dart:convert';

import 'package:czmapp/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:czmapp/constants/constants.dart';
import 'package:czmapp/signin.dart';

import 'constants/routes.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  late User user1;

  void register() async {
    bool isValidated = signUpValidation(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text);

    if (isValidated) {
      var reqBody = {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text
      };

      var response = await http.post(Uri.parse('http://10.0.2.2:8080/register'),
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
        showMessage("User Registered Successfully");
      }
    }
  }

  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                register();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text('Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Routes.instance
                    .push(widget: const SignInScreen(), context: context);
              },
              child: const Text('Already have an account? Login'),
            ),
            SizedBox(height: 50),
            Image.asset(
              "assets/images/Logo.png",
              scale: 4,
            ),
          ],
        ),
      ),
    );
  }
}
