import 'dart:developer';

import 'package:chat_app_example/extentions/build_context_extention.dart';
import 'package:chat_app_example/model/users.dart';
import 'package:chat_app_example/screens/chat_screen.dart';
import 'package:chat_app_example/screens/login_screen.dart';
import 'package:chat_app_example/model/users.dart';
import 'package:chat_app_example/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_example/styles/constantStyles.dart';

class RegistrationScren extends StatefulWidget {
   RegistrationScren({super.key});

  @override
  State<RegistrationScren> createState() => _RegistrationScrenState();
}

class _RegistrationScrenState extends State<RegistrationScren> {
  final nameController = TextEditingController();

  final passwordController = TextEditingController();

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column
    (
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Register now',
        style: textStyle, 
        ),
         CustomTextfield(
          hintText: 'Name', icon: Icons.person, isPassword: false, controller: nameController,),

         CustomTextfield(
          hintText: 'Email', icon: Icons.email, isPassword: false, controller: emailController, ),

           CustomTextfield(
          hintText: 'Password', icon: Icons.lock, isPassword: true, controller: passwordController, ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: ElevatedButton(onPressed: (){
              registorNewUser();
             }, child: Text("Registor Now")),
           ),

          GestureDetector(
            onTap: () =>{
              Navigator.pop(context)
              
                       },
                          child: const Text('Already user? Click here to log in'),
)
         

         




    ],
    ),

    );
  }

  Future<void> registorNewUser() async{
    final email = emailController.text;
    final password = passwordController.text;
    if(email.isNotEmpty && password.isNotEmpty){
     await FirebaseAuth.instance.
    createUserWithEmailAndPassword(email: email, password: password)
    .then((value){ 
      log(value.user!.uid);
      addDataToDataBase(uid: value.user!.uid);
  
    });
  }
}

Future<void> addDataToDataBase({required String uid}) async{
  final user = Users(
    nameController.text,
    emailController.text,
     uid,
     passwordController.text,
     
     true,

     'say cheese');

  FirebaseFirestore.instance
  .collection('users')
  .add(user.toJson())
  .then((value)
  {
    log('User Created successfully');
    context.navigateToScreen(const ChatScreen(),isReplace : true);

  }).catchError((e)
  {
    log('failed to create user $e');
  });
  
}
}