import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:teh_localiza/app/resources/colors.dart';
import 'package:teh_localiza/app/resources/string.dart';
import 'package:teh_localiza/modules/localization/domain/entities/localization.entity.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/localization.controller.dart';

class AddressCard extends StatefulWidget {
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState
    extends ModularState<AddressCard, LocalizationController> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Localization>(
      valueListenable: controller.localization,
      builder: (context, localization, child) {
        return ValueListenableBuilder<Localization>(
          valueListenable: controller.localizationSearch,
          builder: (context, localizationSearch, child) {
            return ValueListenableBuilder<bool>(
              valueListenable: controller.sharing,
              builder: (context, isSharing, child) {
                return ValueListenableBuilder<bool>(
                  valueListenable: controller.searching,
                  builder: (context, isSearching, child) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 6.5,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppColors.moduleLocalization['secondary'],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: <Widget>[
                        Column(
                          children: [
                            Row(
                              children: [
                                <Widget>[
                                  Icon(
                                    Icons.share_outlined,
                                    color: Colors.green,
                                  ),
                                  Icon(
                                    Icons.location_searching_outlined,
                                    color: Colors.red,
                                  ),
                                  Container()
                                ][compileTypeLocalization(
                                  isSearching: isSearching,
                                  isSharing: isSharing,
                                )],
                                SizedBox(
                                  width: 8.0,
                                ),
                                Flexible(
                                  child: Text(
                                    [
                                      "Latitude: " +
                                          (localization != null
                                              ? localization.latitude.toString()
                                              : ""),
                                      "Latitude: " +
                                          (localizationSearch != null
                                              ? localizationSearch.latitude
                                                  .toString()
                                              : ""),
                                      "Latitude: "
                                    ][compileTypeLocalization(
                                      isSearching: isSearching,
                                      isSharing: isSharing,
                                    )],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Flexible(
                                  child: Text(
                                    [
                                      "Longitude: " +
                                          (localization != null
                                              ? localization.longitude
                                                  .toString()
                                              : ""),
                                      "Longitude: " +
                                          (localizationSearch != null
                                              ? localizationSearch.longitude
                                                  .toString()
                                              : ""),
                                      "Longitude: "
                                    ][compileTypeLocalization(
                                      isSearching: isSearching,
                                      isSharing: isSharing,
                                    )],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                              ],
                            ),
                            enableViewAddress(),
                          ],
                        ),
                        disableViewAddress(),
                      ][compileLocalization(
                        isSearching: isSearching,
                        isSharing: isSharing,
                      )],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget enableViewAddress() {
    return ValueListenableBuilder<String>(
      valueListenable: controller.address,
      builder: (context, address, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: controller.addressLoading,
          builder: (context, isLoading, child) {
            return isLoading == true
                ? Container()
                : Row(
                    children: [
                      Flexible(
                        child: SelectableText(
                          address,
                          maxLines: 3,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  );
          },
        );
      },
    );
  }

  Widget disableViewAddress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_off_outlined),
        Flexible(
          child: Text(
            AppStrings.sharingHint,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ],
    );
  }

  int compileLocalization({bool isSharing, bool isSearching}) {
    if (isSharing == true && isSearching == false) {
      return 0;
    } else if (isSharing == false && isSearching == true) {
      return 0;
    }
    return 1;
  }

  int compileTypeLocalization({bool isSharing, bool isSearching}) {
    if (isSharing == true && isSearching == false) {
      return 0;
    } else if (isSharing == false && isSearching == true) {
      return 1;
    }
    return 2;
  }
}
