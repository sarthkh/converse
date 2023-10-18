import 'package:any_link_preview/any_link_preview.dart';
import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/image_widgets.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/pages/post/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/models/post_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(BuildContext context, WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).deletePost(context, post);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downVotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'Image';
    final isTypeText = post.type == 'Text';
    final isTypeLink = post.type == 'Link';
    final user = ref.watch(userProvider)!;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).drawerTheme.backgroundColor),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ).copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  circleAvatar(
                                    backgroundImage:
                                        NetworkImage(post.conclaveDisplayPic),
                                    radius: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text17Bold(
                                          context: context,
                                          text: "c/${post.conclaveName}",
                                        ),
                                        text14Medium(
                                          context: context,
                                          text: "c/${post.username}",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user.uid)
                                iconButton(
                                  onPressed: () => deletePost(context, ref),
                                  icon: SvgPicture.asset(
                                    "assets/images/svgs/home/delete.svg",
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).primaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: text20Bold(
                              context: context,
                              text: post.title,
                            ),
                          ),
                          if (isTypeImage)
                            Container(
                              padding: const EdgeInsets.only(right: 16),
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.bottomLeft,
                              child: text15Regular(
                                  context: context,
                                  text: post.description!,
                                  color: Theme.of(context).cardColor),
                            ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  iconButton(
                                    onPressed: () => upvotePost(ref),
                                    icon: SvgPicture.asset(
                                      "assets/images/svgs/home/upvote.svg",
                                      colorFilter: ColorFilter.mode(
                                        post.upVotes.contains(user.uid)
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).hintColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  text16Medium(
                                    context: context,
                                    text:
                                        '${post.upVotes.length - post.downVotes.length == 0 ? 'Vote' : post.upVotes.length - post.downVotes.length}',
                                  ),
                                  iconButton(
                                    onPressed: () => downVotePost(ref),
                                    icon: SvgPicture.asset(
                                      "assets/images/svgs/home/downvote.svg",
                                      colorFilter: ColorFilter.mode(
                                        post.upVotes.contains(user.uid)
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).hintColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  iconButton(
                                    onPressed: () {},
                                    icon: SvgPicture.asset(
                                      "assets/images/svgs/home/comment.svg",
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(context).hintColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  text16Medium(
                                    context: context,
                                    text:
                                        '${post.commentCount == 0 ? 'Comment' : post.upVotes.length - post.downVotes.length}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
