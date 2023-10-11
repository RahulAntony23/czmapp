import 'dart:convert';

import 'package:czmapp/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants/constants.dart';
import 'constants/routes.dart';
import 'home.dart';

class UpUser extends StatefulWidget {
  late User user;

  UpUser({required this.user});

  @override
  State<UpUser> createState() => _UpUserState();
}

class _UpUserState extends State<UpUser> {
  @override
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  late User user1;

  void update() async {
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

      int id = widget.user.id;
      String param = id.toString();

      var response = await http.put(
          Uri.parse('http://10.0.2.2:8080/updateUser?id=$param'),
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
          children: [
            SizedBox(height: 50),
            Text(
              'Enter New Values',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Update Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Update Email',
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
                hintText: 'New Password',
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
                update();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text('Update',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
