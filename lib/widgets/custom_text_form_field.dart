import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:meetup/constants/app_colors.dart';
import 'package:meetup/constants/input.styles.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    Key? key,
    this.filled,
    this.fillColor,
    this.textEditingController,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.labelText,
    this.hintText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.nextFocusNode,
    this.isReadOnly = false,
    this.onTap,
    this.minLines,
    this.maxLines,
    this.suffixIcon,
    this.prefixIcon,
  }) : super(key: key);

  //
  final bool? filled;
  final Color? fillColor;
  final TextEditingController? textEditingController;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;

  //
  final String? labelText;
  final String? hintText;
  final String? errorText;

  final Function? onChanged;
  final Function? onFieldSubmitted;
  final Function(String)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  final bool isReadOnly;
  final Function? onTap;
  final int? minLines;
  final int? maxLines;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
        enabledBorder: InputStyles.inputEnabledBorder(),
        errorBorder: InputStyles.inputEnabledBorder(),
        focusedErrorBorder: InputStyles.inputFocusBorder(),
        focusedBorder: InputStyles.inputFocusBorder(),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon ?? _getSuffixWidget(),
        labelStyle: Theme.of(context).textTheme.bodyLarge,
      ),
      cursorColor: AppColor.cursorColor,
      obscureText: (widget.obscureText) ? !makePasswordVisible : false,
      onTap: widget.onTap != null ? () => widget.onTap!() : null,
      readOnly: widget.isReadOnly,
      controller: widget.textEditingController,
      validator: widget.validator != null
          ? (data) => widget.validator!(data!)
          : (data) => null,
      focusNode: widget.focusNode,
      onFieldSubmitted: (data) {
        if (widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!(data);
        } else {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      onChanged:
          widget.onChanged != null ? (data) => widget.onChanged!(data) : null,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      minLines: widget.minLines,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
    );
  }

  //check if it's password input
  bool makePasswordVisible = false;
  Widget _getSuffixWidget() {
    if (widget.obscureText) {
      return ButtonTheme(
        minWidth: 30,
        height: 30,
        padding: const EdgeInsets.all(0),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
          ),
          onPressed: () {
            setState(() {
              makePasswordVisible = !makePasswordVisible;
            });
          },
          child: Icon(
            (!makePasswordVisible) ? LineIcons.eyeSlashAlt : LineIcons.eye,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
