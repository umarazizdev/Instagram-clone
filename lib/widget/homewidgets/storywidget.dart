import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/utils/colors.dart';

class StoryWidget extends StatefulWidget {
  StoryWidget({
    super.key,
  });

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('story').snapshots();

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        }

        return Padding(
          padding: EdgeInsets.only(
            left: sc.width * 0.04125,
            top: sc.height * 0.00075,
            bottom: 0,
            right: sc.width * 0.01375,
          ),
          child: SizedBox(
            height: sc.height * 0.154,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const ScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: sc.width * 0.042),
                        child: Stack(
                          children: [
                            Container(
                              height: sc.height * 0.1024,
                              width: sc.width * 0.2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    data['image'],
                                  ),
                                ),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.blue,
                                ),
                                color: whiteclr,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Positioned(
                                bottom: 3,
                                right: 0,
                                child: Container(
                                  height: sc.height * 0.025,
                                  width: sc.width * 0.055,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: blueclr,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      size: sc.height * 0.025,
                                      color: whiteclr,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: sc.width * 0.0185,
                          top: sc.height * 0.0065,
                        ),
                        child: Text(
                          box.read('name'),
                          style: const TextStyle(
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: sc.width * 0.042),
                        child: Container(
                          height: sc.height * 0.1024,
                          width: sc.width * 0.2,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                data['image'],
                              ),
                            ),
                            border: Border.all(
                              width: 2,
                              color: Colors.blue,
                            ),
                            color: whiteclr,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: sc.width * 0.0185,
                          top: sc.height * 0.0065,
                        ),
                        child: Text(
                          data['name'],
                          style: const TextStyle(
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
