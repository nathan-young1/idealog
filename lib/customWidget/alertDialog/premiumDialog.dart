import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'alertDialogComponents.dart';

showPremiumDialog({required BuildContext context}) async {
   AlertDialog alertDialog = AlertDialog(
    contentPadding: EdgeInsets.zero,
    elevation: 5,
    content: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertDialogHeader(
            headerIconColor: DarkBlue,
            headerTextColor: DarkBlue,
            context: context,
            headerIcon: FeatherIcons.creditCard,
            hasCloseButton: true,
            headerText: "Premium Access"),

          DottedLine(lineThickness: 3, dashColor: DarkBlue),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'You require',
                    style: dosis.copyWith(fontSize: 22, color: Colors.black)),
                  TextSpan(text: ' Premium access',
                    style: dosis.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black)),
                  TextSpan(text: ' to use this feature.',
                    style: dosis.copyWith(fontSize: 22, color: Colors.black))
                ]
              )),
          ),

          AlertDialogActionButtons(
            context: context,
            primaryActionText: "Get Access", 
            secondaryActionText: "Ignore", 
            primaryActionButtonColor: DarkBlue, 
            secondaryButtonOutlineColor: DarkBlue, 
            actionButtonsHeight: 40, 
            actionButtonsWidth: 110)
      ]),
    ),
  );

  await showDialog(context: context, builder: (context)=> alertDialog, barrierDismissible: false);
}