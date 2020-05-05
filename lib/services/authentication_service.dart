import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();


  User _currentUser;
  User get currentUser => _currentUser;

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    @required String role,
    @required String photo = 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Microsoft_Account.svg/512px-Microsoft_Account.svg.png',
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      _currentUser = User(
        id: authResult.user.uid,
        email: email,
        fullName: fullName,
        userRole: role,
        photo: photo,
      );

      await _firestoreService.createUser(_currentUser);

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    await _populateCurrentUser(user);
    return user != null;
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
    }
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
    _navigationService.navigateTo(LoginViewRoute);
    
    
  }

  Future<String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  getCurrentUser() async {
    return _firebaseAuth.currentUser();
  }

}
