import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:http/http.dart' as http;

GoogleSignIn googleSignIn = GoogleSignIn(scopes: [DriveApi.driveAppdataScope]);
FirebaseAuth auth = FirebaseAuth.instance;


Future<OAuthCredential> getUserCredientials({required GoogleSignInAccount account}) async {
    final googleAuth = await account.authentication;

  return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
}

Future<void> signInWithGoogle() async {
  // if the user is already sign in then reauthenticate silently
  var googleUser = (auth.currentUser != null)
  ?await googleSignIn.signInSilently()
  :await googleSignIn.signIn();

  await auth.signInWithCredential(await getUserCredientials(account: googleUser!));
  
  // initialize the googleUserData class with the user credientials
    GoogleUserData.instance.intialize(
    userUid: googleSignIn.currentUser!.id,
    userEmail: googleSignIn.currentUser!.email,
    userPhotoUrl: googleSignIn.currentUser!.photoUrl,
    googleSignInAccount: googleUser);
}


Future<void> signOutFromGoogle() async {
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
