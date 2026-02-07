class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  Position copyWith({int? x, int? y}) => Position(x ?? this.x, y ?? this.y);

  @override
  bool operator ==(Object other) =>
      other is Position && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}
