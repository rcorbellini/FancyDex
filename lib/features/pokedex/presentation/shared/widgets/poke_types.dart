import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PokeTypes extends StatelessWidget {
  final Map<String, dynamic> type;
  final double fontSize;
  final bool enable;

  const PokeTypes({Key key, this.type, this.fontSize = 16, this.enable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = type['name'];
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: enable ? Color(type['color']).withOpacity(0.7) : Colors.white,
        ),
        padding: EdgeInsets.all(4),
        child: Text(name[0].toUpperCase() + name.substring(1),
            style: GoogleFonts.lato(
                fontSize: fontSize,
                color: enable ? Colors.white : Colors.grey.shade500,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
