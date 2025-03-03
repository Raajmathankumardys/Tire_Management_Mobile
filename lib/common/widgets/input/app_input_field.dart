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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        const SizedBox(height: 3),
        if (isDropdown && dropdownItems != null)
          DropdownButtonFormField<String>(
            items: dropdownItems,
            onChanged: onDropdownChanged,
            decoration: InputDecoration(hintText: hint),
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
            // validator: (value){
            //   if(value == null || value.isEmpty){
            //      return "Please fill this field";
            //   }
            //   return null;
            // },
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
          )
        else
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLines: isMultiline ? null : 1,
            onChanged: onInputChanged,
            readOnly: disabled,
            initialValue: defaultValue ?? "",
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
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
