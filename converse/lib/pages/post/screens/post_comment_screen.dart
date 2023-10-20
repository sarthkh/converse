import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/app_textfield.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/post_card.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/pages/post/controller/post_controller.dart';
import 'package:converse/pages/post/widget/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/models/post_model.dart';

class PostCommentScreen extends ConsumerStatefulWidget {
  final String postId;

  const PostCommentScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState createState() => _PostCommentScreenState();
}

class _PostCommentScreenState extends ConsumerState<PostCommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addPostComment(Post post) {
    ref.read(postControllerProvider.notifier).addPostComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );

    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(
        context: context,
        title: text22SemiBold(
          context: context,
          text: "Comments",
        ),
        centerTitle: false,
        bottom: true,
        actions: [],
      ),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (data) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostCard(post: data),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: textField(
                      context: context,
                      onSubmitted: (val) => addPostComment(data),
                      controller: commentController,
                      hintText: "What are your thoughts?",
                    ),
                  ),
                  ref.watch(getCommentsOfPostProvider(widget.postId)).when(
                        data: (data) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final comment = data[index];
                                return CommentCard(
                                  comment: comment,
                                );
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () => const Loader(),
                      ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
