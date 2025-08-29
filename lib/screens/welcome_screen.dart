import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/consts.dart';
import 'package:salonix/screens/intro_slider_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  /// Builds the main UI content for the Welcome Screen.
  /// This widget is used both for the initial build and for the slide-up animation.
  static Widget buildWelcomeContent(BuildContext context) {
    final screenHeight = Responsive.screenHeight(context);
    final screenWidth = Responsive.screenWidth(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background image fills the screen.
          Image.asset('assets/welcome.jpg', fit: BoxFit.cover),

          // 2. Linear gradient overlay for better text visibility.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x0032373D), // 0% opacity (top)
                  Color(0xFF32373D), // 100% opacity at 90% height
                  Color(0xFF32373D), // 100% opacity for bottom 10%
                ],
                stops: [0.0, 0.9, 1.0],
              ),
            ),
          ),

          // 3. Foreground text content positioned near the bottom.
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.60, // Position content at ~60% from top
                left: screenWidth * 0.08,
                right: screenWidth * 0.08,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "welcome to" title, sized and aligned responsively.
                  SizedBox(
                    width: 191.w,
                    height: 48.h,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'welcome to',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 40.sp,
                              shadows: const [
                                Shadow(
                                  color: Colors.white38,
                                  blurRadius: 25,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                      ),
                    ),
                  ),

                  // "salonix" brand name, positioned slightly closer to the previous line.
                  Transform.translate(
                    offset: Offset(0, -screenHeight * 0.017),
                    child: SizedBox(
                      width: 179.w,
                      height: 72.h,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'salonix',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                fontStyle: FontStyle.italic,
                                fontSize: 70.sp,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(
                                    color: Colors.white38,
                                    blurRadius: 25,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                        ),
                      ),
                    ),
                  ),

                  // A little vertical spacing before the subtitle.
                  SizedBox(height: screenHeight * 0.02),

                  // Subtitle - responsive and constrained to 3 lines max.
                  SizedBox(
                    width: 341.w,
                    height: 72.h,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ' An Establishment That Offers A Variety Of \nCosmetic Treatments And Cosmetic \nServices For Men And Women',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              fontStyle: FontStyle.normal,
                              fontSize: 20.sp,
                              shadows: const [
                                Shadow(
                                  color: Colors.white12,
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates to the IntroSliderScreen with a slide-up (move up) animation.
  /// The WelcomeScreen content slides upward, revealing the new screen underneath.
  void _goToSliderScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1200),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const IntroSliderScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide up animation for the NEW screen (IntroSliderScreen)
          final slideIn =
              Tween<Offset>(
                begin: const Offset(0, 1.0), // Start just below the screen
                end: Offset.zero, // Slide to normal position
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              );

          // Optionally: you can fade out the old screen a bit for effect
          // but here, we'll keep it simple: old screen remains static.

          return Stack(
            children: [
              buildWelcomeContent(context), // Stays static in the back
              SlideTransition(
                position: slideIn,
                child: child, // The new screen slides up over it
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The whole screen is tappable to trigger navigation.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _goToSliderScreen(context),
      child: buildWelcomeContent(context),
    );
  }
}
