import 'package:flutter/material.dart';
import 'package:teh_localiza/app/resources/colors.dart';

class InitialLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.moduleLocalization['secondary'],
        ),
      ),
    );
  }
}
