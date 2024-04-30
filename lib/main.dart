import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/user_data.dart';
import 'package:reptile_scanner/pages/about_page.dart';
import 'package:reptile_scanner/pages/breeding_list_page.dart';
import 'package:reptile_scanner/pages/colony_list_page.dart';
import 'package:reptile_scanner/pages/dashboard_page.dart';
import 'package:reptile_scanner/pages/error_screen.dart';
import 'package:reptile_scanner/pages/feeder_list_page.dart';
import 'package:reptile_scanner/pages/incubator_list_page.dart';
import 'package:reptile_scanner/pages/landing_page.dart';
import 'package:reptile_scanner/pages/my_pets_page.dart';
import 'package:reptile_scanner/pages/profile_page.dart';
import 'package:reptile_scanner/pages/qr_scan_screen.dart';
import 'package:reptile_scanner/pages/setting_page.dart';
import 'package:reptile_scanner/pages/species_list_page.dart';
import 'package:reptile_scanner/pages/splash_screen.dart';
import 'package:reptile_scanner/pages/todo_page.dart';
import 'package:reptile_scanner/services/auth.dart';
import 'package:reptile_scanner/services/database.dart';
import 'package:reptile_scanner/services/home_page_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<Auth>(
                  create: (context) => Auth(),
                ),
                ChangeNotifierProxyProvider<Auth, Database>(
                    create: (context) => FirestoreDatabase(),
                    update: (ctx, auth, _) {
                      return FirestoreDatabase(
                        uid: auth.currentUser == null
                            ? ''
                            : auth.currentUser!.uid,
                      );
                    }),
                StreamProvider<UserData>(
                  create: (context) {
                    Database db = Provider.of<Database>(context, listen: false);
                    return db.userDataStream();
                  },
                  initialData: UserData(
                    uid: '',
                    userName: '',
                    currency: 'USD',
                    weightUnit: WeightUnit.g,
                    lengthUnit: LengthUnit.cm,
                    exp: 0,
                  ),
                ),
                ChangeNotifierProvider<HomePageBloc>(
                  create: (context) => HomePageBloc(),
                ),
              ],
              child: MaterialApp(
                  title: 'Exotic Pet Manager',
                  debugShowCheckedModeBanner: false,
                  home: WillPopScope(
                    onWillPop: _onWillPop,
                    child: const LandingPage(),
                  ),
                  routes: {
                    DashboardPage.routeName: (context) => const DashboardPage(),
                    MyPetsPage.routeName: (context) => const MyPetsPage(),
                    QRScanScreen.routeName: (context) => const QRScanScreen(),
                    SettingPage.routeName: (context) => const SettingPage(),
                    SpeciesListPage.routeName: (context) =>
                        const SpeciesListPage(),
                    FeederListPage.routeName: (context) =>
                        const FeederListPage(),
                    ColonyListPage.routeName: (context) =>
                        const ColonyListPage(),
                    ToDoPage.routeName: (context) => const ToDoPage(),
                    ProfilePage.routeName: (context) => const ProfilePage(),
                    BreedingListPage.routeName: (context) =>
                        const BreedingListPage(),
                    IncubatorListPage.routeName: (context) =>
                        const IncubatorListPage(),
                    AboutPage.routeName: (context) => const AboutPage(),
                  }),
            );
          } else if (snapshot.hasError) {
            return const MaterialApp(home: Scaffold(body: ErrorScreen()));
          } else {
            return const MaterialApp(home: Scaffold(body: SplashScreen()));
          }
        });
  }

  DateTime? currentBackPressTime;

  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          textColor: Colors.black,
          backgroundColor: Colors.grey[300],
          msg: 'Press back again to exit');
      return Future.value(false);
    }

    return Future.value(true);
  }
}
