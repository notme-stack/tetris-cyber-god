import 'package:flutter/material.dart';
import '../config/tokens.dart';
import '../logic/tetromino.dart';
import '../models/position.dart';

class NextPiecePreview extends StatelessWidget {
  final TetrominoType type;

  const NextPiecePreview({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _PreviewPainter(type),
      ),
    );
  }
}

class _PreviewPainter extends CustomPainter {
  final TetrominoType type;

  _PreviewPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 4;
    final paintFill = Paint()
      ..color = AppColors.lobbyPrimary
      ..style = PaintingStyle.fill;
    final paintBorder = Paint()
      ..color = AppColors.lobbyPrimary.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppBorders.thin;

    final tetromino = _tetromino();
    for (final cellPos in tetromino.cells(0)) {
      final offset = _centered(cellPos, cell);
      final rect = Rect.fromLTWH(offset.dx, offset.dy, cell, cell);
      canvas.drawRect(rect, paintFill);
      canvas.drawRect(rect, paintBorder);
    }
  }

  Offset _centered(Position pos, double cell) {
    final origin = (4 - 4) / 2;
    return Offset((pos.x + origin) * cell, (pos.y + origin) * cell);
  }

  Tetromino _tetromino() {
    switch (type) {
      case TetrominoType.I:
        return TetrominoLibrary.i;
      case TetrominoType.O:
        return TetrominoLibrary.o;
      case TetrominoType.T:
        return TetrominoLibrary.t;
      case TetrominoType.S:
        return TetrominoLibrary.s;
      case TetrominoType.Z:
        return TetrominoLibrary.z;
      case TetrominoType.J:
        return TetrominoLibrary.j;
      case TetrominoType.L:
        return TetrominoLibrary.l;
    }
  }

  @override
  bool shouldRepaint(covariant _PreviewPainter oldDelegate) {
    return oldDelegate.type != type;
  }
}
