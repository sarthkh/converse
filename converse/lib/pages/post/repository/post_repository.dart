import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:converse/constants/firebase_constants.dart';
import 'package:converse/core/failure.dart';
import 'package:converse/core/type_defs.dart';
import 'package:converse/models/post_model.dart';
import 'package:converse/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:converse/models/conclave_model.dart';
import 'package:converse/models/comment_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(
    firebaseFirestore: ref.watch(firebaseFireStoreProvider),
  );
});

class PostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  // getter for reference to Firestore collection
  CollectionReference get _posts =>
      _firebaseFirestore.collection(FirebaseConstants.postsCollection);

  CollectionReference get _comments =>
      _firebaseFirestore.collection(FirebaseConstants.commentsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(
        _posts.doc(post.id).set(post.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Conclave> conclaves) {
    return _posts
        .where('conclaveName', whereIn: conclaves.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(
        _posts.doc(post.id).delete(),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  void upvote(Post post, String userId) {
    if (post.downVotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (post.upVotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downVote(Post post, String userId) {
    if (post.upVotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (post.downVotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map(
          (event) => Post.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  FutureVoid addPostComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(
        _posts.doc(comment.postId).update(
          {
            'commentCount': FieldValue.increment(1),
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

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Comment.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }
}
