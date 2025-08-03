import 'package:flutter/cupertino.dart' as FormBuilderValidators;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

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
  final bool isDateTimePicker;
  final bool readonly;
  final List<DropdownMenuItem<String>>? dropdownItems;
  final Function(String?)? onDropdownChanged;
  final Function(DateTime?)? onDateSelected;
  final bool disabled;
  final Function(String?)? onInputChanged;
  final String? defaultValue;
  final String? Function(String?)? validator;
  final String? Function(DateTime?)? datevalidator;
  final DateFormat? format;
  final bool required;

  const AppInputField(
      {super.key,
      required this.name,
      required this.label,
      this.hint = "",
      this.controller,
      this.keyboardType,
      this.inputFormatters,
      this.isMultiline = false,
      this.isDropdown = false,
      this.isDatePicker = false,
      this.isDateTimePicker = false,
      this.dropdownItems,
      this.format,
      this.onDropdownChanged,
      this.onDateSelected,
      this.disabled = false,
      this.onInputChanged,
      this.defaultValue,
      this.validator,
      this.readonly = false,
      this.required = false,
      this.datevalidator});

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
        RichText(
          text: TextSpan(
            text: label,
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w500),
            children: required
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 3),
        if (isDropdown && dropdownItems != null)
          FormBuilderDropdown<String>(
            name: name,
            items: dropdownItems ?? [],
            initialValue: defaultValue,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              // Update form field state
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
            validator: validator ??
                (value) {
                  if (required && (value == null || value.isEmpty)) {
                    return constants.required;
                  }
                  return null;
                },
          )
        else if (isDatePicker)
          FormBuilderDateTimePicker(
            name: name,
            inputType: InputType.date,
            controller: controller,
            format:
                format ?? DateFormat("dd-MM-yyyy"), // default format fallback
            initialValue: (controller?.text.isNotEmpty ?? false)
                ? (format ?? DateFormat("dd-MM-yyyy")).parse(controller!.text)
                : null, // Ensure date is populated when editing// Ensure intl package is imported
            firstDate: DateTime(1900),
            lastDate: DateTime(3000),
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
            validator: datevalidator ??
                (DateTime? value) {
                  // Accepts DateTime
                  if (required && (value == null)) {
                    return constants.datevalidate;
                  }
                  return null;
                },
          )
        else if (isDateTimePicker)
          FormBuilderDateTimePicker(
            name: name,
            controller: controller,
            inputType: InputType.both,
            format: format ?? DateFormat("yyyy-MM-dd HH:mm"),
            initialValue: (controller?.text.isNotEmpty ?? false)
                ? (format ?? DateFormat("yyyy-MM-dd HH:mm"))
                    .parse(controller!.text)
                : null,
            initialDatePickerMode: DatePickerMode.day,
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
            onChanged: (DateTime? value) {
              if (value != null) {
                controller?.text =
                    (format ?? DateFormat("dd-MM-yyyy HH:mm")).format(value);
                onDateSelected?.call(value);
              }
            },
            validator: datevalidator ??
                (DateTime? value) {
                  if (required && value == null) {
                    return constants.datevalidate;
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
            readOnly: readonly,
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
                  if (required && (value == null || value.isEmpty)) {
                    return constants.required;
                  }
                  return null;
                },
          ),
        SizedBox(height: 15.sp),
      ],
    );
  }
}

// FilteringTextInputFormatter.allow(
// RegExp(r'^\d*\.?\d{0,2}')),

// FilteringTextInputFormatter.allow(
// RegExp(r'^-?\d*\.?\d{0,2}')),
