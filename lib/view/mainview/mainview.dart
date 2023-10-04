import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagramclone/provider/bottombarprovider.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../utils/colors.dart';
import '../adddataview.dart/adddataview.dart';
import '../homeview/homeview.dart';
import '../profileview/profileview.dart';
import '../searchview.dart/searchview.dart';

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationBarExampleState createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    SearchView(),
    AddDataView(),
    ProfileView(uname: ''),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final Stream<QuerySnapshot> _userimage = FirebaseFirestore.instance
      .collection('profile')
      .where(
        "uid",
        isEqualTo: box.read('uid'),
      )
      .snapshots();
  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<BottomProvider>(context);

    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(appModel.selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: sc.height * 0.0675,
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: appModel.selectedIndex == 0
                  ? Icon(
                      Icons.home,
                      size: sc.height * 0.04,
                    )
                  : Icon(
                      Icons.home_outlined,
                      size: sc.height * 0.04,
                    ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: appModel.selectedIndex == 1
                  ? Icon(
                      Icons.search,
                      size: sc.height * 0.04,
                    )
                  : Icon(
                      Icons.search_outlined,
                      size: sc.height * 0.04,
                    ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: appModel.selectedIndex == 2
                  ? Container(
                      height: sc.height * 0.033,
                      width: sc.width * 0.0605,
                      decoration: BoxDecoration(
                        color: blackclr,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: whiteclr,
                          size: 18,
                        ),
                      ),
                    )
                  : Container(
                      height: sc.height * 0.033,
                      width: sc.width * 0.0605,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? whiteclr
                              : blackclr,
                          width: 1.4,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? whiteclr
                              : blackclr,
                          size: 18,
                        ),
                      ),
                    ),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: StreamBuilder<QuerySnapshot>(
                stream: _userimage,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return AlignedGridView.count(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    crossAxisCount: 1,
                    itemCount:
                        (snapshot.hasData && snapshot.data!.docs.isNotEmpty)
                            ? 1
                            : 0,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return Container(
                        height: sc.height * 0.045,
                        width: sc.width * 0.0825,
                        decoration: BoxDecoration(
                          color: whiteclr,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(data['profilepic']),
                          ),
                          shape: BoxShape.circle,
                          border: appModel.selectedIndex == 3
                              ? Border.all(
                                  width: 1.4,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? whiteclr
                                      : blackclr,
                                )
                              : Border.all(
                                  width: 0,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? whiteclr
                                      : blackclr,
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: appModel.selectedIndex,
          selectedItemColor: Theme.of(context).brightness == Brightness.dark
              ? whiteclr
              : blackclr,
          backgroundColor: whiteclr,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontSize: 0),
          unselectedLabelStyle: const TextStyle(fontSize: 0),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Theme.of(context).brightness == Brightness.dark
              ? whiteclr
              : blackclr,
          onTap: (index) {
            appModel.setIndex(index);
            _onItemTapped(index);
          },
        ),
      ),
    );
  }
}
