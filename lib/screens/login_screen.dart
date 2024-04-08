import 'package:chat_app_example/extentions/build_context_extention.dart';
import 'package:chat_app_example/screens/chat_screen.dart';
import 'package:chat_app_example/screens/registration_screen.dart';
import 'package:chat_app_example/styles/constantStyles.dart';
import 'package:chat_app_example/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class loginScreen extends StatefulWidget {
   loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final nameController = TextEditingController();

  final passwordController = TextEditingController();

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column
    (
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Login',style:textStyle ),
          CustomTextfield(
          hintText: 'Email', icon: Icons.email, isPassword: false, controller: emailController, ),

         CustomTextfield(
          hintText: 'Password', icon: Icons.lock, isPassword: true, controller: passwordController, ),
          ElevatedButton(onPressed: (){
            loginUser();
          }, child: const Text('Login')),
          GestureDetector(
            onTap: (){
              context.navigateToScreen(RegistrationScren(),);
              
                       },
                          child: const Text('New user? Create a new  account'),
)




    ],
    ),

    );
  }

  Future<void> loginUser()async
  {
   await  FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
    .then((value)
    {
      context.navigateToScreen(ChatScreen(),isReplace: true);
    });
  }
}

