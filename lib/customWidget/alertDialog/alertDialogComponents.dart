import 'package:flutter/material.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';

enum DeleteDialog{Idea,Task,Multi_Select_Task}

AlertDialog progressAlertDialog = AlertDialog(
  title: Row(children: [
    CircularProgressIndicator(),
    SizedBox(width: 25),
    Text('Saving Data', style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.small))
  ],),
);

showSigningInAlertDialog({required BuildContext context}){
  return showDialog(context: context, 
  builder: (context)=> AlertDialog(
  title: Row(children: [
    CircularProgressIndicator(),
    SizedBox(width: 25),
    Text('Authenticating with google', style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.small))
  ],),
), barrierDismissible: false);
}


// ignore: non_constant_identifier_names
Widget AlertDialogHeader
({
  required BuildContext context,
  required String headerText, 
  required IconData headerIcon,
  required bool hasCloseButton,
  required Color headerIconColor,
  required Color headerTextColor
  }){

   return Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
            child: Row(
              children: [
                Icon(headerIcon, size: 30, color: headerIconColor),
                SizedBox(width: 25),

                Text(headerText, style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_20, color: headerTextColor, fontWeight: FontWeight.w600)),
                
                if(hasCloseButton) Expanded(child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: ()=> Navigator.pop(context),
                    iconSize: 30, color: LightPink))),
              ],
            ),
          );
}

// ignore: non_constant_identifier_names
Widget AlertDialogActionButtons
({
  required BuildContext context,
  required String primaryActionText,
  required String secondaryActionText,
  required Color primaryActionButtonColor,
  required Color secondaryButtonOutlineColor,
  Color? primaryActionTextColor,
  Color? secondaryActionTextColor,
  required double actionButtonsHeight,
  required double actionButtonsWidth
}){
  return Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: ()=> Navigator.pop(context, false),
                 child: Container(
                   height: actionButtonsHeight,
                   width: actionButtonsWidth,
                   decoration: BoxDecoration(
                     border: Border.all(width: 2, color: secondaryButtonOutlineColor),
                     borderRadius: BorderRadius.circular(10)
                   ),
                   child: Center(child: Text(secondaryActionText, 
                    style: dosis.copyWith(fontSize: 17, color: secondaryActionTextColor ?? DarkBlue, fontWeight: FontWeight.w600))))),
                SizedBox(width: 10),
                TextButton(onPressed: ()=> Navigator.pop(context, true),
                 child: Container(
                   height: actionButtonsHeight,
                   width: actionButtonsWidth,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                     color: primaryActionButtonColor
                   ),
                  child: Center(child: Text(primaryActionText,
                   style: dosis.copyWith(color: primaryActionTextColor ?? Colors.white, fontSize: 17, fontWeight: FontWeight.w600))))),
              ]),
          );
}