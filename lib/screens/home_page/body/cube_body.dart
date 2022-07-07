import 'package:cube_timer/models/cube_model.dart';
import 'package:cube_timer/utils/dimensions.dart';
import 'package:cube_timer/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CubeBody extends StatefulWidget {
  const CubeBody({Key? key}) : super(key: key);

  @override
  State<CubeBody> createState() => CubeBodyState();
}

class CubeBodyState extends State<CubeBody> {
  final double _svgSize = Dimensions.width(10);
  String _scramble = " ";
  final CubeModel _myCube = CubeModel(3);

  static const _defaultSVGColors = {
    CubeFaces.up: Colors.white,
    CubeFaces.right: Colors.red,
    CubeFaces.front: Colors.green,
    CubeFaces.down: Colors.yellow,
    CubeFaces.left: Colors.orange,
    CubeFaces.back: Colors.blue,
  };

  @override
  void initState() {
    doScramble();
    super.initState();
  }

  void doScramble() {
    setState(() {
      _myCube.solvedCube();
      _scramble = _myCube.generateScramble();
      _myCube.scramble(_scramble);
    });
  }

  Widget _tile(Color color) {
    return Container(
      padding: EdgeInsets.all(_svgSize / 300),
      width: _svgSize / _myCube.size,
      height: _svgSize / _myCube.size,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _face(CubeFaces face) {
    return SizedBox(
      width: _svgSize,
      height: _svgSize,
      child: GridView.count(
        crossAxisCount: _myCube.size,
        children: [
          for (int i = 0; i < _myCube.size * _myCube.size; i++)
            _tile(_defaultSVGColors[_myCube.stickers[face.index][i]]!),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: _svgSize * 4.3,
          height: _svgSize * 3.2,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: _svgSize * 1.1),
                  _face(CubeFaces.up),
                  SizedBox(width: (_svgSize * 1.1) * 2),
                ],
              ),
              SizedBox(height: _svgSize * 0.1),
              Row(
                children: [
                  _face(CubeFaces.left),
                  SizedBox(width: _svgSize * 0.1),
                  _face(CubeFaces.front),
                  SizedBox(width: _svgSize * 0.1),
                  _face(CubeFaces.right),
                  SizedBox(width: _svgSize * 0.1),
                  _face(CubeFaces.back),
                ],
              ),
              SizedBox(height: _svgSize * 0.1),
              Row(
                children: [
                  SizedBox(width: _svgSize * 1.1),
                  _face(CubeFaces.down),
                  SizedBox(width: (_svgSize * 1.1) * 2),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: Dimensions.height(2),
        ),
        AppText(text: _scramble),
      ],
    );
  }
}
