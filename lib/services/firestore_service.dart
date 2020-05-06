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
      print("is messengerid2 empty" + chat.messengerid2);
      await db
          .collection('chats')
          .document(chat.messengerid1)
          .collection('chats')
          .document(chat.messengerid2)
          .setData(chat.toJson());
      await db
          .collection('chats')
          .document(chat.messengerid2)
          .collection('chats')
          .document(chat.messengerid1)
          .setData(chat.toJson());
      print("sistarad" + chat.messengerid2);
    } catch (e) {
      return e.message;
    }
  }

  deleteChat(Chatters chat) async {
    try {
      await db
          .collection('chats')
          .document(chat.messengerid1)
          .collection('chats')
          .document(chat.messengerid2)
          .delete();
      await db
          .collection('chats')
          .document(chat.messengerid2)
          .collection('chats')
          .document(chat.messengerid1)
          .delete();
      await db
          .collection('chats')
          .document(chat.messengerid1)
          .collection(chat.messengerid2)
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
      });
      await db
          .collection('chats')
          .document(chat.messengerid2)
          .collection(chat.messengerid1)
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
      });
    } catch (e) {}
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

  Future removeUser(User user) async {
    try {
      if (user != null) {
        //await _usersCollectionReference.document(user.id).delete();

        print('It have been sent to hell');
      }
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
