import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:converse/constants/constants.dart';
import 'package:converse/constants/firebase_constants.dart';
import 'package:converse/core/failure.dart';
import 'package:converse/core/type_defs.dart';
import 'package:converse/models/user_model.dart';
import 'package:converse/providers/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firebaseFirestore: ref.read(firebaseFireStoreProvider),
    firebaseAuth: ref.read(firebaseAuthProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  // getter for reference to Firestore collection
  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.usersCollection);

  // retrieving user data for given uid from Firestore and returning stream of UserModel instances
  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
          (event) => UserModel.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  // emit user object whenever Firebase auth state changes
  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // print(userCredential.user?.email);

      UserModel userModel;

      // user is new
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? "Converser",
          avatar: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [],
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      }
      // user is not new
      else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      // right -> success
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      // left -> failure
      return left(
        Failure(e.toString()),
      );
    }
  }

  void logout() async {
    _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
