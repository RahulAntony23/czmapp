import 'dart:convert';
import 'dart:math';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:czmapp/UpUser.dart';
import 'package:czmapp/constants/constants.dart';
import 'package:czmapp/signin.dart';
import 'package:czmapp/thought.dart';
import 'package:czmapp/user.dart';
import 'package:flutter/material.dart';
import 'thought_functions/thought_functions.dart';
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

  List<thought> allthoughts = [];

  Future<List<thought>> fetchthoughts() async {
    var response =
        await http.get(Uri.parse('http://10.0.2.2:8080/getallThoughts'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      for (Map i in data) {
        thought t = thought(
            tid: i['tid'],
            uid: i['uid'],
            heading: i['heading'],
            description: i['description'],
            likes: i['likes'],
            isLiked: false);
        allthoughts.add(t);
      }
      return allthoughts;
    } else {
      return allthoughts;
    }
  }

  // Posting a thought
  TextEditingController _titleController = TextEditingController();
  TextEditingController _PostController = TextEditingController();

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
          // Home Page (Thoughts) Page View
          Container(
            child: FutureBuilder<List<thought>>(
                future: fetchthoughts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Color.fromARGB(255, 0, 0, 0))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${snapshot.data![index].heading}',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${snapshot.data![index].description}',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 1, 1, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if (snapshot.data![index].isLiked ==
                                              false) {
                                            addlike(snapshot.data![index].tid,
                                                snapshot.data![index].likes);
                                            snapshot.data![index].isLiked =
                                                true;
                                            showMessage("Post Liked");
                                          } else if (snapshot
                                                  .data![index].isLiked ==
                                              true) {
                                            removelike(
                                                snapshot.data![index].tid,
                                                snapshot.data![index].likes);
                                            snapshot.data![index].isLiked =
                                                false;
                                            showMessage("Post Unliked");
                                          }
                                        },
                                        icon: Icon(
                                          Icons.thumb_up,
                                          color: snapshot.data![index].isLiked
                                              ? const Color.fromARGB(
                                                  255, 0, 0, 0)
                                              : const Color.fromARGB(
                                                  255, 109, 109, 109),
                                        )),
                                    Text(
                                      '${snapshot.data![index].likes}',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.comment,
                                          color: Color.fromARGB(
                                              255, 109, 109, 109),
                                        )),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.share,
                                          color: Color.fromARGB(
                                              255, 109, 109, 109),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    );
                  }
                }),
          ),

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
                GestureDetector(
                  onTap: () {
                    postthought(widget.user.id, _titleController.text,
                        _PostController.text);
                    _titleController.clear();
                    _PostController.clear();
                  },
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text('Post',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
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

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                activeColor: Color.fromARGB(255, 0, 0, 0),
                inactiveColor: Color.fromARGB(255, 138, 138, 138)),
            BottomNavyBarItem(
                icon: Icon(Icons.chat_bubble),
                title: Text('Post'),
                activeColor: Color.fromARGB(255, 0, 0, 0),
                inactiveColor: Color.fromARGB(255, 138, 138, 138)),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
                activeColor: Color.fromARGB(255, 0, 0, 0),
                inactiveColor: Color.fromARGB(255, 138, 138, 138)),
          ]),
    ));
  }
}
