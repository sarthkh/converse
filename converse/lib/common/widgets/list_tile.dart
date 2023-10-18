import 'package:flutter/material.dart';

Widget listTile({
  required Widget title,
  required Widget leading,
  required Function() onTap,
  required ShapeBorder shape,
  Color? tileColor,
}) {
  return ListTile(
    title: title,
    leading: leading,
    shape: shape,
    onTap: onTap,
    tileColor: tileColor,
  );
}

Widget checkBoxListTile({
  required Widget title,
  required bool value,
  required Function(bool?) onChanged,
}) {
  return CheckboxListTile(
    title: title,
    value: value,
    onChanged: onChanged,
  );
}
