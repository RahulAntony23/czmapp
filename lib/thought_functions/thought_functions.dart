import 'dart:convert';

import '../constants/constants.dart';
import 'package:http/http.dart' as http;

void postthought(int uid, String heading, String description) async {
  var reqBody = {
    "uid": uid,
    "heading": heading,
    "description": description,
  };

  var response = await http.post(Uri.parse('http://10.0.2.2:8080/saveThought'),
      headers: {"Content-Type": "application/json"}, body: jsonEncode(reqBody));

  if (response.statusCode == 200) {
    showMessage("Post Added Successfully");
  }
}

void addlike(int tid, int likes) async {
  int newlikes = likes + 1;

  var response = await http.put(
      Uri.parse('http://10.0.2.2:8080/updatelike?tid=$tid&likes=$newlikes'),
      headers: {"Content-Type": "application/json"});
}

void removelike(int tid, int likes) async {
  int newlikes = likes - 1;

  var response = await http.put(
      Uri.parse('http:////10.0.2.2:8080/updatelike?tid=$tid&likes=$newlikes'),
      headers: {"Content-Type": "application/json"});
}
