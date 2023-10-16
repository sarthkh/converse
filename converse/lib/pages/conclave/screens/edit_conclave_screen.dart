import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/constants/constants.dart';
import 'package:converse/pages/conclave/controller/conclave_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditConclaveScreen extends ConsumerStatefulWidget {
  final String name;

  const EditConclaveScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState createState() => _EditConclaveScreenState();
}

class _EditConclaveScreenState extends ConsumerState<EditConclaveScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getConclaveByNameProvider(widget.name)).when(
          data: (conclave) => Scaffold(
            appBar: buildAppbar(
              context: context,
              bottom: true,
              actions: [
                textButton(
                  onPressed: () {},
                  child: SvgPicture.asset(
                    "assets/images/svgs/conclave/save.svg",
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).hintColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
              title: text22SemiBold(
                context: context,
                text: "Edit Conclave",
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        DottedBorder(
                          radius: const Radius.circular(15),
                          dashPattern: const [10, 5],
                          strokeCap: StrokeCap.round,
                          color: Theme.of(context).cardColor,
                          borderType: BorderType.RRect,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: conclave.banner.isEmpty ||
                                    conclave.banner == Constants.bannerDefault
                                ? Center(
                                    child: SvgPicture.asset(
                                      "assets/images/svgs/conclave/camera.svg",
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(context).hintColor,
                                        BlendMode.srcIn,
                                      ),
                                      height: 45,
                                    ),
                                  )
                                : Image.network(conclave.banner),
                          ),
                        ),
                        Positioned(
                          bottom: 12.5,
                          left: 20,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(conclave.displayPic),
                            radius: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
