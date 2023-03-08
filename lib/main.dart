import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapcoloring/countries_with_neighbouring.dart';
import 'package:mapcoloring/synfMap.dart';
import 'package:vector_map/vector_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapColoring2(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VectorMapController? _controller;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String geoJson = await rootBundle.loadString('assets/countries.geojson');
      MapDataSource ds =
          await MapDataSource.geoJson(geoJson: geoJson, keys: ["ADMIN"]);
      MapLayer layer = MapLayer(
          dataSource: ds,
          theme: MapRuleTheme(contourColor: Colors.white, colorRules: [
            (feature) {
              print(feature.properties);
              String? value = feature.getValue('ADMIN');

              print(feature.properties);
              print(value);
              return value == 'Afghanistan' ? Colors.red : Colors.lightGreen;
            },
            (feature) {
              double? value = feature.getDoubleValue('Seq');
              return value != null && value < 3 ? Colors.green : null;
            },
            (feature) {
              double? value = feature.getDoubleValue('Seq');
              return value != null && value > 9 ? Colors.blue : null;
            }
          ]));

      setState(() {
        _controller =
            VectorMapController(layers: [layer], delayToRefreshResolution: 0)
              ..zoom(Offset(0, 0), 2);

        //_controller= VectorMapController(layers: [roomsLayer, levelLayer, workplacesLayer]);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[200],
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: _controller == null
            ? CircularProgressIndicator()
            : VectorMap(
                controller: _controller,
                clickListener: (feature) => print(feature.properties),
              ));
  }
}

final Map<String, Map> map = {
  "Egypt": {
    "north": "none",
    "south": "sudan",
    "west": "libia",
    "east": "none",
  },
};
