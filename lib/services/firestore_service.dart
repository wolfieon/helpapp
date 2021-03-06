import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/models/chat.dart';
import 'package:compound/models/helprequest.dart';
import 'package:compound/models/markers.dart';
import 'package:compound/models/review.dart';
import 'package:compound/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
      final CollectionReference _markersCollectionReference =
      Firestore.instance.collection('markers');
final db = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
      


  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
      //createChat(user, 'ARm92rzCrHOKxbWPbaKGAlI4zP63');
      await db.collection('chats').document(user.id).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

   Future<User> getUserDetails() async {
     FirebaseUser user = await getCurrentUser();
    try {
      var userData = await _usersCollectionReference.document(user.uid).get();
      return User.fromData(userData.data);
      
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
      
      await db.collection('chats').document(chat.messengerid1).collection('chats').document(chat.messengerid2).setData(chat.toJson());
      await db.collection('chats').document(chat.messengerid2).collection('chats').document(chat.messengerid1).setData(chat.toJsonSwap());
      
    } catch (e) {
      return e.message;
    }
  }

  Future createHelprequest(Helprequest help) async {
    
    try {
      await db.collection('users').document(help.sender).collection('sentHelpRequests').document(help.reciever).setData(help.toJson());
      await db.collection('users').document(help.reciever).collection('recievedHelpRequests').document(help.sender).setData(help.toJson());
    } catch (e) {
      return e.message;
    }
  }
Future sendReviewNotificationAndStore(Review rev) async {
    //from är mig
    //to är otheruser
    try {
      await db.collection('users').document(rev.from).collection('sentReviews').document().setData(rev.toJson());
      await db.collection('users').document(rev.to).collection('reviews').document().setData(rev.toJson());
      await db.collection('users').document(rev.to).collection('reviewNotification').document(rev.from).setData(rev.toJson());
    } catch (e) {
      return e.message;
    }
  }

Future sendAnswerReviewAndStore(Review rev) async {
    //from är mig
    //to är otheruser
    try {
      await db.collection('users').document(rev.from).collection('sentReviews').document().setData(rev.toJson());
      await db.collection('users').document(rev.to).collection('reviews').document().setData(rev.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future deleteNotificationReview(Review rev) async {
    //from är mig
    //to är otheruser
    try {
      await db.collection('users').document(rev.from).collection('reviewNotification').document(rev.to).delete();
    } catch (e) {
      return e.message;
    }
  }
  



  Future acceptRequest(Helprequest help) async {
    
    try {
      await db.collection('users').document(help.sender).collection('acceptedGiveHelpRequest').document(help.reciever).setData(help.toJson());
      await db.collection('users').document(help.reciever).collection('acceptedHelpRequest').document(help.sender).setData(help.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future deleteAcceptRequest(Helprequest help) async {
    
    try {
      await db.collection('users').document(help.sender).collection('acceptedGiveHelpRequest').document(help.reciever).delete();
      await db.collection('users').document(help.reciever).collection('acceptedHelpRequest').document(help.sender).delete();
      await db.collection('users').document(help.sender).collection('acceptedHelpRequest').document(help.reciever).delete();
      await db.collection('users').document(help.reciever).collection('acceptedGiveHelpRequest').document(help.sender).delete();
    }
    catch (e) {
      return e.message;
    }
  }

  Future deleteHelprequest(Helprequest help) async {
    try {
      //copy the 4 rows under to lower event counter
      var uData = await db.collection('users').document(help.sender).get();
      User userData= User.fromData(uData.data);
      int i = userData.activeEvents - 1;
      await db.collection('users').document(help.sender).updateData({'activeEvents': i});
      await db.collection('users').document(help.sender).collection('sentHelpRequests').document(help.reciever).delete();
      await db.collection('users').document(help.reciever).collection('recievedHelpRequests').document(help.sender).delete();
    } catch (e) {
      return e.message;
    }
  }

  Future resolveHelprequest(Helprequest help) async {
    
    try {
      await db.collection('users').document(help.sender).collection('resolvedsentHelpRequests').document(help.reciever).setData(help.toJson());
      await db.collection('users').document(help.reciever).collection('resolvedrecievedHelpRequests').document(help.sender).setData(help.toJson());
      await db.collection('users').document(help.sender).collection('sentHelpRequests').document(help.reciever).delete();
      await db.collection('users').document(help.reciever).collection('recievedHelpRequests').document(help.sender).delete();
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
      return User.fromData(userData.data);
    } catch (e) {
      return null;
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
      return User.fromData(userData.data);
    } catch (e) {
      return e.message;
    }
  }

Future getMarker(String markId) async {
    try {
      var markData = await _markersCollectionReference.document(markId).get();
      return MarkObj.fromData(markData.data);
    } catch (e) {
      return print("lol");
    }
  }

}
