import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:teh_localiza/app/resources/colors.dart';
import 'package:teh_localiza/app/resources/string.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/localization.controller.dart';

class FormCodeCard extends StatefulWidget {
  @override
  _FormCodeCardState createState() => _FormCodeCardState();
}

class _FormCodeCardState
    extends ModularState<FormCodeCard, LocalizationController> {
  final border = OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.moduleLocalization['primary'],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.moduleLocalization['secondary'],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Form(
        key: controller.globalKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppStrings.formCodeHint,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontSize: 14,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller.codeFormController,
                cursorColor: AppColors.moduleLocalization['primary'],
                style: Theme.of(context).textTheme.headline5,
                validator: controller.validateCodeUuid,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  enabledBorder: border,
                  border: border,
                  focusedBorder: border,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
