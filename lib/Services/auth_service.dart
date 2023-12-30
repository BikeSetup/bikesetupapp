import 'package:bikesetupapp/Pages/google_sign_in.dart';
import 'package:bikesetupapp/Pages/home_page.dart';
//import 'package:bike_setup_v2/Services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // 1. HandleAuthState()

  // 2. SignInWithGoogle()

  // 3. SignOut()

  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return MyHomePage(user: FirebaseAuth.instance.currentUser, bikename: "");
          } else {
            return const LoginPage();
          }
        });
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //Sign Out
  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
