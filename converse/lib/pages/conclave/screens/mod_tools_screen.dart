import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/list_tile.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;

  const ModToolsScreen({
    super.key,
    required this.name,
  });

  void navigateToEditConclaveScreen(BuildContext context) {
    GoRouter.of(context).push('/edit-conclave/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(
        context: context,
        bottom: true,
        actions: [],
        title: text22SemiBold(
          context: context,
          text: "Mod Tools",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            listTile(
              title: text17SemiBoldItalic(
                  context: context, text: "Add Moderators"),
              leading: SvgPicture.asset(
                "assets/images/svgs/conclave/moderator.svg",
                colorFilter: ColorFilter.mode(
                  Theme.of(context).canvasColor,
                  BlendMode.srcIn,
                ),
              ),
              onTap: () {},
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.35,
                  color: Theme.of(context).hintColor,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(height: 25),
            listTile(
              title: text17SemiBoldItalic(
                  context: context, text: "Edit Community"),
              leading: SvgPicture.asset(
                "assets/images/svgs/conclave/edit.svg",
                colorFilter: ColorFilter.mode(
                  Theme.of(context).canvasColor,
                  BlendMode.srcIn,
                ),
              ),
              onTap: () => navigateToEditConclaveScreen(context),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.35,
                  color: Theme.of(context).hintColor,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
