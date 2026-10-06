import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class BBCStyle {
  static TextStyle normalStyle({required Color color, required double size}) => GoogleFonts.poppins(fontSize: size, fontWeight: FontWeight.w400, color: color);

  static TextStyle mediumStyle({required Color color, required double size}) => GoogleFonts.poppins(fontSize: size, fontWeight: FontWeight.w500, color: color);

  static TextStyle semiStyle({required Color color, required double size}) => GoogleFonts.poppins(fontSize: size, fontWeight: FontWeight.w600, color: color);

  static TextStyle boldStyle({required Color color, required double size}) => GoogleFonts.poppins(fontSize: size, fontWeight: FontWeight.bold, color: color);
}
