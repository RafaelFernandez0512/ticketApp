import 'package:flutter/material.dart';

class WeekdaySegmentedControl extends StatefulWidget {
  final String? initialDay;
  final ValueChanged<String>? onChanged;

  const WeekdaySegmentedControl({
    Key? key,
    this.initialDay,
    this.onChanged,
  }) : super(key: key);

  @override
  _WeekdaySegmentedControlState createState() =>
      _WeekdaySegmentedControlState();
}

class _WeekdaySegmentedControlState extends State<WeekdaySegmentedControl> {
  final List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  late String _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDay ?? _weekdays[0];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _weekdays.map((day) {
          final bool isSelected = day == _selectedDay;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = day;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(day);
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      isSelected ? Theme.of(context).primaryColor : Colors.grey,
                ),
              ),
              child: Text(
                day,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
