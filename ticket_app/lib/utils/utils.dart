import 'package:intl/intl.dart';

List<Map<String, dynamic>> buildItemsMap<T>(
  List<T> items,
  String? valueProperty,
) {
  Set<dynamic> uniqueValues = {};
  List<Map<String, dynamic>> result = [];

  for (T item in items) {
    dynamic value;
    Map<String, dynamic> itemMap;

    if (item is String) {
      value = item;
      itemMap = {'value': item};
    } else {
      try {
        itemMap = (item as dynamic).toJson() as Map<String, dynamic>;
      } catch (e) {
        throw ArgumentError(
            "Item does not have a toJson method or is not a map.");
      }

      if (valueProperty != null) {
        if (!itemMap.containsKey(valueProperty)) {
          throw ArgumentError("Property '$valueProperty' not found in item.");
        }
        value = itemMap[valueProperty];
      } else {
        value = item;
      }
    }

    if (uniqueValues.add(value)) {
      result.add(itemMap);
    }
  }

  return result;
}

String formatDate(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('MM-dd-yyyy').format(parsedDate); // Formato YYYY-MM-DD
}

String formatTime(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('hh:mm a').format(parsedDate); // Formato 12h con AM/PM
}

extension DateTimeExtensions on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
