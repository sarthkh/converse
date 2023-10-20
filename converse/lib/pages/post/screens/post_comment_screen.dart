import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/app_textfield.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/popup_message.dart';
import 'package:converse/common/widgets/post_card.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/pages/post/controller/post_controller.dart';
import 'package:converse/pages/post/widget/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/models/post_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    String commentText = commentController.text.trim();

    commentText.isNotEmpty
        ? ref.read(postControllerProvider.notifier).addPostComment(
              context: context,
              text: commentText,
              post: post,
            )
        : toastInfo(
            context: context,
            msg: "Please write a comment!",
            type: ToastType.alert,
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
                children: [
                  PostCard(post: data),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: textField(
                      context: context,
                      suffixIcon: iconButton(
                        onPressed: () {
                          addPostComment(data);
                        },
                        icon: SvgPicture.asset(
                          "assets/images/svgs/home/send_comment.svg",
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).hintColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        padding: const EdgeInsets.only(right: 8),
                      ),
                      controller: commentController,
                      hintText: "What are your thoughts?",
                    ),
                  ),
                  Expanded(
                    child: ref
                        .watch(getCommentsOfPostProvider(widget.postId))
                        .when(
                          data: (data) {
                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final comment = data[index];
                                      return CommentCard(
                                        comment: comment,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                          loading: () => const Loader(),
                        ),
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
