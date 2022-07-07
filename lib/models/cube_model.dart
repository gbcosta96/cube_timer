
import 'dart:math';

import 'package:cube_timer/models/moves_model.dart';

enum CubeFaces{up, left, front, right, back, down}
enum FaceSector{north, east, south, west}

///  west   east
///     |   |   
///     # # #  -> North
///     # # #
///     # # #  -> South

class CubeModel {
  final int size;
  List<Map<FaceSector, List<int>>> sectors = [];
  List<List<CubeFaces>> stickers = [];

  CubeModel(this.size) {
    _getSectors();

    solvedCube();
  }

  /// Generate cube face and get sectors clockwise (e. g. 4x4)
  ///   0  1  2  3
  ///   4  5  6  7
  ///   8  9  10 11
  ///   12 13 14 15
  /// 
  ///   Outer sectors:
  ///   North = [0, 1, 2, 3]
  ///   East = [3, 7, 11, 15]
  ///   South = [15, 14, 13, 12]
  ///   West = [12, 8, 4, 0]
  /// 
  ///   Inner sectors:
  ///   North = [4, 5, 6, 7]
  ///   East = [2, 6, 10, 14]
  ///   South = [11, 10, 9, 8]
  ///   West = [12, 8, 4, 0]
  /// 
  void _getSectors() {
    List<List<int>> stickPos = List.generate(size, (i) => List.generate(size, (j) => i*size + j));

    for(int i = 0; i < size/2; i++) {
      List<int> auxEast = [];
      List<int> auxWest = [];
      for(int j = 0; j < size; j++) {
        auxEast.add(stickPos[j][size - 1 - i]);
        auxWest.add(stickPos[size - 1 -j][i]);
      }
      sectors.add({FaceSector.north: stickPos[i],
                  FaceSector.east: auxEast,
                  FaceSector.south: stickPos[size - 1 - i].reversed.toList(),
                  FaceSector.west: auxWest});
    }
  }

  /// Set the cube to solved state
  void solvedCube() {
    stickers = List.generate(6, (face) => List.generate(size*size, (sticker) => CubeFaces.values[face]));
  }

  /// Scramble the cube based on current state
  void scramble(String scramble) {
    List<MovesModel> moves = _getMoves(scramble);
    for(MovesModel move in moves) {
      _makeMove(move);
    }
  }

  List<MovesModel> _getMoves(String scramble) {
    List<MovesModel> moves = [];
    for(String move in scramble.trim().split(' ')) {
      MovesModel? moveModel = MovesModel.stringToMove(move);
      if(moveModel != null) {
        moves.add(moveModel);
      }
    }
    return moves;
  }

  void _makeMove(MovesModel move) {
    List<List<Map<CubeFaces,List<int>>>> rotations = [];
    for(int i = 0; i < sectors.length; i++) {
      // rotate face stickers
      rotations.add([{move.face: sectors[i][FaceSector.north]!.getRange(i, size - i).toList()},
                     {move.face: sectors[i][FaceSector.east]!.getRange(i, size - i).toList()},
                     {move.face: sectors[i][FaceSector.south]!.getRange(i, size - i).toList()},
                     {move.face: sectors[i][FaceSector.west]!.getRange(i, size - i).toList()}]);
      if(i < move.wide) {
        switch(move.face) {
          // rotate adjacent stickers
          case CubeFaces.up:
            rotations.add([{CubeFaces.front: sectors[i][FaceSector.north]!}, {CubeFaces.left: sectors[i][FaceSector.north]!},
                          {CubeFaces.back: sectors[i][FaceSector.north]!}, {CubeFaces.right: sectors[i][FaceSector.north]!}]);
            break;

          case CubeFaces.down:
            rotations.add([{CubeFaces.front: sectors[i][FaceSector.south]!}, {CubeFaces.right: sectors[i][FaceSector.south]!},
                          {CubeFaces.back: sectors[i][FaceSector.south]!}, {CubeFaces.left: sectors[i][FaceSector.south]!}]);
            break;

          case CubeFaces.right:
            rotations.add([{CubeFaces.back: sectors[i][FaceSector.west]!}, {CubeFaces.down: sectors[i][FaceSector.east]!},
                          {CubeFaces.front: sectors[i][FaceSector.east]!}, {CubeFaces.up: sectors[i][FaceSector.east]!}]);
            break;
          
          case CubeFaces.left:
            rotations.add([{CubeFaces.back: sectors[i][FaceSector.east]!}, {CubeFaces.up: sectors[i][FaceSector.west]!},
                          {CubeFaces.front: sectors[i][FaceSector.west]!}, {CubeFaces.down: sectors[i][FaceSector.west]!}]);
            break;
          
          case CubeFaces.front:
            rotations.add([{CubeFaces.right: sectors[i][FaceSector.west]!}, {CubeFaces.down: sectors[i][FaceSector.north]!},
                          {CubeFaces.left: sectors[i][FaceSector.east]!}, {CubeFaces.up: sectors[i][FaceSector.south]!}]);
            break;

          case CubeFaces.back:
            rotations.add([{CubeFaces.right: sectors[i][FaceSector.east]!}, {CubeFaces.up: sectors[i][FaceSector.north]!},
                          {CubeFaces.left: sectors[i][FaceSector.west]!}, {CubeFaces.down: sectors[i][FaceSector.south]!}]);
            break;

          default:
            break;
        }
      }
    }
    
    for(var rotation in rotations) {
      _adjacentRotate(move.quantity, rotation);
    }
  }

  _adjacentRotate(int repetitions, List<Map<CubeFaces,List<int>>> moves) {
    for(int k = 0; k < repetitions; k++) {
      List<List<CubeFaces>> originalStickers = stickers.map<List<CubeFaces>>((element) => List.from(element)).toList();
      for(int i = 0; i < moves.length; i++) {
        int aux = (i + 1) % (moves.length);
        for(int j = 0; j < moves[0].values.first.length; j++) {
          stickers[moves[aux].keys.first.index][moves[aux].values.first[j]] = originalStickers[moves[i].keys.first.index][moves[i].values.first[j]]; 
        }
      }
    }
  }


  static const List<List<String>> _movesByGroup = [
    ["F", "F'", "F2"],
    ["B", "B'", "B2"],
    ["R", "R'", "R2"],
    ["L", "L'", "L2"],
    ["D", "D'", "D2"],
    ["U", "U'", "U2"],
  ];

  String generateScramble() {
    List<int> _groups = [Random().nextInt(6)];
    String scramble = "";
    int scrambleSize = 15 + Random().nextInt(6);
    while (_groups.length < scrambleSize) {
      int newNumber = Random().nextInt(6);
      if (newNumber != _groups[_groups.length - 1]) {
        if (_groups.length < 2 ||
            newNumber / 2 != _groups[_groups.length - 2]) {
          _groups.add(newNumber);
          scramble += "${_movesByGroup[newNumber][Random().nextInt(3)]} ";
        }
      }
    }
    return scramble;
  }

}