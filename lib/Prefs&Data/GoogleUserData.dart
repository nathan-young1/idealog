import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idealog/auth/code/authHandler.dart';

class GoogleUserData with ChangeNotifier{
  static String? _Email = auth.currentUser?.email;
  static String? _Photo_url = googleSignIn.currentUser?.photoUrl;
  static String? _Uid;

  String? get user_email => _Email;
  String? get user_photo_url => _Photo_url;
  String? get user_uid => _Uid;

  set user_email(String? email){
    _Email = email;
    notifyListeners();
  }

  set user_photo_url(String? photoUrl){
    _Photo_url = photoUrl;
    notifyListeners();
  }

  set user_uid(String? userUid){
    _Uid = userUid;
    notifyListeners();
  }

  GoogleUserData._();

  static final GoogleUserData instance = GoogleUserData._();

  void intialize({
    required userUid,
    required userEmail,
    required userPhotoUrl
  }){
      this.user_uid = userUid;
      this.user_email = userEmail;
      this.user_photo_url = userPhotoUrl;
  }

  void clearData(){
    // clear all the data on user signout
    user_email = null;
    user_photo_url = null;
  }
}