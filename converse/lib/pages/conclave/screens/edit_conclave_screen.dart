import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/image_widgets.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/constants/constants.dart';
import 'package:converse/core/providers/utils.dart';
import 'package:converse/pages/conclave/controller/conclave_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:converse/models/conclave_model.dart';

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
  File? bannerFile, displayPicFile;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectDisplayPicImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        displayPicFile = File(res.files.first.path!);
      });
    }
  }

  void save(Conclave conclave) {
    ref.read(conclaveControllerProvider.notifier).editConclave(
          context: context,
          conclave: conclave,
          bannerFile: bannerFile,
          displayPicFile: displayPicFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(conclaveControllerProvider);

    return ref.watch(getConclaveByNameProvider(widget.name)).when(
          data: (conclave) => Scaffold(
            appBar: buildAppbar(
              context: context,
              bottom: true,
              actions: [
                textButton(
                  onPressed: () => save(conclave),
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
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: selectBannerImage,
                              child: DottedBorder(
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
                                  child: bannerFile != null
                                      ? Image.file(bannerFile!)
                                      : conclave.banner.isEmpty ||
                                              conclave.banner ==
                                                  Constants.bannerDefault
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
                            ),
                            Positioned(
                              bottom: 12.5,
                              left: 20,
                              child: GestureDetector(
                                onTap: selectDisplayPicImage,
                                child: displayPicFile != null
                                    ? circleAvatar(
                                        backgroundImage:
                                            FileImage(displayPicFile!),
                                        radius: 35,
                                      )
                                    : circleAvatar(
                                        backgroundImage:
                                            NetworkImage(conclave.displayPic),
                                        radius: 35,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading) const Loader(),
              ],
            ),
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
