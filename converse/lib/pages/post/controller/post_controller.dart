import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/popup_message.dart';
import 'package:converse/models/comment_model.dart';
import 'package:converse/models/conclave_model.dart';
import 'package:converse/models/post_model.dart';
import 'package:converse/pages/post/repository/post_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:converse/providers/storage_repository_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:converse/common/widgets/compress_file.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
    postRepository: postRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final userPostsProvider =
    StreamProvider.family((ref, List<Conclave> conclaves) {
  final postController = ref.watch(postControllerProvider.notifier);

  return postController.fetchUserPosts(conclaves);
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);

  return postController.getPostById(postId);
});

final getCommentsOfPostProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);

  return postController.fetchCommentsOfPost(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false); // represents loading

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Conclave selectedConclave,
    required String description,
  }) async {
    state = true; // loading starts
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      conclaveName: selectedConclave.name,
      conclaveDisplayPic: selectedConclave.displayPic,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'Text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _postRepository.addPost(post);

    state = false; // loading stops

    res.fold(
      (l) => toastInfo(
        context: context,
        msg: l.message,
        type: ToastType.fail,
      ),
      (r) {
        toastInfo(
          context: context,
          msg: "Posted Successfully",
          type: ToastType.pass,
        );
        GoRouter.of(context).pop();
      },
    );
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Conclave selectedConclave,
    required String link,
  }) async {
    state = true; // loading starts
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      conclaveName: selectedConclave.name,
      conclaveDisplayPic: selectedConclave.displayPic,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'Link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(post);

    state = false; // loading stops

    res.fold(
      (l) => toastInfo(
        context: context,
        msg: l.message,
        type: ToastType.fail,
      ),
      (r) {
        toastInfo(
          context: context,
          msg: "Posted Successfully",
          type: ToastType.pass,
        );
        GoRouter.of(context).pop();
      },
    );
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Conclave selectedConclave,
    required File? file,
  }) async {
    state = true; // loading starts
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    // to compress image
    final resultFile = await compressFile(
      file!,
      quality: 50,
    );

    final compressedFile = resultFile['file'] as File;
    final dir = resultFile['dir'] as Directory;

    final imageRes = await _storageRepository.storeFile(
      path: 'posts/${selectedConclave.name}',
      id: postId,
      file: compressedFile,
    );
    imageRes.fold(
      (l) => toastInfo(
        context: context,
        msg: l.message,
        type: ToastType.fail,
      ),
      (r) async {
        final Post post = Post(
          id: postId,
          title: title,
          conclaveName: selectedConclave.name,
          conclaveDisplayPic: selectedConclave.displayPic,
          upVotes: [],
          downVotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'Image',
          createdAt: DateTime.now(),
          awards: [],
          link: r,
        );

        // to delete directory
        if (dir.existsSync()) {
          await dir.delete(recursive: true);
        }

        final res = await _postRepository.addPost(post);

        state = false; // loading stops

        res.fold(
          (l) => toastInfo(
            context: context,
            msg: l.message,
            type: ToastType.fail,
          ),
          (r) {
            toastInfo(
              context: context,
              msg: "Posted Successfully",
              type: ToastType.pass,
            );
            GoRouter.of(context).pop();
          },
        );
      },
    );
  }

  Stream<List<Post>> fetchUserPosts(List<Conclave> conclaves) {
    if (conclaves.isNotEmpty) {
      return _postRepository.fetchUserPosts(conclaves);
    }
    return Stream.value([]);
  }

  void deletePost(BuildContext context, Post post) async {
    final res = await _postRepository.deletePost(post);

    res.fold(
      (l) => null,
      (r) {
        toastInfo(
          context: context,
          msg: "Post Deleted Successfully!",
          type: ToastType.pass,
        );

        GoRouter.of(context).pop();
      },
    );
  }

  void upvote(Post post) {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, uid);
  }

  void downvote(Post post) {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downVote(post, uid);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addPostComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;
    final commentId = const Uuid().v1();
    Comment comment = Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      username: user.name,
      avatar: user.avatar,
    );

    final res = await _postRepository.addPostComment(comment);

    res.fold(
      (l) => toastInfo(
        context: context,
        msg: l.message,
        type: ToastType.fail,
      ),
      (r) => null,
    );
  }

  Stream<List<Comment>> fetchCommentsOfPost(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }
}
