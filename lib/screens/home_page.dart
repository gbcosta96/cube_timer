import 'package:cube_timer/models/cube_model.dart';
import 'package:cube_timer/utils/app_colors.dart';
import 'package:cube_timer/utils/dimensions.dart';
import 'package:cube_timer/widgets/app_button.dart';
import 'package:cube_timer/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StopWatchTimer _stopwatch = StopWatchTimer();
  final int _oneHour = StopWatchTimer.getMilliSecFromHour(1);
  final int _oneMinute = StopWatchTimer.getMilliSecFromMinute(1);  
  bool isRunning = false;

  final double _svgSize = Dimensions.width(10);
  String _scramble = " ";
  final CubeModel _myCube = CubeModel(7);

  static const _defaultSVGColors = {
    CubeFaces.up: Colors.white,
    CubeFaces.right: Colors.red,
    CubeFaces.front: Colors.green,
    CubeFaces.down: Colors.yellow,
    CubeFaces.left: Colors.orange,
    CubeFaces.back: Colors.blue,
  };
  

  void _doScramble() {
    setState(() {
      _myCube.solvedCube();
      _scramble = _myCube.generateScramble();
      _myCube.scramble(_scramble);
    });
  }

  @override
  void initState() {
    _doScramble();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _stopwatch.dispose();
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
          for (int i = 0; i < _myCube.size*_myCube.size; i++)
          _tile(_defaultSVGColors[_myCube.stickers[face.index][i]]!),
        ],
      ),
    );
  }

  Widget _cubeShape() {
    return SizedBox(
      width: _svgSize * 4.3,
      height: _svgSize * 3.2,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: _svgSize*1.1),
              _face(CubeFaces.up),
              SizedBox(width: (_svgSize*1.1) * 2),
            ],
          ),
          SizedBox(height: _svgSize*0.1),
          Row(
            children: [
              _face(CubeFaces.left),
              SizedBox(width: _svgSize*0.1),
              _face(CubeFaces.front),
              SizedBox(width: _svgSize*0.1),
              _face(CubeFaces.right),
              SizedBox(width: _svgSize*0.1),
              _face(CubeFaces.back),
            ],
          ),
          SizedBox(height: _svgSize*0.1),
          Row(
            children: [
              SizedBox(width: _svgSize*1.1),
              _face(CubeFaces.down),
              SizedBox(width: (_svgSize*1.1) * 2),
            ],
          ),
        ],
      ),
    );
  }

  void click() {
    if (!isRunning) {
      _stopwatch.onExecute.add(StopWatchExecute.reset);
      _stopwatch.onExecute.add(StopWatchExecute.start);
    } else {
      _stopwatch.onExecute.add(StopWatchExecute.stop);
      _doScramble();
    }
    setState(() {
      isRunning = !isRunning;
    });
  }

  Widget _stopwathWidget() {
    return StreamBuilder<int>(
      stream: _stopwatch.rawTime,
      initialData: 0,
      builder: (context, snap) {
        late String text;
        if (snap.data! >= _oneHour) {
          text = StopWatchTimer.getDisplayTime(snap.data!);
        } else if (snap.data! >= _oneMinute) {
          text = StopWatchTimer.getDisplayTime(snap.data!, hours: false);
        } else {
          text = StopWatchTimer.getDisplayTime(snap.data!,
              hours: false, minute: false);
        }
        return AppText(
          text: text,
          size: 120,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: const AppText(text: "Cube Timer"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              _cubeShape(),
              SizedBox(
                height: Dimensions.height(2),
              ),
              AppText(text: _scramble),
              const Spacer(flex: 2),
              _stopwathWidget(),
              AppButton(
                onTap: () {
                  click();
                },
                width: Dimensions.width(50),
                text: isRunning ? "Stop" : "Start",
                height: Dimensions.height(10),
              ),
              const Spacer(flex: 2)
            ],
          ),
        ),
      ),
    );
  }
}
