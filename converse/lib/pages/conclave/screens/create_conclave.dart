import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/app_textfield.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateConclave extends ConsumerStatefulWidget {
  const CreateConclave({super.key});

  @override
  ConsumerState createState() => _CreateCommunityState();
}

class _CreateCommunityState extends ConsumerState<CreateConclave> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(
        context: context,
        bottom: true,
        actions: [],
        title: text22SemiBold(context: context, text: "Craft a Conclave"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 35),
          AppTextField(
            height: 100,
            text: "Conclave Name",
            iconName: "assets/images/svgs/conclave/conclave.svg",
            hintText: "c/Conclave_Name",
            func: (value) {},
            maxLength: 25,
            isPasswordField: false,
          ),
          const SizedBox(height: 50),
          appButton(
            context: context,
            buttonName: "Craft",
            func: () {},
          )
        ],
      ),
    );
  }
}
