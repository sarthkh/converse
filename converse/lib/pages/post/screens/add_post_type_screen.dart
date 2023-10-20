import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/app_textfield.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/popup_message.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/pages/conclave/controller/conclave_controller.dart';
import 'package:converse/pages/post/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:converse/core/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';
import 'package:converse/models/conclave_model.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;

  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  List<Conclave> conclaves = [];
  Conclave? selectedConclave;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void sharePost() {
    if (widget.type == 'Image' &&
        bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            selectedConclave: selectedConclave ?? conclaves[0],
            file: bannerFile,
          );
    } else if (widget.type == 'Text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedConclave: selectedConclave ?? conclaves[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'Link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedConclave: selectedConclave ?? conclaves[0],
            link: linkController.text.trim(),
          );
    } else {
      toastInfo(
        context: context,
        msg: "Please enter all the fields!",
        type: ToastType.fail,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'Image';
    final isTypeText = widget.type == 'Text';
    final isTypeLink = widget.type == 'Link';
    final isLoading = ref.watch(postControllerProvider);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: buildAppbar(
          context: context,
          bottom: true,
          title: text22SemiBold(
            context: context,
            text: "Post ${widget.type}",
          ),
          actions: [
            iconButton(
              onPressed: sharePost,
              icon: SvgPicture.asset(
                "assets/images/svgs/home/send.svg",
                colorFilter: ColorFilter.mode(
                  Theme.of(context).hintColor,
                  BlendMode.srcIn,
                ),
              ),
              padding: const EdgeInsets.only(right: 15),
            )
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  textField(
                    context: context,
                    controller: titleController,
                    hintText: "Enter Title",
                    maxLength: 150,
                  ),
                  const SizedBox(height: 25),
                  if (isTypeImage)
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
                              : Center(
                                  child: SvgPicture.asset(
                                    "assets/images/svgs/conclave/camera.svg",
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).hintColor,
                                      BlendMode.srcIn,
                                    ),
                                    height: 45,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  if (isTypeText)
                    textField(
                      context: context,
                      controller: descriptionController,
                      hintText: "Enter Description",
                      maxLines: 5,
                    ),
                  if (isTypeLink)
                    textField(
                      context: context,
                      controller: linkController,
                      hintText: "Enter Link",
                    ),
                  const SizedBox(height: 25),
                  Align(
                    alignment: Alignment.topLeft,
                    child: text16Regular(
                      context: context,
                      text: "Select Conclave",
                    ),
                  ),
                  ref.watch(userConclavesProvider).when(
                        data: (data) {
                          conclaves = data;

                          if (data.isEmpty) {
                            return const SizedBox();
                          }
                          return DropdownButton(
                            isExpanded: true,
                            value: selectedConclave ?? data[0],
                            items: data
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: text17SemiBold(
                                      context: context,
                                      text: e.name,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedConclave = val;
                              });
                            },
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () => const Loader(),
                      ),
                ],
              ),
            ),
            if (isLoading) const Loader(),
          ],
        ),
      ),
    );
  }
}
