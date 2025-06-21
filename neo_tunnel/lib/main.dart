import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const NeoTunnelApp());

class NeoTunnelApp extends StatelessWidget {
  const NeoTunnelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neo Tunnel',
      theme: ThemeData.dark(),
      home: const TunnelPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TunnelPage extends StatefulWidget {
  const TunnelPage({super.key});

  @override
  State<TunnelPage> createState() => _TunnelPageState();
}

class _TunnelPageState extends State<TunnelPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _TunnelPainter(depth: _controller.value * 60),
            child: Container(),
          );
        },
      ),
    );
  }
}

class _TunnelPainter extends CustomPainter {
  _TunnelPainter({required this.depth});

  final double depth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.cyanAccent;

    const int lines = 40;
    const double spacing = 20;

    for (int i = 0; i < lines; i++) {
      final double d = (i - depth) * spacing;
      final double scale = math.pow(1.05, d).toDouble();
      final rect = Rect.fromCenter(
        center: center,
        width: size.width / scale,
        height: size.height / scale,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TunnelPainter oldDelegate) =>
      oldDelegate.depth != depth;
}
