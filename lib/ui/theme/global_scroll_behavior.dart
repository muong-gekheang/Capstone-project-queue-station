import 'package:flutter/material.dart';

class GlobalScrollBehavior extends MaterialScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // This forces every scrollable to use BouncingScrollPhysics
    return const BouncingScrollPhysics();
  }
}
