import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flashpark_client/Services/FirebaseServices.dart';
import 'package:flashpark_client/verPerfil/perfil.dart';
import 'package:flashpark_client/widgets/ConfigMaps.dart';
import 'package:flashpark_client/widgets/Provider_Widget.dart';
import 'package:flashpark_client/widgets/appData.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'mainPage/mainPage.dart';
import 'constants.dart';
import 'mapScreen/map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    configOneSignel();
  }

  void configOneSignel() {
    OneSignal.shared.init(onekey);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      db: FirebaseFirestore.instance,
      appData: AppData(),
      child: MaterialApp(
          title: 'FlashPark',
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomeController()),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;

          return signedIn ? VerPerfil() : MainPage();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
