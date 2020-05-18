
import 'package:compound/ui/views/bottom_nav_view.dart';
import 'package:compound/ui/views/chats_view.dart';
import 'package:compound/ui/views/change_password_view.dart';
import 'package:compound/ui/views/home_view.dart';
import 'package:compound/ui/views/profile_view.dart';
import 'package:compound/ui/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/ui/views/login_view.dart';
import 'package:compound/ui/views/signup_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MyBottomNagivation(),
      );
      
    case SettingsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MenuOptionsScreen(),
      );

      case ChatListRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: Chats(),
      );

    
      case ProfileViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ProfileView(),
      );

    case ChangePasswordViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ChangePasswordView(),
      );  
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
