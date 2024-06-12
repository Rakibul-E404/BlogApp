import 'package:blog_app_project/auth/Register_screen.dart';
import 'package:blog_app_project/home/Home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  Text('Login',
                  style: Theme.of(context).textTheme.displaySmall),
                  const Text("Please enter e-mail & password to get started."),
                  const SizedBox(height: 30,),
                  TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      hintText: 'E-mail',
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please enter Email';
                      }
                      else
                        {
                          return null;
                        }
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: password,
                    obscureText: true,
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
                            Startlogin();
                          }
                      },
                      child: Text('Login'),
                  ),
                  const SizedBox(height: 10,),
                  OutlinedButton(
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                    },
                    child: const Text("Don't have an account? Register now"),
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

  Startlogin()async{
    try{
      await auth.signInWithEmailAndPassword(email: email.text, password: password.text);
      setState(() {
          loading = false;
      });
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
    }on FirebaseAuthException catch(error){
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message?? ""),));
    }
  }
}
