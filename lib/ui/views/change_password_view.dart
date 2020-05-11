import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/profile_view.dart';
import 'package:compound/ui/widgets/busy_button.dart';
import 'package:compound/ui/widgets/input_field.dart';
import 'package:compound/viewmodels/change_password_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
 
class ChangePasswordView extends StatelessWidget {
  final passwordController = TextEditingController();
  final newPasswordConteoller = TextEditingController();
  final fullNameController = TextEditingController();
  final DialogService _dialogService = locator<DialogService>();
  final BottomAppBar _bottomAppBar=BottomAppBar();
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ChangePasswordViewModel>.withConsumer(
      viewModel: ChangePasswordViewModel(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 150,
                  child: Image.asset('assets/images/title.png'),
                ),
                InputField(
                  placeholder: 'Nytt användarnamn',
                  password: false,
                  controller: fullNameController,
                ),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BusyButton(
                        title: 'Byt Namn',
                        busy: model.busy,
                        onPressed: () {
                          if (fullNameController.text != '') {
                            model.newName(
                              newName: fullNameController.text,
                            );
                           /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileView(),
                              ),
                            );*/
                          } else if (fullNameController.text == '') {
                            _dialogService.showDialog(
                              title: 'Error',
                              description: "Måste ange ett nytt namn",
                            );
                          } else {
                            _dialogService.showDialog(
                              title: 'Error',
                              description: "Error något gick väldigt fel",
                            );
                          }
                        },
                      ),
                    ]),
                verticalSpaceSmall,
                InputField(
                  placeholder: 'Nytt lösenord',
                  password: true,
                  controller: newPasswordConteoller,
                ),
                verticalSpaceSmall,
                InputField(
                  placeholder: 'Skriv ditt nuvarande lösenord',
                  password: true,
                  controller: passwordController,
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BusyButton(
                      title: 'Byt lösenord',
                      busy: model.busy,
                      onPressed: () {
                        if (newPasswordConteoller.text != '' &&
                            fullNameController.text == '' &&
                            passwordController.text != '' &&
                            newPasswordConteoller.text !=
                                passwordController.text &&
                            newPasswordConteoller.text.length >= 6) {
                          model.newPassword(
                            newPassword: newPasswordConteoller.text,
                            oldPassword: passwordController.text,
                          );
                        } else if (newPasswordConteoller.text ==
                            passwordController.text) {
                          print("error");
                          _dialogService.showDialog(
                            title: 'Error',
                            description: "Kan inte ange samma lösenord",
                          );
                        } else if (newPasswordConteoller.text.length >= 6) {
                          print("error");
                          _dialogService.showDialog(
                            title: 'Error',
                            description:
                                "Lösenordet måste vara längre än 6 tecken",
                          );
                        } else {
                          print("error");
                          _dialogService.showDialog(
                            title: 'Error',
                            description: "Måste ange nytt och gammalt lösenord",
                          );
                        }
                      },
                    )
                  ],
                ),
                verticalSpaceMedium,
              ],
            ),
          )),
    );
  }
}