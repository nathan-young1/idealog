import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idealog/authentication/authHandler.dart';

class GoogleUserData with ChangeNotifier{
  static String? _email = googleSignIn.currentUser?.email;
  static String? _photoUrl = googleSignIn.currentUser?.photoUrl;
  static String? _uid;
  GoogleSignInAccount? googleSignInAccount;

  String? get userEmail => _email;
  String? get userPhotoUrl => _photoUrl;
  String? get userUid => _uid;

  set userEmail(String? email){
    _email = email;
    notifyListeners();
  }

  set userPhotoUrl(String? photoUrl){
    _photoUrl = photoUrl;
    notifyListeners();
  }

  set userUid(String? userUid){
    _uid = userUid;
    notifyListeners();
  }

  GoogleUserData._();

  static final GoogleUserData instance = GoogleUserData._();

  void intialize({
    required userUid,
    required userEmail,
    required userPhotoUrl,
    required googleSignInAccount
  }){
      this.userUid = userUid;
      this.userEmail = userEmail;
      this.userPhotoUrl = userPhotoUrl;
      this.googleSignInAccount = googleSignInAccount;
      
  }

  void clearData(){
    // clear all the data on user signout
    userEmail = null;
    userPhotoUrl = null;
    googleSignInAccount = null;
  }
}