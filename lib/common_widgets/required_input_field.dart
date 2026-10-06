import 'package:bihar_business_connect/common_widgets/reusable_widgets.dart';
import 'package:bihar_business_connect/core/constants/aap_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RequiredField extends StatelessWidget {
  final bool inputReadOnly;
  final TextEditingController? inputController;
  final TextInputType inputKeyboardType;
  final List<TextInputFormatter>? inputTextFormatter;
  final Widget? inputSuffixIcon;
  final Function? inputValidator;
  final String inputHintText;
  final Function(String)? inputOnChanged;
  final bool inputObscureText;
  final Function()? inputOnTap;
  final String? inoutInitialValue;
  final int? inoutMaxLiens;
  const RequiredField({
    super.key,
    this.inputReadOnly = false,
    this.inputController,
    this.inputKeyboardType = TextInputType.text,
    this.inputTextFormatter,
    this.inputValidator,
    this.inputSuffixIcon,
    required this.inputHintText,
    this.inputOnChanged,
    this.inputObscureText = false,
    this.inputOnTap,
    this.inoutInitialValue,
    this.inoutMaxLiens,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: inputOnTap,
      readOnly: inputReadOnly,
      initialValue: inoutInitialValue,
      controller: inputController,
      keyboardType: inputKeyboardType,
      inputFormatters: inputTextFormatter,
      style: BBCStyle.mediumStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 16),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: inputValidator != null ? (value) => inputValidator!(value) : null,
      onChanged: inputOnChanged,
      obscureText: inputObscureText,
      maxLines: inoutMaxLiens ?? 1,
      decoration: InputDecoration(
        hintText: inputHintText,
        labelText: inputHintText,
        hintStyle: BBCStyle.mediumStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 16),
        labelStyle: BBCStyle.mediumStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 18),
        suffixIcon: inputSuffixIcon,
        focusedBorder: ReusableWidgets.buildInputTextFieldBorder(),
        border: ReusableWidgets.buildInputTextFieldBorder(),
        disabledBorder: ReusableWidgets.buildInputTextFieldBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        enabledBorder: ReusableWidgets.buildInputTextFieldBorder(),
        focusColor: Theme.of(context).hintColor,
        fillColor: Theme.of(context).hintColor,
      ),
    );
  }
}
