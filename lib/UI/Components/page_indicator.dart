import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator(
      {super.key, required this.activeScreenIndex, required this.steps});

  //Count starts from zero so a first screens index would be zero
  final int activeScreenIndex;
  final int steps;

  List<Widget> indicator(int steps) {
    List<Widget> indicators = [];
    if (activeScreenIndex >= steps) {
      throw Exception(
          'Active screen index is greater than number of steps of indicators');
    }
    for (int i = 0; i < steps; i++) {
      indicators.add(
        i == activeScreenIndex
            ? Flexible(
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.purple, width: 4)),
                ),
              )
            : Flexible(
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      border: Border.all(width: 0)),
                ),
              ),
      );
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: indicator(steps),
      ),
    );
  }
}
