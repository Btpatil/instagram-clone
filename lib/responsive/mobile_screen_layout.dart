import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_providers.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:instagram/models/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  // String username = '';

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getCurrentUser();
  // }

  // void getCurrentUser() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();

  //   print("snap ${snap.data()}");

  //   setState(() {
  //     username = (snap.data() as Map<String, dynamic>)['username'];
  //   });
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   addData();
  //   print('line23');
  // }

  // addData() async {
  //   UserProvider userProvider = Provider.of(context, listen: false);
  //   await userProvider.refreshUser();
  //   print('line28');
  // }
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigatinTap(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homescreens,
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
          ],
          onTap: navigatinTap,
          backgroundColor: mobileBackgroundColor,
        ),
      ),
    );
  }
}
