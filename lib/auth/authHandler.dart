import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:http/http.dart' as http;
import 'package:idealog/settings/code/PremiumClass.dart';

GoogleSignIn googleSignIn = GoogleSignIn(scopes: [DriveApi.driveAppdataScope]);
FirebaseAuth auth = FirebaseAuth.instance;


Future<OAuthCredential> getUserCredientials({required GoogleSignInAccount account}) async {
    final googleAuth = await account.authentication;

  return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
}

/// Initiate a sign in or sign up with google account. Returns true if it was a success and false if an error occured.
Future<bool> signInWithGoogle() async {

  final Function ThrowGoogleSigninException = (_)=> throw GoogleSignInException();
  // if the user is already sign in then reauthenticate silently
  try{
    var googleUser = (auth.currentUser != null)
      ?await googleSignIn.signInSilently().catchError(ThrowGoogleSigninException)
      :await googleSignIn.signIn().catchError(ThrowGoogleSigninException);
      

    await auth.signInWithCredential(await getUserCredientials(account: googleUser!)).catchError(ThrowGoogleSigninException);
    
    // initialize the googleUserData class with the user credientials
      GoogleUserData.instance.intialize(
      userUid: googleSignIn.currentUser!.id,
      userEmail: googleSignIn.currentUser!.email,
      userPhotoUrl: googleSignIn.currentUser!.photoUrl,
      googleSignInAccount: googleUser);

      return true;

    } on GoogleSignInException{
    // show flushbar error occured during google sign-in.
    // then rethrow the exception.
    return false;
  }
}


Future<void> signOutFromGoogle() async {
  // if the user is a premium user, then backup data before sign-out from google.
  if(Premium.instance.isPremiumUser) await IdeaManager.backupIdeasNow();
  
  await Prefrences.instance.setAutoSync(false);
  GoogleUserData.instance.clearData();
  await googleSignIn.signOut();
  await auth.signOut();
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  
  final http.Client _client = new http.Client();

  GoogleAuthClient(this._headers);
  
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

/// A custom exception for when an error occures during google sign-in.
class GoogleSignInException implements Exception{
  String _message = "An error occured during google sign-in";
  
  @override
  String toString() {
    return _message;
  }

  String get message => _message;
}
