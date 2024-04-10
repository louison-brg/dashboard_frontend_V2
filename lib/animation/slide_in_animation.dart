import 'package:flutter/material.dart';

enum SlideDirection {
  fromTop,
  fromBottom,
}

class SlideInAnimation extends StatefulWidget {
  final Widget child;
  final SlideDirection direction;

  const SlideInAnimation({
    Key? key,
    required this.child,
    this.direction = SlideDirection.fromBottom,
  }) : super(key: key);

  @override
  _SlideInAnimationState createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Adjust duration as needed
    );
    _animation = Tween<Offset>(
      begin: _getBeginOffset(),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Offset _getBeginOffset() {
    if (widget.direction == SlideDirection.fromTop) {
      return const Offset(0.0, -1.0);
    } else {
      return const Offset(0.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
