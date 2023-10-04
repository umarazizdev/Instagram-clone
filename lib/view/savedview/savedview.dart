import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../../utils/colors.dart';

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {
  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).brightness == Brightness.dark
                  ? whiteclr
                  : blackclr,
            )),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? blackclr
            : whiteclr,
        elevation: 0,
        title: Text(
          "Saved",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? whiteclr
                : blackclr,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('saved')
                  .where(
                    "hostid",
                    isEqualTo: box.read('uid'),
                  )
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return AlignedGridView.count(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    crossAxisCount: 3,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return InkWell(
                        onTap: () {
                          context.push('/saveddetail');
                        },
                        child: Container(
                          height: sc.height * 0.2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: const Border(
                              top: BorderSide(width: 1.0, color: whiteclr),
                              bottom: BorderSide(width: 1.0, color: whiteclr),
                              right: BorderSide(width: 1.0, color: whiteclr),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                data['image'],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                      child: Text("No Saved Posts Yet!",
                          style: TextStyle(fontSize: 16.5)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
