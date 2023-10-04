import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/model/searchmodel.dart';
import 'package:instagramclone/view/searchview.dart/followwidget.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void performSearch() {
    final query = searchController.text.trim();

    FirebaseFirestore.instance
        .collection('profile')
        .where('username', isGreaterThanOrEqualTo: query)
        .orderBy('username')
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        searchResults = querySnapshot.docs;
      });
    }).catchError((error) {
      // ignore: avoid_print
      print('Error performing search: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark ? blackclr : whiteclr,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12),
                child: TextFormField(
                  controller: searchController,
                  cursorColor: greyclr,
                  onChanged: (value) => performSearch(),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search",
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(255, 45, 43, 43)
                        : lgreyclr,
                    hintStyle: const TextStyle(
                      fontSize: 14.5,
                      color: greyclr,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: blackclr.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              if (searchResults.isEmpty && searchController.text.isEmpty) ...[
                AlignedGridView.count(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: search.length,
                  crossAxisCount: 3,
                  itemBuilder: (context, index) {
                    final data = search[index];
                    return Container(
                      height: sc.height * 0.25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: const Border(
                          top: BorderSide(width: 1.0, color: whiteclr),
                          bottom: BorderSide(width: 1.0, color: whiteclr),
                          right: BorderSide(width: 1.0, color: whiteclr),
                        ),
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage(data.image)),
                      ),
                    );
                  },
                ),
              ] else if (searchResults.isEmpty) ...[
                const Center(child: Text('No search results found')),
              ] else ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: searchResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    final resultData = searchResults[index];
                    return InkWell(
                      onTap: () {
                        var username = resultData['uid'];
                        context.push('/usersdetailview', extra: username);
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          foregroundImage:
                              NetworkImage(resultData['profilepic']),
                        ),
                        title: Text(resultData['username']),
                        subtitle: Text(resultData['name']),
                        trailing: FollowSearchWidget(
                          followid: resultData['username'],
                          followname: resultData['name'],
                          followpic: resultData['profilepic'],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
