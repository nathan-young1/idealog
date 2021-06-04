import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';

FirebaseAuth auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

  // Create a new credential
  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Sign into firebase
  await auth.signInWithCredential(credential);

  // initialize the googleUserData class with the user credientials
  GoogleUserData.instance.user_email = googleUser.email;
  GoogleUserData.instance.user_photo_url = googleUser.photoUrl;
  GoogleUserData.instance.userIdentity = googleUser;
}

signOutFromGoogle() async {
GoogleUserData.instance.clearData();
await _googleSignIn.signOut();
await auth.signOut();
}
