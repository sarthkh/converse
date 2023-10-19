import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/app_textfield.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/pages/conclave/controller/conclave_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/common/widgets/loader.dart';

class CraftConclaveScreen extends ConsumerStatefulWidget {
  const CraftConclaveScreen({super.key});

  @override
  ConsumerState createState() => _CraftConclaveScreenState();
}

class _CraftConclaveScreenState extends ConsumerState<CraftConclaveScreen> {
  final conclaveNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    conclaveNameController.dispose();
  }

  void craftConclave() {
    ref.read(conclaveControllerProvider.notifier).craftConclave(
          context,
          conclaveNameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(conclaveControllerProvider);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: buildAppbar(
          context: context,
          bottom: true,
          actions: [],
          title: text22SemiBold(context: context, text: "Craft a Conclave"),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 35),
                AppTextField(
                  height: 100,
                  text: "Conclave Name",
                  iconName: "assets/images/svgs/conclave/conclave.svg",
                  hintText: "c/Conclave_Name",
                  func: (value) {},
                  controller: conclaveNameController,
                  isPasswordField: false,
                ),
                const SizedBox(height: 50),
                appButton(
                  context: context,
                  buttonName: "Craft",
                  func: craftConclave,
                )
              ],
            ),
            if (isLoading) const Loader(),
          ],
        ),
      ),
    );
  }
}
