import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    'Book Your Favorite \nBarber And Salon \nQuickly',
    'Come Be Handsome \nAnd Beautiful With Us \nRight Now!',
  ];

  final List<String> _imagePaths = [
    'assets/slider1.jpg',
    'assets/slider2.jpg',
    'assets/slider3.jpg',
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
        activeDotColor: Color(0xFFF4B860),
        dotColor: Color(0xFF4A5859),
        dotHeight: 6,
        dotWidth: 8,
        spacing: 8,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final buttonHeight = 35.h;
    return Container(
      width: double.infinity,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFF4B860),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextButton(
        onPressed: _onButtonPressed,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF32373D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            // --- Black shadow for the button text ---
            shadows: const [
              Shadow(
                color: Colors.black26,
                blurRadius: 14,
                offset: Offset(2, 8),
              ),
            ],
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
    final screenHeight = 1.sh;
    final screenWidth = 1.sw;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F7),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Top 65%: PageView with images
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: screenHeight * 0.65,
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
            ),
            // 2. Gradient overlay: covers full height for seamless blend
            Container(
              width: double.infinity,
              height: screenHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x0032373D), // transparent at top
                    Color(0xFF32373D), // solid at 65%
                    Color(0xFF32373D), // solid at 100%
                  ],
                  stops: [0.0, 0.65, 1.0],
                ),
              ),
            ),
            // 3. Content on top (bottom-aligned column)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.4,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.07),
                    // Responsive Fitted text block with **white shadow**
                    SizedBox(
                      width: 337.w,
                      height: 144.h,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _slideTexts[_currentPage],
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFF4B860),
                                // --- White shadow for text ---
                                shadows: const [
                                  Shadow(
                                    color: Colors.white24,
                                    blurRadius: 25,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                        ),
                      ),
                    ),
                    _buildDotIndicator(),
                    SizedBox(height: screenHeight * 0.07),
                    _buildActionButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
