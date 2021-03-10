import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ui.Image _image;

  @override
  void initState() {
    _loadImage();
  }

  _loadImage() async {
    ByteData bd = await rootBundle.load("assets/t.png");

    final Uint8List bytes = Uint8List.view(bd.buffer);

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);

    final ui.Image image = (await codec.getNextFrame()).image;

    setState(() => _image = image);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        width: 400,
        height: 400,
        child: CustomPaint(
          painter: BoardPainter(_image),
          child: Center(
            child: Text(
              ' ',
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w900,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// This prolly does nothing for now.
class BoardData {}

// FOR PAINTING LINES
class BoardPainter extends CustomPainter {
  ui.Image _image;

  BoardPainter(ui.Image image) {
    print("Board painter reloaded");
    _image = image;
  }

  @override
  void paint(Canvas canvas, Size size) {
    /*
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Offset startingPoint = Offset(0, size.height / 2);
    Offset endingPoint = Offset(size.width, size.height / 2);

    //canvas.drawLine(startingPoint, endingPoint, paint);
    */

    //var ll = ImageDescriptor.raw(buffer,
    // width: 200, height: 200, pixelFormat: PixelFormat.rgba8888);
    //ll.image
    //var l = Image(image: AssetImage('assets/Chess_kdt45.svg'));

    double cellWidthHeight = size.width / 8;
    Size boardSize = Size(cellWidthHeight, cellWidthHeight);

    var paintDark = Paint()
      ..color = Color(0xff638965)
      ..style = PaintingStyle.fill;

    var paintLight = Paint()
      ..color = Color(0xffbbcccc)
      ..style = PaintingStyle.fill;

    // Draw the squares squares.
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if ((i + j).isEven)
          canvas.drawRect(
              Offset(cellWidthHeight * i, cellWidthHeight * j) & boardSize,
              paintDark);
        else
          canvas.drawRect(
              Offset(cellWidthHeight * i, cellWidthHeight * j) & boardSize,
              paintLight);
      }
    }

    if (_image != null)
      canvas.drawImage(
          _image, Offset(cellWidthHeight * 5, cellWidthHeight * 5), paintDark);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
