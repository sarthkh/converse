import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/list_tile.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/pages/conclave/controller/conclave_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;

  const AddModsScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uIds = {};
  int counter = 0;

  void addUId(String uid) {
    setState(() {
      uIds.add(uid);
    });
  }

  void removeUId(String uid) {
    setState(() {
      uIds.remove(uid);
    });
  }

  void saveMods() {
    ref.read(conclaveControllerProvider.notifier).addMods(
          widget.name,
          uIds.toList(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(
        context: context,
        title: text22SemiBold(
          context: context,
          text: "Add Mods",
        ),
        bottom: true,
        actions: [
          iconButton(
            onPressed: saveMods,
            icon: SvgPicture.asset(
              "assets/images/svgs/conclave/check.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).hintColor,
                BlendMode.srcIn,
              ),
            ),
            padding: const EdgeInsets.only(right: 15),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ref.watch(getConclaveByNameProvider(widget.name)).when(
              data: (conclave) => ListView.builder(
                itemCount: conclave.conversers.length,
                itemBuilder: (BuildContext context, int index) {
                  final converser = conclave.conversers[index];

                  return ref.watch(getUserDataProvider(converser)).when(
                        data: (user) {
                          if (conclave.moderators.contains(converser) &&
                              counter == 0) {
                            uIds.add(converser);
                          }
                          counter++;
                          return checkBoxListTile(
                            title: text17SemiBold(
                              context: context,
                              text: user.name,
                            ),
                            value: uIds.contains(user.uid),
                            onChanged: (val) {
                              if (val!) {
                                addUId(user.uid);
                              } else {
                                removeUId(user.uid);
                              }
                            },
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                },
              ),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            ),
      ),
    );
  }
}
