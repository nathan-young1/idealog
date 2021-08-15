import 'package:flutter/material.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';

class DoesNotExistIllustration extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 230,
            width: 250,
            child: Image.asset(Paths.Search_Grey, fit: BoxFit.contain)),
          Text("Search not found", style: overpass.copyWith(fontSize: 22))
      ]);
  }
}