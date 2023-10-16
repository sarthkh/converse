import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/pages/conclave/controller/conclave_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConclaveScreen extends ConsumerWidget {
  final String name;

  const ConclaveScreen({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: ref.watch(getConclaveByNameProvider(name)).when(
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
                          child: Image.network(
                            conclave.banner,
                            fit: BoxFit.cover,
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
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(conclave.displayPic),
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
                                      onPressed: () {},
                                      child: text17SemiBoldItalic(
                                        context: context,
                                        text: "Mod Tools",
                                      ),
                                    )
                                  : outlinedButton(
                                      context: context,
                                      onPressed: () {},
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: text16Medium(
                                    context: context,
                                    text: "·",
                                  ),
                                ),
                                text16Medium(
                                  context: context,
                                  text: conclave.moderators.length == 1
                                      ? "${conclave.moderators.length} Moderator"
                                      : "${conclave.moderators.length} Moderator",
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
    );
  }
}
