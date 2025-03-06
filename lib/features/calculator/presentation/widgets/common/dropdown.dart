import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final IconData? prefixIcon;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.lightGreenAccent[50],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.lightGreenAccent[700]),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.lightGreenAccent[700])
              : null,
          filled: true,
          fillColor: Colors.lightGreenAccent[50],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Colors.lightGreenAccent[200]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Colors.lightGreenAccent[700]!, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        ),
        style: TextStyle(color: Colors.lightGreenAccent[900]),
        items: items
            .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item,
                    style: TextStyle(color: Colors.lightGreenAccent[900]))))
            .toList(),
        onChanged: onChanged,
        icon: Icon(Icons.arrow_drop_down, color: Colors.lightGreenAccent[700]),
      ),
    );
  }
}
