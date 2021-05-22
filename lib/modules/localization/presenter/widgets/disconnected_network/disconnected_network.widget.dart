import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:teh_localiza/app/app.module.dart';
import 'package:teh_localiza/app/resources/colors.dart';
import 'package:teh_localiza/app/resources/string.dart';

class DisconnectedNetwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_outlined,
            size: 64.0,
            color: AppColors.moduleLocalization['secondary'],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 8,
                child: Text(
                  AppStrings.disconnectedHint,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        color: AppColors.moduleLocalization['secondary'],
                      ),
                ),
              ),
              Flexible(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    print("volta");
                    //Navigator.popUntil(context, ModalRoute.withName('/'));
                    Phoenix.rebirth(context);
                    //Modular.init(AppModule());
                  },
                  child: Text(
                    "Recarregar",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          color: AppColors.moduleLocalization['secondary'],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
