import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'alertDialogComponents.dart';

Future<bool?> showLogOutDialog({required BuildContext context}) async {

  return showDialog<bool>(context: context, 
  builder: (context)=> AlertDialog(
    contentPadding: EdgeInsets.zero,
    elevation: 5,
    content: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertDialogHeader(
            headerIconColor: LightPink,
            headerTextColor: LightPink,
            context: context,
            headerIcon: FeatherIcons.logOut,
            hasCloseButton: false,
            headerText: "Log Out"),

          DottedLine(lineThickness: 3, dashColor: LightPink),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'If your data is not',
                    style: dosis.copyWith(fontSize: 22, color: Colors.black)),
                  TextSpan(text: ' Backed up,',
                    style: dosis.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black)),
                  TextSpan(text: ' it will be lost after you sign out!.',
                    style: dosis.copyWith(fontSize: 22, color: Colors.black))
                ]
              )),
          ),

          AlertDialogActionButtons(
            context: context,
            primaryActionText: "Log out", 
            secondaryActionText: "Backup", 
            primaryActionButtonColor: LightPink, 
            secondaryButtonOutlineColor: Black242424, 
            secondaryActionTextColor: Black242424,
            actionButtonsHeight: 40, 
            actionButtonsWidth: 110)
      ]),
    ),
  ), barrierDismissible: true);
}