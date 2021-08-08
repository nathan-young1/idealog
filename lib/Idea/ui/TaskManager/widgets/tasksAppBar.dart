import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/design/textStyles.dart';

// ignore: non_constant_identifier_names
PreferredSizeWidget TasksAppBar ({required String pageName, required Color pageColor, required BuildContext context}) {

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight * 1.2),
      child: Container(
        color: pageColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            toolbarHeight: kToolbarHeight * 1.2,
            title: Text(pageName, style: overpass.copyWith(fontSize: 25, color: Colors.white)),
            automaticallyImplyLeading: false,
            actions: [
              Container(
                child: IconButton(onPressed: ()=> Navigator.of(context).pop(),
                icon: Icon(FeatherIcons.chevronDown, size: 30, color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );

}