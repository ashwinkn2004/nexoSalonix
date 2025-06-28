import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonix/consts.dart';
import 'package:salonix/screens/home_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroSliderScreen extends ConsumerStatefulWidget {
  const IntroSliderScreen({super.key});

  @override
  ConsumerState<IntroSliderScreen> createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends ConsumerState<IntroSliderScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _slideTexts = [
    'Find Barbers And \nSalons Easily in Your \nHands',
    'Book Your Favorite \nBarber and Salon \nQuickly',
    'Come Be Handsome \nAnd Beautiful With Us \nRight Now!',
  ];

  final List<String> _imagePaths = [
    'assets/barber_banner.png',
    'assets/saloon_banner.png',
    'assets/handsome_banner.png',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    if (_currentPage < _slideTexts.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Widget _buildDotIndicator() {
    return SmoothPageIndicator(
      controller: _pageController,
      count: _slideTexts.length,
      effect: const ExpandingDotsEffect(
        activeDotColor: Color(0xFF3F72AF),
        dotColor: Color(0xFFDBE2EF),
        dotHeight: 6,
        dotWidth: 6,
        spacing: 8,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final buttonHeight = Responsive.screenHeight(context) * 0.047;
    return Container(
      width: double.infinity,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF3F72AF),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextButton(
        onPressed: _onButtonPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: Responsive.fontSize(context, 0.12),
          ),
        ),
        child: Text(
          _currentPage == _slideTexts.length - 1 ? 'GET STARTED' : 'NEXT',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight =
        Responsive.screenHeight(context) - mediaQuery.padding.vertical;
    final screenWidth = Responsive.screenWidth(context);
    final textScale = mediaQuery.textScaleFactor;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // Top 60%: Image PageView
            SizedBox(
              height: screenHeight * 0.6,
              width: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slideTexts.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.asset(_imagePaths[index], fit: BoxFit.cover);
                },
              ),
            ),

            // Bottom 40%: Text, dots, and button
            SizedBox(
              height: screenHeight * 0.4,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: Responsive.screenHeight(context) * 0.05),
                  AutoSizeText(
                    _slideTexts[_currentPage],
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    minFontSize: (screenHeight * 0.039 * textScale)
                        .roundToDouble(),
                    maxFontSize: (screenHeight * 0.07 * textScale)
                        .roundToDouble(),
                    stepGranularity: 0.1,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(
                    height: Responsive.screenHeight(context) * 0.006,
                  ), // 🔥 reduced spacing between text and dots
                  _buildDotIndicator(),

                  SizedBox(
                    height: screenHeight * 0.06,
                  ), // spacing between dots and button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * .09,
                    ),
                    child: _buildActionButton(context),
                  ),
                  SizedBox(
                    height: Responsive.screenHeight(context) * 0.01,
                  ), // bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
