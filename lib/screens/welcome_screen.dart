import 'package:flutter/material.dart';
import 'package:salonix/consts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = Responsive.screenHeight(context);
    final screenWidth = Responsive.screenWidth(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('assets/welcome.jpg', fit: BoxFit.cover),

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x0032373D), // 0% opacity
                  Color(0xFF32373D), // 100% opacity at 90%
                  Color(0xFF32373D), // same 100% color from 90% to 100%
                ],
                stops: [
                  0.0, // Start at 0% of the height
                  0.9, // Reach full opacity at 90%
                  1.0, // Stay full opacity for the last 10%
                ],
              ),
            ),
          ),

          // Text content over image and gradient
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.583,
                left: screenWidth * 0.08,
                right: screenWidth * 0.08,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'welcome to',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: Responsive.fontSize(context, 0.1),
                      fontStyle: FontStyle.italic,
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

                  // salonix title pulled slightly closer
                  Transform.translate(
                    offset: Offset(0, -screenHeight * 0.017),
                    child: Text(
                      'salonix',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: screenHeight * 0.06,
                        fontStyle: FontStyle.italic,
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

                  SizedBox(height: screenHeight * 0.02),

                  // Subtitle text
                  Text(
                    'An Establishment That Offers A Variety Of \nCosmetic Treatments And Cosmetic \nServices For Men And Women',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: Responsive.fontSize(context, 0.03),
                      fontStyle: FontStyle.normal,
                      shadows: const [
                        Shadow(
                          color: Colors.white12,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
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
}
