import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isMultiline;
  final bool isDropdown;
  final bool isDatePicker;
  final List<DropdownMenuItem<String>>? dropdownItems;
  final Function(String?)? onDropdownChanged;
  final Function(DateTime)? onDateSelected;
  final bool disabled;
  final Function(String?)? onInputChanged;
  final String? defaultValue;

  const AppInputField({
    super.key,
    required this.label,
    this.hint = "",
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.isMultiline = false,
    this.isDropdown = false,
    this.isDatePicker = false,
    this.dropdownItems,
    this.onDropdownChanged,
    this.onDateSelected,
    this.disabled = false,
    this.onInputChanged,
    this.defaultValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputFillColor =
        theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.white;
    final borderColor =
        theme.brightness == Brightness.dark ? Colors.white60 : Colors.grey;
    final focusedBorderColor = theme.colorScheme.primary;

    OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor!),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          /*style:
              theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),*/
        ),
        const SizedBox(height: 3),
        if (isDropdown && dropdownItems != null)
          DropdownButtonFormField<String>(
            items: dropdownItems,
            onChanged: onDropdownChanged,
            decoration: InputDecoration(
              hintText: hint,
              border: borderStyle,
              enabledBorder: borderStyle,
              focusedBorder: borderStyle.copyWith(
                borderSide: BorderSide(color: focusedBorderColor),
              ),
              filled: true,
              fillColor: inputFillColor,
            ),
          )
        else if (isDatePicker)
          TextFormField(
            controller: controller,
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null && onDateSelected != null) {
                onDateSelected!(pickedDate);
              }
            },
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: const Icon(Icons.calendar_today),
              border: borderStyle,
              enabledBorder: borderStyle,
              focusedBorder: borderStyle.copyWith(
                borderSide: BorderSide(color: focusedBorderColor),
              ),
              filled: true,
              fillColor: inputFillColor,
            ),
          )
        else
          TextFormField(
            style: theme.textTheme.bodyMedium,
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLines: isMultiline ? null : 1,
            onChanged: onInputChanged,
            readOnly: disabled,
            initialValue: defaultValue ?? "",
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              border: borderStyle,
              enabledBorder: borderStyle,
              contentPadding: const EdgeInsets.all(8),
              focusedBorder: borderStyle.copyWith(
                borderSide: BorderSide(color: focusedBorderColor),
              ),
              filled: true,
              fillColor: inputFillColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please fill this field";
              }
              return null;
            },
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
