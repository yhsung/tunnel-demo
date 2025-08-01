import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'fractals.dart';

void main() => runApp(const FractalZoomApp());

class FractalZoomApp extends StatelessWidget {
  const FractalZoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fractal Zoom',
      theme: ThemeData.dark(),
      home: const FractalPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum FractalType { mandelbrot, julia, burningShip, sierpinski, koch, fern }

class FractalPage extends StatefulWidget {
  const FractalPage({super.key});

  @override
  State<FractalPage> createState() => _FractalPageState();
}

class _FractalPageState extends State<FractalPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  FractalType _type = FractalType.mandelbrot;
  final Map<FractalType, Map<int, List<math.Point<double>>>> _cache = {};

  List<math.Point<double>> _getData(FractalType type, int detail) {
    final byDetail = _cache.putIfAbsent(type, () => {});
    return byDetail.putIfAbsent(detail, () {
      switch (type) {
        case FractalType.mandelbrot:
          return generateMandelbrot(detail: detail);
        case FractalType.julia:
          return generateJulia(detail: detail);
        case FractalType.burningShip:
          return generateBurningShip(detail: detail);
        case FractalType.sierpinski:
          return generateSierpinski(detail: detail);
        case FractalType.koch:
          return generateKoch(detail: detail);
        case FractalType.fern:
          return generateFern(detail: detail);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
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
      appBar: AppBar(
        title: const Text('Fractal Zoom'),
        actions: [
          DropdownButton<FractalType>(
            value: _type,
            dropdownColor: Colors.grey[900],
            onChanged: (value) {
              if (value != null) {
                setState(() => _type = value);
              }
            },
            items: FractalType.values
                .map(
                  (f) => DropdownMenuItem(
                    value: f,
                    child: Text(f.name),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final zoom = math.pow(1.02, _controller.value * 200).toDouble();
          final detail = (math.log(zoom) / math.log(2)).floor();
          final points = _getData(_type, detail);
          return CustomPaint(
            painter: _FractalPainter(
              points: points,
              zoom: zoom,
              connect: _type == FractalType.koch,
            ),
            child: Container(),
          );
        },
      ),
    );
  }
}

class _FractalPainter extends CustomPainter {
  _FractalPainter(
      {required this.points, required this.zoom, this.connect = false});

  final List<math.Point<double>> points;
  final double zoom;
  final bool connect;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width, size.height) / 2;
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale * zoom, -scale * zoom);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / scale;

    if (connect) {
      final path = Path()..moveTo(points.first.x, points.first.y);
      for (var p in points.skip(1)) {
        path.lineTo(p.x, p.y);
      }
      canvas.drawPath(path, paint);
    } else {
      canvas.drawPoints(
        PointMode.points,
        points.map((p) => Offset(p.x, p.y)).toList(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FractalPainter oldDelegate) =>
      oldDelegate.zoom != zoom || oldDelegate.points != points;
}
