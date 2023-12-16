import 'dart:developer';

import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  final String url;
  final double size;
  ContactAvatar({super.key, required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return url.isEmpty
        ? CircleAvatar(
            radius: size,
            backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
          )
        : CircleAvatar(
            radius: size,
            backgroundImage: NetworkImage(url),
          );
  }
}
