import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flog/models/user.dart' as model;

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('User').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // 유저 정보 수정하기
  void updateUser(uid, field, data) async {
    User currentUser = _auth.currentUser!;
    _firestore.collection("User").doc(uid).update({field: data});
  }
}
