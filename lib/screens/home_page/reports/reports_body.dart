import 'package:cube_timer/models/puzzle_config.dart';
import 'package:cube_timer/models/times_model.dart';
import 'package:cube_timer/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:intl/intl.dart';

class ReportsBody extends StatefulWidget {
  final PuzzleConfig puzzle;
  const ReportsBody({Key? key, required this.puzzle}) : super(key: key);

  @override
  State<ReportsBody> createState() => _ReportsBodyState();
}

class _ReportsBodyState extends State<ReportsBody> {
  final int _oneHour = StopWatchTimer.getMilliSecFromHour(1);
  final int _oneMinute = StopWatchTimer.getMilliSecFromMinute(1);  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: Dimensions.width(100/4),
            childAspectRatio: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
          ),
          itemCount: TimesModel.times.where((element) => element.cube == widget.puzzle.name).length,
          itemBuilder: (BuildContext ctx, index) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    DateFormat('dd/MM').format(TimesModel.times.where((element) => element.cube == widget.puzzle.name).toList()[index].dateTime)
                  ),
                  Text(
                    StopWatchTimer.getDisplayTime(
                      TimesModel.times.where((element) => element.cube == widget.puzzle.name).toList()[index].time,
                      hours: TimesModel.times.where((element) => element.cube == widget.puzzle.name).toList()[index].time >= _oneHour,
                      minute: TimesModel.times.where((element) => element.cube == widget.puzzle.name).toList()[index].time >= _oneMinute,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15)),
            );
          }
        ),
      ),
    );
  }
}
