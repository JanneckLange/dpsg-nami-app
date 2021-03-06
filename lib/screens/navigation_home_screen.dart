import 'package:flutter/material.dart';
import 'package:nami/screens/mitgliedsliste/mitglied_liste.dart';
import 'package:nami/screens/statistiken/statistiken_sceen.dart';
import 'package:nami/utilities/custom_drawer/drawer_user_controller.dart';
import 'package:nami/utilities/custom_drawer/home_drawer.dart';

class NavigationHomeScreen extends StatefulWidget {
  const NavigationHomeScreen({Key? key}) : super(key: key);

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.mitglieder;
    screenView = const MitgliedsListe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.mitglieder) {
        setState(() {
          screenView = const MitgliedsListe();
        });
      } else if (drawerIndex == DrawerIndex.stats) {
        setState(() {
          screenView = const StatistikScreen();
        });
      } else {
        // Hier alle weiteren Naviagtionspunkte des Seitenmen??s definieren
      }
    }
  }
}
