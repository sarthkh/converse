import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:converse/constants/firebase_constants.dart';
import 'package:converse/core/failure.dart';
import 'package:converse/core/type_defs.dart';
import 'package:converse/models/conclave_model.dart';
import 'package:converse/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

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

  // get stream of user conclaves by querying conclave
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

  Stream<Conclave> getConclaveByName(String name) {
    return _conclaves
        .doc(name)
        .snapshots()
        .map((event) => Conclave.fromMap(event.data() as Map<String, dynamic>));
  }
}
