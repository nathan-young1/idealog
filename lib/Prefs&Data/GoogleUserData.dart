import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idealog/auth/code/authHandler.dart';

class GoogleUserData with ChangeNotifier{
  static String? _Email = auth.currentUser?.email;
  static String? _Photo_url = auth.currentUser?.photoURL;
  static GoogleIdentity? _User_Identity;

  String? get user_email => _Email;
  String? get user_photo_url => _Photo_url;
  GoogleIdentity? get userIdentity => _User_Identity;

  set user_email(String? email){
    _Email = email;
    notifyListeners();
  }

  set user_photo_url(String? photoUrl){
    _Photo_url = photoUrl;
    notifyListeners();
  }

  set userIdentity(GoogleIdentity? userIdentity){
    _User_Identity = userIdentity;
    notifyListeners();
  }

  GoogleUserData._();

  static final GoogleUserData instance = GoogleUserData._();

  void clearData(){
    // clear all the data on user signout
    user_email = null;
    user_photo_url = null;
    userIdentity = null;
  }
}