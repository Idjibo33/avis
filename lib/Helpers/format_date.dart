// ignore: strict_top_level_inference
String formatDate(var date) {
  final timestamp = DateTime.parse(date);
  String day = timestamp.day.toString();
  String month = timestamp.month.toString();
  String year = timestamp.year.toString();
  return "$day/$month/$year";
}
