// this file contains anything that is going be used in diffenrent sections.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// basic color
Color black = Colors.black;
Color white = Colors.white;

// theme color
Color lightblue = const Color.fromRGBO(187, 208, 255, 1);
Color blue = const Color.fromRGBO(100, 147, 235, 1);
Color grey = const Color.fromRGBO(196, 196, 196, 1);

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
  ),
);

SvgPicture headphoneIcon = SvgPicture.asset(
  "assets/play/headphone.svg",
  color: Colors.white,
);

SvgPicture headphoneWithSoundIcon = SvgPicture.asset(
  "assets/play/headphone_with_sound.svg",
  color: Colors.white,
);
