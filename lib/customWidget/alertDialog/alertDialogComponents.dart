import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:idealog/Prefs&Data/phoneSizeInfo.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  contentPadding: EdgeInsets.zero,
  content: Container(
    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 5.w),
    constraints: BoxConstraints(maxWidth: 380.w, minWidth: 375.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      Container(
        constraints: BoxConstraints(maxHeight: 27.h, maxWidth: 27.w),
        child: CircularProgressIndicator()),

      AutoSizeText('Authenticating with google', 
      style: AppFontWeight.medium,
      maxFontSize: AppFontSize.small,
      minFontSize: AppFontSize.fontSize_15)
    ],),
  ),
), barrierDismissible: false);
}

showDownloadingDataAlertDialog({required BuildContext context}){
  return showDialog(context: context, 
  builder: (context)=> AlertDialog(
  contentPadding: EdgeInsets.zero,
  content: Container(
    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 5.w),
    constraints: BoxConstraints(maxWidth: 380.w, minWidth: 375.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      Container(
        constraints: BoxConstraints(maxHeight: 27.h, maxWidth: 27.w),
        child: CircularProgressIndicator()),

      AutoSizeText('Downloading your ideas', 
      style: AppFontWeight.medium,
      maxFontSize: AppFontSize.small,
      minFontSize: AppFontSize.fontSize_15)
    ],),
  ),
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
  bool? isAutoStartDialog
}){
  return Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: ()=> Navigator.pop(context, false),
                 child: Container(
                   height: actionButtonsHeight,
                   constraints: BoxConstraints(maxWidth: PhoneSizeInfo.width * 0.32, minWidth:  PhoneSizeInfo.width * 0.25),
                   width: (isAutoStartDialog == null) ?PhoneSizeInfo.width * 0.25 :null,
                   decoration: BoxDecoration(
                     border: Border.all(width: 2, color: secondaryButtonOutlineColor),
                     borderRadius: BorderRadius.circular(10)
                   ),
                   child: Center(child: AutoSizeText(secondaryActionText, 
                    style: dosis.copyWith(color: secondaryActionTextColor ?? DarkBlue, fontWeight: FontWeight.w600))))),


                TextButton(onPressed: ()=> Navigator.pop(context, true),
                 child: Container(
                   height: actionButtonsHeight,
                   width: PhoneSizeInfo.width * 0.25,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                     color: primaryActionButtonColor
                   ),
                  child: Center(child: AutoSizeText(primaryActionText,
                   style: dosis.copyWith(color: primaryActionTextColor ?? Colors.white, fontWeight: FontWeight.w600))))),
              ]),
          );
}