import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idealog/auth/code/authHandler.dart';
import 'package:idealog/global/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.data != null){
              print(snapshot.data);
            }else{
              print('i am empty');
            }
            
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(tag: 'Logo', child: Image.asset(pathToAppLogo,height: 150.h,width: 150.w,)),
                  SizedBox(height: 20.h),
                  Container(
                    height: 50.h,
                    child: ElevatedButton.icon(
                    onPressed: () async {
                      await signInWithGoogle();
                      Navigator.pushNamed(context, 'AddNewIdea');
                    },
                    icon: Image.asset(pathToGoogleLogo,height: 40.h,width: 40.w,),
                    label: Text('Proceed with Google')),
                  ),
                  ElevatedButton(onPressed: ()=>signOutFromGoogle(), child: Text('Sign out')),
                ],
      ),
            );
          }
        ),));
  }
}