import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final ValueChanged<String>? change;
  final TextAlign align;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool readOnly;

  const CustomTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.align = TextAlign.left,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.change,
    this.validator,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final valorFormatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9,]'));

    return TextFormField(
      controller: controller,
      textAlign: align,
      textAlignVertical: TextAlignVertical.bottom,
      onChanged: change,
      inputFormatters:
          keyboardType == TextInputType.number ? [valorFormatter] : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Colors.grey,
              decorationColor: Colors.black,
              fontSize: 16,
            ),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Colors.grey,
              decoration: TextDecoration.none,
              fontSize: 16,
            ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
      style: Theme.of(context).textTheme.labelMedium,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, preencha o campo  ${labelText ?? ''}';
            }
            return null;
          },
    );
  }
}
