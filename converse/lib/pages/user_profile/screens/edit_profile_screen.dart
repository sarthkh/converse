import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/app_textfield.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/image_widgets.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/popup_message.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/constants/constants.dart';
import 'package:converse/core/providers/utils.dart';
import 'package:converse/pages/user_profile/controller/user_profile_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uId;

  const EditProfileScreen({
    super.key,
    required this.uId,
  });

  @override
  ConsumerState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile, avatarFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: ref.read(userProvider)!.name,
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectAvatarImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        avatarFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    String nameText = nameController.text.trim();

    nameText.isNotEmpty
        ? ref.read(userProfileControllerProvider.notifier).editUserProfile(
              context: context,
              avatarFile: avatarFile,
              bannerFile: bannerFile,
              name: nameText,
            )
        : toastInfo(
            context: context,
            msg: "Name cannot be blank!",
            type: ToastType.alert,
          );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);

    return ref.watch(getUserDataProvider(widget.uId)).when(
          data: (user) => Scaffold(
            appBar: buildAppbar(
              context: context,
              bottom: true,
              actions: [
                textButton(
                  onPressed: save,
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
                text: "Edit Profile",
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
                                      : user.banner.isEmpty ||
                                              user.banner ==
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
                                          : Image.network(user.banner),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12.5,
                              left: 20,
                              child: GestureDetector(
                                onTap: selectAvatarImage,
                                child: avatarFile != null
                                    ? circleAvatar(
                                        backgroundImage: FileImage(avatarFile!),
                                        radius: 35,
                                      )
                                    : circleAvatar(
                                        backgroundImage:
                                            NetworkImage(user.avatar),
                                        radius: 35,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      textField(
                        context: context,
                        controller: nameController,
                        hintText: "Name",
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
