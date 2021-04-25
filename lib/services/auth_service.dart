import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final googleSignin = GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/youtube']);

  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);

  Stream<User> get currentUser => _auth.authStateChanges();

  Future<void> logout() => _auth.signOut();

  void login() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      //Firebase Sign in
      final result = await signInWithCredential(credential);
    } catch (error) {
      print(error);
    }
  }
}
