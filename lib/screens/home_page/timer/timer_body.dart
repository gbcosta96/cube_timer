import 'package:cube_timer/models/puzzle_config.dart';
import 'package:cube_timer/models/times_model.dart';
import 'package:cube_timer/screens/home_page/timer/cube_body.dart';
import 'package:cube_timer/utils/app_colors.dart';
import 'package:cube_timer/utils/dimensions.dart';
import 'package:cube_timer/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerBody extends StatefulWidget {
  final PuzzleConfig puzzle;
  final Function updateFather;
  const TimerBody({Key? key, required this.puzzle, required this.updateFather}) : super(key: key);

  @override
  State<TimerBody> createState() => TimerBodyState();
}

class TimerBodyState extends State<TimerBody> {
  final StopWatchTimer _stopwatch = StopWatchTimer();
  final int _oneHour = StopWatchTimer.getMilliSecFromHour(1);
  final int _oneMinute = StopWatchTimer.getMilliSecFromMinute(1);  
  bool isRunning = false;
  final GlobalKey<CubeBodyState> _myKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    _stopwatch.dispose();
  }

  void doScramble({int cubeSize = 3}) {
    setState(() {
      _myKey.currentState?.doScramble(cubeSize);
    });
    
  }

  void click() {
    if (!isRunning) {
      _stopwatch.onExecute.add(StopWatchExecute.reset);
      _stopwatch.onExecute.add(StopWatchExecute.start);
    } else {
      _stopwatch.onExecute.add(StopWatchExecute.stop);
      TimesModel.times.add(TimesModel(time: _stopwatch.rawTime.value, dateTime: DateTime.now(), scramble: _myKey.currentState?.getScramble()?? "", penalty: 0, comment: "", cube: widget.puzzle.name));
      doScramble(cubeSize: widget.puzzle.size);
    }
    setState(() {
      isRunning = !isRunning;
      widget.updateFather();
    });
  }

  Widget _stopwathWidget() {
    return StreamBuilder<int>(
      stream: _stopwatch.rawTime,
      initialData: 0,
      builder: (context, snap) {
        String text = StopWatchTimer.getDisplayTime(snap.data!, hours: snap.data! >= _oneHour, minute: snap.data! >= _oneMinute);
        return AppText(
          text: text,
          size: 120,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => click(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: AppColors.backColor,
            width: Dimensions.width(100),
            height: Dimensions.height(100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(!isRunning) ...[
                  const Spacer(),
                  CubeBody(key: _myKey, cubeSize: widget.puzzle.size),
                ],
                const Spacer(flex: 2),
                _stopwathWidget(),
                const Spacer(flex: 2)
              ],
            ),
          ),
        ),
      ),
    );
  }
}