import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:teh_localiza/app/resources/colors.dart';
import 'package:teh_localiza/app/resources/string.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/localization.controller.dart';

class ActionsCard extends StatefulWidget {
  @override
  _ActionsCardState createState() => _ActionsCardState();
}

class _ActionsCardState
    extends ModularState<ActionsCard, LocalizationController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height / 6.8,
      decoration: BoxDecoration(
        color: AppColors.moduleLocalization['secondary'],
        borderRadius: BorderRadius.circular(6),
      ),
      child: GridView.count(
        physics: BouncingScrollPhysics(),
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        padding: EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: controller.sharing,
            builder: (context, isSharing, child) {
              return actionCard(
                child: Icon(
                  Icons.share_outlined,
                  color: Colors.green,
                ),
                title: isSharing == true
                    ? AppStrings.noShareAction
                    : AppStrings.shareAction,
                onTap: () => controller.shareLocalization(!isSharing),
              );
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: controller.viewMap,
            builder: (context, isViewMap, child) {
              return actionCard(
                child: Icon(Icons.location_on_outlined),
                title: isViewMap == true
                    ? AppStrings.noMapAction
                    : AppStrings.mapAction,
                onTap: () => controller.setIsViewMap(!isViewMap),
              );
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: controller.searching,
            builder: (context, isSearching, child) {
              return actionCard(
                child: Icon(
                  Icons.location_searching_outlined,
                  color: Colors.red,
                ),
                title: isSearching == true
                    ? AppStrings.noSearchAction
                    : AppStrings.searchAction,
                onTap: isSearching == true
                    ? () => controller.searchLocalization(false)
                    : controller.localizeCode,
              );
            },
          ),
          actionCard(
            child: Icon(
              Icons.settings_outlined,
              color: Colors.black54,
            ),
            title: AppStrings.settingsAction,
            onTap: () => {},
          ),
        ],
      ),
    );
  }

  Widget actionCard({
    double radius = 20,
    Color backgroundColor = Colors.white,
    Color borderColor = Colors.grey,
    double strokeWidth = 2.0,
    Widget child,
    String title,
    Function onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: borderColor,
            child: CircleAvatar(
              backgroundColor: backgroundColor,
              radius: radius - strokeWidth,
              child: child,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.headline3.copyWith(
                  color: Colors.black,
                ),
          )
        ],
      ),
    );
  }
}
