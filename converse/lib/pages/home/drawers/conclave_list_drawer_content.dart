import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:go_router/go_router.dart';
import 'package:converse/common/widgets/text_widgets.dart';

class CommunityListDrawerContent extends StatelessWidget {
  const CommunityListDrawerContent({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    GoRouter.of(context).pushNamed('create-conclave');
    ZoomDrawer.of(context)?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
              child: ListTile(
                title: text20Medium(
                  context: context,
                  text: "Craft a Conclave",
                ),
                leading: SvgPicture.asset(
                  "assets/images/svgs/home/plus.svg",
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).canvasColor,
                    BlendMode.srcIn,
                  ),
                ),
                onTap: () => navigateToCreateCommunity(context),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0.35,
                    color: Theme.of(context).hintColor,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
