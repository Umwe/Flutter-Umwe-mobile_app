import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';

class CompassPage extends StatefulWidget {
  @override
  _CompassPageState createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'KajJoJes Compass App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
        child: Column(
          children: [
            Icon(
              Icons.arrow_circle_up,
              size: 30,
              color: Colors.blueGrey[900],
            ),
            Text(
              '|',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            StreamBuilder<CompassEvent>(
              stream: FlutterCompass.events,
              builder: (context, event) {
                if (event.hasError) {
                  return Text('Błąd odczytu pozycji: ${event.error}');
                }
                if (event.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                double? kierunek = event.data?.heading;

                if (kierunek == null)
                  return Center(
                    child: Text("W urządzeniu nie ma magnetometru."),
                  );

                return Material(
                  shape: CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  elevation: 6.0,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber[700],
                      border: Border.all(
                        color: Colors.blue,
                        width: 5,
                      ),
                    ),
                    child: Transform.rotate(
                      angle: (kierunek * (math.pi / 180) * -1),
                      child: Image.asset(
                        'assets/compass.png',
                        scale: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 40,),
            Text(
              'Chyba się zgubiłeś!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              '@Paweł Jackowski, 2021',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            backgroundColor: Colors.green[800],
          ));
        },
        child: const Icon(Icons.alternate_email, color: Colors.white),
        backgroundColor: Colors.amber[700],
      ),
    );
  }
}
