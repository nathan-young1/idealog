import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/Prefs&Data/prefs.dart';

FirebaseAuth auth = FirebaseAuth.instance;
GoogleSignIn googleSignIn = GoogleSignIn();

Future<OAuthCredential> getUserCredientials({required GoogleSignInAccount account}) async {
    final googleAuth = await account.authentication;

  return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
}

Future<void> signInWithGoogle() async {
  // if the user is already sign in then reauthenticate silently
  final googleUser = (auth.currentUser != null)
  ?await googleSignIn.signInSilently()
  :await googleSignIn.signIn();

  await auth.signInWithCredential(await getUserCredientials(account: googleUser!));

  // initialize the googleUserData class with the user credientials
    GoogleUserData.instance.intialize(
    userUid: auth.currentUser!.uid,
    userEmail: googleUser.email,
    userPhotoUrl: googleUser.photoUrl);
}

Future<void> signOutFromGoogle() async {
  await Prefrences.instance.setAutoSync(false);
  GoogleUserData.instance.clearData();
  await googleSignIn.signOut();
  await auth.signOut();
}
