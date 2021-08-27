import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/Prefs&Data/backupJson.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:http/http.dart' as http;
import 'package:idealog/customWidget/alertDialog/alertDialogComponents.dart';

GoogleSignIn googleSignIn = GoogleSignIn(scopes: [DriveApi.driveAppdataScope]);
FirebaseAuth auth = FirebaseAuth.instance;

Future<OAuthCredential> getUserCredientials({required GoogleSignInAccount account}) async {
    final googleAuth = await account.authentication;
    return GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
}

/// This will initialize the user's google data if he/she is signed in.
initializeUserGoogleData(){
  var googleUser = auth.currentUser;

  if (googleUser!= null)
    // initialize my custom googleUserData class with the user credientials.
    GoogleUserData.instance.intialize(
    userUid: googleUser.uid,
    userEmail: googleUser.email,
    userPhotoUrl: null,
    googleSignInAccount: null);
  
}
/// Initiate a sign in or sign up with google account. Returns true if it was a success and false if an error occured.
Future<bool> signInWithGoogle() async {

  final Function throwGoogleSigninException = (_)=> throw _GoogleSignInException();
  // if the user is already sign in then reauthenticate silently
  try{
    var googleUser = (auth.currentUser != null)
      ?await googleSignIn.signInSilently().catchError(throwGoogleSigninException)
      :await googleSignIn.signIn().catchError(throwGoogleSigninException);
      

    await auth.signInWithCredential(await getUserCredientials(account: googleUser!)).catchError(throwGoogleSigninException);
    
      // initialize my custom googleUserData class with the user credientials.
      GoogleUserData.instance.intialize(
      userUid: googleSignIn.currentUser!.id,
      userEmail: googleSignIn.currentUser!.email,
      userPhotoUrl: googleSignIn.currentUser!.photoUrl,
      googleSignInAccount: googleUser);

      return true;

    } on Exception catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

Future<void> downloadBackupFileIfAnyExistsThenWriteToDb(BuildContext context) async {
  await BackupJson.instance.initialize();
  // if the user has a file backed up then download it and write to db.
  if(BackupJson.instance.lastBackupFileIfExists != null) {
    showDownloadingDataAlertDialog(context: context);
    await BackupJson.instance.downloadFromDrive();
    
    await Future.delayed(Duration(seconds: 2));
    // remove downloading from drive dialog.
    Navigator.of(context).pop();
    }
}


Future<void> signOutFromGoogle() async {
  await Prefrences.instance.setAutoSync(false);
  GoogleUserData.instance.clearData();
  await googleSignIn.signOut();
  await auth.signOut();
  // delete all the data attached to this google account.
  await IdealogDb.instance.dropAllTablesInDb();
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
class _GoogleSignInException implements Exception{
  String _message = "An error occured during google sign-in";
  
  @override
  String toString() {
    return _message;
  }

  String get message => _message;
}
