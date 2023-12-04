import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropdown Example',
      home: ExemplePage(),
    );
  }
}

class ExemplePage extends StatefulWidget {
  @override
  _ExemplePageState createState() => _ExemplePageState();
}

class _ExemplePageState extends State<ExemplePage> {
  String _selectedMonth = 'January';
  String _selectedYear = '2024';
  String _SelectedCVV = '000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Example'),
      ),
      body: Center(
          child: Card(
              elevation: 10.0, // Réglez ceci pour l'élévation souhaitée
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // Bord arrondi de 5
              ),
              child: Container(
                  width: 300, // Spécifiez la largeur souhaitée
                  height: 500, // Spécifiez la hauteur souhaitée
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Fit le Row à la taille de son contenu
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            DropdownButton<String>(
                              value: _selectedMonth,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMonth = newValue!;
                                });
                              },
                              items: <String>[
                                'January',
                                'February',
                                'March',
                                'April',
                                'May',
                                'June',
                                'July',
                                'August',
                                'September',
                                'October',
                                'November',
                                'December'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                                width:
                                    20), // Espacement entre les DropdownButton
                            DropdownButton<String>(
                              value: _selectedYear,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedYear = newValue!;
                                });
                              },
                              items: <String>[
                                '2024',
                                '2025',
                                '2026',
                                '2027',
                                '2028',
                                '2029',
                                '2030',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      )
                    ],
                  )))),
    );
  }
}
