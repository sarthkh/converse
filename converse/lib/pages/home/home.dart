import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/cached_image.dart';
import 'package:converse/common/widgets/image_widgets.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/constants/constants.dart';
import 'package:converse/pages/home/delegates/search_conclave_delegate.dart';
import 'package:converse/pages/home/drawers/custom_drawer.dart';
import 'package:converse/pages/home/drawers/user_profile_drawer_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:converse/pages/home/drawers/conclave_list_drawer_content.dart';

enum DrawerType {
  conclaveList,
  userProfile,
}

final activeDrawerProvider = StateProvider<DrawerType>(
  (ref) => DrawerType.conclaveList,
);

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int _page = 0;

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ZoomDrawerController();
    final activeDrawer = ref.watch(activeDrawerProvider);
    final user = ref.watch(userProvider)!;

    return CustomDrawer(
      controller: controller,
      menuScreen: activeDrawer == DrawerType.userProfile
          ? const UserProfileDrawerContent()
          : const ConclaveListDrawerContent(),
      mainScreen: Scaffold(
        appBar: buildAppbar(
          context: context,
          bottom: true,
          actions: [
            iconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchConclaveDelegate(ref),
                );
              },
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
              onPressed: () {
                ref.read(activeDrawerProvider.notifier).state =
                    DrawerType.userProfile;
                ZoomDrawer.of(context)?.toggle();
              },
              icon: circleAvatar(
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
              onPressed: () {
                ref.read(activeDrawerProvider.notifier).state =
                    DrawerType.conclaveList;
                ZoomDrawer.of(context)?.toggle();
              },
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
        body: Constants.tabWidgets[_page],
        bottomNavigationBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_rounded,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_rounded,
              ),
            ),
          ],
          onTap: onPageChange,
          currentIndex: _page,
          activeColor: Theme.of(context).hintColor,
          height: 75,
        ),
      ),
      isRtl: activeDrawer == DrawerType.userProfile,
    );
  }
}
