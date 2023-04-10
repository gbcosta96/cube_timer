
class PuzzleConfig {
  final String name;
  final int size;
  final bool bld;

  PuzzleConfig(this.name, this.size, {this.bld = false});

 @override
  bool operator ==(Object other) => other is PuzzleConfig && other.name == name;

  @override
  int get hashCode => name.hashCode;

  static List<PuzzleConfig> get getPuzzles => _puzzles;

  static final List<PuzzleConfig> _puzzles = [
    PuzzleConfig("2x2", 2),
    PuzzleConfig("3x3", 3),
    PuzzleConfig("4x4", 4),
    PuzzleConfig("5x5", 5),
    PuzzleConfig("6x6", 6),
    PuzzleConfig("7x7", 7),
    PuzzleConfig("3x3 bld", 3, bld: true),
    PuzzleConfig("4x4 bld", 4, bld: true),
    PuzzleConfig("5x5 bld", 5, bld: true),
  ];
  

  
}