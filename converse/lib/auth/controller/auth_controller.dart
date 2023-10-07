import 'package:converse/auth/repository/auth_repository.dart';
import 'package:converse/common/widgets/popup_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
  ),
);

class AuthController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  void googleSignIn(BuildContext context) async {
    final user = await _authRepository.signInWithGoogle();
    // l -> failure, r -> success
    user.fold(
      (l) => toastInfo(
        context: context,
        msg: l.message,
        type: ToastType.fail,
      ),
      (r) => null,
    );
  }
}
