import 'package:flutter/material.dart';
import 'package:compound/models/option_model.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';


class MenuOptionsScreen extends StatefulWidget {
  @override
  _MenuOptionsScreenState createState() => _MenuOptionsScreenState();
}

class _MenuOptionsScreenState extends State<MenuOptionsScreen> {
  int _selectedOption = 0;

  final NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Settings'),
        leading: FlatButton(
          textColor: Colors.white,
          child: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => navigateToLogIn(),
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            child: Text(
              'HELP',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => navigateToSignUp(),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: options.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return SizedBox(height: 15.0);
          } else if (index == options.length + 1) {
            return SizedBox(height: 100.0);
          }
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10.0),
            width: double.infinity,
            height: 80.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: _selectedOption == index - 1
                  ? Border.all(color: Colors.black26)
                  : null,
            ),
            child: ListTile(
              leading: options[index - 1].icon,
              title: Text(
                options[index - 1].title,
                style: TextStyle(
                  color: _selectedOption == index - 1
                      ? Colors.black
                      : Colors.grey[600],
                ),
              ),
              subtitle: Text(
                options[index - 1].subtitle,
                style: TextStyle(
                  color:
                      _selectedOption == index - 1 ? Colors.black : Colors.grey,
                ),
              ),
              selected: _selectedOption == index - 1,
              onTap: () {
                setState(() {
                  _selectedOption = index - 1;
                });
              },
            ),
          );
        },
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: 80.0,
        color: Color(0xFFF3F3F3),
        child: Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'SAVE & CONTINUE',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(width: 8.0),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 18.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToSettings() {
    _navigationService.navigateTo(SettingsViewRoute);
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(SignUpViewRoute);
  }
  void navigateToLogIn()
  {
    _navigationService.navigateTo(LoginViewRoute);
  }
}
