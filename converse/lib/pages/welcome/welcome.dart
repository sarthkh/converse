import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/theme_switcher.dart';
import 'package:converse/common/widgets/app_decorations.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/pages/welcome/widgets.dart';
import 'package:converse/pages/welcome/notifier/welcome_notifier.dart';

// welcome page count
const totalPageCount = 4;

class Welcome extends ConsumerWidget {
  Welcome({super.key});

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexDotProvider);

    return Scaffold(
      appBar: buildAppbar(
        context: context,
        bottom: false,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 25),
            child: const ThemeSwitcher(),
          ),
        ],
        leadingWidget: _skipButton(index, _controller, context),
      ),
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              ref.read(indexDotProvider.notifier).changeIndex(value);
              // print('index value is $value');
            },
            controller: _controller,
            children: [
              // welcome pages
              welcomePage(
                controller: _controller,
                imagePath: "assets/images/svgs/welcome/odyssey.svg",
                title: "Begin Your Exciting Odyssey!",
                subTitle:
                    "Embark on a journey through vibrant communities. Engage in dialogues and form connections that span the cosmos.",
                index: 1,
                context: context,
              ),
              welcomePage(
                controller: _controller,
                imagePath: "assets/images/svgs/welcome/expedition.svg",
                title: "Tailor Your Personal Expedition",
                subTitle:
                    "Express your passions, align with like-minded communities, and carve out your unique path.",
                index: 2,
                context: context,
              ),
              welcomePage(
                controller: _controller,
                imagePath: "assets/images/svgs/welcome/conversation.svg",
                title: "Fuel Innovative Conversations",
                subTitle:
                    "Initiate, engage, and influence. Share your insights in a way that resonates with you and makes a difference.",
                index: 3,
                context: context,
              ),
              welcomePage(
                controller: _controller,
                imagePath: "assets/images/svgs/welcome/divein.svg",
                title: "Dive In, Make Waves!",
                subTitle:
                    "Unleash your ideas, connect with fellow explorers, and ignite your journey of discovery. Are you ready to dive in?",
                index: 4,
                context: context,
              ),
            ],
          ),
        ],
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SmoothPageIndicator(
              controller: _controller,
              count: totalPageCount,
              onDotClicked: (index) {
                _controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.fastOutSlowIn,
                );
              },
              effect: ExpandingDotsEffect(
                activeDotColor: Theme.of(context).primaryColor,
                dotColor: Theme.of(context).cardColor,
                dotWidth: 25,
                dotHeight: 12.5,
                radius: 5,
              ),
            ),
            _nextButton(index, _controller, context),
          ],
        ),
      ),
    );
  }
}

Widget _nextButton(int index, PageController controller, BuildContext context) {
  return GestureDetector(
    onTap: () async {
      if (index < totalPageCount - 1) {
        // print('$index');
        controller.animateToPage(
          index + 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
      } else {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => const Login(),
        //   ),
        // );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboardingComplete', true);

        if (context.mounted) {
          GoRouter.of(context).pushNamed('login');
        }
      }
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: index < totalPageCount - 1 ? 100 : 125,
      height: 50,
      decoration: appBoxShadow(
        context: context,
        color: Theme.of(context).primaryColor,
      ),
      child: Center(
        child: text20ExtraBold(
          text: index < totalPageCount - 1 ? "NEXT" : "DIVE IN",
          context: context,
        ),
      ),
    ),
  );
}

Widget _skipButton(int index, PageController controller, BuildContext context) {
  return Visibility(
    visible: index < totalPageCount - 1,
    child: Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 25),
      child: GestureDetector(
        onTap: () {
          controller.animateToPage(
            totalPageCount - 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
          );
        },
        child: SvgPicture.asset(
          "assets/images/svgs/welcome/skip.svg",
          height: 30,
          colorFilter: ColorFilter.mode(
            Theme.of(context).hintColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    ),
  );
}
