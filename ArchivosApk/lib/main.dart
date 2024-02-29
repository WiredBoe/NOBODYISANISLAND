// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:osc/osc.dart';
import 'dart:io';
import 'package:flutter_glow/flutter_glow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      primaryColor: Color.fromARGB(255, 255, 255, 255),
      scaffoldBackgroundColor: Color.fromARGB(255, 31, 31, 31),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
        )
      )
      ),
      home: const MyHomePage(title: ''),
      debugShowCheckedModeBanner: false,
      );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
            'assets/secuencia.gif',
            height: 230.0,
            width: 230.0,
            fit: BoxFit.contain,
          ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlockSettingsScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              child: 
                const Text('HELP YOUR PARTNER',
                style: TextStyle(
                  fontFamily: 'CustomFont',
                )
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlockSettingsScreen extends StatefulWidget {
  @override
  _BlockSettingsScreenState createState() => _BlockSettingsScreenState();
}

class _BlockSettingsScreenState extends State<BlockSettingsScreen> {
  int redValue = 0;
  int blueValue = 0;
  int greenValue = 0;

  Timer? _timer;
  int incrementDuration = 250; // duration between increments in millisecond

  void _startDecrementing(String color) {
    _timer = Timer.periodic(Duration(milliseconds: incrementDuration), (timer) {
      decreaseValue(color);
    });
  }
  void _stopDecrementing() {
    _timer?.cancel();
  }

  void _startIncrementing(String color) {
    _timer = Timer.periodic(Duration(milliseconds: incrementDuration), (timer) {
      increaseValue(color);
    });
  }
  void _stopIncrementing() {
    _timer?.cancel();
  }

  void increaseValue(String color) {
    setState(() {
      if (color == 'Red' && redValue < 100)
        redValue++;
      else if (color == 'Blue' && blueValue < 100)
        blueValue++;
      else if (color == 'Green' && greenValue < 100) greenValue++;
    });
  // Create an OSC message with the desired address pattern and arguments
  final message1 = OSCMessage('/Platform/Red', arguments: [redValue]);
  final message2 = OSCMessage('/Platform/Green', arguments: [greenValue]);
  final message3 = OSCMessage('/Platform/Blue', arguments: [blueValue]);
  // Create an OSC socket and send the message
  final socket = OSCSocket(destination: InternetAddress(''), destinationPort: 8000);

  socket.send(message1);
  socket.send(message2);
  socket.send(message3);
  
  print('OSC message sent: $message1');
  print('OSC message sent: $message2');
  print('OSC message sent: $message3');
  }

  void decreaseValue(String color) {
    setState(() {
      if (color == 'Red' && redValue > 0)
        redValue--;
      else if (color == 'Blue' && blueValue > 0)
        blueValue--;
      else if (color == 'Green' && greenValue > 0) greenValue--;
    });
   // Create an OSC message with the desired address pattern and arguments
  final message1 = OSCMessage('/Platform/Red', arguments: [redValue]);
  final message2 = OSCMessage('/Platform/Green', arguments: [greenValue]);
  final message3 = OSCMessage('/Platform/Blue', arguments: [blueValue]);
  // Create an OSC socket and send the message
  final socket = OSCSocket(destination: InternetAddress(''), destinationPort: 8000);

  socket.send(message1);
  socket.send(message2);
  socket.send(message3);
  
  print('OSC message sent: $message1');
  print('OSC message sent: $message2');
  print('OSC message sent: $message3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        padding: EdgeInsets.fromLTRB(16.0, 70.0, 16.0, 0.0),
        children: [
          _buildBlockSetting('Red', redValue),
          _buildBlockSetting('Blue', blueValue),
          _buildBlockSetting('Green', greenValue),
        ],
      ),
    );
  }

  Widget _buildBlockSetting(String color, int value) {
    final colorTextDefault = Color.fromARGB(255, 223, 223, 223);
    Color squareColor;
    switch (color) {
      case 'Red':
        squareColor = Colors.red;
        break;
      case 'Blue':
        squareColor = Colors.blue;
        break;
      case 'Green':
        squareColor = Colors.green;
        break;
      default:
        squareColor = Colors.white;
    }

    final isDecrementing = ValueNotifier<bool>(false);
    final isIncrementing = ValueNotifier<bool>(false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        SizedBox(height: 15),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: GlowText(
                  '$color',
                  style: TextStyle(
                    color: squareColor,
                    fontSize: 32,
                    fontFamily: 'CustomFont',
                  ),
                  glowColor: squareColor,
                  blurRadius: 25,
                ),
              ),
              TextSpan(
                text: ' platform',
                style: TextStyle(
                  color: colorTextDefault,
                  fontSize: 32,
                  fontFamily: 'CustomFont',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 25),
        
        SizedBox(         
          width: 300, // define the width of the SizedBox
          child: AnimatedAlign(
            alignment: Alignment(value / 100 * 2 - 1, 0), // calculate the alignment based on the value
            duration: const Duration(milliseconds: 500),
            child: ShaderMask(
            shaderCallback:
                (bounds) =>
                    RadialGradient(
              center:
                  Alignment.center,
              radius:
                  1.0,
              colors: [
                squareColor.withOpacity(0.8),
                Colors.transparent
              ],
              stops:
                  [0.5, 1.0],
            ).createShader(bounds),
            blendMode:
                BlendMode.plus,
            child: Container(
              width: 40,
              height: 40,
              color: squareColor,
            ),)
          ),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: ValueListenableBuilder<bool>(
                valueListenable: isDecrementing,
                builder: (context, isDecrementing, child) {
                  return IconButton(
                    icon: const Icon(Icons.remove),
                    color:
                        isDecrementing ? squareColor : colorTextDefault,
                    onPressed: () => decreaseValue(color),
                    iconSize: 32,
                  );
                },
              ),
              onLongPressStart: (_) {
                _startDecrementing(color);
                isDecrementing.value = true;
              },
              onLongPressEnd: (_) {
                _stopDecrementing();
                isDecrementing.value = false;
              },
            ),
           GlowText(
                  '$value',
                  style: TextStyle(
                    color: squareColor,
                    fontSize: 24,
                    fontFamily: 'CustomFont',
                  ),
                  glowColor: squareColor,
                  blurRadius: 25,
                ),
            
            GestureDetector(
              child: ValueListenableBuilder<bool>(
                valueListenable: isIncrementing,
                builder: (context, isIncrementing, child) {
                  return IconButton(
                    icon: const Icon(Icons.add),
                    color:
                        isIncrementing ? squareColor : colorTextDefault,
                    onPressed: () => increaseValue(color),
                    iconSize: 32,
                  );
                },
              ),
              onLongPressStart: (_) {
                _startIncrementing(color);
                isIncrementing.value = true;
              },
              onLongPressEnd: (_) {
                _stopIncrementing();
                isIncrementing.value = false;
              },
            ),
          ],
        ),
        SizedBox(height: 28),
      ],
    );
  }
}
