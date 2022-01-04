import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notebook/shared/providers.dart';
import 'package:riverpod/riverpod.dart';
import 'package:notebook/databases/study_modes_data.dart';
import 'package:notebook/databases/subjects_data.dart';
import 'package:notebook/shared/shared_prefs.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Authentications {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future registerUser(
      String name, String email, String password, aim, standard, board) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User user = result.user;

      //  user.updatePhotoURL(userImage);

      user.updateDisplayName(name);

      FirebaseFirestore.instance.collection("Users").doc(user.uid).set({
        'name': name,
        'email': email,
        'password': password,
        'id': user.uid,
        'userImage': '',
        'aim': aim,
        'standard': standard,
        'board': board
      });

      StudyModesDatabase s = StudyModesDatabase();
      s.addModes();

      FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .collection("Homeworks");

      FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .collection("Quick Notes");

      UserPreferences.setMode("both");
      UserPreferences.setTT("daily");
      return "Registered";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //sign out the user

  Future logout() async {
    try {
      UserPreferences.clearEverything();
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in user
  Future signIn(String email, String password) async {
    //  List x = [];
    await auth.signInWithEmailAndPassword(email: email, password: password);
    try {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(auth.currentUser.uid)
          .collection("Subjects")
          .get()
          .then((d) {
        d.docs.forEach((element) {
          for (var i in element.get("colors")) {
            print(i);
          }

          SubjectsDatabase()
              .addSubject(element.get("subjectName"), element.get("colors"));
        });
      });

      return "Welcome Back!";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // Future signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     await FirebaseAuth.instance.signInWithCredential(credential);

  //     FirebaseFirestore.instance
  //         .collection("Users")
  //         .doc(FirebaseAuth.instance.currentUser.uid)
  //         .set({
  //       'name': googleUser.displayName,
  //       'email': googleUser.email,
  //       'googleId': googleUser.id,
  //       'FirebaseId': FirebaseAuth.instance.currentUser.uid,
  //       'userImage': googleUser.photoUrl.toString()
  //     });

  //     CollectionReference ref = FirebaseFirestore.instance
  //         .collection("Users")
  //         .doc(auth.currentUser.uid)
  //         .collection("Study Modes");

  //     ref.doc("Beach Mode").set({
  //       "mode": "Beach Mode",
  //       "label": "A chill Topic",
  //       "intensity": 0,
  //       'imageSrc':
  //           "https://i.pinimg.com/originals/65/df/cd/65dfcd4ca6db90665bb3288910464fac.jpg",
  //       'duration': {"hours": 00, "minutes": 15}
  //     });
  //     ref.doc("Revision Mode").set({
  //       "mode": "Revision Mode",
  //       "label": "Strong Revision",
  //       "intensity": 1,
  //       'imageSrc':
  //           "https://i.pinimg.com/originals/68/5b/50/685b509e3759ff589446765ac4223bc8.jpg",
  //       'duration': {"hours": 00, "minutes": 30}
  //     });
  //     ref.doc("Workout Mode").set({
  //       "mode": "Workout Mode",
  //       "label": "Focus Hard",
  //       "intensity": 2,
  //       "imageSrc":
  //           "https://st.depositphotos.com/1695366/1391/v/950/depositphotos_13917373-stock-illustration-cartoon-woman-working-out.jpg",
  //       'duration': {"hours": 1, "minutes": 20}
  //     });
  //     ref.doc("Batman Mode").set({
  //       "mode": "Batman Mode",
  //       "label": "Deep Focus",
  //       "intensity": 3,
  //       "imageSrc":
  //           "https://cdn.vox-cdn.com/thumbor/Jx60U-RgTmEdAj1pTYWgF4bPVeg=/0x0:1200x900/1200x675/filters:focal(506x368:698x560)/cdn.vox-cdn.com/uploads/chorus_image/image/61790177/Screen_Shot_2018_10_15_at_5.48.17_PM.0.png",
  //       'duration': {"hours": 3, "minutes": 00}
  //     });
  //     ref.doc("Super Sayian Mode").set({
  //       "mode": "Super Sayian Mode",
  //       "label": "Deepest Focus",
  //       "intensity": 4,
  //       'imageSrc':
  //           "https://qph.fs.quoracdn.net/main-qimg-43da3131abfc216e219e0a0cca430993",
  //       'duration': {"hours": 4, "minutes": 00}
  //     });

  //     FirebaseFirestore.instance
  //         .collection("Users")
  //         .doc(auth.currentUser.uid)
  //         .collection("Homeworks");

  //     FirebaseFirestore.instance
  //         .collection("Users")
  //         .doc(auth.currentUser.uid)
  //         .collection("Quick Notes");

  //     UserPreferences.setSubjectList();

  //     return;
  //   } on FirebaseAuthException catch (e) {
  //     return e.message.toString();
  //   }
  // }

  // Future signInWithFacebook() async {
  //   try {
  //     final AccessToken result = await FacebookAuth.instance.login();

  //     final facebookAuthCredential =
  //         FacebookAuthProvider.credential(result.token);

  //     User user = (await FirebaseAuth.instance
  //             .signInWithCredential(facebookAuthCredential))
  //         .user;

  //     FirebaseFirestore.instance.collection("Users").doc(user.email).set({
  //       'name': user.displayName,
  //       'email': user.email,
  //       'FirebaseId': auth.currentUser.uid
  //     });
  //     CollectionReference ref = FirebaseFirestore.instance
  //         .collection("Users")
  //         .doc(auth.currentUser.uid)
  //         .collection("Study Modes");

  //     ref.doc("Beach Mode").set({
  //       "mode": "Beach Mode",
  //       "label": "A chill Topic",
  //       "intensity": 0,
  //       'duration': {"hours": 00, "minutes": 15}
  //     });
  //     ref.doc("Revision Mode").set({
  //       "mode": "Revision Mode",
  //       "label": "Strong Revision",
  //       "intensity": 1,
  //       'duration': {"hours": 00, "minutes": 30}
  //     });
  //     ref.doc("Workout Mode").set({
  //       "mode": "Workout Mode",
  //       "label": "Focus Hard",
  //       "intensity": 2,
  //       'duration': {"hours": 1, "minutes": 20}
  //     });
  //     ref.doc("Batman Mode").set({
  //       "mode": "Batman Mode",
  //       "label": "Deep Focus",
  //       "intensity": 3,
  //       'duration': {"hours": 3, "minutes": 00}
  //     });
  //     ref.doc("Super Sayian Mode").set({
  //       "mode": "Super Sayian Mode",
  //       "label": "Deepest Focus",
  //       "intensity": 4,
  //       'duration': {"hours": 4, "minutes": 00}
  //     });

  //     FirebaseFirestore.instance
  //         .collection("Users")
  //         .doc(auth.currentUser.uid)
  //         .collection("Homeworks");

  //     FirebaseFirestore.instance
  //         .collection("Users")
  //         .doc(auth.currentUser.uid)
  //         .collection("Quick Notes");

  //     UserPreferences.setSubjectList();
  //     return "Registered";
  //   } on FirebaseAuthException catch (e) {
  //     return e.message.toString();
  //   }
  // }
}
