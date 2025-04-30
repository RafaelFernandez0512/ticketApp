import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/ui/widgets/custom_text_field.dart';

class CustomDatePicker extends StatefulWidget {
  CustomDatePicker(
      {super.key,
      this.finalDefaultValue,
      this.onChanged,
      required this.labelText,
      this.enabled});
  DateTime? finalDefaultValue;
  final ValueChanged<DateTime?>? onChanged;
  bool? enabled;
  String labelText;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

_getStringFromDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  Widget build(BuildContext context) {
    var date = widget.finalDefaultValue;
    var controller = TextEditingController(
        text: widget.finalDefaultValue == null
            ? '--/--/----'
            : _getStringFromDate(date!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: widget.enabled ?? true
                      ? () {
                          _selectDate(context,
                              date); // Llama al método para abrir el selector de fecha
                        }
                      : null,
                  child: AbsorbPointer(
                    // Evita que el usuario edite directamente el campo
                    child: CustomTextField(
                      key: super.widget.key,
                      labelText: "",
                      readOnly: false,
                      controller: controller,
                    ),
                  ),
                ),
              ),
            ]),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 356 * 100)),
      builder: (context, child) {
        var currentTheme = Theme.of(context);
        return Theme(
          data: currentTheme.copyWith(
            colorScheme: ColorScheme.light(
              primary: currentTheme.primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: currentTheme.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    widget.onChanged!(picked);
  }
}
