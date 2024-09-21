
import 'package:flutter/material.dart';

class AnimatedLoadingWidget extends StatefulWidget {
  const AnimatedLoadingWidget({super.key,this.height,this.width});
  final double? height;
  final double? width;

  @override
  State<AnimatedLoadingWidget> createState() => _AnimatedLoadingWidgetState();
}

class _AnimatedLoadingWidgetState extends State<AnimatedLoadingWidget> with SingleTickerProviderStateMixin{
  Duration animationDuration = const Duration(seconds: 5);
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this,duration: animationDuration)..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __){
        return  Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white,Colors.grey[400]!,],
              stops: [0,_animationController.value]
            ),
            borderRadius: BorderRadius.circular(10)
          ),
        );

      },);
  }
}
