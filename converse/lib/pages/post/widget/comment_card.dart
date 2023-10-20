import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/image_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/models/comment_model.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentCard extends ConsumerWidget {
  final Comment comment;

  const CommentCard({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).drawerTheme.backgroundColor?.withOpacity(0.35),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              circleAvatar(
                  backgroundImage: NetworkImage(comment.avatar), radius: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text16Bold(
                        context: context,
                        text: "u/${comment.username}",
                      ),
                      const SizedBox(height: 3.5),
                      text16SemiBold(
                        context: context,
                        text: comment.text,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              iconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  "assets/images/svgs/home/reply.svg",
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).hintColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              text16Medium(
                context: context,
                text: "Reply",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
