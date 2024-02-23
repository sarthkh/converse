import 'package:any_link_preview/any_link_preview.dart';
import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/app_shimmer.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/image_widgets.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/constants/constants.dart';
import 'package:converse/pages/conclave/controller/conclave_controller.dart';
import 'package:converse/pages/post/controller/post_controller.dart';
import 'package:converse/responsive/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/models/post_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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

  void awardPost(
    WidgetRef ref,
    String award,
    BuildContext context,
  ) async {
    ref.read(postControllerProvider.notifier).awardPost(
          award: award,
          context: context,
          post: post,
        );
  }

  void navigateToConclaveScreen(BuildContext context) {
    GoRouter.of(context).push('/c/${post.conclaveName}');
  }

  void navigateToUserProfileScreen(BuildContext context) {
    GoRouter.of(context).push('/u/${post.uid}');
  }

  void navigateToPostCommentScreen(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final postCommentPageRoute = '/post/${post.id}/comments';
    if (currentRoute != postCommentPageRoute) {
      GoRouter.of(context).push(postCommentPageRoute);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'Image';
    final isTypeText = post.type == 'Text';
    final isTypeLink = post.type == 'Link';
    final user = ref.watch(userProvider)!;
    final check = post.uid == user.uid;
    final isGuest = !user.isAuthenticated;

    return Responsive(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .drawerTheme
                  .backgroundColor
                  ?.withOpacity(0.35),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (kIsWeb)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        iconButton(
                          onPressed: isGuest ? () {} : () => upvotePost(ref),
                          icon: post.upVotes.contains(user.uid)
                              ? SvgPicture.asset(
                                  "assets/images/svgs/home/upvote_filled.svg",
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).hintColor,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : SvgPicture.asset(
                                  "assets/images/svgs/home/upvote.svg",
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).hintColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                        ),
                        text17Medium(
                          context: context,
                          text:
                              '${post.upVotes.length - post.downVotes.length == 0 ? 'Vote' : post.upVotes.length - post.downVotes.length}',
                        ),
                        iconButton(
                          onPressed: isGuest ? () {} : () => downVotePost(ref),
                          icon: post.downVotes.contains(user.uid)
                              ? SvgPicture.asset(
                                  "assets/images/svgs/home/downvote_filled.svg",
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).hintColor,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : SvgPicture.asset(
                                  "assets/images/svgs/home/downvote.svg",
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).hintColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
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
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      navigateToConclaveScreen(context),
                                  child: circleAvatar(
                                    backgroundImage:
                                        NetworkImage(post.conclaveDisplayPic),
                                    radius: 16,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(right: check ? 0 : 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text16Bold(
                                          context: context,
                                          text: "c/${post.conclaveName}",
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              navigateToUserProfileScreen(
                                                  context),
                                          child: text14Medium(
                                            context: context,
                                            text: "u/${post.username}",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (check)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: iconButton(
                                        onPressed: () =>
                                            deletePost(context, ref),
                                        icon: SvgPicture.asset(
                                          "assets/images/svgs/home/delete.svg",
                                          colorFilter: ColorFilter.mode(
                                            Theme.of(context).primaryColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if (post.awards.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 8,
                                ),
                                child: SizedBox(
                                  height: 28,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: post.awards.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final award = post.awards[index];

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Image.asset(
                                          Constants.awards[award]!,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8)
                                  .copyWith(right: 10),
                              child: text20Bold(
                                context: context,
                                text: post.title,
                              ),
                            ),
                            if (isTypeImage)
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8)
                                    .copyWith(right: 16),
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    post.link!,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress,
                                    ) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return shimmer(
                                          context: context,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.35,
                                          width: double.infinity,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            if (isTypeLink)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8)
                                    .copyWith(right: 16),
                                child: AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: post.link!,
                                ),
                              ),
                            if (isTypeText)
                              Container(
                                padding: const EdgeInsets.only(
                                    right: 10, bottom: 16),
                                alignment: Alignment.bottomLeft,
                                child: text16SemiBold(
                                  context: context,
                                  text: post.description!,
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (!kIsWeb)
                                  Row(
                                    children: [
                                      iconButton(
                                        onPressed: isGuest
                                            ? () {}
                                            : () => upvotePost(ref),
                                        icon: post.upVotes.contains(user.uid)
                                            ? SvgPicture.asset(
                                                "assets/images/svgs/home/upvote_filled.svg",
                                                colorFilter: ColorFilter.mode(
                                                  Theme.of(context).hintColor,
                                                  BlendMode.srcIn,
                                                ),
                                              )
                                            : SvgPicture.asset(
                                                "assets/images/svgs/home/upvote.svg",
                                                colorFilter: ColorFilter.mode(
                                                  Theme.of(context).hintColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                      ),
                                      text17Medium(
                                        context: context,
                                        text:
                                            '${post.upVotes.length - post.downVotes.length == 0 ? 'Vote' : post.upVotes.length - post.downVotes.length}',
                                      ),
                                      iconButton(
                                        onPressed: isGuest
                                            ? () {}
                                            : () => downVotePost(ref),
                                        icon: post.downVotes.contains(user.uid)
                                            ? SvgPicture.asset(
                                                "assets/images/svgs/home/downvote_filled.svg",
                                                colorFilter: ColorFilter.mode(
                                                  Theme.of(context).hintColor,
                                                  BlendMode.srcIn,
                                                ),
                                              )
                                            : SvgPicture.asset(
                                                "assets/images/svgs/home/downvote.svg",
                                                colorFilter: ColorFilter.mode(
                                                  Theme.of(context).hintColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    iconButton(
                                      onPressed: () =>
                                          navigateToPostCommentScreen(context),
                                      icon: SvgPicture.asset(
                                        "assets/images/svgs/home/comment.svg",
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(context).hintColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    text17Medium(
                                      context: context,
                                      text:
                                          '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                ref
                                    .watch(getConclaveByNameProvider(
                                        post.conclaveName))
                                    .when(
                                      data: (data) {
                                        if (data.moderators
                                            .contains(user.uid)) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: iconButton(
                                              onPressed: () =>
                                                  deletePost(context, ref),
                                              icon: SvgPicture.asset(
                                                "assets/images/svgs/home/mod_tools.svg",
                                                colorFilter: ColorFilter.mode(
                                                  Theme.of(context).hintColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                      error: (error, stackTrace) => ErrorText(
                                        error: error.toString(),
                                      ),
                                      loading: () => const Loader(),
                                    ),
                                iconButton(
                                  onPressed: isGuest
                                      ? () {}
                                      : () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: GridView.builder(
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 4,
                                                  ),
                                                  itemCount: user.awards.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final award =
                                                        user.awards[index];

                                                    return GestureDetector(
                                                      onTap: () => awardPost(
                                                        ref,
                                                        award,
                                                        context,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: Image.asset(
                                                          Constants
                                                              .awards[award]!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                  icon: SvgPicture.asset(
                                    "assets/images/svgs/home/gift.svg",
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).hintColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  padding: const EdgeInsets.only(right: 16),
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
