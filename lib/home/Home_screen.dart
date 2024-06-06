import 'package:blog_app_project/auth/Login_screen.dart';
import 'package:blog_app_project/home/widgets/Item_blog.dart';
import 'package:blog_app_project/models/blog.dart';
import 'package:blog_app_project/screens/add_blog/Add_Blog_screen.dart';
import 'package:blog_app_project/screens/my%20blogs/My_Blog_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyBlogScreen()));
                  },
                    child: const Text("My blogs"),),
                PopupMenuItem(
                  onTap:() async {
                    final auth = FirebaseAuth.instance;
                  await auth.signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen(),), (route) => false);
                  },

              child: const Text("Logout"),)
              ]
          )
        ],
      ),
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection("blogs").snapshots(),
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
        return SizedBox();
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AddBlogScreen()));
        },
        child: const Icon(CupertinoIcons.plus),
      ),
    );
  }
}
