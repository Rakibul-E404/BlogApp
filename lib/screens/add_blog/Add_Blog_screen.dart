import 'package:blog_app_project/home/Home_screen.dart';
import 'package:blog_app_project/models/blog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({super.key});

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final title = TextEditingController();
  final description = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool loading = false;


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
        title: const Text("Add blog"),
        actions: [
          IconButton(onPressed: (){
            if(formkey.currentState!.validate()){
              setState(() {
                loading = true;
              });
              addBlog();
            }
          }, icon: Icon(Icons.done))
        ],
      ),
      body: loading? Center(child: CircularProgressIndicator(),):
      Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            TextFormField(
              controller: title,
              decoration: const InputDecoration(
                hintText: "Title",
                border: OutlineInputBorder(),
              ),
              validator: (value){
                if(value!.isEmpty){
                  return "Plese enter title";
                }
                return null;
              },
            ),
            const SizedBox(height: 15,),
            TextFormField(
              controller: description,
              maxLines: 10 ,
              decoration: const InputDecoration(
                hintText: "Description",
                border: OutlineInputBorder(),
              ),
              validator: (value){
                if(value!.isEmpty){
                  return "Plese enter description";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }


  addBlog() async{
    final db = FirebaseFirestore.instance.collection("blogs");
    final user = FirebaseAuth.instance.currentUser!;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    Blog blog = Blog(
        id: id,
        userId: user.uid,
        title: title.text,
        desc: description.text,
        createdAt: DateTime.now()
    );
    // await db.doc(id).set(blog.toMap());
    try {
      await db.doc(id).set(blog.toMap());
      setState(() {
        loading = false;
      });
    }on FirebaseException catch(error) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message?? ""),));
    }
  }
}
