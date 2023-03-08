import 'dart:developer';
import 'dart:math' as x;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import 'countries_with_neighbouring.dart';

class Model {
  Model(this.state, this.color, this.stateCode);

  String state;
  Color color;
  String stateCode;
}

final colors = ["red", "blue", "yellow", "green"];
final map2 = {};

colorTheMap() {
  countriesMap.forEach((key, value) {
    List allColors = List.from(colors);
    var country = key;
    value["neighbours"]?.forEach((value2) {
      if (map2[value2["countryCode"]] != null) {
        allColors.remove(map2[value2["countryCode"]]);
      } else {}
    });
    map2[country] = allColors.isEmpty ? "green" : allColors.first;
  });
  log(map2.toString());
}

Color col(String color) {
  if (color == "red") {
    return Colors.red;
  } else if (color == "yellow") {
    return Colors.yellow;
  } else if (color == "blue") {
    return Colors.blue;
  } else {
    return Colors.green;
  }
}

class MapColoring2 extends StatefulWidget {
  const MapColoring2({super.key});

  @override
  State<MapColoring2> createState() => _MapColoring2State();
}

class _MapColoring2State extends State<MapColoring2> {
  late MapShapeSource _mapSource;
  late MapShapeLayer mapShapeLayer;
  @override
  void initState() {
    InitMap();
    super.initState();
  }

  void InitMap() {
    colorTheMap();
    _mapSource = MapShapeSource.asset(
      'assets/countries.geojson',
      shapeDataField: 'ISO_A2',
      dataCount: map2.length,
      primaryValueMapper: (int index) => map2.keys.elementAt(index),
      shapeColorValueMapper: (int index) => col(map2.values.elementAt(index)),
    );
    mapShapeLayer = MapShapeLayer(
      source: _mapSource,
      tooltipSettings: MapTooltipSettings(),
      onSelectionChanged: (s) {
        print(s);
      },
      zoomPanBehavior: MapZoomPanBehavior(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          colors.shuffle();
          InitMap();
          setState(() {});
        },
      ),
      body: SfMaps(
        layers: [mapShapeLayer],
      ),
    );
  }
}
