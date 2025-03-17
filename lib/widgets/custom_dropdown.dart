import 'package:flutter/material.dart';

class CustomDropdown<T> extends FormField<T> {
  CustomDropdown({
    Key? key,
    required List<T> items,
    required T? value,
    required String hint,
    required ValueChanged<T?> onChanged,
    required String Function(T)? itemLabel,
    required IconData Function(T)? itemIcon,
    FormFieldValidator<T>? validator,
  }) : super(
          key: key,
          initialValue: value,
          validator: validator,
          builder: (FormFieldState<T> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: state.hasError ? Colors.red : Colors.black),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      isExpanded: true,
                      value: state.value,
                      hint: Text(hint),
                      onChanged: (newValue) {
                        state.didChange(newValue);
                        onChanged(newValue);
                      },
                      icon: Icon(Icons.arrow_drop_down),
                      dropdownColor: Colors.white,
                      items: items.map((T item) {
                        return DropdownMenuItem<T>(
                          value: item,
                          child: Row(
                            children: [
                              if (itemIcon != null)
                                Icon(itemIcon(item), size: 20),
                              SizedBox(width: 10),
                              Text(itemLabel != null
                                  ? itemLabel(item)
                                  : item.toString()),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    ),
                  ),
              ],
            );
          },
        );
}
