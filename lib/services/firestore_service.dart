import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/models/chat.dart';
import 'package:compound/models/user.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
final db = Firestore.instance;
      


  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
      //createChat(user, 'ARm92rzCrHOKxbWPbaKGAlI4zP63');
      await db.collection('chats').document(user.id).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }


//kanske ska ändras till user, men kör på string nu
  Future createChat(Chatters chat) async {
    //en parameter kan vara to, men det fixas i chatten nu.,
    try {
      //Lägger till en chatt koppling mellan två användare id, och lägger till chatten till bägge users databas
      //await db.collection('chats').document(from.id).collection(to).document(to).setData(from.toJson());
      await db.collection('chats').document(chat.messengerid1).collection('chats').document().setData(chat.toJson());
      await db.collection('chats').document(chat.messengerid2).collection('chats').document().setData(chat.toJson());
    } catch (e) {
      return e.message;
    }
  }

  

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      print(userData.data.toString());
      return User.fromData(userData.data);
      
    } catch (e) {
      return e.message;
    }
  }

    Future getChats(String uid) async {
    try {
      var userData = await db.collection('chats').document(uid).get();
      print(userData.data.toString());
      return User.fromData(userData.data);
      
    } catch (e) {
      return e.message;
    }
  }


  

}
