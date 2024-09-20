import 'package:flutter/material.dart';
import 'package:meetup/constants/app_colors.dart';
import 'package:meetup/constants/app_text_styles.dart';

class CustomTextButton extends StatelessWidget {
  final Function? onPressed;
  final String title;
  const CustomTextButton({
    this.onPressed,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed != null ? onPressed!() : null,
      child: Text(
        title,
        style: AppTextStyle.h4TitleTextStyle(
          color: AppColor.primaryColor,
        ),
      ),
    );
  }
}
