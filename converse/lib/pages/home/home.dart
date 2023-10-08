import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: Center(
        child: text20ExtraBold(
          context: context,
          text: user.name,
        ),
      ),
    );
  }
}
