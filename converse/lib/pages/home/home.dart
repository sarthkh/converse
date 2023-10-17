import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/cached_image.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/pages/home/drawers/conclave_list_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:converse/pages/home/drawers/conclave_list_drawer_content.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return ConclaveListDrawer(
      mainScreen: Scaffold(
        appBar: buildAppbar(
          context: context,
          bottom: true,
          actions: [
            iconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/images/svgs/home/search.svg",
                colorFilter: ColorFilter.mode(
                  Theme.of(context).hintColor,
                  BlendMode.srcIn,
                ),
                height: 27.5,
              ),
            ),
            iconButton(
              onPressed: () {},
              icon: CircleAvatar(
                backgroundImage: cachedNetworkImageProvider(
                  url: user.avatar,
                ),
                radius: 15,
              ),
              padding: const EdgeInsets.only(left: 5, right: 15),
            ),
          ],
          title: text22SemiBold(
            context: context,
            text: "Home",
          ),
          centerTitle: false,
          leadingWidget: Builder(builder: (context) {
            return iconButton(
              onPressed: () => ZoomDrawer.of(context)?.toggle(),
              icon: SvgPicture.asset(
                "assets/images/svgs/home/menu.svg",
                colorFilter: ColorFilter.mode(
                  Theme.of(context).hintColor,
                  BlendMode.srcIn,
                ),
                height: 27.5,
              ),
              margin: const EdgeInsets.symmetric(vertical: 7),
              padding: const EdgeInsets.only(left: 15),
            );
          }),
        ),
      ),
      menuScreen: const ConclaveListDrawerContent(),
    );
  }
}
