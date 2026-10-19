// ignore: strict_top_level_inference
String formatDate(var date) {
  final DateTime? timestamp = DateTime.tryParse(date?.toString() ?? '');
  if (timestamp == null) {
    return date?.toString() ?? '';
  }
  final String day = timestamp.day.toString().padLeft(2, '0');
  final String month = timestamp.month.toString().padLeft(2, '0');
  final String year = timestamp.year.toString();
  return "$day/$month/$year";
}
