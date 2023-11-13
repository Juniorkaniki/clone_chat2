import 'package:chat/components/drawer.dart';
import 'package:chat/components/text_field.dart';
import 'package:chat/components/wall_post.dart';
import 'package:chat/helper/helper_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //user

  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller

  final textController = TextEditingController();
  //sign user out
  void siginOut() {
    FirebaseAuth.instance.signOut();
  }

  //post message
  void postMessage() {
    // only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      // store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }
    //clear the textfiled
    setState(() {
      textController.clear();
    });
  }

  //navigate to profile
  void goToProfilePage() {
    //pop menu drawer
    Navigator.pop(context);

    //go to
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const ProfilePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "The Wall",
        ),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSiginOut: siginOut,
      ),
      body: Center(
        child: Column(
          children: [
            //the wall
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy(
                      "TimeStamp",
                      descending: false,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        //get the message
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: FormatDate(
                            post['TimeStamp'],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            //post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Write something on the wall...',
                      obscuretext: false,
                    ),
                  ),
                  //POST butt
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),
            // logged in as
            Text("Logged in as " + currentUser.email!),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
