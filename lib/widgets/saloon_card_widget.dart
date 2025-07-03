import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/models/saloon_models.dart';
import 'package:salonix/screens/saloon_details_screen.dart';

class HorizontalCardList extends StatelessWidget {
  final List<SalonModel> salons;

  const HorizontalCardList({super.key, required this.salons});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.55;
    final cardHeight = cardWidth + screenWidth * 0.17;
    final smallPadding = screenWidth * 0.02;

    return SizedBox(
      height: cardHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(salons.length, (index) {
            final salon = salons[index];

            return Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.05),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SalonDetailsScreen(salon: salon),
                    ),
                  );
                },
                child: SizedBox(
                  width: cardWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Image with Shadow
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              offset: Offset(2, 4),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.asset(
                                salon.image,
                                height: cardWidth,
                                width: cardWidth,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                                ),
                                child: Text(
                                  "${salon.distance} km",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
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
                          Expanded(
                            child: Text(
                              salon.name,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(fontSize: 16.sp),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 10.sp,
                              ),
                              Text(
                                "${salon.rating}",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: const Color(0xFFF0F0F0),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        salon.address,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFFF0F0F0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
