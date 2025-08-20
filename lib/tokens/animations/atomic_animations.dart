import 'package:flutter/material.dart';

class AtomicAnimations {
  AtomicAnimations._();

  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 800);
  static const Duration slowest = Duration(milliseconds: 1000);

  static const Duration buttonPress = fast;
  static const Duration pageTransition = normal;
  static const Duration modalShow = normal;
  static const Duration shimmer = slower;
  static const Duration loading = slowest;

  static const Curve linear = Curves.linear;
  static const Curve ease = Curves.ease;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  
  static const Curve standardEasing = Curves.fastOutSlowIn;
  static const Curve decelerateEasing = Curves.decelerate;
  static const Curve accelerateEasing = Curves.fastLinearToSlowEaseIn;
  
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve bounceInOut = Curves.bounceInOut;
  static const Curve elasticIn = Curves.elasticIn;
  static const Curve elasticOut = Curves.elasticOut;
  
  static const Curve buttonCurve = easeInOut;
  static const Curve modalCurve = decelerateEasing;
  static const Curve pageCurve = standardEasing;
  static const Curve listItemCurve = easeOut;

  
  static Tween<double> fadeTween({double begin = 0.0, double end = 1.0}) {
    return Tween<double>(begin: begin, end: end);
  }
  
  static Tween<double> scaleTween({double begin = 0.0, double end = 1.0}) {
    return Tween<double>(begin: begin, end: end);
  }
  
  static Tween<Offset> slideTween({
    Offset begin = const Offset(0.0, 1.0),
    Offset end = Offset.zero,
  }) {
    return Tween<Offset>(begin: begin, end: end);
  }
  
  static Tween<double> rotationTween({double begin = 0.0, double end = 1.0}) {
    return Tween<double>(begin: begin, end: end);
  }

  
  static Duration staggerDelay(int index, {Duration baseDelay = const Duration(milliseconds: 50)}) {
    return baseDelay * index;
  }
  
  static const Duration staggerInterval = Duration(milliseconds: 100);

  
  static Route<T> pageRouteBuilder<T>({
    required Widget page,
    Duration duration = normal,
    Curve curve = pageCurve,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: curve));
        
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  
  static HeroFlightShuttleBuilder heroFlightShuttleBuilder = (
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final Hero toHero = toHeroContext.widget as Hero;
    return toHero;
  };
} 