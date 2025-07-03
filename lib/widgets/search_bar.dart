import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.019;
    final iconSize = screenWidth * 0.07;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding,
        verticalPadding,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: const Color(0xFF4A5859),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(Icons.search, size: iconSize, color: Colors.white30),
          ),
        ),
      ),
    );
  }
}
