import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class AppInputField extends StatelessWidget {
  final String name;
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
  final Function(DateTime?)? onDateSelected;
  final bool disabled;
  final Function(String?)? onInputChanged;
  final String? defaultValue;
  final String? Function(String?)? validator;

  const AppInputField({
    super.key,
    required this.name,
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
    this.validator,
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
      borderSide: BorderSide(color: borderColor),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style:
              theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 3),
        if (isDropdown && dropdownItems != null)
          FormBuilderDropdown<String>(
            name: name,
            items: dropdownItems ?? [],
            initialValue: defaultValue,
            onChanged: (value) {
              if (onDropdownChanged != null) {
                onDropdownChanged!(value);
              }
            },
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
            validator: (value) {
              if (validator != null) {
                return validator!(value);
              }
              if (value == null || value.isEmpty) {
                return "Please select an option"; // ✅ Default validation
              }
              return null;
            },
          )
        else if (isDatePicker)
          FormBuilderDateTimePicker(
            name: name,
            inputType: InputType.date,
            controller: controller,
            format: DateFormat("dd-MM-yyyy"),
            initialValue: controller?.text.isNotEmpty == true
                ? DateFormat("dd-MM-yyyy").parse(controller!.text)
                : null, // Ensure date is populated when editing// Ensure intl package is imported
            firstDate: DateTime(1900),
            lastDate: DateTime(2101),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: onDateSelected,
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
            validator: (DateTime? value) {
              // Accepts DateTime
              if (value == null) {
                return "Please select a date";
              }
              return null;
            },
          )
        else
          FormBuilderTextField(
            name: name,
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLines: isMultiline ? null : 1,
            onChanged: onInputChanged,
            enabled: !disabled,
            initialValue: defaultValue,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
            validator: validator ??
                (value) {
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
