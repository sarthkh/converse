import 'dart:ui';
import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/app_shimmer.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/cached_image.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/image_widgets.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/pages/conclave/controller/conclave_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:converse/models/conclave_model.dart';
import 'package:converse/common/widgets/post_card.dart';

class ConclaveScreen extends ConsumerWidget {
  final String name;

  const ConclaveScreen({
    super.key,
    required this.name,
  });

  void navigateToModToolsScreen(BuildContext context) {
    GoRouter.of(context).push('/mod-tools/$name');
  }

  void joinConclave(WidgetRef ref, BuildContext context, Conclave conclave) {
    ref
        .read(conclaveControllerProvider.notifier)
        .joinConclave(context, conclave);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: SafeArea(
        child: ref.watch(getConclaveByNameProvider(name)).when(
              data: (conclave) => NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 150,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: cachedNetworkImage(
                              imageUrl: conclave.banner,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => shimmer(
                                context: context,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              errorWidget: (context, url, error) =>
                                  SvgPicture.asset(
                                "assets/images/svgs/register/alert.svg",
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 0.125,
                                  sigmaY: 0.125,
                                ),
                                child: Container(
                                  color: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(15),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Align(
                              alignment: Alignment.topLeft,
                              child: circleAvatar(
                                backgroundImage: cachedNetworkImageProvider(
                                  url: conclave.displayPic,
                                ),
                                radius: 35,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: text20SemiBold(
                                    context: context,
                                    text: "c/${conclave.name}",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                conclave.moderators.contains(user.uid)
                                    ? outlinedButton(
                                        context: context,
                                        onPressed: () =>
                                            navigateToModToolsScreen(context),
                                        child: text17SemiBoldItalic(
                                          context: context,
                                          text: "Mod Tools",
                                        ),
                                      )
                                    : outlinedButton(
                                        context: context,
                                        onPressed: () => joinConclave(
                                            ref, context, conclave),
                                        child: text17SemiBoldItalic(
                                          context: context,
                                          text: conclave.conversers
                                                  .contains(user.uid)
                                              ? "Joined"
                                              : "Join",
                                        ),
                                      ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  text16Medium(
                                    context: context,
                                    text: conclave.conversers.length == 1
                                        ? "${conclave.conversers.length} Converser"
                                        : "${conclave.conversers.length} Conversers",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: text16Medium(
                                      context: context,
                                      text: "·",
                                    ),
                                  ),
                                  text16Medium(
                                    context: context,
                                    text: conclave.moderators.length == 1
                                        ? "${conclave.moderators.length} Moderator"
                                        : "${conclave.moderators.length} Moderators",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: ref.watch(getConclavePostsProvider(name)).when(
                      data: (data) {
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final post = data[index];
                            return PostCard(post: post);
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    ),
              ),
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            ),
      ),
    );
  }
}
