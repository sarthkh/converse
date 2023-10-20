import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/compress_file.dart';
import 'package:converse/common/widgets/popup_message.dart';
import 'package:converse/constants/constants.dart';
import 'package:converse/models/conclave_model.dart';
import 'package:converse/pages/conclave/repository/conclave_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:converse/providers/storage_repository_provider.dart';
import 'package:converse/core/failure.dart';
import 'package:converse/models/post_model.dart';

final conclaveControllerProvider =
    StateNotifierProvider<ConclaveController, bool>((ref) {
  final conclaveRepository = ref.watch(conclaveRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ConclaveController(
    conclaveRepository: conclaveRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final userConclavesProvider = StreamProvider((ref) {
  final conclaveController = ref.watch(conclaveControllerProvider.notifier);
  return conclaveController.getUserConclaves();
});

final getConclaveByNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(conclaveControllerProvider.notifier).getConclaveByName(name);
});

final searchConclaveProvider = StreamProvider.family((ref, String query) {
  return ref.watch(conclaveControllerProvider.notifier).searchConclave(query);
});

final getConclavePostsProvider = StreamProvider.family((ref, String name) {
  return ref.read(conclaveControllerProvider.notifier).getConclavePosts(name);
});

class ConclaveController extends StateNotifier<bool> {
  final ConclaveRepository _conclaveRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  ConclaveController({
    required ConclaveRepository conclaveRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _conclaveRepository = conclaveRepository,
        _ref = ref,
        _storageRepository = storageRepository,
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

  void joinConclave(BuildContext context, Conclave conclave) async {
    final user = _ref.read(userProvider)!;
    Either<Failure, void> res;

    if (conclave.conversers.contains(user.uid)) {
      res = await _conclaveRepository.leaveConclave(conclave.name, user.uid);
    } else {
      res = await _conclaveRepository.joinConclave(conclave.name, user.uid);
    }

    res.fold(
      (l) => toastInfo(
        context: context,
        msg: l.message,
        type: ToastType.fail,
      ),
      (r) {
        if (conclave.conversers.contains(user.uid)) {
          toastInfo(
            context: context,
            msg: "Left successfully",
            type: ToastType.pass,
          );
        } else {
          toastInfo(
            context: context,
            msg: "Joined successfully",
            type: ToastType.pass,
          );
        }
      },
    );
  }

  void editConclave({
    required BuildContext context,
    required Conclave conclave,
    required File? bannerFile,
    required File? displayPicFile,
  }) async {
    state = true; // start loading

    if (displayPicFile != null) {
      // to compress displayPic
      final resultDisplayPic = await compressFile(
        displayPicFile,
        quality: 50,
      );

      final compressedDisplayPic = resultDisplayPic['file'] as File;
      final dir = resultDisplayPic['dir'] as Directory;

      // conclaves/displayPic/sarthak
      final res = await _storageRepository.storeFile(
        path: 'conclaves/displayPic',
        id: conclave.name,
        file: compressedDisplayPic,
      );
      // to handle result
      res.fold(
        (l) => toastInfo(
          context: context,
          msg: l.message,
          type: ToastType.fail,
        ),
        (r) async {
          toastInfo(
            context: context,
            msg: "${conclave.name} display picture changed successfully!",
            type: ToastType.pass,
          );
          conclave = conclave.copyWith(displayPic: r);

          // to delete directory
          if (dir.existsSync()) {
            await dir.delete(recursive: true);
          }
        },
      );
    }

    if (bannerFile != null) {
      // to compress banner
      final resultBanner = await compressFile(
        bannerFile,
        quality: 50,
      );

      final compressedBanner = resultBanner['file'] as File;
      final dir = resultBanner['dir'] as Directory;

      // conclaves/banner/sarthak
      final res = await _storageRepository.storeFile(
        path: 'conclaves/banner',
        id: conclave.name,
        file: compressedBanner,
      );
      res.fold(
        (l) => toastInfo(
          context: context,
          msg: l.message,
          type: ToastType.fail,
        ),
        (r) async {
          toastInfo(
            context: context,
            msg: "${conclave.name} banner changed successfully!",
            type: ToastType.pass,
          );
          // update conclave model with new url
          conclave = conclave.copyWith(banner: r);

          // to delete directory
          if (dir.existsSync()) {
            await dir.delete(recursive: true);
          }
        },
      );
    }

    final res = await _conclaveRepository.editConclave(conclave);

    state = false; // stop loading

    res.fold(
      (l) => toastInfo(
        context: context,
        msg: l.message,
        type: ToastType.fail,
      ),
      (r) => GoRouter.of(context).pop(),
    );
  }

  Stream<List<Conclave>> searchConclave(String query) {
    return _conclaveRepository.searchConclave(query);
  }

  void addMods(
    String conclaveName,
    List<String> uIds,
    BuildContext context,
  ) async {
    final res = await _conclaveRepository.addMods(conclaveName, uIds);

    res.fold(
      (l) => toastInfo(
        context: context,
        msg: l.message,
        type: ToastType.fail,
      ),
      (r) => GoRouter.of(context).pop(),
    );
  }

  Stream<List<Post>> getConclavePosts(String name) {
    return _conclaveRepository.getConclavePosts(name);
  }
}
