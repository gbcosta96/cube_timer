
import 'package:cube_timer/models/puzzle_config.dart';
import 'package:cube_timer/models/times_model.dart';
import 'package:cube_timer/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:stop_watch_timer/stop_watch_timer.dart';

class GraphBody extends StatefulWidget {
  final PuzzleConfig puzzle;
  const GraphBody({Key? key, required this.puzzle}) : super(key: key);

  @override
  State<GraphBody> createState() => _GraphBodyState();
}

class _GraphBodyState extends State<GraphBody> {
  final int _oneHour = StopWatchTimer.getMilliSecFromHour(1);
  final int _oneMinute = StopWatchTimer.getMilliSecFromMinute(1);  
  
  @override
  Widget build(BuildContext context) {
    var puzzleList = TimesModel.times.where((element) => element.cube == widget.puzzle.name).toList();
    List<ChartItem> bestTimes = [];
    if(puzzleList.isNotEmpty) {
      bestTimes.add(ChartItem(0, puzzleList.first.time));
    }
    for(int i = 0; i < puzzleList.length; i++) {
      if (puzzleList[i].time < bestTimes[bestTimes.length - 1].value) {
        bestTimes.add(ChartItem(i, puzzleList[i].time));
      }
    }
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: Dimensions.width(100),
              height: Dimensions.height(40),
              child: charts.LineChart(
                [
                  charts.Series<int, int>(
                    id: "all",
                    colorFn: (_, __) => charts.MaterialPalette.white,
                    domainFn: (_, index) => index!,
                    measureFn: (value, _) => value,
                    data: puzzleList.map((e) => e.time).toList()
                  ),
                  charts.Series<ChartItem, int>(
                    id: "bests",
                    colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
                    domainFn: (value, _) => value.index,
                    measureFn: (value, _) => value.value,
                    data: bestTimes,
                    dashPatternFn: (_, __) => [2, 3],
                  ),
                  charts.Series<ChartItem, int>(
                    id: "bests",
                    colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
                    domainFn: (value, _) => value.index,
                    measureFn: (value, _) => value.value,
                    data: bestTimes,
                    dashPatternFn: (_, __) => [2, 3],
                  )..setAttribute(charts.rendererIdKey, 'customPoint'),
                ],            
                animate: true,
                defaultRenderer: charts.LineRendererConfig(),
                customSeriesRenderers: [
                  charts.PointRendererConfig(
                    customRendererId: 'customPoint',
                  ),
                ],
                primaryMeasureAxis: charts.NumericAxisSpec(
                  tickFormatterSpec: charts.BasicNumericTickFormatterSpec((num? value) {
                    return StopWatchTimer.getDisplayTime(value!.toInt(), hours: value.toInt() >= _oneHour, minute: value.toInt() >= _oneMinute);
                  }),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.height(40),
            )
          ],
        ),
      ),
    );
  }
}

class ChartItem {
  final int index;
  final int value;
  ChartItem(this.index, this.value);
}