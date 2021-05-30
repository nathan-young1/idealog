import 'package:flutter/material.dart';
import 'package:idealog/auth/code/authHandler.dart';

class GoogleUserData with ChangeNotifier{
  static String? _Email = auth.currentUser?.email;
  static String? _Photo_url = auth.currentUser?.photoURL;

  String? get user_email => _Email ?? null;
  String? get user_photo_url => _Photo_url;

  set user_email(String? email){
    _Email = email;
    notifyListeners();
  }

  set user_photo_url(String? photoUrl){
    _Photo_url = photoUrl;
    notifyListeners();
  }

  GoogleUserData._();

  static final GoogleUserData instance = GoogleUserData._();

  void clearData(){
    // clear all the data on user signout
    user_email = null;
    user_photo_url = null;
  }
}