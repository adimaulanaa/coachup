import 'package:flutter/material.dart';

enum TransitionType { slide, fade, scale }

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get context => navigatorKey.currentContext!;

  static Route<T> _animatedRoute<T>(Widget page, TransitionType type) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (type) {
          case TransitionType.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          case TransitionType.scale:
            return ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
              child: child,
            );
          case TransitionType.slide:
          return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
        }
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static Future<T?> push<T>(Widget page, {TransitionType transition = TransitionType.slide}) {
    return Navigator.of(context).push<T>(_animatedRoute<T>(page, transition));
  }

  static Future<T?> pushReplacement<T, TO>(Widget page, {TransitionType transition = TransitionType.slide}) {
    return Navigator.of(context).pushReplacement<T, TO>(_animatedRoute<T>(page, transition));
  }

  static Future<T?> pushAndRemoveUntil<T>(Widget page, {TransitionType transition = TransitionType.slide}) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      _animatedRoute<T>(page, transition),
      (route) => false,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    Navigator.of(context).pop<T>(result);
  }

  static bool canPop() {
    return Navigator.of(context).canPop();
  }

  static void replaceWith<T>(Widget page) {
    Navigator.of(context).pushReplacement<T, T>(
      PageRouteBuilder<T>(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
