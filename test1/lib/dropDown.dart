import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dropdown extends StatefulWidget {
  final List<String> choices;
  final String label;
  final Function(String) onSelected;
  const Dropdown(
      {super.key,
      required this.choices,
      required this.label,
      required this.onSelected});

  @override
  State<Dropdown> createState() => _DropDownState(choices);
}

class _DropDownState extends State<Dropdown> {
  late String value = '';
  List<String> choices = [];
  _DropDownState(this.choices) {
    value = choices.first;
  }

  @override
  void initState() {
    super.initState();
    value = widget.choices.first; // Initialisation de la valeur
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
      DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            value: value,
            elevation: 16,
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            onChanged: (String? newValue) {
              setState(() {
                value = newValue!;
              });
              widget.onSelected(newValue!);
            },
            items: widget.choices.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList()),
      ),
    ]);
  }
}
