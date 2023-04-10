
class TimesModel {
  int time;
  DateTime dateTime;
  String scramble;
  int penalty;
  String comment;
  String cube;

  TimesModel({
    required this.time,
    required this.dateTime,
    required this.scramble,
    required this.penalty,
    required this.comment,
    required this.cube
  });

  static List<TimesModel> times = [];
}