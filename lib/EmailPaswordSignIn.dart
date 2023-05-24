import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailPaswordSignIn extends StatefulWidget {
  const EmailPaswordSignIn({Key? key}) : super(key: key);

  @override
  State<EmailPaswordSignIn> createState() => _EmailPaswordSignInState();
}

class _EmailPaswordSignInState extends State<EmailPaswordSignIn> {
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: Email,
              )),
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: Password,
              )),

          ElevatedButton.icon(onPressed: () async {
            try {
              final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: Email.text,
                  password: Password.text
              );
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                print('No user found for that email.');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No user found for that email.")));

              } else if (e.code == 'wrong-password') {
                print('Wrong password provided for that user.');

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("'Wrong password provided for that user.")));

              }
            }

          }, icon: Icon(Icons.email), label: Text("Sign In"))
        ],
      ),
    );
  }
}
