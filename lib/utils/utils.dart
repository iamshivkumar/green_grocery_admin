import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class Utils {
  static List<String> categories = [
    'Popular',
    'Fruits',
    "Vegetables",
    'Food',
    'Drinks',
    'Snacks'
  ];

  static String formatedAddress(Placemark placemark) {
    return "${placemark.name}, ${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}, ${placemark.postalCode}.";
  }

  static DateTime now = DateTime.now();
  static DateTime today = DateTime(now.year, now.month, now.day);

  static List<DateTime> deliveryDates = [
    today,
    today.add(
      Duration(days: 1),
    ),
    today.add(
      Duration(days: 2),
    ),
  ];

  static String weekday(DateTime dateTime) {
    if (dateTime == today) {
      return "Today";
    } else if (dateTime ==
        today.add(
          Duration(days: 1),
        )) {
      return "Tommorow";
    } else {
      return DateFormat(DateFormat.WEEKDAY).format(dateTime);
    }
  }

  static String formatedDate(DateTime dateTime)=>DateFormat(DateFormat.MONTH_DAY).format(dateTime);
}