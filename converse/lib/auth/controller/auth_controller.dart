import 'package:converse/auth/repository/auth_repository.dart';
import 'package:converse/common/widgets/popup_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

// expose authentication state change stream
final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

// retrieve user data for given uid
final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false); // represents loading

  // emit current user when authentication state changes
  Stream<User?> get authStateChange => _authRepository.authStateChange;

  // get a stream of user data for given uid
  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void googleSignIn(BuildContext context) async {
    state = true; // start loading
    final user = await _authRepository.signInWithGoogle();
    state = false; // stop loading

    // l -> failure, r -> success
    user.fold(
      (l) => toastInfo(
        context: context,
        msg: l.message,
        type: ToastType.fail,
      ),
      // on success update the userProvider state with new user
      (r) => _ref.read(userProvider.notifier).update((state) => r),
    );
  }
}
