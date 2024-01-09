import 'package:chat/components/button.dart';
import 'package:chat/components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  //sign user up
  void siginUp() async {
    //montre le cercle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //make oyu password match
    if (passwordTextController.text != confirmpasswordController.text) {
      //pop loading circle
      Navigator.pop(context);
      //display error  message
      displayMessage("Passwords don't match ! ");
      return;
    }
    //try creating the user
    try {
      //cree un utilisateur
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text);
      // after creating the user, create a new document in cloud firestore called Users
      // cree un documents dans le cloud fire appele
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email!)
          .set({
        'username': emailTextController.text.split('@')[0], //initial username
        'bio': 'Emply bio...' // initally empty bio
        //add any additional fields as  needed
      });

      //pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      //show error to user
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const SizedBox(
                    //   height: 50,
                    // ),
                    //logo
                    const Icon(
                      Icons.lock,
                      size: 100,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    //Welcome back message
                    //message de re-bienvenu 
                    Text(
                      "Lets create an account for you",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                    //email textfield
                    //cree un adresse mail 
                    MyTextField(
                      controller: emailTextController,
                      hintText: 'Email',
                      obscuretext: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //password textfield
                    //cree mot de passe
                    MyTextField(
                      controller: passwordTextController,
                      hintText: 'Password',
                      obscuretext: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //confirm votre mot de passe textfield
                    MyTextField(
                      controller: confirmpasswordController,
                      hintText: 'Confirm Password',
                      obscuretext: true,
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    //creatin  d'un comptre buttom
                    MyButton(onTap: siginUp, text: 'Sign Up'),
                    const SizedBox(
                      height: 25,
                    ),
                    // aller faire s'inscription page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " Vous avez un compte !",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "Login now ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
