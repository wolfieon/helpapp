import 'package:cloud_firestore/cloud_firestore.dart';
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
  final db = Firestore.instance;

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
    String photo = 'https://i.ibb.co/tPRRv0v/f1.png',
    int activeEvents=0,
    String desc="",
    int happyCount=0,
    int sadCount=0,
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
        activeEvents: activeEvents,
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
    return (await _firebaseAuth.currentUser());
  }

  Future getCurrentUserId() async {
    FirebaseUser userb = await _firebaseAuth.currentUser();

    final uid = userb.uid;
    //User user = await _firestoreService.getUser(uid);
    return uid;
  }

   Future updateFullName({
    @required String newName,
 
  }) async {
    FirebaseUser userb = await _firebaseAuth.currentUser();
    final uid = userb.uid;
    print(newName);
    print(userb.displayName);
    if (newName != null && newName != '') {
      db.collection('users').document(uid).updateData({'fullName': newName});
      return true;
    }
    else{
      return false;
    }
   
  }
   Future updateDesc({
    @required String newDesc,
 
  }) async {
    FirebaseUser userb = await _firebaseAuth.currentUser();
    final uid = userb.uid;
    print(newDesc);
    if (newDesc != null && newDesc != '') {
      db.collection('users').document(uid).updateData({'desc': newDesc});
      return true;
    }
    else{
      return false;
    }
   
  }
 
  Future updatePassword({
    @required String newPassword,
    @required String oldPassword,
  }) async {
    FirebaseUser userb = await _firebaseAuth.currentUser();
    //final uid = userb.uid;
    //User user = await _firestoreService.getUser(uid);
    //DocumentReference userRef = _usersCollectionReference.document(uid);
    print(newPassword);
    print(oldPassword);
    await loginWithEmail(email: userb.email, password: oldPassword);
    print('here ');
    await userb.updatePassword(newPassword);
    return true;
  }
}
