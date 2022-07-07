import 'package:cube_timer/screens/home_page/body/cube_body.dart';
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
  final GlobalKey<CubeBodyState> _myKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    _stopwatch.dispose();
  }

  void click() {
    if (!isRunning) {
      _stopwatch.onExecute.add(StopWatchExecute.reset);
      _stopwatch.onExecute.add(StopWatchExecute.start);
    } else {
      _stopwatch.onExecute.add(StopWatchExecute.stop);
      _myKey.currentState?.doScramble();
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
              CubeBody(key: _myKey),
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
