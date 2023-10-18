import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/image_widgets.dart';
import 'package:converse/common/widgets/list_tile.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/text_styles.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/pages/conclave/controller/conclave_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:go_router/go_router.dart';

class SearchConclaveDelegate extends SearchDelegate {
  final WidgetRef ref;

  SearchConclaveDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      iconButton(
        onPressed: () {
          query = "";
        },
        icon: SvgPicture.asset(
          "assets/images/svgs/home/cut.svg",
          colorFilter: ColorFilter.mode(
            Theme.of(context).hintColor,
            BlendMode.srcIn,
          ),
        ),
        padding: const EdgeInsets.only(right: 15),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  void navigateToConclave(BuildContext context, String conclaveName) {
    GoRouter.of(context).push('/c/$conclaveName');
    ZoomDrawer.of(context)?.close();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchConclaveProvider(query)).when(
          data: (conclaves) => Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: conclaves.length,
              itemBuilder: (BuildContext context, int index) {
                final conclave = conclaves[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: listTile(
                    title: text18Regular(
                      context: context,
                      text: "c/${conclave.name}",
                    ),
                    leading: circleAvatar(
                      backgroundImage: NetworkImage(conclave.displayPic),
                    ),
                    onTap: () => navigateToConclave(context, conclave.name),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: Theme.of(context).cardColor.withOpacity(0.35),
                  ),
                );
              },
            ),
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: text20MediumStyle(context),
      ),
      textTheme: TextTheme(
        bodyLarge: text20MediumStyle(context),
      ),
    );
  }
}
