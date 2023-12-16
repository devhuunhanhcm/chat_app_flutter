import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

pickImages(ImageSource imageSource) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: imageSource);

  if (_file != null) {
    return await _file.readAsBytes();
  }

  print('No images selected.');
}

String formattedDate(datePublished) {
  final now = DateTime.now();
  final difference = now.difference(datePublished);
  if (difference.inHours >= 24) {
    final days = difference.inDays;
    return '$days day${days > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  }
}

// function to convert time stamp to date
DateTime returnDateAndTimeFormat(String time) {
  var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
  var originalDate = DateFormat('MM/dd/yyyy').format(dt);
  return DateTime(dt.year, dt.month, dt.day);
}

//function to return message time in 24 hours format AM/PM
String messageTimeInDay(String time) {
  var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
  String difference = '';
  difference = DateFormat('jm').format(dt).toString();
  return difference;
}

// function to return date if date changes based on your local date and time
String groupMessageDateAndTime(String time) {
  var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
  var originalDate = DateFormat('MM/dd/yyyy').format(dt);

  final todayDate = DateTime.now();

  final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
  final yesterday =
      DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
  String difference = '';
  final aDate = DateTime(dt.year, dt.month, dt.day);

  if (aDate == today) {
    difference = "Today";
  } else if (aDate == yesterday) {
    difference = "Yesterday";
  } else {
    difference = DateFormat.yMMMd().format(dt).toString();
  }

  return difference;
}
