import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: SignUpEmailPassword(),
  ));
}

class SignUpEmailPassword extends StatefulWidget {
  const SignUpEmailPassword({Key? key}) : super(key: key);

  @override
  State<SignUpEmailPassword> createState() => _SignUpEmailPasswordState();
}

class _SignUpEmailPasswordState extends State<SignUpEmailPassword> {
  TextEditingController Phonenumber = TextEditingController();
  TextEditingController Otp = TextEditingController();

  // New Add

  String vid = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: Phonenumber,
              )),
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: Otp,
              )),

          // ElevatedButton.icon(onPressed: () async {
          //
          //   try {
          //     final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          //       email: Email.text,
          //       password: Password.text,
          //     );
          //
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       return EmailPaswordSignIn();
          //     },));
          //
          //   } on FirebaseAuthException catch (e) {
          //     if (e.code == 'weak-password') {
          //       print('The password provided is too weak.');
          //     } else if (e.code == 'email-already-in-use') {
          //       print('The account already exists for that email.');
          //     }
          //   } catch (e) {
          //     print(e);
          //   }
          //
          // }, icon: Icon(Icons.email), label: Text("Sign In")),

          ElevatedButton(
              onPressed: () {
                signInWithGoogle().then((value) {
                  print("====$value");
                });
              },
              child: Text("Login With Google")),

          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: '+91${Phonenumber.text}',
                  verificationCompleted: (PhoneAuthCredential credential) {

                  },
                  verificationFailed: (FirebaseAuthException e) {

                  },
                  codeSent: (String verificationId, int? resendToken) {
                    setState(() {
                      vid = verificationId;
                    });

                  },
                  codeAutoRetrievalTimeout: (String verificationId) {

                  },
                );
              },
              child: Text("Mobilenuber Submit")),
          ElevatedButton(onPressed: () async {

            FirebaseAuth auth = FirebaseAuth.instance;

            String smsCode = '${Otp.text}';

            // Create a PhoneAuthCredential with the code
            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: vid, smsCode: smsCode);

            // Sign the user in (or link) with the credential
            await auth.signInWithCredential(credential);
          }, child: Text("Otp Submit"))
        ],
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
