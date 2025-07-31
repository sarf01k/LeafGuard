import 'package:intl/intl.dart';

String convertDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat("d MMMM y").format(dateTime.toLocal());
}
