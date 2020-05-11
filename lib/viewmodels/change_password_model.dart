import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:flutter/foundation.dart';

import 'base_model.dart';

class ChangePasswordViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future newPassword({
     String newPassword,
     String oldPassword,
  }) async {
    setBusy(true);

    var result= await _authenticationService.updatePassword(
      newPassword: newPassword,
      oldPassword: oldPassword,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'not cool',
          description: 'super not cool',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'mega not cool',
        description: result,
      );
    }
  }

  Future newName({
     String newName,
  }) async {
    setBusy(true);

    var result= await _authenticationService.updateFullName(
      newName: newName,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'error',
          description: 'wrong password',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'mega not cool',
        description: result,
      );
    }
  }

}
