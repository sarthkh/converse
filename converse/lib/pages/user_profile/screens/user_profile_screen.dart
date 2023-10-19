import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/app_shimmer.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/cached_image.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/image_widgets.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uId;

  const UserProfileScreen({
    super.key,
    required this.uId,
  });

  void navigateToEditProfileScreen(BuildContext context) {
    GoRouter.of(context).push('/edit-profile/$uId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: ref.watch(getUserDataProvider(uId)).when(
              data: (user) => NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 250,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: cachedNetworkImage(
                              imageUrl: user.banner,
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
                          Container(
                            alignment: Alignment.bottomCenter,
                            padding:
                                const EdgeInsets.all(35).copyWith(bottom: 115),
                            child: circleAvatar(
                              backgroundImage: cachedNetworkImageProvider(
                                url: user.avatar,
                              ),
                              radius: 50,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.all(35),
                            child: appButton(
                              context: context,
                              buttonName: "Edit Profile",
                              width: 175,
                              func: () => navigateToEditProfileScreen(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(25),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            text20SemiBold(
                              context: context,
                              text: "u/${user.name}",
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: text20ExtraBold(
                                context: context,
                                text: user.karma == 1
                                    ? "${user.karma} karma"
                                    : "${user.karma} karmas",
                              ),
                            ),
                            const SizedBox(height: 15),
                            Divider(
                              thickness: 2,
                              color: Theme.of(context).hintColor,
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: text25Bold(
                  context: context,
                  text: "Displaying Posts",
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
