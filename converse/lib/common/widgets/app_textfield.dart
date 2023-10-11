import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/common/widgets/text_styles.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/common/widgets/app_decorations.dart';
import 'package:converse/common/widgets/image_widgets.dart';

class AppTextField extends ConsumerWidget {
  final String text;
  final String iconName;
  final String hintText;
  final StateProvider<bool>? obscureTextProvider;
  final void Function(String value)? func;
  final bool isPasswordField;

  const AppTextField({
    super.key,
    required this.text,
    required this.iconName,
    required this.hintText,
    required this.func,
    required this.isPasswordField,
    this.obscureTextProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordVisible =
        obscureTextProvider != null ? ref.watch(obscureTextProvider!) : false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text16Regular(context: context, text: text),
          const SizedBox(height: 10),
          Container(
            width: 345,
            height: 65,
            decoration: appBoxDecorationTextField(
              context: context,
              color: Theme.of(context).scaffoldBackgroundColor,
              borderColor: Theme.of(context).cardColor,
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 2),
                  child: authImage(
                    imagePath: iconName,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                Container(
                  width: 285,
                  height: 65,
                  alignment: Alignment.center,
                  child: TextField(
                    cursorColor: Theme.of(context).hintColor,
                    onChanged: (value) {
                      if (func != null) {
                        func!(value);
                      }
                    },
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      suffixIcon: isPasswordField
                          ? IconButton(
                              icon: passwordVisible
                                  ? authImage(
                                      imagePath:
                                          "assets/images/svgs/register/show.svg",
                                      color: Theme.of(context).hintColor,
                                    )
                                  : authImage(
                                      imagePath:
                                          "assets/images/svgs/register/hide.svg",
                                      color: Theme.of(context).hintColor,
                                    ),
                              onPressed: obscureTextProvider != null
                                  ? () {
                                      ref
                                          .read(obscureTextProvider!.notifier)
                                          .state = !passwordVisible;
                                    }
                                  : null,
                            )
                          : null,
                    ),
                    maxLines: 1,
                    autocorrect: false,
                    obscureText: passwordVisible,
                    style: text18MediumStyle(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
