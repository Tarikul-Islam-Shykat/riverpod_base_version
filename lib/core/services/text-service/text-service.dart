import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Heading text with large font (28.sp)
Widget headingTextV2({
  required String text,
  FontWeight fontWeight = FontWeight.bold,
  Color color = Colors.black,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: GoogleFonts.manrope(
          fontSize: 28.sp,
          fontWeight: fontWeight,
          color: color,
        ),
      );
    },
  );
}

/// Heading text with medium font (18.sp)
Widget headingText({
  required String text,
  FontWeight fontWeight = FontWeight.bold,
  Color color = Colors.black,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: GoogleFonts.manrope(
          fontSize: 18.sp,
          fontWeight: fontWeight,
          color: color,
        ),
      );
    },
  );
}

/// Normal body text (16.sp)
Widget normalText({
  required String text,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: GoogleFonts.poppins(
          fontSize: 16.sp,
          fontWeight: fontWeight,
          color: color,
        ),
      );
    },
  );
}

/// Small text (12.sp)
Widget smallText({
  required String text,
  FontWeight fontWeight = FontWeight.w400,
  Color color = Colors.black,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: GoogleFonts.poppins(
          fontSize: 12.sp,
          fontWeight: fontWeight,
          color: color,
        ),
      );
    },
  );
}

/// Extra small text (10.sp)
Widget smallerText({
  required String text,
  FontWeight fontWeight = FontWeight.w400,
  Color color = Colors.black,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: GoogleFonts.poppins(
          fontSize: 10.sp,
          fontWeight: fontWeight,
          color: color,
        ),
      );
    },
  );
}
