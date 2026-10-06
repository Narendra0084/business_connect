import 'package:bihar_business_connect/common_widgets/reusable_widgets.dart';
import 'package:bihar_business_connect/core/constants/aap_style.dart';
import 'package:flutter/material.dart';

class RequiredDropdownWidgets<T> extends StatelessWidget {
  final String inputHintText;
  final List<DropdownMenuItem<T>>? dropdownItems;
  final Function(T?)? onChanged;
  final String validationName;
  final T? value;
  const RequiredDropdownWidgets({super.key, required this.inputHintText, this.dropdownItems, this.onChanged, required this.validationName, this.value});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      style: BBCStyle.mediumStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 16),
      hint: Text(
        inputHintText,
        style: BBCStyle.normalStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 14),
      ),
      dropdownColor: Colors.black,
      iconEnabledColor: Colors.white,
      iconDisabledColor: Colors.white,
      iconSize: 25,
      decoration: InputDecoration(
        fillColor: Theme.of(context).hintColor,
        focusedBorder: ReusableWidgets.buildInputTextFieldBorder(),
        border: ReusableWidgets.buildInputTextFieldBorder(),
        disabledBorder: ReusableWidgets.buildInputTextFieldBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        enabledBorder: ReusableWidgets.buildInputTextFieldBorder(),
      ),
      items: dropdownItems,
      onChanged: onChanged,
      value: value,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null) {
          return 'Please select your $validationName';
        }
        return null;
      },
    );
  }
}
