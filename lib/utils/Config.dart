// ignore_for_file: file_names

import 'package:flutter/material.dart';

const TextStyle ts = TextStyle(
  fontSize: 15.0,
  color: Colors.white70,
);
const TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold, color: Color(0xFF0486f8), fontSize: 18.0);
const TextStyle textStyletb = TextStyle(
    fontWeight: FontWeight.bold, color: Color(0xFFff601c), fontSize: 18.0);
const Duration duration = Duration(milliseconds: 1000);
final BoxDecoration decorationVB = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
      colors: [Color(0xFF0099ff), Color(0xFF2a9bff)], // whitish to gray
      tileMode: TileMode.clamp, // repeats the gradient over the canvas
    ),
    color: const Color(0xFF2a9bff),
    borderRadius: BorderRadius.circular(5.0));
final BoxDecoration decorationHS = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
      colors: [Color(0xFFff5f09), Color(0xFFff8e51)], // whitish to gray
      tileMode: TileMode.clamp, // repeats the gradient over the canvas
    ),
    color: const Color(0xFFff8e51),
    borderRadius: BorderRadius.circular(5.0));
final BoxDecoration decorationQH = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
      colors: [Color(0xFFff7473), Color(0xFFff0305)], // whitish to gray
      tileMode: TileMode.clamp, // repeats the gradient over the canvas
    ),
    color: const Color(0xFFff8e51),
    borderRadius: BorderRadius.circular(5.0));
final BoxDecoration decorationPH = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
      colors: [Color(0xFF45e108), Color(0xFF38af09)], // whitish to gray
      tileMode: TileMode.clamp, // repeats the gradient over the canvas
    ),
    color: const Color(0xFFff8e51),
    borderRadius: BorderRadius.circular(5.0));
const appColor = Color(0xFF0485f8);
const camColor = Color(0xFFff600a);
const TextStyle labelHeadFormStyle =
    TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold);
const TextStyle labelFormStyle =
    TextStyle(fontSize: 13.0, color: Color(0xFF0485f8));
const TextStyle textFormStyle =
    TextStyle(fontSize: 13.0, color: Colors.black54);
