import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:teh_localiza/app/resources/colors.dart';
import 'package:teh_localiza/modules/localization/domain/entities/localization.entity.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/localization.controller.dart';

class MapCard extends StatefulWidget {
  @override
  _MapCardState createState() => _MapCardState();
}

class _MapCardState extends ModularState<MapCard, LocalizationController> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.viewMap,
      builder: (context, isViewMap, child) {
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
                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              padding: EdgeInsets.all(8.0),
                              height: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.moduleLocalization['secondary'],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: FlutterMap(
                                mapController: controller.mapController,
                                options: MapOptions(
                                  center: point(
                                    localization: localization,
                                    localizationSearch: localizationSearch,
                                    isSearching: isSearching,
                                    isSharing: isSharing,
                                    isViewMap: isViewMap,
                                  ),
                                  zoom: 13.0,
                                ),
                                layers: [
                                  TileLayerOptions(
                                    urlTemplate:
                                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                    subdomains: ['a', 'b', 'c'],
                                    tileProvider:
                                        NonCachingNetworkTileProvider(),
                                  ),
                                  MarkerLayerOptions(
                                    markers: [
                                      Marker(
                                        width: 80.0,
                                        height: 80.0,
                                        point: point(
                                          localization: localization,
                                          localizationSearch:
                                              localizationSearch,
                                          isSearching: isSearching,
                                          isSharing: isSharing,
                                          isViewMap: isViewMap,
                                        ),
                                        builder: (ctx) => new Container(
                                          child: Icon(
                                            Icons.radio_button_on_outlined,
                                            color: AppColors
                                                .moduleLocalization['primary'],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            isViewMap == false ? disableViewMap() : Container(),
                          ],
                        );
                      },
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

  LatLng point({
    Localization localization,
    Localization localizationSearch,
    bool isSharing,
    bool isSearching,
    bool isViewMap,
  }) =>
      [
        localization != null
            ? LatLng(
                localization.latitude,
                localization.longitude,
              )
            : controller.defaultLatLon,
        localizationSearch != null
            ? LatLng(
                localizationSearch.latitude,
                localizationSearch.longitude,
              )
            : controller.defaultLatLon,
        LatLng(
          controller.lastLocalizations.value.latitude,
          controller.lastLocalizations.value.longitude,
        ),
        controller.defaultLatLon,
      ][compileTypeMap(
        isSearching: isSearching,
        isSharing: isSharing,
        isViewMap: isViewMap,
      )];

  int compileTypeMap({bool isSharing, bool isSearching, bool isViewMap}) {
    if (isViewMap == true) {
      if (isSharing == true && isSearching == false) {
        return 0;
      } else if (isSharing == false && isSearching == true) {
        return 1;
      }
      return 2;
    }
    return 3;
  }

  Widget disableViewMap() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.transparent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Icon(
          Icons.visibility_off_outlined,
          size: 64.0,
          color: AppColors.moduleLocalization['secondary'],
        ),
      ),
    );
  }
}
