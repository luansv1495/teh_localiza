import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:teh_localiza/app/resources/colors.dart';
import 'package:teh_localiza/app/resources/string.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/localization.controller.dart';

class CodeCard extends StatefulWidget {
  @override
  _CodeCardState createState() => _CodeCardState();
}

class _CodeCardState extends ModularState<CodeCard, LocalizationController> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.sharing,
      builder: (context, isSharing, child) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppColors.moduleLocalization['secondary'],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: controller.clientUid),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppStrings.copyCodeHint,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              color: AppColors.moduleLocalization['secondary'],
                            ),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.copy_outlined),
              ),
              SizedBox(
                width: 8.0,
              ),
              Flexible(
                child: Text(
                  controller.clientUid ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
