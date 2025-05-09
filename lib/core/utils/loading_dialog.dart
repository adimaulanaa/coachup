import 'package:flutter/material.dart';

class LoadingDialog {
  static bool _isShowing = false; // Menambahkan variabel statis untuk tracking status loading

  static bool get isShowing => _isShowing; // Getter untuk memeriksa apakah dialog sedang ditampilkan

  static void show(BuildContext context) {
    if (!_isShowing) {
      _isShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: _CustomLoading()),
      );
    }
  }

  static void hide(BuildContext context) {
    if (_isShowing) {
      _isShowing = false;
      if (Navigator.canPop(context)) Navigator.pop(context);
    }
  }
}

class _CustomLoading extends StatefulWidget {
  const _CustomLoading();

  @override
  State<_CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<_CustomLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _animations = List.generate(6, (index) {
      final start = index / 6;
      var end = start + 0.5;
      if (end > 1.0) {
        end = 1.0;
      }
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        double offset = _animations[index].value;
        double translateY = index.isEven ? offset * 6 : -offset * 6;
        return Transform.translate(
          offset: Offset(0, translateY),
          child: child,
        );
      },
      child: Container(
        width: 4, // kecilkan titik
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 2), // rapatkan jarak
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // cegah dismiss pakai tombol back
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Transform.rotate(
            angle: 0.785398, // 45 derajat → belah ketupat
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Transform.rotate(
                  angle: -0.785398,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(6, _buildDot),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
