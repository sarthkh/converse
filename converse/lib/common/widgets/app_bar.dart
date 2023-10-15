import 'package:flutter/material.dart';

AppBar buildAppbar({
  required BuildContext context,
  Widget? title,
  required bool bottom,
  required List<Widget>? actions,
  Widget? leadingWidget,
  bool centerTitle = true,
  bool automaticallyImplyLeading = true,
}) {
  return AppBar(
    title: title,
    centerTitle: centerTitle,
    bottom: bottom
        ? PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
              color: Theme.of(context).cardColor.withOpacity(0.35),
              height: 1,
            ),
          )
        : null,
    actions: actions,
    leading: leadingWidget,
    automaticallyImplyLeading: automaticallyImplyLeading,
  );
}
