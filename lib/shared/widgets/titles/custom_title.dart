import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_standred/core/utils/app_colors.dart';
import 'package:new_standred/core/utils/styles.dart';
import 'package:new_standred/shared/animations/animation_utils.dart';
import 'package:new_standred/shared/widgets/fields/text_widget.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  final AnimationController controller;

  const CustomTitle({required this.text, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimationUtils.fade(
      controller: controller,
      child: ShaderMask(
        shaderCallback:
            (bounds) => LinearGradient(
              colors: [Colors.white, AppColors.blue100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
        child: TextWidget(text, style: TextStyles.font28Weight600WhiteTrans()),
      ),
    );
  }
}
