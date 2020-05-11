import 'package:compound/provider/user_provider.dart';
import 'package:compound/ui/views/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:provider/provider.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';
import 'locator.dart';

void main() {
  // Register all the models and services before the app starts
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      
        //ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        
        create: (context) => UserProvider(),
      
      child: MaterialApp(
        builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
        title: "HelpApp",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        navigatorKey: locator<NavigationService>().navigationKey,
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 9, 202, 171),
        backgroundColor: Color.fromARGB(255, 26, 27, 30),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
            ),
        ),
        home: StartUpView(),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}