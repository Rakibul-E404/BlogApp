// import 'package:blog_app_project/auth/Login_screen.dart';
// import 'package:blog_app_project/home/Home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final name = TextEditingController();
//   final email = TextEditingController();
//   final password = TextEditingController();
//   final formkey = GlobalKey<FormState>();
//   final auth = FirebaseAuth.instance;
//   bool loading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: Form(
//               key: formkey,
//               child: ListView(
//                 padding: const EdgeInsets.all(15),
//                 children: [
//                   const SizedBox(height: 100,),
//                   Text('Register',
//                       style: Theme.of(context).textTheme.displaySmall),
//                   const Text("Please enter name, e-mail & password to get started."),
//                   const SizedBox(height: 30,),
//                   TextFormField(
//                     controller: name,
//                     decoration: const InputDecoration(
//                       hintText: 'Name',
//                     ),
//                     validator: (value){
//                       if(value!.isEmpty){
//                         return 'Please enter Name';
//                       }
//                       else
//                       {
//                         return null;
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 15,),
//                   TextFormField(
//                     controller: email,
//                     decoration: const InputDecoration(
//                       hintText: 'E-mail',
//                     ),
//                     validator: (value){
//                       if(value!.isEmpty){
//                         return 'Please enter E-mail';
//                       }
//                       else
//                       {
//                         return null;
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 15,),
//                   TextFormField(
//                     obscureText: true,
//                     controller: password,
//                     decoration: const InputDecoration(
//                         hintText: 'Password'
//                     ),
//                     validator: (value){
//                       if(value!.isEmpty){
//                         return 'Please enter Password';
//                       }
//                       else
//                       {
//                         return null;
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 30,),
//                   loading? const Center(child: CircularProgressIndicator(),):
//                   ElevatedButton(
//                     onPressed: (){
//                       if(formkey.currentState!.validate()){
//                         setState(() {
//                           loading = true;
//                         });
//                         StartRegister();
//                       }
//                     },
//                     child: const Text('Register'),
//                   ),
//                   const SizedBox(height: 10,),
//                   OutlinedButton(
//                     onPressed: (){
//                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen(),));
//                     },
//                     child: const Text("Already have an account? Login now"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 15,)
//         ],
//       ),
//
//
//     );
//   }
//
//
//   StartRegister()async{
//     try{
//       final result = await auth.createUserWithEmailAndPassword(email: email.text, password: password.text);
//       await result.user?.updateDisplayName(name.text);
//       setState(() {
//         loading = false;
//       });
//       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
//     }on FirebaseAuthException catch(error){
//       setState(() {
//         loading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message?? ""),));
//     }
//   }
// }
///--------------------------------------------ok up there---------------------------------------
///
///
///
///
import 'package:blog_app_project/auth/Login_screen.dart';
import 'package:blog_app_project/home/Home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: formkey,
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  const SizedBox(height: 100,),
                  Text('Register',
                      style: Theme.of(context).textTheme.displaySmall),
                  const Text("Please enter name, e-mail & password to get started."),
                  const SizedBox(height: 30,),
                  TextFormField(
                    controller: name,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please enter Name';
                      }
                      else
                      {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      hintText: 'E-mail',
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please enter E-mail';
                      }
                      else
                      {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    obscureText: true,
                    controller: password,
                    decoration: const InputDecoration(
                        hintText: 'Password'
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please enter Password';
                      }
                      else
                      {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 30,),
                  loading? const Center(child: CircularProgressIndicator(),):
                  ElevatedButton(
                    onPressed: (){
                      if(formkey.currentState!.validate()){
                        setState(() {
                          loading = true;
                        });
                        startRegister();
                      }
                    },
                    child: const Text('Register'),
                  ),
                  const SizedBox(height: 10,),
                  OutlinedButton(
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen(),));
                    },
                    child: const Text("Already have an account? Login now"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15,)
        ],
      ),
    );
  }

  Future<void> startRegister() async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      final uid = result.user!.uid;
      final userName = name.text;

      // Store user data in 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'userName': userName,
        'email': email.text,
        'profileImageUrl': '', // Initially empty, will be updated when the user uploads a profile picture
      });

      await result.user?.updateDisplayName(userName);

      setState(() {
        loading = false;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? "")),
      );
    }
  }
}
