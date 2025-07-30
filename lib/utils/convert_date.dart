import 'package:intl/intl.dart';

String convertDate(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);

  return DateFormat("d MMMM y").format(dateTime.toLocal());
}
