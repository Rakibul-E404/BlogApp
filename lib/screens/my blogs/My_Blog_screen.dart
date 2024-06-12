import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../home/Home_screen.dart';
import '../../models/blog.dart';
import 'package:blog_app_project/home/widgets/Item_blog.dart';

import '../add_blog/Add_Blog_screen.dart';

class MyBlogScreen extends StatefulWidget {
  const MyBlogScreen({Key? key}) : super(key: key);

  @override
  _MyBlogScreenState createState() => _MyBlogScreenState();
}

class _MyBlogScreenState extends State<MyBlogScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Blogs"),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("blogs")
            .where("userId", isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!.docs;
            List<Blog> blogs = [];
            for (var element in data) {
              Blog blog = Blog.fromMap(element.data());
              blogs.add(blog);
            }
            return ListView.builder(
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      // Show delete confirmation dialog
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Delete"),
                          content: const Text("Are you sure you want to delete this blog post?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );
                    }
                    return false;
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: ItemBlog(blog: blogs[index]),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      // Delete blog post from Firestore
                      FirebaseFirestore.instance.collection("blogs").doc(blogs[index].id).delete();
                    }
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => const AddBlogScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
///--------------------code is perfect-------------------
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
