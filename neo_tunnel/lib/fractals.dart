import 'dart:math' as math;

/// Generate points for the Mandelbrot set normalized to [-1, 1].
///
/// The [detail] parameter increases both resolution and iteration depth
/// exponentially, allowing the fractal to reveal more structure when zooming.
List<math.Point<double>> generateMandelbrot({int detail = 0}) {
  final resolution = 200 * (detail + 1);
  final maxIter = 50 + detail * 20;
  const double xmin = -2.0;
  const double xmax = 1.0;
  const double ymin = -1.5;
  const double ymax = 1.5;
  final points = <math.Point<double>>[];
  for (int i = 0; i < resolution; i++) {
    for (int j = 0; j < resolution; j++) {
      final a = xmin + (xmax - xmin) * i / resolution;
      final b = ymin + (ymax - ymin) * j / resolution;
      double x = 0;
      double y = 0;
      int iter = 0;
      while (x * x + y * y <= 4 && iter < maxIter) {
        final xNew = x * x - y * y + a;
        y = 2 * x * y + b;
        x = xNew;
        iter++;
      }
      if (iter == maxIter) {
        final nx = (2 * a + 1) / 3;
        final ny = (2 * b) / 3;
        points.add(math.Point(nx, ny));
      }
    }
  }
  return points;
}

/// Generate points for a Julia set normalized to [-1, 1].
///
/// The optional [detail] parameter increases resolution and iteration depth.
List<math.Point<double>> generateJulia({int detail = 0}) {
  final resolution = 200 * (detail + 1);
  final maxIter = 50 + detail * 20;
  const double xmin = -1.5;
  const double xmax = 1.5;
  const double ymin = -1.5;
  const double ymax = 1.5;
  const double ca = -0.4;
  const double cb = 0.6;
  final points = <math.Point<double>>[];
  for (int i = 0; i < resolution; i++) {
    for (int j = 0; j < resolution; j++) {
      final a = xmin + (xmax - xmin) * i / resolution;
      final b = ymin + (ymax - ymin) * j / resolution;
      double x = a;
      double y = b;
      int iter = 0;
      while (x * x + y * y <= 4 && iter < maxIter) {
        final xNew = x * x - y * y + ca;
        y = 2 * x * y + cb;
        x = xNew;
        iter++;
      }
      if (iter == maxIter) {
        final nx = a / 1.5;
        final ny = b / 1.5;
        points.add(math.Point(nx, ny));
      }
    }
  }
  return points;
}

/// Generate Sierpinski triangle points using the chaos game.
/// [detail] increases the number of iterations exponentially.
List<math.Point<double>> generateSierpinski({int detail = 0}) {
  final iterations = 10000 * (detail + 1);
  final vertices = [
    math.Point(-1.0, -1.0),
    math.Point(1.0, -1.0),
    math.Point(0.0, 1.0),
  ];
  final rng = math.Random(0);
  var point = vertices[0];
  final points = <math.Point<double>>[];
  for (int i = 0; i < iterations; i++) {
    final v = vertices[rng.nextInt(3)];
    point = math.Point((point.x + v.x) / 2, (point.y + v.y) / 2);
    points.add(point);
  }
  return points;
}

/// Generate Barnsley fern points normalized roughly to [-1, 1].
/// [detail] increases the number of iterations.
List<math.Point<double>> generateFern({int detail = 0}) {
  final iterations = 20000 * (detail + 1);
  final rng = math.Random(0);
  var x = 0.0;
  var y = 0.0;
  final points = <math.Point<double>>[];
  for (int i = 0; i < iterations; i++) {
    final r = rng.nextDouble();
    double nextX, nextY;
    if (r < 0.01) {
      nextX = 0.0;
      nextY = 0.16 * y;
    } else if (r < 0.86) {
      nextX = 0.85 * x + 0.04 * y;
      nextY = -0.04 * x + 0.85 * y + 1.6;
    } else if (r < 0.93) {
      nextX = 0.2 * x - 0.26 * y;
      nextY = 0.23 * x + 0.22 * y + 1.6;
    } else {
      nextX = -0.15 * x + 0.28 * y;
      nextY = 0.26 * x + 0.24 * y + 0.44;
    }
    x = nextX;
    y = nextY;
    final nx = x / 2.5;
    final ny = (y - 5) / 5;
    points.add(math.Point(nx, ny));
  }
  return points;
}

/// Generate points for the Koch snowflake outline.
/// [detail] controls the recursion depth of the snowflake.
List<math.Point<double>> generateKoch({int detail = 0}) {
  final iterations = 4 + detail;
  var path = <math.Point<double>>[
    math.Point(-0.5, -math.sqrt(3) / 6),
    math.Point(0.5, -math.sqrt(3) / 6),
    math.Point(0.0, math.sqrt(3) / 3),
    math.Point(-0.5, -math.sqrt(3) / 6),
  ];
  for (int iter = 0; iter < iterations; iter++) {
    final newPath = <math.Point<double>>[];
    for (int i = 0; i < path.length - 1; i++) {
      final p1 = path[i];
      final p2 = path[i + 1];
      final dx = (p2.x - p1.x) / 3;
      final dy = (p2.y - p1.y) / 3;
      final pa = p1;
      final pb = math.Point(p1.x + dx, p1.y + dy);
      final pd = math.Point(p1.x + 2 * dx, p1.y + 2 * dy);
      final angle = math.atan2(p2.y - p1.y, p2.x - p1.x) - math.pi / 3;
      final dist = math.sqrt(dx * dx + dy * dy);
      final pc = math.Point(
          pb.x + dist * math.cos(angle), pb.y + dist * math.sin(angle));
      newPath
        ..add(pa)
        ..add(pb)
        ..add(pc)
        ..add(pd);
    }
    newPath.add(path.last);
    path = newPath;
  }
  return path;
}

/// Generate points for the Burning Ship fractal normalized to [-1, 1].
///
/// The [detail] parameter increases both resolution and iteration depth.
List<math.Point<double>> generateBurningShip({int detail = 0}) {
  final resolution = 200 * (detail + 1);
  final maxIter = 50 + detail * 20;
  // Coordinates that frame the Burning Ship fractal well.
  const double xmin = -2.5;
  const double xmax = 1.5;
  const double ymin = -2.0;
  const double ymax = 1.0;
  final points = <math.Point<double>>[];
  for (int i = 0; i < resolution; i++) {
    for (int j = 0; j < resolution; j++) {
      final a = xmin + (xmax - xmin) * i / resolution;
      final b = ymin + (ymax - ymin) * j / resolution;
      double x = 0;
      double y = 0;
      int iter = 0;
      while (x * x + y * y <= 4 && iter < maxIter) {
        // The core difference from Mandelbrot: use absolute values.
        final xNew = x * x - y * y + a;
        y = (2 * x * y).abs() + b;
        x = xNew;
        iter++;
      }
      // We plot the points that "escape" to see the interesting structure.
      if (iter < maxIter) {
        // Normalize the point to fit within the [-1, 1] view.
        final nx = (a + 0.5) / 2.0;
        final ny = (b + 0.5) / 1.5;
        points.add(math.Point(nx, ny));
      }
    }
  }
  return points;
}
