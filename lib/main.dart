import 'dart:async';
import 'dart:math';
import 'package:cube_app/flutter_cube.dart';
import 'package:flutter/material.dart';
import 'package:seekbar/seekbar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cube',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Cube Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  Scene _scene;
  Object _cube;
  AnimationController _controller;
  double _value = 0.0;
  double _valueCube = 0.0;
  double _secondValue = 0.0;

  Timer _progressTimer;
  Timer _secondProgressTimer;

  bool _done = false;

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    scene.camera.position.z =50;
    _cube = Object(scale: Vector3(2.0, 2.0, 2.0), backfaceCulling: false, fileName: 'assets/cube/floating-cube.obj');
    final int samples = 0;
    final double radius = 8;
    final double offset = 2 / samples;
    final double increment = pi * (3 - sqrt(5));
    for (var i = 0; i < samples; i++) {
      final y = (i * offset - 1) + offset / 2;
      final r = sqrt(1 - pow(y, 2));
      final phi = ((i + 1) % samples) * increment;
      final x = cos(phi) * r;
      final z = sin(phi) * r;
      final Object cube = Object(
        position: Vector3(x, y, z)..scale(radius),
        fileName: 'assets/cube/floating-cube.obj',
      );
      _cube.add(cube);
    }
    scene.world.add(_cube);
  }

  @override
  void initState() {
    super.initState();
    _resumeProgressTimer();
    _secondProgressTimer =
        Timer.periodic(const Duration(milliseconds: 10), (_) {
          setState(() {
            _secondValue += 0.001;
            if (_secondValue >= 1) {
              _secondProgressTimer.cancel();
            }
          });
        });
    super.initState();
  }

  _resumeProgressTimer() {
//    _progressTimer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      setState(() {
        _value += 0.0005;
        _valueCube += 10;
        if (_cube != null) {
//          _cube.rotation.z = _value;
//          _cube.scale.x =  _valueCube;
//          _cube.scale.y =  _valueCube;
//          _cube.scale.z =  _valueCube;
        _scene.camera.zoom = _valueCube;
          _cube.updateTransform();
          _scene.update();
        }
        if (_value >= 1) {
          _progressTimer.cancel();
          _done = true;
        }
      });
//    }
//    );
  /*  _controller = AnimationController(duration: Duration(milliseconds: 30000), vsync: this)
      ..addListener(() {
        if (_cube != null) {
          _cube.rotation.y = _controller.value * 360;
          _cube.updateTransform();
          _scene.update();
        }
      })
      ..repeat();*/
  }

  @override
  void dispose() {
//    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
       /* child: Cube(
          onSceneCreated: _onSceneCreated,
        ),*/
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
              Expanded(
              flex: 90,
              child:Cube(
              onSceneCreated: _onSceneCreated,
            ),
              ),
//            Cube(
//              onSceneCreated: _onSceneCreated,
//            ),
            Expanded(
              flex: 10,
    child:  Slider(
        value: _valueCube,
        min: 1,
        max: 100,
        divisions: 100,
        activeColor: Colors.green,
        inactiveColor: Colors.grey,
        label: '${_valueCube.round()}',
        onChanged: (double newValue) {
//          _value = newValue*10;
          setState(() {
            _valueCube = newValue.floorToDouble();
            if (_cube != null) {
//          _cube.rotation.z = _value;
//          _cube.scale.x =  _valueCube;
//          _cube.scale.y =  _valueCube;
//          _cube.scale.z =  _valueCube;
              _scene.camera.zoom = _valueCube;
              _cube.updateTransform();
              _scene.update();
            }
          });
        },
        semanticFormatterCallback: (double newValue) {
          return '${newValue.round()}';
        }
    ),
    /*          child:  SeekBar(
                value: _value,
                secondValue: _secondValue,
                progressColor: Colors.blue,
                secondProgressColor: Colors.blue.withOpacity(0.5),
                onStartTrackingTouch: () {
                  print('onStartTrackingTouch');
                  if (!_done) {
                    _progressTimer?.cancel();
                  }
                },
                onProgressChanged: (value) {
                  print('onProgressChanged:$value');
                  _value = value;
                },
                onStopTrackingTouch: () {
                  print('onStopTrackingTouch');
                  if (!_done) {
                    _resumeProgressTimer();
                  }
                },
              )*/
            )

              ]
          )
      ),
    );
  }
}
