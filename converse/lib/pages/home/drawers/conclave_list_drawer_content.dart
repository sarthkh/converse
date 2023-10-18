import 'package:converse/common/widgets/cached_image.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/image_widgets.dart';
import 'package:converse/common/widgets/list_tile.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/pages/conclave/controller/conclave_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:go_router/go_router.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/models/conclave_model.dart';

class ConclaveListDrawerContent extends ConsumerWidget {
  const ConclaveListDrawerContent({super.key});

  void navigateToCraftConclaveScreen(BuildContext context) {
    GoRouter.of(context).pushNamed('craft-conclave-screen');
    ZoomDrawer.of(context)?.close();
  }

  void navigateToConclave(BuildContext context, Conclave conclave) {
    GoRouter.of(context).push('/c/${conclave.name}');
    ZoomDrawer.of(context)?.close();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              listTile(
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
                onTap: () => navigateToCraftConclaveScreen(context),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0.35,
                    color: Theme.of(context).hintColor,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(height: 20),
              ref.watch(userConclavesProvider).when(
                    data: (conclaves) => Expanded(
                      child: ListView.builder(
                        itemCount: conclaves.length,
                        itemBuilder: (BuildContext context, int index) {
                          final conclave = conclaves[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: listTile(
                              leading: circleAvatar(
                                backgroundImage: cachedNetworkImageProvider(
                                  url: conclave.displayPic,
                                ),
                              ),
                              title: textScroll17Regular(
                                context: context,
                                text: "c/${conclave.name}",
                              ),
                              onTap: () {
                                navigateToConclave(context, conclave);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              tileColor:
                                  Theme.of(context).cardColor.withOpacity(0.35),
                            ),
                          );
                        },
                      ),
                    ),
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
