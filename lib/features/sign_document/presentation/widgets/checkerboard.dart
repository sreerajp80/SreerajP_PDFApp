import 'package:material_ui/material_ui.dart';

/// A light grey checkerboard behind [child], the usual way to show which parts
/// of a picture are see-through.
class Checkerboard extends StatelessWidget {
  const Checkerboard({super.key, required this.child, this.cell = 12});

  final Widget child;
  final double cell;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _CheckerPainter(cell), child: child);
}

class _CheckerPainter extends CustomPainter {
  _CheckerPainter(this.cell);

  final double cell;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    final dark = Paint()..color = const Color(0xFFE6E6E6);
    for (var y = 0.0, row = 0; y < size.height; y += cell, row++) {
      for (var x = (row.isEven ? 0.0 : cell); x < size.width; x += cell * 2) {
        canvas.drawRect(Rect.fromLTWH(x, y, cell, cell), dark);
      }
    }
  }

  @override
  bool shouldRepaint(_CheckerPainter old) => old.cell != cell;
}
