// import 'dart:io';
// import 'package:blog_app_project/home/Home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// class MyProfileScreen extends StatefulWidget {
//   const MyProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   _MyProfileScreenState createState() => _MyProfileScreenState();
// }
//
// class _MyProfileScreenState extends State<MyProfileScreen> {
//   File? _imageFile;
//   String? _userProfileImageUrl;
//   String? _userName;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUserProfileDetails();
//   }
//
//   Future<void> _fetchUserProfileDetails() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       // Fetch profile image URL from the users collection
//       final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
//       final userProfileImageUrl = userDoc['profileImageUrl'] as String?;
//
//       // Fetch user's name from the blogs collection
//       final blogQuery = await FirebaseFirestore.instance
//           .collection('blogs')
//           .where('userId', isEqualTo: currentUser.uid)
//           .limit(1)
//           .get();
//
//       String? userName;
//       if (blogQuery.docs.isNotEmpty) {
//         userName = blogQuery.docs.first['name'] as String?;
//       }
//
//       setState(() {
//         _userProfileImageUrl = userProfileImageUrl;
//         _userName = userName;
//       });
//     }
//   }
//
//   Future<void> _updateProfilePicture(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: source);
//
//     if (pickedImage != null) {
//       final File imageFile = File(pickedImage.path);
//
//       final ref = FirebaseStorage.instance.ref().child('user_profile_images').child('${DateTime.now()}.jpg');
//       await ref.putFile(imageFile);
//       final imageUrl = await ref.getDownloadURL();
//
//       final currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser != null) {
//         await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
//           'profileImageUrl': imageUrl,
//         }, SetOptions(merge: true));
//
//         setState(() {
//           _imageFile = imageFile;
//           _userProfileImageUrl = imageUrl;
//         });
//       }
//     }
//   }
//
//   void _showImageSourceActionSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _updateProfilePicture(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_camera),
//               title: const Text('Camera'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _updateProfilePicture(ImageSource.camera);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
//           },
//           icon: const Icon(Icons.arrow_back_ios_new),
//         ),
//         title: const Text('My Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.grey[200],
//                   backgroundImage: _imageFile != null
//                       ? FileImage(_imageFile!)
//                       : (_userProfileImageUrl != null
//                       ? NetworkImage(_userProfileImageUrl!) as ImageProvider<Object>
//                       : null),
//                   child: _userProfileImageUrl == null && _imageFile == null
//                       ? const Icon(Icons.person, size: 80, color: Colors.grey)
//                       : null,
//                 ),
//                 Positioned(
//                   top: 60,
//                   left: 60,
//                   child: FloatingActionButton(
//                     onPressed: () => _showImageSourceActionSheet(context),
//                     child: const Icon(Icons.camera_alt),
//                     mini: true,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Text(
//               _userName ?? 'User Name',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Other user details',
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
///--------------------------------------------ok up there-------------------------------------------
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
import 'dart:io';
import 'package:blog_app_project/home/Home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  File? _imageFile;
  String? _userProfileImageUrl;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _fetchUserProfileDetails();
  }

  Future<void> _fetchUserProfileDetails() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Fetch user profile details from the users collection
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          final userProfileImageUrl = userData['profileImageUrl'] as String?;
          final userName = userData['userName'] as String?;
          setState(() {
            _userProfileImageUrl = userProfileImageUrl;
            _userName = userName;
          });
        }
      }
    }
  }

  Future<void> _updateProfilePicture(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      final File imageFile = File(pickedImage.path);

      final ref = FirebaseStorage.instance.ref().child('user_profile_images').child('${DateTime.now()}.jpg');
      await ref.putFile(imageFile);
      final imageUrl = await ref.getDownloadURL();

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
          'profileImageUrl': imageUrl,
        }, SetOptions(merge: true));

        setState(() {
          _imageFile = imageFile;
          _userProfileImageUrl = imageUrl;
        });
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _updateProfilePicture(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _updateProfilePicture(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
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
        title: const Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (_userProfileImageUrl != null
                      ? NetworkImage(_userProfileImageUrl!) as ImageProvider<Object>
                      : null),
                  child: _userProfileImageUrl == null && _imageFile == null
                      ? const Icon(Icons.person, size: 80, color: Colors.grey)
                      : null,
                ),
                Positioned(
                  top: 60,
                  left: 60,
                  child: FloatingActionButton(
                    onPressed: () => _showImageSourceActionSheet(context),
                    child: const Icon(Icons.camera_alt),
                    mini: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _userName ?? 'User Name',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Other user details',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
