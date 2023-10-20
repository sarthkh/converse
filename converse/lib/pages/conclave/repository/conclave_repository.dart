import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:converse/constants/firebase_constants.dart';
import 'package:converse/core/failure.dart';
import 'package:converse/core/type_defs.dart';
import 'package:converse/models/conclave_model.dart';
import 'package:converse/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:converse/models/post_model.dart';

final conclaveRepositoryProvider = Provider((ref) {
  return ConclaveRepository(
    firebaseFirestore: ref.watch(firebaseFireStoreProvider),
  );
});

class ConclaveRepository {
  final FirebaseFirestore _firebaseFirestore;

  ConclaveRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  // getter for reference to Firestore collection
  CollectionReference get _conclaves =>
      _firebaseFirestore.collection(FirebaseConstants.conclaveCollection);

  CollectionReference get _posts =>
      _firebaseFirestore.collection(FirebaseConstants.postsCollection);

  FutureVoid craftConclave(Conclave conclave) async {
    try {
      var conclaveDoc = await _conclaves.doc(conclave.name).get();
      if (conclaveDoc.exists) {
        throw 'A conclave with same name already exists :(';
      }
      // right -> success
      return right(
        _conclaves.doc(conclave.name).set(conclave.toMap()),
      );
    } on FirebaseException catch (e) {
      // left -> failure
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid joinConclave(String conclaveName, String userId) async {
    try {
      return right(
        _conclaves.doc(conclaveName).update({
          'conversers': FieldValue.arrayUnion([userId]),
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid leaveConclave(String conclaveName, String userId) async {
    try {
      return right(
        _conclaves.doc(conclaveName).update({
          'conversers': FieldValue.arrayRemove([userId]),
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  // get stream of user conclaves
  Stream<List<Conclave>> getUserConclaves(String uid) {
    return _conclaves
        .where('conversers', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<Conclave> conclaves = [];
      for (var doc in event.docs) {
        conclaves.add(Conclave.fromMap(doc.data() as Map<String, dynamic>));
      }
      return conclaves;
    });
  }

  // get stream of conclave name
  Stream<Conclave> getConclaveByName(String name) {
    return _conclaves
        .doc(name)
        .snapshots()
        .map((event) => Conclave.fromMap(event.data() as Map<String, dynamic>));
  }

  // to update conclave document
  FutureVoid editConclave(Conclave conclave) async {
    try {
      return right(
        _conclaves.doc(conclave.name).update(conclave.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  // search for conclaves by string
  Stream<List<Conclave>> searchConclave(String query) {
    return _conclaves
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map(
      (event) {
        List<Conclave> conclaves = [];
        for (var conclave in event.docs) {
          conclaves.add(
            Conclave.fromMap(
              conclave.data() as Map<String, dynamic>,
            ),
          );
        }
        return conclaves;
      },
    );
  }

  FutureVoid addMods(String conclaveName, List<String> uIds) async {
    try {
      return right(
        _conclaves.doc(conclaveName).update(
          {
            'moderators': uIds,
          },
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  Stream<List<Post>> getConclavePosts(String name) {
    return _posts
        .where(
          'conclaveName',
          isEqualTo: name,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
