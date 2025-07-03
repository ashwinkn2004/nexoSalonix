import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalCardList extends StatelessWidget {
  const HorizontalCardList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.55;
    final imageSize = cardWidth;
    final cardHeight = cardWidth + screenWidth * 0.17;
    final smallPadding = screenWidth * 0.02;

    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(right: screenWidth * 0.09),
          child: SizedBox(
            width: cardWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- OUTER IMAGE SHADOW ----
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(2, 4),
                        blurRadius: 18,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image(
                          image: AssetImage('assets/welcome.jpg'),
                          height: imageSize,
                          width: imageSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // ---- 1.2km BADGE WITH WHITE SHADOW ----
                      Positioned(
                        bottom: smallPadding * 1.5,
                        right: smallPadding * 2.5,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: smallPadding,
                            vertical: smallPadding / 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white30,
                                offset: Offset(1, 6),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            "1.2km",
                            style: Theme.of(context).textTheme.labelSmall!
                                .copyWith(color: Colors.white, fontSize: 12.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: smallPadding * 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shop Name",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16.sp),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: smallPadding * 2),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 10.sp),
                          Text(
                            "4.5",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  fontSize: 10.sp,
                                  color: const Color(0xFFF0F0F0),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  "Address",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 13.sp,
                        color: const Color(0xFFF0F0F0),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
