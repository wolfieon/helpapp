import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/busy_button.dart';
import 'package:compound/ui/widgets/input_field.dart';
import 'package:compound/viewmodels/change_password_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class ChangePasswordView extends StatelessWidget {
  final passwordController = TextEditingController();
  final newPasswordConteoller = TextEditingController();

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
                  placeholder: 'Nytt lösenord',
                  password: true,
                  controller: newPasswordConteoller,
                ),
                verticalSpaceSmall,
                InputField(
                  placeholder: 'Skriv ditt gammla lösenord för att bekräfta',
                  password: true,
                  controller: passwordController,
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BusyButton(
                      title: 'Change password',
                      busy: model.busy,
                      onPressed: () {
                        model.newPassword(
                          newPassword: newPasswordConteoller.text,
                          oldPassword: passwordController.text,
                        );
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
