import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_providers.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/home_page.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);
  // This widget is the root of your application0.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: lightDynamic ?? _defaultLightColorScheme,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkDynamic ?? _defaultDarkColorScheme,
              useMaterial3: true,
            ),
            themeMode: ThemeMode.dark,
            // home: const ResponsiveLayout(
            //   mobileScreenLayout: MobileScreenLayout(),
            //   webScreenLayout: WebScreenLayout(),
            // ),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const ResponsiveLayout(
                      mobileScreenLayout: MobileScreenLayout(),
                      webScreenLayout: WebScreenLayout(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}


// web       1:375873748608:web:adbcf7fcc14dddeb157065
// android   1:375873748608:android:7dbf4399a92c1384157065
// ios       1:375873748608:ios:7252aabbd941a5be157065
// macos     1:375873748608:ios:55c4bea0158c3809157065