import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/popup_message.dart';
import 'package:converse/constants/constants.dart';
import 'package:converse/models/conclave_model.dart';
import 'package:converse/pages/conclave/repository/conclave_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final conclaveControllerProvider =
    StateNotifierProvider<ConclaveController, bool>((ref) {
  final conclaveRepository = ref.watch(conclaveRepositoryProvider);
  return ConclaveController(
    conclaveRepository: conclaveRepository,
    ref: ref,
  );
});

final userConclavesProvider = StreamProvider((ref) {
  final conclaveController = ref.watch(conclaveControllerProvider.notifier);
  return conclaveController.getUserConclaves();
});

final getConclaveByNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(conclaveControllerProvider.notifier).getConclaveByName(name);
});

class ConclaveController extends StateNotifier<bool> {
  final ConclaveRepository _conclaveRepository;
  final Ref _ref;

  ConclaveController({
    required ConclaveRepository conclaveRepository,
    required Ref ref,
  })  : _conclaveRepository = conclaveRepository,
        _ref = ref,
        super(false); // represents loading

  void craftConclave(BuildContext context, String name) async {
    state = true; // start loading
    final uid = _ref.read(userProvider)?.uid ?? '';
    Conclave conclave = Conclave(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      displayPic: Constants.displayPicDefault,
      conversers: [uid],
      moderators: [uid],
    );

    final res = await _conclaveRepository.craftConclave(conclave);
    state = false; // stop loading
    res.fold(
      (l) => toastInfo(
        context: context,
        msg: l.message,
        type: ToastType.fail,
      ),
      (r) {
        toastInfo(
          context: context,
          msg: "$name crafted successfully :)",
          type: ToastType.pass,
        );
        GoRouter.of(context).pop();
      },
    );
  }

  Stream<List<Conclave>> getUserConclaves() {
    final uid = _ref.read(userProvider)!.uid;
    return _conclaveRepository.getUserConclaves(uid);
  }

  Stream<Conclave> getConclaveByName(String name) {
    return _conclaveRepository.getConclaveByName(name);
  }
}
