import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home/Home_screen.dart';
import '../../home/widgets/Item_blog.dart';
import '../../models/blog.dart';


class MyBlogScreen extends StatefulWidget {
  const MyBlogScreen({super.key});

  @override
  State<MyBlogScreen> createState() => _MyBlogScreenState();
}


class _MyBlogScreenState extends State<MyBlogScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          },
        ),
        title: const Text("My blog"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("blogs").where('userId', isEqualTo: user.uid).snapshots(),
        builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasData && snapshot.data != null){
            final data = snapshot.data!.docs;
            List<Blog> blogs = [];
            for (var element in data) {
              Blog blog = Blog.fromMap(element.data());
              blogs.add(blog);
            }
            return ListView(
              children: [
                for(var blog in blogs)
                // ListTile(
                //   title: Text(blog.title),
                //   subtitle: Text(blog.desc),
                // )

                  ItemBlog(blog: blog)
              ],
            );
          }
          return const SizedBox();
        },
      ),

    );
  }
}
