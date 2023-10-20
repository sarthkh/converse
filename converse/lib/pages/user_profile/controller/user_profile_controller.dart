import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/compress_file.dart';
import 'package:converse/common/widgets/popup_message.dart';
import 'package:converse/models/user_model.dart';
import 'package:converse/pages/user_profile/repository/user_profile_respository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:converse/providers/storage_repository_provider.dart';
import 'package:converse/models/post_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false); // represents loading

  void editUserProfile({
    required BuildContext context,
    required File? bannerFile,
    required File? avatarFile,
    required String name,
  }) async {
    state = true; // start loading
    UserModel user = _ref.read(userProvider)!;

    if (avatarFile != null) {
      // to compress avatar
      final resultAvatar = await compressFile(
        avatarFile,
        quality: 50,
      );

      final compressedAvatar = resultAvatar['file'] as File;
      final dir = resultAvatar['dir'] as Directory;

      // users/displayPic/sarthak
      final res = await _storageRepository.storeFile(
        path: 'users/avatar',
        id: user.uid,
        file: compressedAvatar,
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
            msg: "${user.name} display picture changed successfully!",
            type: ToastType.pass,
          );
          user = user.copyWith(avatar: r);

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

      // users/banner/sarthak
      final res = await _storageRepository.storeFile(
        path: 'users/banner',
        id: user.uid,
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
            msg: "${user.name} banner changed successfully!",
            type: ToastType.pass,
          );
          // update user model with new url
          user = user.copyWith(banner: r);

          // to delete directory
          if (dir.existsSync()) {
            await dir.delete(recursive: true);
          }
        },
      );
    }

    user = user.copyWith(name: name);

    final res = await _userProfileRepository.editUserProfile(user);

    state = false; // stop loading

    res.fold(
      (l) => toastInfo(
        context: context,
        msg: l.message,
        type: ToastType.fail,
      ),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        GoRouter.of(context).pop();
      },
    );
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }
}
