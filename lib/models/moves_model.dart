import 'package:cube_timer/models/cube_model.dart';

class MovesModel {
  final CubeFaces face;
  int wide;
  int quantity;

  MovesModel({required this.face, this.wide = 1, this.quantity = 1});

  static MovesModel? stringToMove(String str) {
    MovesModel? moveModel;
    if(str.contains("F")) {
      moveModel = MovesModel(face: CubeFaces.front);
    } else if(str.contains("B")) {
      moveModel = MovesModel(face: CubeFaces.back);
    } else if(str.contains("L")) {
      moveModel = MovesModel(face: CubeFaces.left);
    } else if(str.contains("R")) {
      moveModel = MovesModel(face: CubeFaces.right);
    } else if(str.contains("U")) {
      moveModel = MovesModel(face: CubeFaces.up);
    } else if(str.contains("D")) {
      moveModel = MovesModel(face: CubeFaces.down);
    } else {
      return null;
    }

    if(str.endsWith("'")) {
      moveModel.quantity = 3;
    } else if(str.endsWith("2")) {
      moveModel.quantity = 2;
    }

    if(str.contains("w")) {
      moveModel.wide = int.tryParse(str[0]) ?? 2;
    }
    return null;
  }
}