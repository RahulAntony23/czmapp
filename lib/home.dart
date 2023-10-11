import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:czmapp/UpUser.dart';
import 'package:czmapp/constants/constants.dart';
import 'package:czmapp/signin.dart';
import 'package:czmapp/thought.dart';
import 'package:czmapp/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  late User user;

  Home({required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<thought> thoughts = [];

  Future<List> fetchthoughts() async {
    var response =
        await http.get(Uri.parse('http://10.0.2.2:8080/getallThoughts'));

    if (response.statusCode == 200) {
      var thoughts = jsonDecode(response.body) as List;
      return thoughts.map((thought) => thought.fromJson(thought)).toList();
    } else {
      throw Exception('Failed to load thoughts');
    }
  }

  // Posting a thought
  TextEditingController _titleController = TextEditingController();
  TextEditingController _PostController = TextEditingController();

  void postthought() async {
    var reqBody = {
      "uid": widget.user.id,
      "heading": _titleController.text,
      "description": _PostController.text
    };

    var response = await http.post(
        Uri.parse('http://10.0.2.2:8080/saveThought'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    if (response.statusCode == 200) {
      showMessage("Post Added Successfully");
    }
  }

  //Intitializing the page controller
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  // Main Widget
  @override
  Widget build(BuildContext context) {
    // Fetching all the thoughts
    fetchthoughts().then((value) {
      setState(() {
        thoughts.addAll(value as Iterable<thought>);
      });
    });
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('CZMAPP'),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SizedBox.expand(
          child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: [
          // Home Page
          ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        thoughts[index].heading,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        thoughts[index].description,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.thumb_up)),
                              Text('Like')
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.comment)),
                              Text('Comment')
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.share)),
                              Text('Share')
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(
                        thickness: 1,
                      )
                    ],
                  ),
                );
              }),

          // Post Page
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 100),
                Text(
                  'New Post',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Post Title'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _PostController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Write a Post'),
                  minLines: 5,
                  maxLines: 9,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      postthought();
                    },
                    child: Text('Post',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255))))
              ],
            ),
          ),

          // Profile Page
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/images/dp.png',
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(height: 10),
                Text('${widget.user.name}',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                SizedBox(height: 10),
                Text('${widget.user.email}',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpUser(user: widget.user)));
                  },
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text('Edit Profile',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 255, 255, 255))),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
      bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavyBarItem(
                icon: Icon(Icons.chat_bubble), title: Text('Post')),
            BottomNavyBarItem(icon: Icon(Icons.person), title: Text('Profile')),
          ]),
    ));
  }
}
