import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PokeTypes extends StatelessWidget {
  final Map<String, dynamic> type;
  final double fontSize;

  const PokeTypes({Key key, this.type, this.fontSize = 16}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = type['name'];
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(type['color']).withOpacity(0.7),
        ),
        padding: EdgeInsets.all(4),
        child: Text(name[0].toUpperCase() + name.substring(1),
            style: GoogleFonts.lato(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
