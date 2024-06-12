// import 'dart:io';
// import 'package:blog_app_project/home/Home_screen.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../models/blog.dart';
//
// class AddBlogScreen extends StatefulWidget {
//   const AddBlogScreen({Key? key}) : super(key: key);
//
//   @override
//   _AddBlogScreenState createState() => _AddBlogScreenState();
// }
//
// class _AddBlogScreenState extends State<AddBlogScreen> {
//   final title = TextEditingController();
//   final description = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   bool loading = false;
//   User? user;
//   File? _image;
//
//   @override
//   void initState() {
//     super.initState();
//     if (FirebaseAuth.instance.currentUser != null) {
//       user = FirebaseAuth.instance.currentUser;
//     } else {
//       // Handle the case when the user is not logged in
//     }
//   }
//
//   Future<void> _getImage() async {
//     final imagePicker = ImagePicker();
//     final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedImage != null) {
//         _image = File(pickedImage.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Future<void> addBlog() async {
//     if (formKey.currentState!.validate()) {
//       setState(() {
//         loading = true;
//       });
//
//       final id = "${DateTime.now().millisecondsSinceEpoch}.${_image != null ? _image!.path.split(".").last.trim() : 'default'}";
//       final userName = user?.displayName ?? "admin";
//       final createdAt = DateTime.now();
//       String? imageUrl;
//
//       if (_image != null) {
//         // Upload image to Firebase Storage
//         final storageRef = FirebaseStorage.instance.ref().child('blog_images').child(id);
//         final uploadTask = storageRef.putFile(_image!);
//         await uploadTask.whenComplete(() {});
//
//         // Get download URL of the uploaded image
//         imageUrl = await storageRef.getDownloadURL();
//       }
//
//       // Create blog object with or without image URL
//       final blog = Blog(
//         id: id,
//         userId: user?.uid ?? "Unknown",
//         title: title.text,
//         desc: description.text,
//         name: userName,
//         createdAt: createdAt,
//         imageUrl: imageUrl, // This can be null
//       );
//
//       // Add blog data to Firestore
//       await FirebaseFirestore.instance.collection("blogs").doc(id).set(blog.toMap());
//
//       setState(() {
//         loading = false;
//       });
//
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back_ios_new),
//         ),
//         title: const Text("Add Blog"),
//         actions: [
//           IconButton(
//             onPressed: addBlog,
//             icon: const Icon(Icons.done),
//           ),
//         ],
//       ),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : Form(
//         key: formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(15),
//           children: [
//             TextFormField(
//               controller: title,
//               decoration: const InputDecoration(
//                 hintText: "Title",
//               ),
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return "Please enter title";
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 15),
//             TextFormField(
//               controller: description,
//               maxLines: 10,
//               decoration: const InputDecoration(
//                 hintText: "Description",
//               ),
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return "Please enter description";
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 15),
//             GestureDetector(
//               onTap: _getImage,
//               child: _image != null
//                   ? Image.file(
//                 _image!,
//                 height: 150,
//                 width: MediaQuery.of(context).size.width,
//                 fit: BoxFit.cover,
//               )
//                   : Container(
//                 height: 150,
//                 color: Colors.grey[200],
//                 child: const Center(child: Icon(Icons.camera_alt, size: 50)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
import 'dart:io';
import 'package:blog_app_project/home/Home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/blog.dart';

class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({Key? key}) : super(key: key);

  @override
  _AddBlogScreenState createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final title = TextEditingController();
  final description = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  User? user;
  File? _image;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      user = FirebaseAuth.instance.currentUser;
    } else {
      // Handle the case when the user is not logged in
    }
  }

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> addBlog() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      final userName = user?.displayName ?? "admin";
      final createdAt = DateTime.now();
      String? imageUrl;

      // Create a new document reference with an auto-generated ID
      DocumentReference docRef = FirebaseFirestore.instance.collection("blogs").doc();

      if (_image != null) {
        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('blog_images').child(docRef.id);
        final uploadTask = storageRef.putFile(_image!);
        await uploadTask.whenComplete(() {});

        // Get download URL of the uploaded image
        imageUrl = await storageRef.getDownloadURL();
      }

      // Create blog object with or without image URL
      final blog = Blog(
        id: docRef.id,
        userId: user?.uid ?? "Unknown",
        title: title.text,
        desc: description.text,
        name: userName,
        createdAt: createdAt,
        imageUrl: imageUrl, // This can be null
      );

      // Add blog data to Firestore
      await docRef.set(blog.toMap());

      setState(() {
        loading = false;
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("Add Blog"),
        actions: [
          IconButton(
            onPressed: addBlog,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            TextFormField(
              controller: title,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter title";
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: description,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter description";
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: _getImage,
              child: _image != null
                  ? Image.file(
                _image!,
                height: 150,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 150,
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.camera_alt, size: 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
