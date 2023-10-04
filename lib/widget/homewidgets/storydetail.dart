import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/utils/colors.dart';

// ignore: must_be_immutable
class StoryDetail extends StatelessWidget {
  final String detail;
  StoryDetail(this.detail, {super.key});

  CollectionReference users = FirebaseFirestore.instance.collection('story');

  Future<bool> isFirstDocument(String detail) async {
    // Get all documents
    QuerySnapshot allDocuments = await users.get();
    return allDocuments.docs.first.id == detail;
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(detail).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            isFirstDocument(detail).then((isFirst) {
              if (isFirst) {
                return Container(
                  height: sc.height,
                  width: sc.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        data['image'],
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: sc.height * 0.1,
                      left: sc.width * 0.1,
                    ),
                    child: Text(
                      box.read('name'),
                    ),
                  ),
                );
              } else {
                return Container(
                  height: sc.height,
                  width: sc.width,
                  decoration: BoxDecoration(
                    color: blackclr,
                    image: DecorationImage(
                      image: NetworkImage(
                        data['image'],
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: sc.height * 0.055,
                      left: sc.width * 0.1,
                    ),
                    child: Text(
                      data['image'],
                      style: TextStyle(
                        color: whiteclr,
                        fontSize: sc.height * 0.03,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }
            });
          }

          return const Text("");
        },
      ),
    );
  }
}
