import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:converse/constants/firebase_constants.dart';
import 'package:converse/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:converse/core/failure.dart';
import 'package:converse/core/type_defs.dart';
import 'package:converse/providers/firebase_providers.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(
    firebaseFirestore: ref.watch(firebaseFireStoreProvider),
  );
});

class UserProfileRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserProfileRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  // getter for reference to Firestore collection
  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.usersCollection);

  // to update user document
  FutureVoid editUserProfile(UserModel user) async {
    try {
      return right(
        _users.doc(user.uid).update(user.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
