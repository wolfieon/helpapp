import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/user.dart';
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
  final descController = TextEditingController();
  final DialogService _dialogService = locator<DialogService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ChangePasswordViewModel>.withConsumer(
      viewModel: ChangePasswordViewModel(),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Edit Profile ',
                style: TextStyle(color: Colors.black),
              )),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight(context)/50,),
                InputField(
                  placeholder: 'New username',
                  password: false,
                  controller: fullNameController,
                ),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BusyButton(
                        title: 'Change Name',
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
                              description: "You must enter a new name",
                            );
                          } else {
                            _dialogService.showDialog(
                              title: 'Error',
                              description: "Error something went wrong",
                            );
                          }
                        },
                      ),
                    ]),
                verticalSpaceMedium,
                Container(
                  height: 100,
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: descController,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 13,
                  ),
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BusyButton(
                      title: 'Change description',
                      busy: model.busy,
                      onPressed: () {
                        if (descController.text.length < 200) {
                          model.newDesc(
                            newDesc: descController.text,
                          );
                        }
                      },
                    )
                  ],
                ),
                verticalSpaceMedium,
                InputField(
                  placeholder: 'New password',
                  password: true,
                  controller: newPasswordConteoller,
                ),
                verticalSpaceSmall,
                InputField(
                  placeholder: 'Current password',
                  password: true,
                  controller: passwordController,
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BusyButton(
                      title: 'Change password',
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
                            description: "Can't give same password",
                          );
                        } else if (newPasswordConteoller.text.length >= 6) {
                          print("error");
                          _dialogService.showDialog(
                            title: 'Error',
                            description:
                                "Password must be longer than 6",
                          );
                        } else {
                          print("error");
                          _dialogService.showDialog(
                            title: 'Error',
                            description: "Must give new and old password",
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
