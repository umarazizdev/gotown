import 'package:flutter/material.dart';

class MyIndicator extends StatefulWidget {
  const MyIndicator({Key? key}) : super(key: key);

  @override
  State<MyIndicator> createState() => _MyIndicatorState();
}

class _MyIndicatorState extends State<MyIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  final double barWidth = 300;
  final double indicatorWidth = 100;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    animation = Tween<double>(
      begin: 0,
      end: 300,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      width: barWidth,
      height: 12,
      child: Stack(
        children: [
          Container(
            width: barWidth,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Positioned(
                left: animation.value,
                child: Container(
                  width: indicatorWidth,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xffBFCC36),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
